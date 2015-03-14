library(shiny)
library(ggplot2)
library(ggmap)
library(leaflet)
location <- c("Alcochete", "Alenquer", "Alhandra", "Almada",
              "Coruche", "Ericeira", "Lisboa", "Loures",
              "Mafra", "Moita", "Palmela", "Samora Correia",
              "Setubal", "Sintra", "Torres Vedras", "Vendas Novas")
coords <- list(c(-8.96084, 38.75605), c(-9.00761, 39.05663), c(-9.00792, 38.92884), c(-9.1560, 38.6804),
               c(-8.52850, 38.95778), c(-9.41701, 38.96317), c(-9.1595, 38.7436), c(-9.16845, 38.83087),
               c(-9.32824, 38.93698), c(-8.99353, 38.65240), c(-8.90117, 38.56960), c(-8.86732, 38.93398),
               c(-8.89253, 38.52447), c(-9.38810, 38.79846), c(-9.26074, 39.09308), c(-8.45524, 38.67739))
vmode <- c("driving", "walking", "bicycling")
shinyServer(
  function(input, output, session){ 
    map <- createLeafletMap(session, "map")
    
    output$scoord <- renderText({coords[location==input$istart][[1]]})
    output$ecoord <- renderText({coords[location==input$iend][[1]]})
    
    output$dist <- renderTable({
      df <- data.frame(
        mapdist(from=coords[location==input$istart][[1]], 
        to=coords[location==input$iend][[1]], 
        mode=input$imode, output="simple")
      )
      df <- df[ , c(4,5,7)]
    })
  }
)