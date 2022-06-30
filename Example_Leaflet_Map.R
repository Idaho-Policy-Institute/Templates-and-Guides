library(tidyverse)
library(tidycensus)
library(tigris)
library(leaflet)

#Download basic county population data from the ACS API, for the states of Idaho, Montana, and Utah
id_data <- get_acs(geography = "county", variables = "B01001_001", year = 2020, state = "Idaho")
mt_data <- get_acs(geography = "county", variables = "B01001_001", year = 2020, state = "Montana")
ut_data <- get_acs(geography = "county", variables = "B01001_001", year = 2020, state = "Utah")

#Combine the dataset rows using the row bind (rbind) function.
mtn_west <- rbind(id_data, mt_data, ut_data)

#Use the counties function from the tigris library to get a county shape file for our three states.
county_base_layer <- counties(c("Idaho", "Montana", "Utah"), cb = TRUE)

#Join our population data into our county shape file, using the GEOID columns to match
county_base_layer <- left_join(county_base_layer, mtn_west, by = "GEOID")

#Build a custom tooltip by specifying the text and variable combinations I want to use.
my_text <- paste(
  "State: ", county_base_layer$State, "<br/>",
  "County: ", county_base_layer$NAME, "<br/>",
  "Population: ", county_base_layer$estimate, sep = ""
) %>% lapply(htmltools::HTML)

#Building a color palette with the colorNumeric() function
my_palette <- colorNumeric(palette = "Greens", domain = county_base_layer$estimate)
#Try changing colorNumeric to colorQuantile and see what happens!

#Finally, building my map.
map <- leaflet(county_base_layer) %>%
  #I had to look up which background map from which provider I wanted to use.
  addProviderTiles(providers$CartoDB.Positron) %>%
  #Set the coordinates that I want to be included in my map 
  #(this requires some trial and error, but lets us get really specific)
  setView(lat = 43.2, lng = -112, zoom = 5) %>%
  #Add in the county color shapes 
  addPolygons(stroke = TRUE, #Draws county lines
              weight = 0.1, #Sets the weight of the county lines
              fillColor = ~my_palette(estimate), #Tells leaflet to color based on the palette I built
              fillOpacity = 0.7, #Sets how transparent my map is (1 is least, 0 is most)
              label = my_text) %>% #Creates the tooltip based on the custom text I built above
  addLegend(pal = my_palette, values=~estimate, opacity = 0.7, title = "Population", position = "bottomright")

#Display the map:
map
