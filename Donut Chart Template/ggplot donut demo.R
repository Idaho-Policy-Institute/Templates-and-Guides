library(tidyverse)
library(janitor)
library(palmerpenguins)

boise_state_palette = c("#0033A0", "#D64309", "#3F4444", "#00A9E0", "#FF6A13")

hole_size = 3

demo_donut_plot <- penguins %>%
  group_by(species) %>%
  summarize(Count = n()) %>%
  mutate(Percent = round(Count/sum(Count)*100, 2),
         hole_size = hole_size) %>%
  #I'm creating a new column with fancy labels for each row, 
  #pasting the species and the Percent together with a line break "\n" between them.
  mutate(Custom_Fancy_Label = paste0(species, "\n", Percent, "%", sep = "")) %>%
  ggplot(aes(x = hole_size, y = Percent, fill = species)) +
    geom_col() +
    geom_text(aes(label = Custom_Fancy_Label), position = position_stack(vjust = 0.5), color = "white", size = 2.5, show.legend = FALSE) +
    coord_polar(theta = "y") +
    xlim(c(0.2, hole_size + 0.5)) +
    scale_fill_manual(values = boise_state_palette) +
    labs(fill = "Species") +
    ggtitle("Palmer Penguins\nSpecies Breakdown") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid = element_blank(),
          axis.title = element_blank(),
          axis.ticks = element_blank(),
          axis.text = element_blank(),
          legend.position = "none",
          plot.title = element_text(vjust = -60, hjust = 0.5)
          )

demo_donut_plot

ggsave(filename = "Demo_Donut_Plot.png", plot = demo_donut_plot, width = 4.5, height = 4.5, units = "in")

