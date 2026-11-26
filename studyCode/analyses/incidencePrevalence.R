## Incidence
### denominator cohorts

cdm <- generateDenominatorCohortSet(
  cdm = cdm,
  name = "inc_denominator_cgm_iud",
  cohortDateRange = study_period,
  ageGroup = list(c(0, 150), c(18, 55)),
  sex = c("Both", "Female"),
  daysPriorObservation = 365
)

cdm$inc_denominator_cgm_iud <- cdm$inc_denominator_cgm_iud |>
  addCountry()


results[["incidence_1"]] <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "inc_denominator_cgm_iud",
  outcomeTable = "study_cohorts",
  outcomeCohortId = c("cgm", "iud"),
  interval = c("years", "overall"),
  outcomeWashout = Inf,
  repeatedEvents = FALSE,
  strata = list(c("country"))
)

cdm <- generateDenominatorCohortSet(
  cdm = cdm,
  name = "inc_denominator_dressings",
  cohortDateRange = study_period,
  ageGroup = list(c(0, 150)),
  sex = c("Both"),
  daysPriorObservation = 30
)

cdm$inc_denominator_dressings <- cdm$inc_denominator_dressings |>
  addCountry()


results[["incidence_2"]] <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "inc_denominator_dressings",
  outcomeTable = "study_cohorts",
  outcomeCohortId = cohorts_30,
  interval = c("years", "overall"),
  outcomeWashout = Inf,
  repeatedEvents = FALSE,
  strata = list(c("country"))
)

## Prevalence - TO CHECK

cdm <- generateTargetDenominatorCohortSet(
  cdm = cdm,
  targetCohortTable = "diabetes",
  name = "prev_denominator",
  ageGroup = list(c(0, 17), c(18, 64), c(65, 150), c(0, 150)),
  sex = "Both",
  daysPriorObservation = 365,
  cohortDateRange = study_period
)

cdm$prev_denominator <- cdm$prev_denominator |>
  addCountry()

results[["prevalence"]] <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "prev_denominator",
  outcomeTable = "study_cohorts",
  outcomeCohortId = "cgm",
  interval = c("overall", "years"),
  strata = list(c("country"))
)

