library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(plotly)
library(DT)

graduate <- read.csv("graduate_survey.csv", sep=";", stringsAsFactors=FALSE)

# Standardizing Campus Names
graduate_survey$Campus <- recode(graduate_survey$Campus,
                                 "Umhlanga Campus" = "Durban",
                                 "Durban Campus" = "Durban",
                                 "Port Elizabeth Campus" = "Nelson Mandela Bay",
                                 "Nelson Mandela Bay Campus" = "Nelson Mandela Bay",
                                 "Nelspruit Campus" = "Mbombela")

# Convert relevant columns to factors
graduate_survey$Employment <- as.factor(graduate_survey$Employment)
graduate_survey$StudyField <- as.factor(graduate_survey$StudyField)

ui <- dashboardPage(
  dashboardHeader(title = "Eduvos Graduate Survey"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem("Top Tools", tabName = "tools", icon = icon("laptop-code")),
      menuItem("Industries", tabName = "industries", icon = icon("industry")),
      menuItem("Job Roles", tabName = "roles", icon = icon("briefcase")),
      menuItem("Employment", tabName = "employment", icon = icon("chart-pie"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "overview",
              h2("Eduvos Graduate Survey Dashboard"),
              DTOutput("table_summary")),
      
      tabItem(tabName = "tools",
              h2("Top Tools Used by Graduates"),
              plotlyOutput("plot_tools")),
      
      tabItem(tabName = "industries",
              h2("Top Industries for Graduates"),
              plotlyOutput("plot_industry")),
      
      tabItem(tabName = "roles",
              h2("Top Job Roles"),
              plotlyOutput("plot_roles")),
      
      tabItem(tabName = "employment",
              h2("Employment Rate"),
              plotlyOutput("plot_employment"))
    )
  )
)
server <- function(input, output) {
  
  # Overview DataTable
  output$table_summary <- renderDT({
    graduate_survey %>% 
      group_by(StudyField, Employment) %>%
      summarise(Count = n(), .groups = "drop")
  })
  
  # Top Tools Visualization
  output$plot_tools <- renderPlotly({
    graduate_survey %>%
      separate_rows(ProgLang, sep = ";") %>%
      count(ProgLang, sort = TRUE) %>%
      top_n(10) %>%
      ggplot(aes(x = reorder(ProgLang, n), y = n, fill = ProgLang)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Top Programming Languages", x = "Language", y = "Count") +
      theme_minimal() %>%
      ggplotly()
  })
  
  # Industry Visualization
  output$plot_industry <- renderPlotly({
    graduate_survey %>%
      separate_rows(Industry, sep = ";") %>%
      count(Industry, sort = TRUE) %>%
      top_n(10) %>%
      ggplot(aes(x = reorder(Industry, n), y = n, fill = Industry)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Top Industries for Graduates", x = "Industry", y = "Count") +
      theme_minimal() %>%
      ggplotly()
  })
  
  # Job Roles Visualization
  output$plot_roles <- renderPlotly({
    graduate_survey %>%
      separate_rows(Role, sep = ";") %>%
      count(Role, sort = TRUE) %>%
      top_n(10) %>%
      ggplot(aes(x = reorder(Role, n), y = n, fill = Role)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Top Job Roles", x = "Job Role", y = "Count") +
      theme_minimal() %>%
      ggplotly()
  })
  # Employment Pie Chart
  output$plot_employment <- renderPlotly({
    employment_data <- graduate_survey %>%
      group_by(Employment) %>%
      summarise(count = n()) %>%
      mutate(percent = count / sum(count) * 100)
    
    ggplot(employment_data, aes(x = "", y = percent, fill = Employment)) +
      geom_bar(stat = "identity", width = 1, color = "white") +
      coord_polar(theta = "y") +
      labs(title = "Employment Rate of Graduates", fill = "Employment Status") +
      theme_void() +
      theme(legend.position = "bottom") +
      geom_text(aes(label = paste0(round(percent, 1), "%")), 
                position = position_stack(vjust = 0.5), size = 5, color = "white") %>%
      ggplotly()
  })
}


shinyApp(ui, server)
