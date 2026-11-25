## Incidence
### denominator cohorts

cdm <- generateDenominatorCohortSet(
  cdm = cdm,
  name = "inc_denominator",
  cohortDateRange = study_period,
  ageGroup = list(c(0, 150)),
  sex = c("Both", "Female"),
  daysPriorObservation = 365
)


results[["incidence"]] <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "inc_denominator",
  outcomeTable = "study_cohorts",
  interval = c("years", "overall"),
  outcomeWashout = Inf,
  repeatedEvents = FALSE
)

## Prevalence - TO CHECK

cdm <- generateTargetDenominatorCohortSet(
  cdm = cdm,
  targetCohortTable = "diabetes",
  name = "prev_denominator",
  ageGroup = list(c(0, 150)),
  sex = "Both",
  daysPriorObservation = 365,
  cohortDateRange = study_period
)

results[["prevalence"]] <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "prev_denominator",
  outcomeTable = "study_cohorts",
  outcomeCohortId = "cgm",
  interval = c("overall", "years")
)

