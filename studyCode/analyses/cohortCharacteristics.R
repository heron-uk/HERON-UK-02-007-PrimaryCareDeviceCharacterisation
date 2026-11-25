results[["chars"]] <- summariseCharacteristics(
  cohort = cdm$study_cohorts,
  cohortId = c("cgm", "iud", "antimicrobial_dressing"),
  ageGroup = list(c(0,17), c(18, 64),
                  c(65, 150))
)

### LSC

results[["lsc"]] <- summariseLargeScaleCharacteristics(
  cdm$study_cohorts,
  cohortId = c("cgm", "iud", "antimicrobial_dressing"),
  window = list(c(-Inf, -366), c(-365, -31), c(-30, -1), c(0, 0), c(1, 30), c(31, 365),
                c(366, Inf)),
  eventInWindow = c("condition_occurrence", "procedure_occurrence",
                    "drug_exposure")
)


