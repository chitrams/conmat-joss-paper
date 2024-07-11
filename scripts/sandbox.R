# Set-up ---------

library(conmat)
library(tidyverse)

set.seed(2022 - 12 - 19)

# Obtain data from conmat ----------

single_contact <- get_polymod_contact_data(setting = "all")

# Extract setting-wise contact data
polymod_contact_data <- get_polymod_setting_data()
polymod_survey_data <- get_polymod_population()