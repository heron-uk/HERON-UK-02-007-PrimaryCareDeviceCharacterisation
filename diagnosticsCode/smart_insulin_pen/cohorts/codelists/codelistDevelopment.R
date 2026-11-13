
# diagnoses/ meds
# t1_diabetes <- CodelistGenerator::getDescendants(cdm, 201254)$concept_id
# t2_diabetes <- CodelistGenerator::getDescendants(cdm, 201826)$concept_id
# insulin <- CodelistGenerator::getCandidateCodes(cdm, "insulin", domains = "drug")$concept_id

# device snomed
smart_pen <- list(
  novopen_echo_plus = c(36961108, 36940362, 36935069,
                        36952051, 21411250, 21390868), # NovoPen Echo Plus
  novopen_6 = c(36950519, 36936336) # NovoPen 6
  ) |>
  newCodelist()
smart_pen <- smart_pen |>
  unionCodelists("smart_insulin_pen",
                 keepOriginal = TRUE)

# export codelists
smart_pen |>
  exportCodelist(here::here("smart_insulin_pen", "cohorts","codelists"), type = "csv")


