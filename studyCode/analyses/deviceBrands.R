
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
  separate(col=`Source concept name`,sep="_", remove=FALSE, into=c("Source concept name","Brand")) |>
  select(c(`Standard concept ID`,`Standard concept name`,`Source concept name`,Brand)) |> arrange(Brand) |>
  mutate(Duration=c(rep("5 years",5),rep("10 years",2),rep("5 years",3), "10 years",
                       rep("5 years",4),"10 years",rep("5 years",6),"10 years","5 years",rep("10 years",2))) |>
  rename("concept_ID"=1,"Standard_concept_name"=2,"Source_concept_name"=3)
cohort_code_iud |> print(n=Inf)


#Step 2
#Summarise by Duration
cohort_code_iud |> arrange(desc(Duration),Brand) |> print(n=Inf)
#Summarise by Brand
cohort_code_iud |> arrange(Brand,desc(Duration)) |> print(n=Inf)
data.frame(table(cohort_code_iud$Brand)) |> arrange(Freq)
cohort_code_iud |>
  group_by(Brand,Duration) |>
  summarise(Models=length(unique(Source_concept_name)) )
#compare codes
table(iud_codes$iud %in% cohort_code_iud$`concept_ID`)
add_iud_codes <- data.frame(c(iud_codes$iud), c(iud_codes$iud %in% cohort_code_iud$`concept_ID`)) |>
  rename(concept_ID=1,inc=2) |> filter(inc=="FALSE") |> select(concept_ID) |>
  mutate(Standard_concept_name = c("Steriload", "Ancora 375 Ag", "IUB Ballerine MIDI"),
         Source_concept_name = Standard_concept_name,
         Brand = c("Farla Medical Ltd","R.F. Medical Supplies Ltd","OCON Medical Ltd"),
         Duration = c("Unknown",rep("5 years",2)) )
add_iud_codes
cohort_code_iud <- rbind(add_iud_codes,cohort_code_iud) |> arrange(Brand,desc(Duration))
cohort_code_iud


#Step 3
#Step 3a: Duration
##Step 3a.1 - 5 years
(cohort_code_iud %>% filter(Duration=="5 years") )$concept_ID
iud_5years <- list("5years"= c(21399040, 21470537, 21348967, 21450903, 21441018, 21349000, 21327814, 21350078,
                               21470538, 21337994, 21450144, 21390888, 21329906, 21421598, 21360574, 21421597,
                               21462392, 21399039, 21368651, 21442060, 36047594 )) |> newCodelist()
##Step 3a.2 - 10 years
(cohort_code_iud %>% filter(Duration=="10 years") )$concept_ID
iud_10years <- list("10years"=c(21430445, 21389549, 21389357, 21411274, 21368650, 21481322, 21388824)) |>
  newCodelist()
#Step 3b: Brand
##Step 3b.1 - Bayer Plc
(cohort_code_iud %>% filter(Brand=="Bayer Plc") )$concept_ID
iud_BayerPlc <- list("BayerPlc"=c(21399040)) |> newCodelist()
##Step 3b.2 - Durbin Plc
(cohort_code_iud %>% filter(Brand=="Durbin Plc") )$concept_ID
iud_DurbinPlc <- list("DurbinPlc"=c(21470537, 21348967, 21450903, 21441018, 21430445, 21389549, 21349000)) |>
  newCodelist()
##Step 3b.3 - Family Planning Sales Ltd
(cohort_code_iud %>% filter(Brand=="Family Planning Sales Ltd") )$concept_ID
iud_FamilyPlanningSalesLtd <- list("FamilyPlanningSalesLtd"=c(21327814)) |> newCodelist()
##Step 3b.4 - Farla Medical Ltd
(cohort_code_iud %>% filter(Brand=="Farla Medical Ltd") )$concept_ID
iud_FarlaMedicalLtd <- list("FarlaMedicalLtd"=c(21350078, 21380323)) |> newCodelist()
##Step 3b.5 - Janssen-Cilag Ltd
(cohort_code_iud %>% filter(Brand=="Janssen-Cilag Ltd") )$concept_ID
iud_JanssenCilagLtd <- list("JanssenCilagLtd"=c(21389357)) |> newCodelist()
##Step 3b.6 - Organon Laboratories Ltd
(cohort_code_iud %>% filter(Brand=="Organon Laboratories Ltd") )$concept_ID
iud_OrganonLaboratoriesLtd <- list("OrganonLaboratoriesLtd"=c(21470538, 21337994, 21450144)) |> newCodelist()
##Step 3b.7 - R.F. Medical Supplies Ltd
(cohort_code_iud %>% filter(Brand=="R.F. Medical Supplies Ltd") )$concept_ID
iud_RFMedicalSuppliesLtd <- list("RFMedicalSuppliesLtd"=c(21390888, 21411274, 21329906, 21421598, 21360574,
                                                          21421597, 21462392, 21442060)) |> newCodelist()
