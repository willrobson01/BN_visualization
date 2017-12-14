source("utils.R")


shinyServer(function(input, output) {
  
  source("Net.R")
  source('~/R/BNvis/grain.R')
  source("~/R/BNvis/bchart.R")
  
  observe({
   if(input$cpt=="Info" ){ 
     output$network <-buildDAG()} else{
       output$network <-renderVisNetwork({
         generateNodeOutput(distributions, generateVisNet()) %>% 
           visInteraction(navigationButtons = TRUE) %>%
           visOptions(highlightNearest = TRUE, 
                      selectedBy = "type.label")  %>%
           visEvents(select = "function(nodes) {
                     Shiny.onInputChange('current_node_id', nodes.nodes);
                     ;}")
                    })
     }
  })
  
  node.selected <- reactiveValues(selected = '')
  
  observeEvent(input$current_node_id, {
    node.selected$selected <<- input$current_node_id
  })
  
  output$table <-  renderDataTable(
    nodes[which(node.selected$selected == nodes$id),c(2,3,4,5)],options = list(lengthChange = FALSE, searching = FALSE,paging = FALSE, info=FALSE), rownames=FALSE
  )
  
  output$table.default <-  renderDataTable(
    nodes[,c(2,3,4,5)], options = list(lengthChange = FALSE, searching = FALSE,paging = FALSE, info=FALSE), rownames=FALSE
  )
  
  output$table.cpt <-  renderDataTable(
    distributions[[node.selected$selected]],options = list(lengthChange = FALSE, searching = FALSE,paging = FALSE, info=FALSE), rownames=FALSE, colnames=c("","Prob.")
  )
  
  output$dt_UI <- renderUI({
    if(nrow(nodes[which(node.selected$selected == nodes$id),])!=0){
      DT::dataTableOutput('table')
    } else{
      DT::dataTableOutput('table.default')
    }
  })
    
  output$dt_UI2 <- renderUI({
    DT::dataTableOutput('table.cpt')
    }
  )

  output$network <- renderVisNetwork({
    visNetwork(nodes, links) %>%
      visOptions(highlightNearest = TRUE, 
                 selectedBy = "type.label")  %>%
      visEvents(select = "function(nodes) {
                Shiny.onInputChange('current_node_id', nodes.nodes);
                ;}")
  }) 


})