
codes <- importCodelist(here::here("antimicrobial_dressings", "cohorts", "codelists"))

# diagnoses -----
# device -----
cdm$antimicrobial_dressings <- conceptCohort(cdm,
                          conceptSet = codes,
                          name = "antimicrobial_dressings",
                          exit = "event_start_date")

attr(cdm$antimicrobial_dressings, "cohort_set") <- attr(cdm$antimicrobial_dressings, "cohort_set") |>
  mutate(group = "antimicrobial_dressings")
