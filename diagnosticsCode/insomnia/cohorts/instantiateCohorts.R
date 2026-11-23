
codes <- importCodelist(here::here("insomnia", "cohorts", "codelists"))
# diagnoses -----
cdm$diagnoses <- conceptCohort(cdm,
                               conceptSet = codes[c("insomnia")],
                               name = "diagnoses",
                               exit = "event_start_date")

# app -----
cdm$insomnia_app <- conceptCohort(cdm,
                                conceptSet = codes[c("insomnia_app")],
                                name = "insomnia_app",
                                exit = "event_start_date")

# bind -----
cdm <- bind(cdm$diagnoses,
            cdm$insomnia_app,
            name = "insomnia")
attr(cdm$insomnia, "cohort_set") <- attr(cdm$insomnia, "cohort_set") |>
  mutate(group = "insomnia")
