
codes <- importCodelist(here::here("cgm", "cohorts", "codelists"))

# diagnoses -----
cdm$diagnoses <- conceptCohort(cdm,
                            conceptSet = codes[str_detect(names(codes), "t1|t2")],
                            name = "diagnoses",
                            exit = "event_start_date")

# device -----
cdm$cgm <- conceptCohort(cdm,
                          conceptSet = codes[str_detect(names(codes), "t1|t2", negate = TRUE)],
                          name = "cgm",
                          exit = "event_start_date")

# bind -----
cdm <- bind(cdm$diagnoses,
            cdm$cgm,
            name = "cgm")
attr(cdm$cgm, "cohort_set") <- attr(cdm$cgm, "cohort_set") |>
  mutate(group = "cgm")