##Step 3b.8 - Schering Health Care Ltd
(cohort_code_iud %>% filter(Brand=="Schering Health Care Ltd") )$concept_ID
iud_ScheringHealthCareLtd <- list("ScheringHealthCareLtd"=c(21399039)) |> newCodelist()
##Step 3b.9 - Williams Medical Supplies Ltd
(cohort_code_iud %>% filter(Brand=="Williams Medical Supplies Ltd") )$concept_ID
iud_WilliamsMedicalSuppliesLtd <- list("WilliamsMedicalSuppliesLtd"=c(21368650, 21368651, 21481322, 21388824)) |>
  newCodelist()
##Step 3b.9 - Williams Medical Supplies Ltd
(cohort_code_iud %>% filter(Brand=="OCON Medical Ltd") )$concept_ID
iud_OCONMedicalLtd <- list("OCONMedicalLtd"=c(36047594)) |> newCodelist()



cdm$iud <- cdm$iud |>
  addConceptIntersectField(conceptSet = iud_codes,field = "device_concept_id",allowDuplicates = TRUE) |>
  rename("device_concept_id"="device_concept_id_iud_0_to_inf") |>
  addConceptIntersectFlag(conceptSet = iud_5years, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_10years, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_BayerPlc, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_DurbinPlc, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_FamilyPlanningSalesLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_FarlaMedicalLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_JanssenCilagLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_OCONMedicalLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_OrganonLaboratoriesLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_RFMedicalSuppliesLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_ScheringHealthCareLtd, window = c(0,0)) |>
  addConceptIntersectFlag(conceptSet = iud_WilliamsMedicalSuppliesLtd, window = c(0,0))


#
#### CGM ####

#Step 1
summarise_cohort_code_cgm <- read_csv("analyses/summarise_cohort_code_cgm.csv")
cohort_code_cgm <- summarise_cohort_code_cgm[c(4,3,5)] |> rename(concept_ID=1,concept_name=2)
glimpse(cohort_code_cgm )
cohort_code_cgm$concept_name <- gsub(" Sensor","",cohort_code_cgm$concept_name)
cohort_code_cgm <- cohort_code_cgm |>
  mutate(Brand = ifelse(str_detect(concept_name, "Dexcom")==TRUE,"Dexcom",
                    ifelse(str_detect(concept_name, "FreeStyle Libre")==TRUE,"FreeStyle Libre","NA") )) |>
  select(concept_ID, concept_name,Brand)
cohort_code_cgm |> print(n=Inf)


#Step 2
#Summarise by Brand
cohort_code_cgm |> arrange(Brand) |> print(n=Inf)
#compare codes
table(cgm_codes$cgm %in% cohort_code_cgm$concept_ID)
data.frame(c(cgm_codes$cgm), c(cgm_codes$cgm %in% cohort_code_cgm$concept_ID)) |>
  rename(concept_ID=1,inc=2) |> filter(inc=="FALSE")

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
  addConceptIntersectFlag(conceptSet = cgm_freestyle_libre,window=c(0,0))
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
         Brand = c("FreeStyle Libre",rep("Dexcom",2),"Medtrum",rep("Dexcom",2),"Medtrum","Dexcom","spirit health",
                   "FreeStyle Libre","spirit health",rep("FreeStyle Libre",3),rep("Dexcom",2),
                   rep("FreeStyle Libre",2))  )
add_cgm_codes
cohort_code_cgm <- unique(rbind(add_cgm_codes[c(1,2,4)],cohort_code_cgm)) |> arrange(Brand,concept_name)
cohort_code_cgm


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
  separate(col=`Source concept name`,sep="_", remove=TRUE, into=c("Source","Brand")) |>
  select(!c("Source"))
cohort_code_dre
table(cohort_code_dre$type)
table((cohort_code_dre |> filter(is.na(Brand)) )$type)


#Step 3
dressing_codes <- importCodelist(here("..", "diagnosticsCode",
                                             "antimicrobial_dressings", "cohorts", "codelists"))

cdm$dre <- cdm$dre |>
  addConceptIntersectFlag(conceptSet = silver_dressing_codes )

