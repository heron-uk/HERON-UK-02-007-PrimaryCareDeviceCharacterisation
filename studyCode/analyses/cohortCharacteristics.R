results[["chars"]] <- summariseCharacteristics(
  cdm$study_cohorts,
  ageGroup = list(c(0,17), c(18, 64), c(65, 150))
)

### LSC

results[["lsc"]] <- summariseLargeScaleCharacteristics(
  cdm$study_cohorts,
  window = list(c(-Inf, -366), c(-365, -31), c(-30, -1), c(0, 0), c(1, 30), c(31, 365),
                c(366, Inf), c(366, 1825), c(1826, 3650)),
  eventInWindow = c("condition_occurrence", "procedure_occurrence",
                    "drug_exposure")
)


