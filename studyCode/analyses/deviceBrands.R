
##### IUD ####

#Step 1
#Import IUD brand & model
summarise_cohort_code_iud <- read_csv("analyses/summarise_cohort_code_iud.csv")
cohort_code_iud <- summarise_cohort_code_iud[c(3:8)]
glimpse(cohort_code_iud)
#Clean names
cohort_code_iud$`Source concept name` <-
  gsub("[)]| intrauterine| contraceptive| device","",cohort_code_iud$`Source concept name`)
cohort_code_iud$`Standard concept name` <-
  gsub(" intrauterine| contraceptive| device","",cohort_code_iud$`Standard concept name`)
cohort_code_iud$`Source concept name` <-
  gsub("[(]","_",cohort_code_iud$`Source concept name`)
#Add duration of IUD
cohort_code_iud <- cohort_code_iud |>
  separate(col=`Source concept name`,sep="_", remove=FALSE, into=c("Source concept name","brand")) |>
  select(c(`Standard concept ID`,`Standard concept name`,`Source concept name`,brand)) |> arrange(brand) |>
  mutate(duration=c(rep("5 years",5),"10 years",rep("5 years",3), "10 years","Unknown",
                       rep("3 years",2),rep("5 years",2),"10 years",rep("5 years",9),"10 years")) |>
  rename("concept_ID"=1,"Standard_concept_name"=2,"Source_concept_name"=3)
cohort_code_iud |> print(n=Inf)


#Step 2
#Summarise by duration
cohort_code_iud |> arrange(desc(duration),brand) |> print(n=Inf)
#Summarise by brand
cohort_code_iud |> arrange(brand,desc(duration)) |> print(n=Inf)
data.frame(table(cohort_code_iud$brand)) |> arrange(Freq)
cohort_code_iud |>
  group_by(brand,duration) |>
  summarise(Models=length(unique(Source_concept_name)) )
#compare codes
table(iud_codes$iud %in% cohort_code_iud$`concept_ID`)
add_iud_codes <- data.frame(c(iud_codes$iud), c(iud_codes$iud %in% cohort_code_iud$`concept_ID`)) |>
  rename(concept_ID=1,inc=2) |> filter(inc=="FALSE") |> select(concept_ID) |>
  mutate(Standard_concept_name = c("Steriload", "Ancora 375 Ag", "IUB Ballerine MIDI"),
         Source_concept_name = Standard_concept_name,
         brand = c("Farla Medical Ltd","R.F. Medical Supplies Ltd","OCON Medical Ltd"),
         duration = c("Unknown",rep("5 years",2)) )
add_iud_codes
cohort_code_iud <- rbind(add_iud_codes,cohort_code_iud) |>
  arrange(brand,desc(duration)) |>
  rename(concept_name=Standard_concept_name)
cohort_code_iud

#Step 3
#Step 3a: duration
##Step 3a.1 - 5 years
iud_5years <- list("5years"= c((cohort_code_iud %>% filter(duration=="5 years") )$concept_ID)) |> newCodelist()
##Step 3a.2 - 10 years
iud_10years <- list("10years"= c((cohort_code_iud %>% filter(duration=="10 years") )$concept_ID)) |> newCodelist()
#Step 3b: brand
##Step 3b.1 - Bayer Plc
iud_BayerPlc <- list("BayerPlc"=c((cohort_code_iud %>% filter(brand=="Bayer Plc") )$concept_ID)) |> newCodelist()
##Step 3b.2 - Durbin Plc
iud_DurbinPlc <- list("DurbinPlc"=c((cohort_code_iud %>% filter(brand=="Durbin Plc") )$concept_ID)) |>
  newCodelist()
##Step 3b.3 - Family Planning Sales Ltd
iud_FamilyPlanningSalesLtd <- list("FamilyPlanningSalesLtd"=c(
  (cohort_code_iud %>% filter(brand=="Family Planning Sales Ltd") )$concept_ID)) |> newCodelist()
##Step 3b.4 - Farla Medical Ltd
iud_FarlaMedicalLtd <- list("FarlaMedicalLtd"=c(
  (cohort_code_iud %>% filter(brand=="Farla Medical Ltd") )$concept_ID)) |> newCodelist()
##Step 3b.5 - Janssen-Cilag Ltd
iud_JanssenCilagLtd <- list("JanssenCilagLtd"=c(
  (cohort_code_iud %>% filter(brand=="Janssen-Cilag Ltd") )$concept_ID)) |> newCodelist()
##Step 3b.6 - Organon Laboratories Ltd
iud_OrganonLaboratoriesLtd <- list("OrganonLaboratoriesLtd"=c(
  (cohort_code_iud %>% filter(brand=="Organon Laboratories Ltd") )$concept_ID)) |> newCodelist()
##Step 3b.7 - R.F. Medical Supplies Ltd
iud_RFMedicalSuppliesLtd <- list("RFMedicalSuppliesLtd"=c(
  (cohort_code_iud %>% filter(brand=="R.F. Medical Supplies Ltd") )$concept_ID)) |> newCodelist()
