# Load packages
library(surveydown)

db <- sd_db_connect()

ui <- sd_ui()

server <- function(input, output, session) {

  # Run surveydown server and define database
  sd_server(db = db)

}

# Launch the app
shiny::shinyApp(ui = ui, server = server)
