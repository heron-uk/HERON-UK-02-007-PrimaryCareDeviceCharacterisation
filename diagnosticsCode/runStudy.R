
to_run <- c("cgm","iud","antimicrobial_dressings",
            "asthma","copd","insomnia")

# create logger ----
resultsFolder <- here("results")
if(!dir.exists(resultsFolder)){
  dir.create(resultsFolder)
}

createLogFile(logFile = tempfile(pattern = "log_{date}_{time}"))
logMessage("LOG CREATED")


# cohorts ----
if("cgm" %in% to_run){
  logMessage("GETTING CGM COHORTS")
  source(here("cgm", "cohorts", "instantiateCohorts.R"))
}
if("iud" %in% to_run){
  logMessage("GETTING IUD COHORTS")
  source(here("iud", "cohorts", "instantiateCohorts.R"))
}
if("antimicrobial_dressings" %in% to_run){
  logMessage("GETTING ANTIMICROBIAL DRESSINGS COHORTS")
  source(here("antimicrobial_dressings", "cohorts", "instantiateCohorts.R"))
}
if("asthma" %in% to_run){
  logMessage("GETTING ASTHMA COHORTS")
  source(here("asthma", "cohorts", "instantiateCohorts.R"))
}
if("copd" %in% to_run){
  logMessage("GETTING COPD COHORTS")
  source(here("copd", "cohorts", "instantiateCohorts.R"))
}
if("insomnia" %in% to_run){
  logMessage("GETTING INSOMNIA COHORTS")
  source(here("insomnia", "cohorts", "instantiateCohorts.R"))
}

logMessage("COMBINE INTO SINGLE COHORT TABLE")
cdm <- do.call(
  what = bind,
  args = c(
    lapply(to_run, function(x) cdm[[x]]),
    list(name = "study_cohorts")
  )
)

# run ----
logMessage("Running PhenotypeDiagnostics")
diagnostics <- phenotypeDiagnostics(cdm$study_cohorts,
                                    cohortDiagnostics = list(compareCohorts = TRUE),
                                    populationDiagnostics = list(populationDateRange = c(as.Date("2016-01-01"),
                                                                                         as.Date(NA))))

exportSummarisedResult(diagnostics,
                       minCellCount = minCellCount,
                       fileName = "phenotyper_results_{cdm_name}_{date}.csv",
                       path = resultsFolder)
logMessage("Finished")
