

results[["chars"]] <- summariseCharacteristics(
  cdm$study_cohorts,
  ageGroup = list(c(0,17), c(18, Inf))
  )

results[["sum_chars_devices"]] <- summariseCharacteristics(
  cdm$study_cohorts,
  strata="device_concept_id"
  )

results[["sum_large_chars"]] <- summariseLargeScaleCharacteristics(
  cdm$study_cohorts,
  window = list(c(1, 1825)),
  eventInWindow = "condition_occurrence"
  )


