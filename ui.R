library(shiny)
library(shinydashboard)
require(visNetwork)
library(DT)

# library(dygraphs) # optional, used for dygraphs

# Header elements for the visualization
header <- dashboardHeader(title = "Visualization and Modelling of BN", titleWidth="900px", disable = FALSE)

# Sidebar elements for the search visualizations
sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$script(src = "custom.js")
  ),
  sidebarMenu(
    id="tabs",
    menuItem("First Page", tabName = "fb", icon = icon("home")),
    menuItem("Model input", tabName = "mi", icon = icon("line-chart")),
    menuItem("Table Builder", tabName = "tb", icon = icon("table"))
    ) # /menuItem
    # this is where other menuItems & menuSubItems would go
  ) # /sidebarMenu
 # /dashboardSidebar

#Body elements for the search visualizations.
body <- dashboardBody(
  tabItems(
    # First tab content
    
    tabItem(tabName = "fb",
            fluidRow(selectInput("cpt","Display",c("Info" ,"CPT"), selected="Info")),
            fluidRow(visNetworkOutput("network"), height="1200px"),
            uiOutput("dt_UI"),
            uiOutput("dt_UI2")
            )
    ,
    # Second tab content
    tabItem(tabName = "mi",
            h2("Modify model input")
    ),
    # third tab content
    tabItem(tabName = "tb",
            h2("Visualize tables")
    )
  )
)
dashboardPage(header, sidebar, body, skin = "black")