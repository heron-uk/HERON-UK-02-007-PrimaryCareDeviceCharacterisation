
codes <- importCodelist(here::here("copd", "cohorts", "codelists"))
# diagnoses -----
cdm$diagnoses <- conceptCohort(cdm,
                            conceptSet = codes[c("copd")],
                            name = "diagnoses",
                            exit = "event_start_date")

# app -----
cdm$copd_app <- conceptCohort(cdm,
                          conceptSet = codes[str_detect(names(codes), "copd_app")],
                          name = "copd_app",
                          exit = "event_start_date")

# bind -----
cdm <- bind(cdm$diagnoses,
            cdm$copd_app,
            name = "copd")
attr(cdm$copd, "cohort_set") <- attr(cdm$copd, "cohort_set") |>
  mutate(group = "copd")
