
# diagnoses
list(copd = getDescendants(cdm, 436962) |>
  pull(concept_id)) |>
  exportCodelist(here::here("copd", "cohorts","codelists"), type = "csv")


# app
list(accepted_copd_app = c(36685477)) |>
  exportCodelist(here::here("copd", "cohorts","codelists"), type = "csv")
list(declined_copd_app = c(36685473)) |>
  exportCodelist(here::here("copd", "cohorts","codelists"), type = "csv")

