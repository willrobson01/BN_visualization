#Create CPN

require(gRain)
#############Functions#######################

#getparentnodes
getPN<-function(visN, node){
  res<-subset(visN$x$edges, to==node)
  return(res$from)
}

#build gRain data structure
#for each node build cpt
initDAG<-function(visNet){
  nodes<-unique(c(visNet$x$edges$from,visNet$x$edges$to))
  tabs<-lapply(nodes, function(x){
    #single node?
    if (length(getPN(visNet,x))==0) {
       t<-cptable(~x, values=getValues(visNet, x), levels=getLevels(visNet,x), normalize=TRUE)
       t$vpa<-x
    return(t)
    } else{
       t<-cptable(~c(x, getPN(visNet, x)), values=getValues(visNet, x), levels=getLevels(visNet,x), normalize=TRUE)
       t$vpa<-c(x, getPN(visNet, x))
    return(t)}
    })
  cptlist<-compileCPT(tabs)
  
  return(cptlist)
}

getValues<-function(visN,node){
  #no. of values = level(a)*level(b)*level(n)..
  #how many parents
  nodes<-c(node, getPN(visN,node))
  tab<-visN$x$nodes
  lvs<-subset(tab, id %in% nodes, levels)
  #no of levels
  no<-lapply(lvs, function(x) lengths(gregexpr(",", x)) + 1)
  #hlp function for demo, random values
  values<-sample(1:10000, prod(no$levels), replace=T)
  return(values)
}

getLevels<-function(visN,node){
  te<-subset(visN$x$nodes, node==id, levels)
  l<-strsplit(te$levels, ", ")[[1]]
  return(l)
}

generateVisNet<-function(){
  return(visNetwork(nodes, links, width = "100%"))
}

#########################################################

buildDAG<-function(){
  net<-generateVisNet()

  #build data structure for GRAIN
  grain_struc<<-grain(initDAG(net))
  distributions<<-querygrain(grain_struc, result="data.frame")
  
  net_out<-renderVisNetwork({
    net %>% 
      visInteraction(navigationButtons = TRUE) %>%
      visOptions(highlightNearest = TRUE, 
                 selectedBy = "type.label")  %>%
      visEvents(select = "function(nodes) {
                Shiny.onInputChange('current_node_id', nodes.nodes);
                ;}")
  }) 
  

  return(net_out)
}




