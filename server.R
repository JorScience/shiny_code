# Library
library(shiny)
library(dplyr)
library(leaflet)
library(leaflet.extras)
library(rgdal)
library(RColorBrewer)
library(magrittr)

# Working directory
# setwd("C:/Users/Rotterdam.LAP13971/Desktop/Coursera/Roffabomb/Shiny/Roffabomb")

# Data
df <- readRDS("./Data/maindf.Rda")
district_shape <- readOGR(dsn="tempdir", layer="district_shape")

# Server for map
shinyServer(function(input, output) {
    
    output$Bombmap <- renderLeaflet({
        leaflet() %>%
            addTiles(options=providerTileOptions(minZoom=11, maxZoom=17)) %>%
            setView(lng=4.4777325, lat=51.912448, zoom=12)
    })
    
    observe({
        # Inputs
        map <- input$map
        
        leafletProxy("Bombmap", data=df) %>%
            addProviderTiles(provider=map, options=providerTileOptions(minZoom=11, maxZoom=17))
    })
    
    observe ({
        # Inputs
        clusterEn <- input$cluster
        bombyears <- input$bombs
        
        # Leaflet objects        
        bombIcon <- makeIcon(
            iconUrl = "./Data/explosion-417894_640.png",
            iconWidth=50, iconHeight=50.15674)
        
        leafletProxy("Bombmap", data=filter(df, Year %in% bombyears)) %>%
            clearMarkerClusters() %>%
            clearMarkers() %>%
            { if (clusterEn) {
                addMarkers(., ~lon, ~lat, icon=bombIcon, 
                           clusterOptions=markerClusterOptions(disableClusteringAtZoom=15, spiderfyOnMaxZoom=FALSE),
                           popup=~(`Pop-up`))
            } else {
                addMarkers(., ~lon, ~lat, icon=bombIcon,
                           popup=~(`Pop-up`))}
            } 
    })
    
    observe ({
        # Inputs
        heatmap <- input$heatmap
        shape <- district_shape
        district <- input$district
        
        # Leaflet objects
        reds <- brewer.pal(9, "Reds")
        
        leafletProxy("Bombmap", data=df) %>%
            clearHeatmap %>%
            {if (heatmap) {
                addHeatmap(.,~lon, ~lat, blur=45, cellSize=(40), group="Heatmap")
            } else {.}} %>%
            clearShapes() %>%
            { if(district) {
                addPolygons(., data = shape, weight = 2, color = "black", fillOpacity = 0.80, 
                            fillColor = ~colorNumeric(reds, Total)(Total))
            } else {.}}
    })
    
    output$Final <- renderUI({
        leafletOutput("Bombmap", width="100%", height=750)
    })
})
