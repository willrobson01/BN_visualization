#generate html output

generateNodeOutput<-function(grainMod, visNet){
  #for each node
  visNet$x$nodes$title<-sapply(visNet$x$nodes$id, function(x) {
    Label<-grainMod[[x]][1]
    Value<-grainMod[[x]][2]
    return(generateBarChart(Label, Value))
  })
  return(visNet)
}

generateBarChart<-function(vLabel, vValue){
  style<-"<style>
    
    .chart div {
      font: 10px sans-serif;
      background-color: steelblue;
      text-align: right;
      padding: 3px;
      margin: 1px;
      color: black;
    }
  
  </style>"
  
  div.top<-"<div class='chart'>"
  div.bottom<-"</div>"
  
  result<-paste0("<span>", as.character(vLabel[,1]), "</span><div style='width: ", vValue[,1]*100, "px;'>", round(vValue[,1],digits=2),"</div>")
  result<-paste(result, collapse = "")
  
  code<-paste0(style, div.top, result, div.bottom)
  
  return(code)
  
}