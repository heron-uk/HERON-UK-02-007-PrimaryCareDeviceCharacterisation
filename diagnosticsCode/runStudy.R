
to_run <- c("cgm","iud","silver_dressings")

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
if("silver_dressings" %in% to_run){
  logMessage("GETTING SILVER DRESSINGS COHORTS")
  source(here("silver_dressings", "cohorts", "instantiateCohorts.R"))
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
