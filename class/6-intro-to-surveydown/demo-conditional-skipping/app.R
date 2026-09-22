# Load packages
library(surveydown)

db <- sd_db_connect()

ui <- sd_ui()

server <- function(input, output, session) {

  # Define any conditional skipping logic here (skip forward to a page if a condition is true)
  sd_skip_if(
    sd_value("vehicle_simple") == "no" ~ "screenout",
    sd_value("vehicle_complex") == "no" &
      sd_value("buy_vehicle") == "no" ~ "screenout"
  )

  # Run surveydown server and define database
  sd_server(db = db)
}

# Launch the app
shiny::shinyApp(ui = ui, server = server)
