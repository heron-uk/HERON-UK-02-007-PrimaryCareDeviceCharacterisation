
results[["chars"]] <- summariseCharacteristics(
  cdm$study_cohorts,
  ageGroup = list(c(0,17), c(18, Inf))
  )

results[["chars_cgm"]] <- summariseCharacteristics(
  cdm$cgm |>
    addAge( ageGroup = list(c(0,17), c(18, Inf)) ),
  otherVariables = c("brand"),
  strata=list("sex","age_group")
  )

results[["chars_iud"]] <- summariseCharacteristics(
  cdm$iud |>
    requireAge(ageRange = c(18,55)) |>
    requireSex(sex = "Female"),
  otherVariables = c("brand"),
  strata = list("duration")
  )

results[["sum_large_chars"]] <- summariseLargeScaleCharacteristics(
  cdm$study_cohorts,
  window = list(c(31, 1825)),
  eventInWindow = "condition_occurrence"
  )


