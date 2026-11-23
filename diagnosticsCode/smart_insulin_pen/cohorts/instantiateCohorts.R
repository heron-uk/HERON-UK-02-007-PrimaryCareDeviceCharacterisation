
codes <- importCodelist(here::here("smart_insulin_pen", "cohorts", "codelists"))

# device -----
cdm$smart_insulin_pen <- conceptCohort(cdm,
                         conceptSet = codes,
                         name = "smart_insulin_pen",
                         exit = "event_start_date")

attr(cdm$smart_insulin_pen, "cohort_set") <- attr(cdm$smart_insulin_pen, "cohort_set") |>
  mutate(group = "smart_insulin_pen")
