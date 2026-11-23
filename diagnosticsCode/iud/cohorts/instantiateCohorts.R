
codes <- importCodelist(here::here("iud", "cohorts", "codelists"))

# device -----
cdm$iud <- conceptCohort(cdm,
                          conceptSet = codes,
                          name = "iud",
                          exit = "event_start_date")

attr(cdm$iud, "cohort_set") <- attr(cdm$iud, "cohort_set") |>
  mutate(group = "iud")
