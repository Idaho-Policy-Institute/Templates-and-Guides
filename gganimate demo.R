library(palmerpenguins)
library(tidyverse)
library(gganimate)
library(png)
library(gifski)
library(transformr) #Required for animating line graphs

penguins

#Restart of RStudio might be required to get the png and gifski packages to kick in properly

weight_by_sex_animation <- penguins %>%
  ggplot(aes(x = species, y = body_mass_g, color = species, fill = species)) +
    geom_jitter(width = 0.05) +
    geom_boxplot(alpha = 0.5) + #Up to here, it's just a typical ggplot.
    transition_states(sex) + #Animate based on the sex variable
    labs(title = "Sex: {closest_state}") #The closest_state label is connected to transition_states

weight_by_sex_animation

#Demonstrating a time series animation
time_series_animation <- economics %>%
  mutate(date = as.Date(date)) %>%
  ggplot(aes(x = date, y = unemploy)) +
    geom_line(size =  1.5, color = "red") +
    transition_time(date) +
    shadow_mark(alpha = 0.5, size = 1, color = "gray") +
    labs(title = "Date: {frame_time}") #The frame_time label is connected to transition_time

time_series_animation

#Another option for time series:
time_series_animation_reveal <- economics %>%
  mutate(date = as.Date(date)) %>%
  ggplot(aes(x = date, y = unemploy)) +
  geom_line(size =  1.3, color = "red") +
  transition_reveal(date) +
  labs(title = "Date: {frame_along}") #The frame_along label is connected to transition_reveal

time_series_animation_reveal

#This one demonstrates some transition options
penguin_scatter_plot <- penguins %>%
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
    geom_point(size = 2) +
    transition_states(species) + #Animate with species
    enter_fade() +  #Transition: Fade in new points
    exit_fade() +   #Transition: Fade out old points
    labs(title = "Species: {closest_state}")

penguin_scatter_plot
#If we didn't color (or group instead, if desired) by species, gganimate would assume that the points are linked,
#and show them moving from one place to another, which is misleading.

#Finally, demonstrating another transition option:
penguin_scatter_plot_bounce <- penguins %>%
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_jitter(size = 2, width = 0.1) +
  transition_states(species) + #Animate with species
  ease_aes(y = "bounce-out") + #Add the ease function to determine more complex transition animations
  labs(title = "Species: {closest_state}")

penguin_scatter_plot_bounce
