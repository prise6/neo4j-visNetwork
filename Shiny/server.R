
library(shiny)
library(shinydashboard)
library(RNeo4j)
library(visNetwork)




server = function(input, output, session){
  
  # selection
  
  selection_person = reactive({
    if(is.null(input$id_select_person))
      NULL
    else
      as.character(input$id_select_person)
  })
  
  selection_test = eventReactive(input$action_button, {
    input$id_text_cypher
  }, ignoreNULL = FALSE)
  
  # getters
  
  getRelations = reactive({
    print(selection_test())
    relations = data.table(cypher(graph, selection_test()))
  })
  
  getNodes = reactive({
    return(nodes[id %in% unique(c(getRelations()$to, getRelations()$from))])
  })
  
  
  # outputs
  
  output$network = renderVisNetwork({
    visNetwork(getNodes(), getRelations()) %>% 
      visLegend() %>%
      visOptions(highlightNearest = list(
        "enabled"   = T,
        "degree"    = 1,
        "hover"     = F,
        "algorithm" = "all"
      ))
  })
  
  observeEvent(input$id_select_person, {
    print("ici")
    str(selection_person())
    visNetworkProxy("network") %>%
      visSetSelection(nodesId = c("392", "395", "396"))
  })
  
}