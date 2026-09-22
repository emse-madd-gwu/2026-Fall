# Load packages
library(surveydown)
library(glue)

db <- sd_db_connect()

ui <- sd_ui()

server <- function(input, output, session) {

  observe({
    # Trigger with any change to the pet_type question
    pet_type <- sd_value("pet_type")

    # Make the question
    sd_question(
      type   = "mc",
      id     = "pet_owner",
      label  = glue("Are you a {pet_type} owner?"),
      option = c("Yes" = "yes", "No" = "no")
    )
  })

  # Only show the pet_owner question if pet_type is answered
  sd_show_if(
    sd_is_answered("pet_type") ~ "pet_owner"
  )

  # Run surveydown server and define database
  sd_server(db = db)
}

# Launch the app
shiny::shinyApp(ui = ui, server = server)
