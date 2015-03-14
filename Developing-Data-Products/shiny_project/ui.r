library(shiny)
library(leaflet)
location <- c("Alcochete", "Alenquer", "Alhandra", "Almada",
              "Coruche", "Ericeira", "Lisboa", "Loures",
              "Mafra", "Moita", "Palmela", "Samora Correia",
              "Setubal", "Sintra", "Torres Vedras", "Vendas Novas")
vmode <- c("driving", "walking", "bicycling")
shinyUI(navbarPage("Lisbon Region Distance Calculator", id="nav",

  tabPanel(
    "Interactive map",
    div(class="outer",
      
      tags$head(
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),
      
      leafletMap("map", width="100%", height="100%",
        initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
        options=list(
          center = c(38.7436, -9.1595), 
          zoom = 10,
          maxBounds = list(list(38.4,-8.4), list(39.15,-9.9))
        )
      ),

      absolutePanel(id = "controls", class = "modal", 
        top = 60, left = 350, right = "auto", bottom = "auto",
        width = 200, height = "auto",
        draggable = TRUE, fixed = TRUE,
   
        h4("Calculate a distance"),                    
        selectInput("istart", "Start location", location),
        p('Latitude and Longitude'),
        try(textOutput("scoord"), silent=TRUE),
        selectInput("iend", "End location", location),
        p('Latitude and Longitude'),
        try(textOutput("ecoord"), silent=TRUE),
        selectInput("imode", "Mode of transport", vmode),
        
        submitButton('Calculate'),
        
        tableOutput("dist")
      )
    )
  )
))