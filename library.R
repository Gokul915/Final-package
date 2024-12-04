
install.packages("roxygen2")
library("roxygen2")
This function visualizes temperature zones on a geographic map and overlays country names.
#' @param sf_data An sf object containing spatial data with "zone" and "name_long" columns.
#' @param zone_colors A named vector specifying colors for each temperature zone.
#' @return A ggplot object visualizing the temperature zones with country names.

library(ggplot2)
library(rnaturalearth)
