# cgm -----
cgm_codes <- importCodelist(here("codelist", "cgm"))

cdm$cgm <- conceptCohort(cdm,
                         conceptSet = cgm_codes,
                         name = "cgm",
                         exit = "event_start_date")

# iud -----
iud_codes <- importCodelist(here("..", "diagnosticsCode",
                                 "iud", "cohorts", "codelists"))
cdm$iud <- conceptCohort(cdm,
                         conceptSet = iud_codes,
                         name = "iud",
                         exit = "event_start_date")

# bind
cdm <- bind(cdm$cgm,
            cdm$iud,
            name = "study_cohorts")

cdm$study_cohorts <- cdm$study_cohorts |>
  requireIsFirstEntry() |>
  requirePriorObservation(minPriorObservation = 365) |>
  requireInDateRange(dateRange = study_period) |>
  requireSex(sex = "Female",
             cohortId = "iud")

### Diabetes

diabetes_cl <- importCodelist(here("codelist", "diabetes"))

cdm$diabetes <- conceptCohort(cdm = cdm,
                              conceptSet = diabetes_cl,
                              name = "diabetes",
                              exit = "event_start_date") |>
  requireIsFirstEntry() |>
  exitAtObservationEnd()


