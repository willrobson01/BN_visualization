#################################################################################
# Programmname:		Net.R                                                         #
# Studie: 			                                                                #
# Beschreibung:		                                            			          	#
# Autor:            MK                                                          #
# Letzte ?nderung:  21-03-2017                                                  #
# Hinweis:                                                                      #
#                                                                               #
#################################################################################

require(visNetwork)

#load nodes & edges
setwd("C:/Users/Maren/Documents/R/BNvis/data")
nodes <- read.csv("./Dataset1-Media-Example-NODES.csv", header=T, as.is=T, sep=";")
links <- read.csv("./Dataset1-Media-Example-EDGES.csv", header=T, as.is=T, sep=";")

# We can visualize the network right away - visNetwork() will accept 
# our node and link data frames (it needs node data with an 'id' column,
# and edge data with 'from' and 'to' columns).

#visNetwork(nodes, links)

# We can set the height and width of the window visNetwork() takes 
# with parameters 'hight' and 'width', and the title with 'main'

#visNetwork(nodes, links, height="600px", width="100%", main="Network!")

# Like 'igraph' did, 'visNetwork' allows us to set graphic properties 
# as node or edge attributes. We can add them as columns in our data.


nodes$shape <- "dot"  
nodes$shadow <- TRUE # Nodes will drop shadow
nodes$hlpString<-sapply(nodes$riskfactor.txt, function(x) return(paste(strwrap(x,60), collapse="<br/>")))
nodes$title <- paste0("<p>", nodes$hlpString, "</p") # Text on click
nodes$label <- nodes$riskfactor # Node label
#$size <- nodes$audience.size # Node size
nodes$borderWidth <- 2 # Node border width


# We can set the color for several elements of the nodes:
# "background" changes the node color, "border" changes the frame color;
# "highlight" sets the color on click, "hover" sets the color on mouseover.

nodes$color.background <- c("slategrey", "tomato", "gold")[nodes$riskfactor.type]
nodes$color.border <- "black"
nodes$color.highlight.background <- "orange"
nodes$color.highlight.border <- "darkred"

visNetwork(nodes, links)

# Below we change some of the visual properties of the edges:

links$width <- 1+links$weight/8 # line width
links$color <- "gray"    # line color  
links$arrows <- "to" # arrows: 'from', 'to', or 'middle'
links$smooth <- FALSE    # should the edges be curved?
links$shadow <- FALSE    # edge shadow

#visNetwork(nodes, links)

# Remove the arrows and set the edge width to 1:
#links$arrows <- "" 
#links$width  <- 1


# 'visNetwork' offers a number of other options, including
# highlighting the neighbors of a selected node, or adding 
# a drop-down menu to select groups of nodes. The groups are
# based on a column from our data - here the type label.

visNetwork(nodes, links) %>%
  visOptions(highlightNearest = TRUE, 
             selectedBy = "type.label")



