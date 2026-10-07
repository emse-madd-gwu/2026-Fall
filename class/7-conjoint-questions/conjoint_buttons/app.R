# Package setup ---------------------------------------------------------------

# Install required packages:
# install.packages("pak")
# pak::pak(c(
#   'surveydown-dev/surveydown', # Development version from GitHub
#   'glue',
#   'readr',
#   'dplyr'
# ))

# Load packages
library(surveydown)
library(dplyr)
library(glue)
library(readr)

# Read in the full survey design file
# We'll use this in the server to create the choice questions
design <- read_csv(file.path("data", "choice_questions.csv"))

# Database setup --------------------------------------------------------------
#
# Details at: https://surveydown.org/docs/storing-data
#
# surveydown stores data on any PostgreSQL database. We recommend
# https://supabase.com/ for a free and easy to use service.
#
# Once you have your database ready, run the following function to store your
# database configuration parameters in a local .env file:
#
# sd_db_config()
#
# Once your parameters are stored, you are ready to connect to your database.
# This template runs in preview mode (set via `mode: preview` in survey.qmd),
# which saves responses locally instead of to a database. To collect real
# responses, run sd_db_config() to store your database credentials, then
# change `mode` to `database` in the survey.qmd YAML header.

db <- sd_db_connect()

# UI setup --------------------------------------------------------------------

ui <- sd_ui()

# Helper functions ------------------------------------------------------------
#
# Function to create the question options based on design values
#
# CUSTOMIZE THIS FUNCTION FOR YOUR STUDY:
#
# - Replace the attributes (type, price, freshness) with your own product features
# - Update the image display if needed (or remove if not using images)
# - Modify the formatting/layout of each option as desired
# - Modify the number of alternatives appropriately to your study (alt1, alt2, alt3)

make_cbc_options <- function(df) {
  # Extract each alternative
  alt1 <- df |> filter(altID == 1)
  alt2 <- df |> filter(altID == 2)
  alt3 <- df |> filter(altID == 3)

  # Define option values (these stay the same)
  options <- c("option_1", "option_2", "option_3")

  # Create option labels with attribute values
  names(options) <- c(
    glue(
      "
      **Option 1**<br>
      <img src='{alt1$image}' width=100><br>
      **Type**: {alt1$type}<br>
      **Price**: $ {alt1$price} / lb<br>
      **Freshness**: {alt1$freshness}
    "
    ),
    glue(
      "
      **Option 2**<br>
      <img src='{alt2$image}' width=100><br>
      **Type**: {alt2$type}<br>
      **Price**: $ {alt2$price} / lb<br>
      **Freshness**: {alt2$freshness}
    "
    ),
    glue(
      "
      **Option 3**<br>
      <img src='{alt3$image}' width=100><br>
      **Type**: {alt3$type}<br>
      **Price**: $ {alt3$price} / lb<br>
      **Freshness**: {alt3$freshness}
    "
    )
  )
  return(options)
}

# Server setup ----------------------------------------------------------------

server <- function(input, output, session) {
  # Make a 10-digit random number completion code
  completion_code <- sd_completion_code(10)
  sd_store_value(completion_code)

  # Sample a random respondentID and store it directly as "respID"
  respondentID <- sample(design$respID, 1)
  sd_store_value(respondentID, "respID")

  # Filter for the rows for the chosen respondentID
  df <- design |>
    filter(respID == respondentID)

  # Create the options for each choice question (using the helper function above)
  # NOTE: This example contains 6 choice questions - update as needed for your study
  cbc1_options <- make_cbc_options(df |> filter(qID == 1))
  cbc2_options <- make_cbc_options(df |> filter(qID == 2))
  cbc3_options <- make_cbc_options(df |> filter(qID == 3))
  cbc4_options <- make_cbc_options(df |> filter(qID == 4))
  cbc5_options <- make_cbc_options(df |> filter(qID == 5))
  cbc6_options <- make_cbc_options(df |> filter(qID == 6))

  # Create each choice question - display these in your survey.qmd using sd_output()
  # Example: sd_output('cbc_q1', type = 'question')
  # NOTE: This example contains 6 choice questions - update as needed for your study
  sd_question(
    type = 'mc_buttons',
    id = 'cbc_q1',
    label = "(1 of 6) If these were your only options, which would you choose?",
    option = cbc1_options
  )

  sd_question(
    type = 'mc_buttons',
    id = 'cbc_q2',
    label = "(2 of 6) If these were your only options, which would you choose?",
    option = cbc2_options
  )

  sd_question(
    type = 'mc_buttons',
    id = 'cbc_q3',
    label = "(3 of 6) If these were your only options, which would you choose?",
    option = cbc3_options
  )

  sd_question(
    type = 'mc_buttons',
    id = 'cbc_q4',
    label = "(4 of 6) If these were your only options, which would you choose?",
    option = cbc4_options
  )

  sd_question(
    type = 'mc_buttons',
    id = 'cbc_q5',
    label = "(5 of 6) If these were your only options, which would you choose?",
    option = cbc5_options
  )

  sd_question(
    type = 'mc_buttons',
    id = 'cbc_q6',
    label = "(6 of 6) If these were your only options, which would you choose?",
    option = cbc6_options
  )

  # Define conditional skip logic (skip to page if a condition is true)
  sd_skip_if(
    sd_value("screenout") == "blue" ~ "end_screenout",
    sd_value("consent_age") == "no" ~ "end_consent",
    sd_value("consent_understand") == "no" ~ "end_consent"
  )

  # Define conditional display logic (show a question if a condition is true)
  sd_show_if(
    sd_value("like_fruit") %in% c("yes", "kind_of") ~ "fav_fruit"
  )

  # Run surveydown server and define database
  sd_server(db = db)
}

# Launch the app
shiny::shinyApp(ui = ui, server = server)