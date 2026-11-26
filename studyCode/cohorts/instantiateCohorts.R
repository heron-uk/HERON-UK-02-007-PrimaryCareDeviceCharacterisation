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

cohort_names <- settings(cdm$study_cohorts) |> pull(cohort_name)
cohorts_30 <- cohort_names[!cohort_names %in% c("cgm", "iud")]

cdm$study_cohorts <- cdm$study_cohorts |>
  requirePriorObservation(minPriorObservation = 365,
                          atFirst = TRUE,
                          cohortId = c("cgm", "iud")) |>
  requirePriorObservation(minPriorObservation = 30,
                          atFirst = TRUE,
                          cohortId = cohorts_30) |>
  requireInDateRange(dateRange = study_period) |>
  requireSex(sex = "Female",
             cohortId = "iud") |>
  requireAge(ageRange = c(18, 55),
             cohortId = "iud") |>
  collapseCohorts(cohortId = "cgm",
                  gap = 90)

### Diabetes

diabetes_cl <- importCodelist(here("codelist", "diabetes"))

cdm$diabetes <- conceptCohort(cdm = cdm,
                              conceptSet = diabetes_cl,
                              name = "diabetes",
                              exit = "event_start_date") |>
  requireIsFirstEntry() |>
  exitAtObservationEnd()
