install.packages("leaflet")

library(leaflet)
m <- leaflet()

m%>%addTiles()%>%
  addMarkers(lng = 5.1398, lat = 7.3070, popup = "Federal University of Technology Akure")

library(sf)
getwd()
setwd("C:/Users/HP/Desktop/IdeaSpaceLab/Leaflet")
getwd()
urea <- st_read("C:/Users/HP/Desktop/IdeaSpaceLab/Leaflet/Nepal_Urea_Data/Nepal_Urea_Data.shp")
road <- st_read("C:/Users/HP/Desktop/IdeaSpaceLab/Leaflet/npl-majrdsl-gist/npl_majrdsl_gist.shp")


m <- leaflet()%>%
  addPolygons(data = urea,
              color = "black",
              weight = 1,
              fillOpacity = 0.5,
              fillColor = "yellow")%>%
  addPolylines(data = road,
               weight = 1,
               color = "green")

m

#Adding raster images in Leaflet

library(raster)

file_pt <- file.choose()
r <-raster(file_pt)
r

#creating the leaflet
leaflet()%>%
  addTiles()%>%
  addRasterImage(r, colors = terrain.colors(10))

#if rater file is too large
#using resample

rs <- raster(r)
res(r) <- 300
res(rs)
r <- resample(r, rs, method = "ngb")
res(r)

leaflet()%>%
  addTiles()%>%
  addRasterImage(r, colors = terrain.colors(10))


#adding legend to a leaflet map

library(sf)
library(leaflet)

urea <- st_read("C:/Users/HP/Desktop/IdeaSpaceLab/Leaflet/Nepal_Urea_Data/Nepal_Urea_Data.shp")

#createthe palette
pal <- colorNumeric(
  palette = "oranges",
  domain = urea$Total_Urea
)

m <- leaflet(urea)%>%
  addTiles()%>%
  addPolygons(
    stroke = TRUE,
    color = "red",
    weight = 1,
    fillColor = ~pal(Total_Urea),
    fillOpacity = 0.3
  )%>%
  addLegend(
    "bottomright",
    pal = pal,
    values = ~Total_Urea,
    title = "Urea consum."
  )
  
m

#using quantile for the legend

qpal <- colorQuantile("orange", urea$Total_Urea, n=5)


m <- leaflet(urea)%>%
  addTiles()%>%
  addPolygons(
    stroke = TRUE,
    color = "red",
    weight = 1,
    fillColor = ~qpal(Total_Urea),
    fillOpacity = 0.3
  )%>%
  addLegend(
    "bottomright",
    pal = qpal,
    values = ~Total_Urea,
    title = "Urea consum."
  )

m

#chloropleth map

urea <- st_read("C:/Users/HP/Desktop/IdeaSpaceLab/Leaflet/Nepal_Urea_Data/Nepal_Urea_Data.shp")

m <- leaflet(urea)%>%addTiles()
m

m%>%addPolygons()

bins <- c(100, 500, 1000, 2000, 4000, 8000, Inf)
pal <- colorBin("orange", domain = urea$Total_Urea, bins = bins)

m%>%addPolygons(
  fillColor = ~pal(Total_Urea),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = 3,
  fillOpacity = 1,
  highlightOptions = highlightOptions(
    weight = 3,
    color = "red",
    dashArray = "",
    fillOpacity = 1,
    bringToFront = TRUE
  )
)

#adding the custom info
labels <- sprintf(
  "<b>%s</b><br/>%g Metric Ton",
  urea$FIRST_DIST, urea$Total_Urea
)%>%lapply(htmltools::HTML)

m%>%addPolygons(
  fillColor = ~pal(Total_Urea),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = 3,
  fillOpacity = 1,
  highlightOptions = highlightOptions(
    weight = 3,
    color = "red",
    dashArray = "",
    fillOpacity = 1,
    bringToFront = TRUE
  ), 
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight"= "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"
  )
)%>%
  #adding legend to the map
  addLegend(
    pal = pal,
    values = ~Total_Urea,
    opacity = 0.9,
    title = "Urea(Metric ton)",
    position = "bottomright"
  )






















