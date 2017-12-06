# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("The Bombardment of Rotterdam"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       h3("Description"),
       h5("This application shows bomb strike impact locations in Rotterdam between 1940 and 1945, for which 
          data from the municipal archive of Rotterdam was used.
          Below, options can be found to customize the used map, to filter the years in which the bombstrikes occured, 
          to enable district- and heatmap overlays and to enable the clustering of the markers on the map. For more
          information regarding the process of generating the plot using the Rotterdam data, please refer to
          http://rpubs.com/JorScience/333354"),
       h3("Map options"),
       selectInput("map", "Choose a map:", c("OSM (default)"="OpenStreetMap.Mapnik", 
                                             "Black and White"="OpenMapSurfer.Grayscale",
                                             "Stamen Terrain"="Stamen.Terrain"),
                   selected="Stamen Terrain"),
       selectInput("bombs", "Show bomb strikes for the following years:", c("1940", "1941", "1942",
                                                       "1943", "1944", "1945"),
                   multiple=TRUE),
       checkboxInput("district", "Enable Districts"),
       checkboxInput("heatmap", "Enable Heatmap"),
       checkboxInput("cluster", "Enable Clustering", value=TRUE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       uiOutput("Final")
    )
  )
))
