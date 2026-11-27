

# cgm -----
cgm_codes <- importCodelist(here("..", "diagnosticsCode",
                           "cgm", "cohorts", "codelists"))
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

# silver dressings -----
silver_dressing_codes <- importCodelist(here("..", "diagnosticsCode",
                                 "silver_dressings", "cohorts", "codelists"))
cdm$silver_dressings <- conceptCohort(cdm,
                         conceptSet = silver_dressing_codes,
                         name = "silver_dressings",
                         exit = "event_start_date")

# asthma app ------
asthma_codes <- importCodelist(here("..", "diagnosticsCode",
                                             "asthma/cohorts", "codelists"))

# bind
cdm <- bind(cdm$cgm,
            cdm$iud,
            cdm$silver_dressings,
            name = "study_cohorts")