##Step 3b.8 - Schering Health Care Ltd
iud_ScheringHealthCareLtd <- list("ScheringHealthCareLtd"=c(
  (cohort_code_iud %>% filter(brand=="Schering Health Care Ltd") )$concept_ID)) |> newCodelist()
##Step 3b.9 - Williams Medical Supplies Ltd
iud_WilliamsMedicalSuppliesLtd <- list("WilliamsMedicalSuppliesLtd"=c(
  (cohort_code_iud %>% filter(brand=="Williams Medical Supplies Ltd") )$concept_ID)) |>
  newCodelist()
##Step 3b.9 - OCON Medical Ltd
iud_OCONMedicalLtd <- list("OCONMedicalLtd"=c(
  (cohort_code_iud %>% filter(brand=="OCON Medical Ltd") )$concept_ID)) |> newCodelist()
#Step 3c
cdm$iud <-  { cdm$iud |>
  addConceptIntersectField(conceptSet = iud_codes,field = "device_concept_id",allowDuplicates = TRUE) |>
  rename("device_concept_id"="device_concept_id_iud_0_to_inf") |>
  addConceptIntersectFlag(conceptSet = iud_5years, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_10years, window = c(0,0)) |>
  mutate("duration" = ifelse(`5years_0_to_0`==1, "5 years",
                             ifelse(`10years_0_to_0`==1, "10 years", "Other/Unknown"))) |>
  addConceptIntersectFlag(conceptSet = iud_BayerPlc, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_DurbinPlc, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_FamilyPlanningSalesLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_FarlaMedicalLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_JanssenCilagLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_OCONMedicalLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_OrganonLaboratoriesLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_RFMedicalSuppliesLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_ScheringHealthCareLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_WilliamsMedicalSuppliesLtd, window = c(0,0)) |>
  mutate("brand" =
           ifelse(bayerplc_0_to_0==1, "Bayer Plc",
              ifelse(durbinplc_0_to_0==1, "Durbin Plc",
                 ifelse(familyplanningsalesltd_0_to_0==1, "Family Planning Sales Ltd",
                   ifelse(farlamedicalltd_0_to_0==1, "Farla Medical Ltd",
                      ifelse(janssencilagltd_0_to_0==1, "Janssen Cilag Ltd",
                        ifelse(oconmedicalltd_0_to_0==1, "OCON Medical Ltd",
                          ifelse(organonlaboratoriesltd_0_to_0==1, "Organon Laboratories Ltd",
                             ifelse(rfmedicalsuppliesltd_0_to_0==1, "RF Medical Supplies Ltd",
                                ifelse(scheringhealthcareltd_0_to_0==1, "Schering Health Care Ltd",
                                  ifelse(williamsmedicalsuppliesltd_0_to_0==1, "Williams Medical Supplies Ltd",
                                                                "Other/Unknown"))))))))) ) )
}


#
#### CGM ####

#Step 1
summarise_cohort_code_cgm <- read_csv("analyses/summarise_cohort_code_cgm.csv")
cohort_code_cgm <- summarise_cohort_code_cgm[c(4,3,5)] |> rename(concept_ID=1,concept_name=2)
glimpse(cohort_code_cgm )
cohort_code_cgm$concept_name <- gsub(" Sensor","",cohort_code_cgm$concept_name)
cohort_code_cgm <- cohort_code_cgm |>
  mutate(brand = ifelse(str_detect(concept_name, "Dexcom")==TRUE,"Dexcom",
                    ifelse(str_detect(concept_name, "FreeStyle Libre")==TRUE,"FreeStyle Libre","NA") )) |>
  select(concept_ID, concept_name,brand)
cohort_code_cgm |> print(n=Inf)


#Step 2
#Summarise by brand
cohort_code_cgm |> arrange(brand) |> print(n=Inf)
#compare codes
table(cgm_codes$cgm %in% cohort_code_cgm$concept_ID)
data.frame(c(cgm_codes$cgm), c(cgm_codes$cgm %in% cohort_code_cgm$concept_ID)) |>
  rename(concept_ID=1,inc=2) |> filter(inc=="FALSE")
#add codes to table
table(cgm_codes$cgm %in% cohort_code_cgm$concept_ID)
add_cgm_codes <- data.frame(c(cgm_codes$cgm), c(cgm_codes$cgm %in% cohort_code_cgm$`concept_ID`)) |>
  rename(concept_ID=1,inc=2) |> filter(inc=="FALSE") |> select(concept_ID) |>
  mutate(concept_name = c("FreeStyle Libre 3 Plus","Dexcom G6","Dexcom One+","A8 TouchCare Nano","Dexcom G6",
                          "Dexcom G7","A8 TouchCare Nano","Dexcom G7","CareSens Air Sensor",
                          "FreeStyle Libre 2 Plus", "CareSens Air Sensor", "FreeStyle Libre 3",
                          "FreeStyle Libre 2 Plus","FreeStyle Libre 2",rep("Dexcom One",2),
                          rep("FreeStyle Libre",2)),
         Source_concept_name = concept_name,
         brand = c("FreeStyle Libre",rep("Dexcom",2),"Medtrum",rep("Dexcom",2),"Medtrum","Dexcom","spirit health",
                   "FreeStyle Libre","spirit health",rep("FreeStyle Libre",3),rep("Dexcom",2),
                   rep("FreeStyle Libre",2))  )
