
# diagnoses
list(asthma = getDescendants(cdm, 317009) |>
  pull(concept_id)) |>
  exportCodelist(here::here("asthma", "cohorts","codelists"), type = "csv")

# app
list(accepted_asthma_app = c(37310765)) |>
  exportCodelist(here::here("asthma", "cohorts","codelists"), type = "csv")
list(declined_asthma_app = c(37310762)) |>
  exportCodelist(here::here("asthma", "cohorts","codelists"), type = "csv")

