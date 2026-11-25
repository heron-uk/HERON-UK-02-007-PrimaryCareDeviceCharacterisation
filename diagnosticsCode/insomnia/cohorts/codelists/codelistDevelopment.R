
# diagnoses
list(insomnia = getDescendants(cdm, 436962) |>
  pull(concept_id)) |>
  exportCodelist(here::here("insomnia", "cohorts","codelists"), type = "csv")


# app
list(insomnia_app = c(37208615, 37208616)) |>
  exportCodelist(here::here("insomnia", "cohorts","codelists"), type = "csv")

