
##### IUD ####

#Step 1
#Import IUD brand & model
summarise_cohort_code_iud <- read_csv("analyses/summarise_cohort_code_iud.csv")
cohort_code_iud <- summarise_cohort_code_iud[c(3:8,11,12)]
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
  select(c(`Standard concept ID`,`Standard concept name`,`Source concept name`,Brand,`CPRD GOLD: Person count`,
           `CPRD GOLD: Record count`)) |> arrange(Brand) |>
  mutate(Duration=c(rep("5 years",5),rep("10 years",2),rep("5 years",3), "10 years",
                       rep("5 years",4),"10 years",rep("5 years",6),"10 years","5 years",rep("10 years",2))) |>
  rename("concept_ID"=1,"Standard_concept_name"=2,"Source_concept_name"=3, "Person_count"=5,"Record_count"=6)
cohort_code_iud |> print(n=Inf)


#Step 2
#Summarise by Duration
cohort_code_iud$Person_count <- as.numeric(gsub("[,<]","",cohort_code_iud$Person_count) )
cohort_code_iud$Record_count <- as.numeric(gsub("[,<]","",cohort_code_iud$Record_count) )
cohort_code_iud |> arrange(desc(Duration),desc(Person_count)) |> print(n=Inf)
sum((cohort_code_iud |> filter(Duration=="5 years"))$Person_count)
sum((cohort_code_iud |> filter(Duration=="10 years"))$Person_count)
#Summarise by Brand
cohort_code_iud |> arrange(Brand,desc(Duration),desc(Person_count)) |> print(n=Inf)
data.frame(table(cohort_code_iud$Brand)) |> arrange(Freq)
cohort_code_iud |>
  group_by(Brand,Duration) |>
  summarise(Models=length(unique(Source_concept_name)),
            Person_count=sum(Person_count),
            Record_count=sum(Record_count) )
#compare codes
table(iud_codes$iud %in% cohort_code_iud$`concept_ID`)
data.frame(c(iud_codes$iud), c(iud_codes$iud %in% cohort_code_iud$`concept_ID`)) |>
  rename(concept_ID=1,inc=2) |> filter(inc=="FALSE")


#Step 3
#Step 3a: Duration
#Step 3a.1 - 5 years
(cohort_code_iud %>% filter(Duration=="5 years") )$concept_ID
iud_5years <- list("5years"= c(21399040, 21470537, 21348967, 21450903, 21441018, 21349000, 21327814, 21350078, 21470538,
                   21337994, 21450144, 21390888, 21329906, 21421598, 21360574, 21421597, 21462392, 21399039,
                   21368651 )) |> newCodelist()
#Step 3a.2 - 10 years
(cohort_code_iud %>% filter(Duration=="5 years") )$concept_ID
iud_10years <- list("10years"=c(21430445, 21389549, 21389357, 21411274, 21368650, 21481322, 21388824)) |>
  newCodelist()
#Step 3b: Brand
#Step 3b.1 - Bayer Plc
(cohort_code_iud %>% filter(Brand=="Bayer Plc") )$concept_ID
iud_BayerPlc <- list("BayerPlc"=c(21399040)) |> newCodelist()
#Step 3b.2 - Durbin Plc
(cohort_code_iud %>% filter(Brand=="Durbin Plc") )$concept_ID
iud_DurbinPlc <- list("DurbinPlc"=c(21470537, 21348967, 21450903, 21441018, 21430445, 21389549, 21349000)) |>
  newCodelist()
#
(cohort_code_iud %>% filter(Brand=="Family Planning Sales Ltd") )$concept_ID
(cohort_code_iud %>% filter(Brand=="Farla Medical Ltd") )$concept_ID
(cohort_code_iud %>% filter(Brand=="Janssen-Cilag Ltd") )$concept_ID
(cohort_code_iud %>% filter(Brand=="Organon Laboratories Ltd") )$concept_ID
(cohort_code_iud %>% filter(Brand=="R.F. Medical Supplies Ltd") )$concept_ID
(cohort_code_iud %>% filter(Brand=="Schering Health Care Ltd") )$concept_ID
(cohort_code_iud %>% filter(Brand=="Williams Medical Supplies Ltd") )$concept_ID




cdm$iud <- cdm$iud |>
  addConceptIntersectField(conceptSet = iud_codes,field = "device_concept_id",allowDuplicates = TRUE) |>
  rename("device_concept_id"="device_concept_id_iud_0_to_inf") |>
  addConceptIntersectFlag(conceptSet = iud_5years) |>
  addConceptIntersectFlag(conceptSet = iud_10years)



#
#### CGM ####

#Step 1
summarise_cohort_code_cgm <- read_csv("analyses/summarise_cohort_code_cgm.csv")
cohort_code_cgm <- summarise_cohort_code_cgm[c(4,3,5:7,11,12)]
glimpse(cohort_code_cgm )
cohort_code_cgm <- cohort_code_cgm |>
  mutate(Brand = ifelse(str_detect(`Standard concept name`, "Dexcom")==TRUE,"Dexcom",
                    ifelse(str_detect(`Standard concept name`, "FreeStyle Libre")==TRUE,"FreeStyle Libre","NA") )) |>
  select(`Standard concept ID`, `Standard concept name`,Brand,`CPRD GOLD: Person count`,`CPRD GOLD: Record count`) |>
  rename(concept_ID=1,concept_name=2,Person_count=4,Record_count=5)
cohort_code_cgm |> print(n=Inf)


#Step 2
#Summarise by Brand
cohort_code_cgm$Person_count <- as.numeric(gsub("[,<]","",cohort_code_cgm$Person_count) )
cohort_code_cgm$Record_count <- as.numeric(gsub("[,<]","",cohort_code_cgm$Record_count) )
cohort_code_cgm |> arrange(desc(Person_count)) |> print(n=Inf)
cohort_code_cgm |> arrange(Brand,desc(Person_count)) |> print(n=Inf)
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


#
#### Dressings ####

#Step 1
summarise_cohort_code_dressings <- unique(read_csv("analyses/summarise_cohort_code_use_dressings.csv"))
cohort_code_dre <- summarise_cohort_code_dressings[c(2,4,3,5,11,12)]|>
  rename(concept_ID=2,concept_name=3,Person_count=5,Record_count=6,type=1) |>
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
table((cohort_code_dre |> filter(is.na(Brand)) )$type)


#Step 3
dressing_codes <- importCodelist(here("..", "diagnosticsCode",
                                             "antimicrobial_dressings", "cohorts", "codelists"))
cdm$dre <- cdm$dre |>
  addConceptIntersectFlag(conceptSet = silver_dressing_codes ) |>
  addConceptIntersectFlag(conceptSet = silver_dressing_codes )

