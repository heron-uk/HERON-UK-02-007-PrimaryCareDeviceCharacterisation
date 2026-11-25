

results[["chars"]] <- summariseCharacteristics(
  cdm$study_cohorts,
  ageGroup = list(c(0,17), c(18, Inf))
  )

results[["sum_chars_devices"]] <- summariseCharacteristics(
  cdm$cgm,
  ageGroup = list(c(0,17), c(18, Inf)),
  cohortIntersectFlag = list( "Dexcom" = list(
    conceptSet = cgm_dexcom_codes, window = c(0, 0)
    )),
  otherVariables = c("cgm_dexcom_0_to_0","cgm_freestyle_libre_0_to_0")
  )

results[["sum_large_chars"]] <- summariseLargeScaleCharacteristics(
  cdm$study_cohorts,
  window = list(c(1, 1825)),
  eventInWindow = "condition_occurrence"
  )


