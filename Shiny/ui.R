
library(shiny)
library(shinydashboard)
library(RNeo4j)
library(visNetwork)

ui = dashboardPage(
  header  = dashboardHeader(title = "Neo4j/VisNetwork"),
  sidebar = dashboardSidebar(disable = T),
  body    = dashboardBody(
    
    fluidRow(
      column(
        width = 3,
        tags$div(
          selectInput(
            inputId = "id_select_person",
            choices = choix_person,
            label   = "Choix star",
            selected = NULL,
            multiple = TRUE
          ),
          tags$textarea(
            id   = "id_text_cypher",
            rows = 3,
            cols = 40,
            "MATCH (n:Person)-[r]->(m:Movie)
RETURN
ID(n) AS from,
ID(m) AS to,
TYPE(r) AS label
LIMIT 30",
            `placeholder`= "req cypher"
          ),
          actionButton(
            "action_button",
            "lancer la requete"
          )
        )
      ),
      column(
        width = 9,
        tags$div(
          
          visNetworkOutput("network", height = "600px")
          
        )
      )
    )
  )
)
