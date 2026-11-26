

results[["chars"]] <- summariseCharacteristics(
  cdm$study_cohorts,
  ageGroup = list(c(0,17), c(18, Inf))
  )

results[["chars_cgm"]] <- summariseCharacteristics(
  cdm$cgm,
  ageGroup = list(c(0,17), c(18, Inf)),
  otherVariables = c("cgm_dexcom_0_to_0","cgm_freestyle_libre_0_to_0")
  )

results[["chars_iud"]] <- summariseCharacteristics(
  cdm$iud |>
    requireAge(ageRange = c(18,55)) |>
    requireSex(sex = "Female"),
  otherVariables = c("5years_0_to_0","10years_0_to_0","bayerplc_0_to_0","durbinplc_0_to_0",
                     "familyplanningsalesltd_0_to_0","farlamedicalltd_0_to_0", "janssencilagltd_0_to_0",
                     "oconmedicalltd_0_to_0","organonlaboratoriesltd_0_to_0","rfmedicalsuppliesltd_0_to_0",
                     "scheringhealthcareltd_0_to_0","williamsmedicalsuppliesltd_0_to_0") )

results[["chars_dressings"]] <- summariseCharacteristics(
  cdm |>
    requireAge(ageRange = c(18,55)) |>
    requireSex(sex = "Female"),
  otherVariables = c("iud_5years","iud_10years","iud_BayerPlc","iud_DurbinPlc","iud_FamilyPlanningSalesLtd",
                     "iud_FarlaMedicalLtd", "iud_JanssenCilagLtd","iud_OCONMedicalLtd","iud_OrganonLaboratoriesLtd",
                     "iud_RFMedicalSuppliesLtd","iud_ScheringHealthCareLtd","iud_WilliamsMedicalSuppliesLtd")
)


results[["sum_large_chars"]] <- summariseLargeScaleCharacteristics(
  cdm$study_cohorts,
  window = list(c(31, 1825)),
  eventInWindow = "condition_occurrence"
  )


