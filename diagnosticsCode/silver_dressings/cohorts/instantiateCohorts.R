
codes <- importCodelist(here::here("silver_dressings", "cohorts", "codelists"))

# diagnoses -----
# device -----
cdm$silver_dressings <- conceptCohort(cdm,
                          conceptSet = codes,
                          name = "silver_dressings",
                          exit = "event_start_date")

attr(cdm$silver_dressings, "cohort_set") <- attr(cdm$silver_dressings, "cohort_set") |>
  mutate(group = "silver_dressings")
