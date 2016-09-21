
library(shiny)
library(shinydashboard)
library(RNeo4j)
library(visNetwork)
library(DT)




server = function(input, output, session){
  
  # selection
  
  selection_entity = reactive({
    input$id_select_entity
  })
  
  selection_relation = reactive({
    input$id_select_relation
  })
  
  selection_all_graph = reactive({
    input$id_select_all_graph
  })
  
  selection_current_edge = reactive({
    input$id_current_select_edge
  })

  # getters
  
  getRelations = reactive({
    if(isTRUE(selection_all_graph()))
      return(relations)
    relations[(from %chin% selection_entity() | to %chin% selection_entity()) &
                label %chin% selection_relation()]
  })
  
  getGraphsNodes = reactive({
    if(isTRUE(selection_all_graph()))
      return(NULL)
    unique(c(getRelations()$from, getRelations()$to))
  })
  
  getNodes = reactive({
    if(isTRUE(selection_all_graph()))
      return(nodes)
    nodes[id %chin% getGraphsNodes()]
  })
  
  
  # outputs
  
  output$network = renderVisNetwork({
    visNetwork(getNodes(), getRelations())  %>%
      visEvents(selectEdge = "function(edge) {
        Shiny.onInputChange('id_current_select_edge', edge);
      }") %>%
      visPhysics(solver = c("repulsion"), stabilization = FALSE)  %>%
      visEdges(smooth = list(enabled = F), shadow = F, physics = F) %>%
      visOptions(highlightNearest = T)
  })
  
  output$network_dt = DT::renderDataTable({
    getRelations()[, list(from, to, label)]
  })
  
  # output$edge_plus = DT::renderDataTable({
  #   print(selection_current_edge())
  #   getRelations()[1,]
  # })
  
  # output$shiny_return = renderPrint({
  #   input$id_current_select_edge
  # })

  # observeEvent(input$id_select_person, {
  #   print("ici")
  #   str(selection_person())
  #   visNetworkProxy("network") %>%
  #     visSetSelection(nodesId = c("392", "395", "396"))
  # })
  
}