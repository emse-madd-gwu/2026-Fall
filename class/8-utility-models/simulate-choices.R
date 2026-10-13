# Make conjoint surveys using the cbcTools package

# Install packages
# install.packages("remotes")
# install.packages("fastDummies")
# remotes::install_github("jhelvy/cbcTools")

# Load libraries
library(cbcTools)
library(logitr)
library(fastDummies)

# Define profiles with attributes and levels
profiles <- cbc_profiles(
  price = c(15, 20, 25), # Price ($1,000)
  fuelEconomy = c(20, 25, 30), # Fuel economy (mpg)
  accelTime = c(6, 7, 8), # 0-60 mph acceleration time (s)
  powertrain = c("Gasoline", "Hybrid", "Electric")
)

# Make a full-factorial design of experiment
design <- cbc_design(
  profiles = profiles,
  n_resp = 1000, # Number of respondents
  n_alts = 3, # Number of alternatives per question
  n_q = 8 # Number of questions per respondent
)

# --------------------
# Simulate choice data!
# --------------------

# Simulate random choices
data <- cbc_choices(
  design = design
)

# Use cbcTools package to get some reasonable starting assumptions
# for prior parameter values
cbc_suggest_priors(profiles)

# Simulate choices according to an assumed utility model
priors <- cbc_priors(
  profiles = profiles,
  price = -0.7,
  fuelEconomy = 0.1,
  accelTime = -0.2,
  powertrain = c('Hybrid' = 0.5, 'Electric' = -4.0)
)

data <- cbc_choices(
  design = design,
  priors = priors
)

# Simulated choices use standard coding (powertrain is a factor).
# Dummy code it before estimating a model. Gasoline is the reference level,
# so we leave powertrain_Gasoline out of "pars" below.
data <- dummy_cols(data, "powertrain")

# NOTE: If your design has a no_choice option, cbc_choices() has already dummy
# coded your data. Skip the step above and use the column names it created
# (powertrainHybrid, powertrainElectric) in "pars" below.

# Estimate a model
model <- logitr(
  data = data,
  outcome = "choice",
  obsID = "obsID",
  pars = c(
    "price",
    "fuelEconomy",
    "accelTime",
    "powertrain_Hybrid",
    "powertrain_Electric"
  )
)

summary(model)
