
# diagnoses/ meds
t1_diabetes <- CodelistGenerator::getDescendants(cdm, 201254)$concept_id
t2_diabetes <- CodelistGenerator::getDescendants(cdm, 201826)$concept_id
# insulin <- CodelistGenerator::getCandidateCodes(cdm, "insulin", domains = "drug")$concept_id

# device snomed
# nb Accu-Chek SmartGuide Sensor not in omop dmd (added January 2026)
cgm <- list(
  cgm_dexcom_g6 = c(891070, 882115, 888630), # Dexcom G6 Sensor
  cgm_dexcom_g7 = c(885453, 889729, 891653), # Dexcom G7 Sensor
  cgm_dexcom_one = c(36964253, 36924428, 36944703), # Dexcom One Sensor
  cgm_dexcom_one_plus = c(886971, 885073), # Dexcom One+
  cgm_freestyle_libre_2_plus = c(888893, 896954, 35402057), # FreeStyle Libre 2 Plus Sensor
  cgm_freestyle_libre_2 = c(35889967, 35891819), # FreeStyle Libre 2 Sensor
  cgm_freestyle_libre_3_plus = c(837419, 879292), # FreeStyle Libre 3 Plus Sensor
  cgm_freestyle_libre_3 = c(880079, 897543), # FreeStyle Libre 3 Sensor
  cgm_freestyle_libre_plus = c(40677414, 42524374, 40675740), #FreeStyle Libre Sensor
  cgm_a8_touchcare_nano = c(886918, 891479), #A8 TouchCare Nano Sensor
  cgm_caresens_air= c(893573, 897329) # CareSens Air Sensor
  ) |>
  newCodelist()
cgm <- cgm |>
  unionCodelists("cgm",
                 keepOriginal = TRUE)


# export codelists
cgm |>
  exportCodelist(here::here("cgm", "cohorts","codelists"), type = "csv")


