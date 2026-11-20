
library(PhenotypeR)
library(PatientProfiles)
library(CDMConnector)
library(CohortConstructor)
library(duckdb)
library(here)
library(omock)
library(DBI)
library(omopgenerics)
library(CodelistGenerator)
library(readr)
library(stringr)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(OmopSketch)
library(CohortCharacteristics)
library(odbc)
library(RPostgres)
library(purrr)


#Step 1: creating codelists
## skip if already done 
## repeat b and c for all implants of interest 
#Step 1a
here()
cdm <- cdm                                                                          #change cdm to your cdm
#Step 1b - create codelist
implant_code <-                                                                     #change implant to your device 
  list(implant=c(
    getCandidateCodes(cdm=cdm, keywords = c("implant"),domains="Device")$concept_id #change to your codes
  )  ) |> 
  newCodelist()
#Step 1c - export codelist
implant_code |>  
  exportCodelist(
    here::here("datathon","example","codelist"), 
    type = "csv") 


#Step 2: create device cohort
#Step 2a - codelist
## import .csv files of codelists
implant_codes <- importCodelist(here::here("datathon","example","codelist")) #change to your file path
#Step 2b - cohort
cdm$implant <- conceptCohort(
  cdm = cdm, conceptSet = implant_codes,
  name = "implant" ) |>
  addDemographics( age = TRUE, sex = TRUE ) 
glimpse(cdm$implant)

#Step 3 - summarise characteristics
## basic
tableCharacteristics(result = cdm$implant |> summariseCharacteristics(), header = "cohort_name")
## add age groups
tableCharacteristics(result = 
                       cdm$implant |>
                       addAge(ageGroup = list(c(0,17), c(18, Inf))) |>
                       summariseCharacteristics( strata = list("age_group") ) ) 
## add intersect with another concept (flagged as yes/no)
tableCharacteristics(
  result = 
    cdm$implant |>
    addAge(ageGroup = list(c(0,17), c(18, Inf))) |>
    addConceptIntersectFlag(
      conceptSet = list("con" = 
                          getDescendants(cdm, 201254)$concept_id) #change to codes for your concept
      ) |> 
    mutate("condition" = ifelse(con_0_to_inf==1, "Yes", "No")) |>
    summariseCharacteristics( strata = list("age_group"), 
                              otherVariables = c("condition") ) )
