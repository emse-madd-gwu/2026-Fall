# Load packages
library(surveydown)

db <- sd_db_connect()

ui <- sd_ui()

server <- function(input, output, session) {

  # Define any conditional showing logic here (show a question if a condition is true)
  sd_show_if(

    # Simple conditional showing
    sd_value("penguins_simple") == "other" ~ "penguins_simple_other",

    # Complex conditional showing
    sd_value("penguins_complex") == "other" &
      sd_value("show_other") == "show" ~ "penguins_complex_other",

    # Conditional showing based on a numeric value
    sd_value("car_number") > 1 ~ "ev_ownership",

    # Conditional showing based on multiple inputs
    sd_value("fav_fruits") %in% c("apple", "banana") ~ "apple_or_banana",
    length(sd_value("fav_fruits")) > 3 ~ "fruit_number"
  )

  # Run surveydown server and define database
  sd_server(db = db)

}

# Launch the app
shiny::shinyApp(ui = ui, server = server)
