
library(shiny)
library(shinydashboard)
library(RNeo4j)
library(visNetwork)

ui = dashboardPage(
  header  = dashboardHeader(title = "RVisNetwork"),
  sidebar = dashboardSidebar(disable = T),
  body    = dashboardBody(
    
    fluidRow(
      column(
        width = 3,
        tags$div(
          selectInput(
            inputId = "id_select_entity",
            choices = choix_entity,
            label   = "Choix de l'entité",
            selected = NULL,
            multiple = TRUE
          ),
          
          checkboxGroupInput(
            inputId = "id_select_relation",
            label = "choix du type de relation",
            choices = choix_relations,
            selected = choix_relations
          ),
          
          checkboxInput(
            inputId = "id_select_all_graph",
            label = "Visualiser l'ensemble du graph",
            value = FALSE
          )
        )
      ),
      
      column(
        width = 9,
        tags$div(
          
          visNetworkOutput("network", height = "600px")
          
        )
      ),
      column(
        width = 12,
        dataTableOutput("network_dt")
      )
    )
  )
)
