#Step 1: creating codelists
## skip if already done 
## repeat for all implants of interest 
#Step 1a - create codelist
implant_code <-                                                                     
  list(implant=c(                                                                   #change implant to your device 
    getCandidateCodes(cdm=cdm, keywords = c("implant"),domains="Device")$concept_id #change to your codes
  )  ) |> 
  newCodelist()
#Step 1b - export codelist
implant_code |>  
  exportCodelist(
    here::here("datathon","example","codelist"), 
    type = "csv") 


#Step 2: create device cohort
#Step 2a - codelist
## import .csv files of codelists
implant_codes <- importCodelist(here::here("datathon", "example"), "codelist") #change to your file path
implant_codes <- importCodelist(here::here("/Users/ah22023/Documents/GitHub/
                                           HERON-UK-02-007-PrimaryCareDeviceCharacterisation/diagnosticsCode/cgm/
                                           cohorts/codelists/")) #e.g. continuous glucose monitor codes


#Step 2b - cohort
#Step 2b - cohort
cdm$implant <- conceptCohort(
  cdm = cdm, conceptSet = implant_codes,
  name = "implant" ) |>
  addDemographics( age = TRUE, sex = TRUE ) 
glimpse(cdm$implant)


#Step 3 - summarise characteristics
device_summary_long <- list(c())
for (i in 1:length(implant_codes) ) {
  implant_name <- paste0(names(implant_codes)[[i]])
  codes <- list(implant = c(implant_codes[[i]])) |> newCodelist() 
  cdm[[paste0(implant_name)]] <- conceptCohort(
    cdm = cdm, conceptSet = codes,
    name = implant_name ) |>
    addDemographics( age = TRUE, sex = TRUE ) |>
    addAge(ageGroup = list(c(0,17), c(18, Inf)))
  device_summary_long[[paste0(implant_name)]] <- 
    cdm[[paste0(implant_name)]] |> summariseCharacteristics(strata = list("age_group"))
}
device_summary_long
tableCharacteristics(device_summary_long[[paste0(implant_name)]])


#Step 4: Tables of Characteristics
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
