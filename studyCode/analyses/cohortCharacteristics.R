if(db_name == "GOLD"){
  cdm$study_cohorts_char <- cdm$study_cohorts |>
    subsetCohorts(cohortId = c("cgm", "iud", "antimicrobial_dressing"),
                  name = "study_cohorts_char") |>
    addCountry()
}

results[["chars"]] <- summariseCharacteristics(
  cohort = cdm$study_cohorts_char,
  ageGroup = list(c(0,17), c(18, 64),
                  c(65, 150)),
  otherVariables = "country"
)

### LSC

results[["lsc"]] <- summariseLargeScaleCharacteristics(
  cdm$study_cohorts_char,
  window = list(c(-Inf, -366), c(-365, -31), c(-30, -1), c(0, 0), c(1, 30), c(31, 365),
                c(366, Inf)),
  eventInWindow = c("condition_occurrence", "procedure_occurrence",
                    "drug_era", "drug_exposure"),
)


