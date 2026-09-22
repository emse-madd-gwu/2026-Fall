# Load packages
library(surveydown)
library(dplyr)
library(ggplot2)

# Must have database connected for this example - run to store db credentials:
# sd_db_config()
db <- sd_db_connect()

# UI setup --------------------------------------------------------------------

ui <- sd_ui()

# Server setup ----------------------------------------------------------------

server <- function(input, output, session) {

    # Refresh data every 5 seconds
    data <- sd_get_data(db, refresh_interval = 5)

    # Render the plot
    output$penguin_plot <- renderPlot({
        data() |> # Note the () here, as this is a reactive expression
            count(penguins) |>
            mutate(penguins = ifelse(penguins == '', 'No response', penguins)) |>
            ggplot() +
            geom_col(aes(x = n, y = reorder(penguins, n)), width = 0.7) +
            theme_minimal() +
            labs(x = "Count", y = "Penguin Type", title = "Penguin Count")
    })

    # Run surveydown server and define database
    # (settings like all-required and use-cookies go in the survey.qmd YAML)
    sd_server(db = db)

}

# Launch the app
shiny::shinyApp(ui = ui, server = server)
