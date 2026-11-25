# cgm -----
cgm_codes <- importCodelist(here("codelist", "cgm"))

cdm$cgm <- conceptCohort(cdm,
                         conceptSet = cgm_codes,
                         name = "cgm",
                         exit = "event_start_date")

# iud -----
iud_codes <- importCodelist(here("codelist", "iud"))

cdm$iud <- conceptCohort(cdm,
                         conceptSet = iud_codes,
                         name = "iud",
                         exit = "event_start_date")

# dressings -----
dress_codes <- importCodelist(here("codelist", "dressing"))

cdm$antimicrobial_dressings <- conceptCohort(cdm,
                         conceptSet = dress_codes,
                         name = "antimicrobial_dressings",
                         exit = "event_start_date")

### Diabetes

diabetes_cl <- importCodelist(here("codelist", "diabetes"))

cdm$diabetes <- conceptCohort(cdm = cdm,
                              conceptSet = diabetes_cl,
                              name = "diabetes",
                              exit = "event_start_date") |>
  requireIsFirstEntry() |>
  exitAtObservationEnd()

## Study cohorts

# bind
cdm <- bind(cdm$cgm,
            cdm$iud,
            cdm$antimicrobial_dressings,
            name = "study_cohorts")

cdm$study_cohorts <- cdm$study_cohorts |>
  requirePriorObservation(minPriorObservation = 365,
                          atFirst = TRUE) |>
  requireInDateRange(dateRange = study_period,
                     indexDate = "cohort_end_date") |>
  requireSex(sex = "Female",
             cohortId = "iud") |>
  requireAge(ageRange = c(18, 55),
             cohortId = "iud") |>
  padCohortEnd(cohortId = "cgm",
               days = 30,
               collapse = TRUE) |>
  collapseCohorts(cohortId = "cgm",
                  gap = 30)

### Diabetes

diabetes_cl <- importCodelist(here("codelist", "diabetes"))

cdm$diabetes <- conceptCohort(cdm = cdm,
                              conceptSet = diabetes_cl,
                              name = "diabetes",
                              exit = "event_start_date") |>
  requireIsFirstEntry() |>
  exitAtObservationEnd()
