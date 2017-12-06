source("utils.R")


shinyServer(function(input, output) {
  
  source("Net.R")
  
  output$network <- renderVisNetwork({
    visNetwork(nodes, links) %>%
      visOptions(highlightNearest = TRUE, 
                 selectedBy = "type.label")
  }) 
  
})