add_cgm_codes
cohort_code_cgm <- unique(rbind(add_cgm_codes[c(1,2,4)],cohort_code_cgm)) |> arrange(brand,concept_name)
cohort_code_cgm


#Step 3
cgm_codes_all <- { list(
  cgm_dexcom_g6 = c(891070, 882115, 888630), # Dexcom G6 Sensor
  cgm_dexcom_g7 = c(885453, 889729, 891653), # Dexcom G7 Sensor
  cgm_dexcom_one = c(36964253, 36924428, 36944703), # Dexcom One Sensor
  cgm_dexcom_one_plus = c(886971, 885073), # Dexcom One+
  cgm_freestyle_libre_2_plus = c(888893, 896954, 35402057), # FreeStyle Libre 2 Plus Sensor
  cgm_freestyle_libre_2 = c(35889967, 35891819), # FreeStyle Libre 2 Sensor
  cgm_freestyle_libre_3_plus = c(837419, 879292), # FreeStyle Libre 3 Plus Sensor
  cgm_freestyle_libre_3 = c(880079, 897543), # FreeStyle Libre 3 Sensor
  cgm_freestyle_libre_plus = c(40677414, 42524374, 40675740), #FreeStyle Libre Sensor
  cgm_a8_touchcare_nano = c(886918, 891479), #A8 TouchCare Nano Sensor
  cgm_caresens_air= c(893573, 897329) # CareSens Air Sensor
) |>
  newCodelist() }
cgm_model_codes <- { list(
  cgm_dexcom = c(891070, 882115, 888630,885453, 889729, 891653, 36964253, 36924428, 36944703,886971, 885073),
  cgm_freestyle_libre = c(888893, 896954, 35402057,35889967, 35891819,837419, 879292,880079, 897543,40677414,
                          42524374, 40675740),
  cgm_a8_touchcare_nano = c(886918, 891479),
  cgm_caresens_air= c(893573, 897329) ) |>
  newCodelist() }
cgm_dexcom_codes <- list(  cgm_dexcom = cgm_model_codes$cgm_dexcom ) |> newCodelist()
cgm_freestyle_libre <- list(  cgm_freestyle_libre = cgm_model_codes$cgm_freestyle_libre ) |> newCodelist()
cdm$cgm <- cdm$cgm |>
  addConceptIntersectFlag(conceptSet = cgm_dexcom_codes,window=c(0,0)) |>
  addConceptIntersectFlag(conceptSet = cgm_freestyle_libre,window=c(0,0)) |>
  mutate(brand=ifelse(cgm_dexcom_0_to_0==1,"Dexcom",
                      ifelse(cgm_freestyle_libre_0_to_0==1,"Freestyle Libre","Other")))



#
#### Dressings ####

#Step 1
summarise_cohort_code_dressings <- unique(read_csv("analyses/summarise_cohort_code_use_dressings.csv"))
cohort_code_dre <- summarise_cohort_code_dressings[c(2,4,3,5)]|>
  rename(concept_ID=2,concept_name=3,type=1) |>
  filter(!type=="antimicrobial_dressing")
glimpse(cohort_code_dre)
#Clean names
cohort_code_dre$`Source concept name` <-
  gsub("[)]","",cohort_code_dre$`Source concept name`)
cohort_code_dre$`Source concept name` <-
  gsub("[(]","_",cohort_code_dre$`Source concept name`)
cohort_code_dre <- cohort_code_dre |>
  separate(col=`Source concept name`,sep="_", remove=TRUE, into=c("Source","brand")) |>
  select(!c("Source")) |>
  mutate(brand=ifelse(str_detect(brand, " x | X |mm hole|fenestrated")==TRUE, NA,brand)) |>
  arrange(type,brand,concept_name)
#Summarise by brand
cohort_code_dr
data.frame(table(cohort_code_dre$brand)) |> arrange(Freq)
table(cohort_code_dre$type)
table((cohort_code_dre |> filter(is.na(brand)) )$type)


#Step 2
dressing_codes <- importCodelist(here("codelist","dressing"))
table(dressing_codes$cgm %in% cohort_code_cgm$concept_ID)
cdm$antimicrobial_dressings |> glimpse()
cdm$antimicrobial_dressings <- cdm$antimicrobial_dressings |>
  addConceptIntersectFlag(conceptSet = dressing_codes)



##### Summary ####

cohort_codes <- rbind(cohort_code_dre |> mutate(duration=NA,device="dressings"),
      cohort_code_iud |> mutate(type=NA,device="iud") |> select(!c(Source_concept_name)),
      cohort_code_cgm |> mutate(type=NA,duration=NA,device="cgm")) |>
  select(concept_ID,device,type,brand,concept_name,duration) |>
  arrange(device,type,brand,duration,concept_name)
cohort_codes
results[["cohort_codes"]] <- cohort_codes

