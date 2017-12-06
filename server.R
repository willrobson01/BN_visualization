source("utils.R")


shinyServer(function(input, output) {
  
  source("Net.R")
  
  output$network <- renderVisNetwork({
    visNetwork(nodes, links) %>%
      visOptions(highlightNearest = TRUE, 
                 selectedBy = "type.label")  %>%
      visEvents(select = "function(nodes) {
                Shiny.onInputChange('current_node_id', nodes.nodes);
                ;}")
  }) 

  
  myNode <- reactiveValues(selected = '')
  
  observeEvent(input$current_node_id, {
    myNode$selected <<- input$current_node_id
  })
  
  output$table <-  renderDataTable({
    nodes[which(myNode$selected == nodes$id),c(2,3,4,5)]
  })
  
  output$table.default <-  renderDataTable({
    nodes[,c(2,3,4,5)]
  })
  
  output$dt_UI <- renderUI({
    if(nrow(nodes[which(myNode$selected == nodes$id),])!=0){
      dataTableOutput('table')
    } else{
      dataTableOutput('table.default')
    }
    
  })
  
})