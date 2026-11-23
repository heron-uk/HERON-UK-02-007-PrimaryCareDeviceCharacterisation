
to_run <- c("cgm","smart_insulin_pen",
            "asthma","insomnia","copd")

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
if("smart_insulin_pen" %in% to_run){
  logMessage("GETTING SMART INSULIN PEN COHORTS")
  source(here("smart_insulin_pen", "cohorts", "instantiateCohorts.R"))
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
                                    populationDiagnostics = list(populationDateRange = c(as.Date("2018-01-01"),
                                                                                         as.Date(NA))))

exportSummarisedResult(diagnostics,
                       minCellCount = minCellCount,
                       fileName = "phenotyper_results_{cdm_name}_{date}.csv",
                       path = resultsFolder)
logMessage("Finished")
