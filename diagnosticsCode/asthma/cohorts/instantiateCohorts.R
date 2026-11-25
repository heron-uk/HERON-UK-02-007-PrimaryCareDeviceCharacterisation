
codes <- importCodelist(here::here("asthma", "cohorts", "codelists"))
# diagnoses -----
cdm$diagnoses <- conceptCohort(cdm,
                               conceptSet = codes[c("asthma")],
                               name = "diagnoses",
                               exit = "event_start_date")

# app -----
cdm$asthma_app <- conceptCohort(cdm,
                              conceptSet = codes[str_detect(names(codes), "asthma_app")],
                              name = "asthma_app",
                              exit = "event_start_date")

# bind -----
cdm <- bind(cdm$diagnoses,
            cdm$asthma_app,
            name = "asthma")
attr(cdm$asthma, "cohort_set") <- attr(cdm$asthma, "cohort_set") |>
  mutate(group = "asthma")
