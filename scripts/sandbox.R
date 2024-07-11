# Set-up ---------

library(conmat)
library(tidyverse)
library(gratia)
library(patchwork)

set.seed(2022 - 12 - 19)

# Obtain data from conmat ----------

# Extract setting-wise contact data
polymod_contact_data <- get_polymod_setting_data()
polymod_survey_data <- get_polymod_population()

# Fit the model
polymod_setting_models <- fit_setting_contacts(
  contact_data_list = polymod_contact_data,
  population = polymod_survey_data
)

p_home <- polymod_setting_models$home
p_work <- polymod_setting_models$work
p_school <- polymod_setting_models$school
p_other <- polymod_setting_models$other

# Home setting-specific -------------

#%% Partial dependency plots ------
# Of each covariate
pdp_home <- draw(p_home, residuals = TRUE) + plot_annotation(title = "Home setting")
ggsave(pdp_home,
       filename = "pdp_home.png",
       device = "png",
       height = 15, width = 20, units = "cm")

#%% Model summary -----
summary(p_home)

#%% Smooth estimates -----
sm_home <- smooth_estimates(p_home)

dat_home <- sm_home %>% 
  pivot_longer(
    cols = starts_with("gam_age"),
    names_prefix = "gam_age_",
    values_to = "x_value"
  ) %>% 
  filter(!is.na(x_value)) %>% 
  select(!c(`.type`, `.by`, `.smooth`)) %>% 
  rename(estimate = `.estimate`, se = `.se`) %>% 
  relocate(name)

#TODO: Better to rename these covariates, especially "estimate" and "x_value"

# Save the smooth estimates
write_csv(dat_home, "./output/smooth-values-home.csv")
