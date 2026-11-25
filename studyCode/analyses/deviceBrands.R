
#####

##IUD
#hormonal vs non hormonal
#long term : hormonal, unexpected pregnancy
#unintended preg, expulsion, perforation, clincally relevent comp
#link to preocdedure code - are there IUD insert/removal codes?
#IUD records, charactsie, summarisecharacteristics() of those who have record procedure
#codes for hormonal IUSs
#first ever record
#365 day prior history
#age brand
#windows (366-5yr, 5yr-10yr)
#discuss how estimate duration till new mplant or removal code or x years (according to type) - discuss in paper


#####
library(ggplot2)
library(treemapify)
library(colorspace)
library(scales)
library(readr)
library(tidyverse)
library(OmopSketch)
library(cowplot)
library(RColorBrewer)
library(dplyr)
library(omopgenerics)
library(CohortConstructor)
library(CDMConnector)
library(CodelistGenerator)
library(omock)
library(duckdb)
library(CDMConnector)
library(dplyr)
library(tidyr)
library(here)

source("iud/cohorts/codelists/codelistDevelopment.R")
source("iud/cohorts/instantiateCohorts.R")
source("analyses/instantiateCohorts.R")

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
cdm$iud <- cdm$iud |>
  addConceptIntersectField(conceptSet = iud_codes,field = "device_concept_id",allowDuplicates = TRUE) |>
  rename("device_concept_id"="device_concept_id_iud_0_to_inf")

for (i in 1:nrow(cohort_code_iud)) {
  indiv_iud_code <- list(iud=cohort_code_iud$concept_ID[[i]]) |> newCodelist()
  cdm[[paste0("iud_",cohort_code_iud$concept_ID[[i]])]] <-
    conceptCohort(cdm = cdm,
                conceptSet = indiv_iud_code,
                name = paste0("iud_",cohort_code_iud$concept_ID[[i]]) ,
                exit = "event_start_date")
}
cdm$iud <- { cdm$iud |>

  #21399040 Nova-T 380 Bayer Plc 5 years (1)
  addCohortIntersectFlag(targetCohortTable = "iud_21399040" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21399040"=(ncol(cdm$iud)+1)) |>

  #21470537 Flexi-T 300 Durbin Plc 5 years (2)
  addCohortIntersectFlag(targetCohortTable = "iud_21470537" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21470537"=(ncol(cdm$iud)+2)) |>

  #21348967 Flexi-T+ 380 Durbin Plc 5 years (3)
  addCohortIntersectFlag(targetCohortTable = "iud_21348967" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21348967"=(ncol(cdm$iud)+3)) |>

  #21450903 Load 375 Durbin Plc 5 years (4)
  addCohortIntersectFlag(targetCohortTable = "iud_21450903" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21450903"=(ncol(cdm$iud)+4)) |>

  #21441018 Mini TT380 Slimline Durbin Plc 5 years (5)
  addCohortIntersectFlag(targetCohortTable = "iud_21441018" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21441018"=(ncol(cdm$iud)+5)) |>

  #21430445 TT380 Slimline Durbin Plc 10 years (6)
  addCohortIntersectFlag(targetCohortTable = "iud_21430445" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21430445"=(ncol(cdm$iud)+6)) |>

  #21389549 UT380 Short Durbin Plc 10 years (7)
  addCohortIntersectFlag(targetCohortTable = "iud_21389549" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21389549"=(ncol(cdm$iud)+7)) |>

  #21349000
  addCohortIntersectFlag(targetCohortTable = "iud_21349000" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21349000"=(ncol(cdm$iud)+8)) |>

  #21327814
  addCohortIntersectFlag(targetCohortTable = "iud_21327814" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21327814"=(ncol(cdm$iud)+9)) |>

  #21350078
  addCohortIntersectFlag(targetCohortTable = "iud_21350078" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21350078"=(ncol(cdm$iud)+10)) |>

  #21389357 Gyne-T 380S
  addCohortIntersectFlag(targetCohortTable = "iud_21389357" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21389357"=(ncol(cdm$iud)+11)) |>

  #21470538 Multiload Cu250 Short
  addCohortIntersectFlag(targetCohortTable = "iud_21470538" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21470538"=(ncol(cdm$iud)+12)) |>

  #21337994 Multiload Cu250 (13)
  addCohortIntersectFlag(targetCohortTable = "iud_21337994" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21337994"=(ncol(cdm$iud)+13)) |>

  #21450144 Multiload Cu375 (14)
  addCohortIntersectFlag(targetCohortTable = "iud_21450144" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21450144"=(ncol(cdm$iud)+14)) |>

  #21390888 Ancora 375 Cu (15)
  addCohortIntersectFlag(targetCohortTable = "iud_21390888" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21390888"=(ncol(cdm$iud)+15)) |>

  #21411274 Copper T380 A (16)
  addCohortIntersectFlag(targetCohortTable = "iud_21411274" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21411274"=(ncol(cdm$iud)+16)) |>

  #21329906 Eurogine T 380 Ag mini
  addCohortIntersectFlag(targetCohortTable = "iud_21329906" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21329906"=(ncol(cdm$iud)+17)) |>

  #21421598 Eurogine T 380 Ag normal (18)
  addCohortIntersectFlag(targetCohortTable = "iud_21421598" , window = list(c(0, 0)), name="iud" ) |>
  rename("iud_21421598"=(ncol(cdm$iud)+18)) |>

    #21360574 Eurogine T 380 Cu mini
    addCohortIntersectFlag(targetCohortTable = "iud_21360574" , window = list(c(0, 0)), name="iud" ) |>
    rename("iud_21360574"=(ncol(cdm$iud)+19)) |>

    #21421597 Eurogine T 380 Cu normal
    addCohortIntersectFlag(targetCohortTable = "iud_21421597" , window = list(c(0, 0)), name="iud" ) |>
    rename("iud_21421597"=(ncol(cdm$iud)+20)) |>

    #21462392 Novaplus T 380 Ag maxi (21)
    addCohortIntersectFlag(targetCohortTable = "iud_21462392" , window = list(c(0, 0)), name="iud" ) |>
    rename("iud_21462392"=(ncol(cdm$iud)+21)) |>

    #21399039 Nova-T
    addCohortIntersectFlag(targetCohortTable = "iud_21399039" , window = list(c(0, 0)), name="iud" ) |>
    rename("iud_21399039"=(ncol(cdm$iud)+22)) |>

    #21368650 GyneFix Williams Medical
    addCohortIntersectFlag(targetCohortTable = "iud_21368650" , window = list(c(0, 0)), name="iud" ) |>
    rename("iud_21368650"=(ncol(cdm$iud)+23)) |>

    #21368651 Multi-Safe 375 Williams Medical
    addCohortIntersectFlag(targetCohortTable = "iud_21368651" , window = list(c(0, 0)), name="iud" ) |>
    rename("iud_21368651"=(ncol(cdm$iud)+24)) |>

    #21481322 Neo-Safe T380 Williams Medical (25)
    addCohortIntersectFlag(targetCohortTable = "iud_21481322" , window = list(c(0, 0)), name="iud" ) |>
    rename("iud_21481322"=(ncol(cdm$iud)+25)) |>

    #21388824 T-Safe 380A QL Williams Medical (26)
    addCohortIntersectFlag(targetCohortTable = "iud_21388824" , window = list(c(0, 0)), name="iud" ) |>
    rename("iud_21388824"=(ncol(cdm$iud)+26))
}


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

