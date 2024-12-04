# Install necessary packages
install.packages(c("raster", "ggplot2", "sf", "viridis"))

# Load libraries
library(raster)
library(ggplot2)
library(sf)
library(viridis)

# Download WorldClim temperature data (example for global data)
temp_data <- getData('worldclim', var='tmean', res=10) # Monthly mean temperature data at 10-minute resolution

# Select a specific month (e.g., January)
temp_jan <- temp_data[[1]] # First layer corresponds to January

# Convert raster to data frame for ggplot
temp_df <- as.data.frame(rasterToPoints(temp_jan), col.names = c("lon", "lat", "temperature"))

# Visualize using ggplot2
ggplot(data = temp_df, aes(x = lon, y = lat, fill = temperature)) +
  geom_tile() +
  scale_fill_viridis(name = "Temp (°C)", option = "inferno") +
  theme_minimal() +
  labs(
    title = "Global Temperature Zones in January",
    subtitle = "WorldClim Temperature Data",
    x = "Longitude",
    y = "Latitude"
  )
Example 2: Using Interpolation (Kriging or IDW)
R
Copy code
# Install necessary packages
install.packages(c("gstat", "sp", "sf", "ggplot2"))

# Load libraries
library(gstat)
library(sp)
library(sf)
library(ggplot2)

# Sample temperature data with coordinates
temperature_data <- data.frame(
  lon = c(-120, -90, -60, 0, 60, 90, 120),
  lat = c(30, 45, -10, 0, 15, 50, -20),
  temperature = c(10, 15, 30, 25, 20, 5, 35)
)

# Convert to spatial object
coordinates(temperature_data) <- ~lon+lat

# Create a grid for interpolation
grd <- expand.grid(
  lon = seq(-180, 180, by = 2),
  lat = seq(-90, 90, by = 2)
)
coordinates(grd) <- ~lon+lat
gridded(grd) <- TRUE

# Interpolate using IDW (Inverse Distance Weighting)
idw_result <- idw(temperature ~ 1, temperature_data, newdata = grd)

# Convert interpolated raster to data frame
idw_df <- as.data.frame(as(idw_result, "SpatialPixelsDataFrame"))

# Visualize using ggplot2
ggplot(data = idw_df, aes(x = x1, y = x2, fill = var1.pred)) +
  geom_tile() +
  scale_fill_viridis(name = "Temp (°C)", option = "magma") +
  theme_minimal() +
  labs(
    title = "Temperature Zones (IDW Interpolation)",
    x = "Longitude",
    y = "Latitude"
  )
Example 3: Overlaying Temperature Zones on a World Map
R
Copy code
# Install necessary packages
install.packages(c("sf", "ggplot2", "rnaturalearth", "raster", "viridis"))

# Load libraries
library(sf)
library(ggplot2)
library(rnaturalearth)
library(raster)
library(viridis)

# Load a base world map
world <- ne_countries(scale = "medium", returnclass = "sf")

# Generate mock temperature zones (or use real raster data)
temp_raster <- raster(nrows=180, ncols=360, xmn=-180, xmx=180, ymn=-90, ymx=90)
values(temp_raster) <- runif(ncell(temp_raster), min=-30, max=50)

# Convert raster to data frame
temp_df <- as.data.frame(rasterToPoints(temp_raster), col.names = c("lon", "lat", "temperature"))

# Plot temperature zones overlaid with the world map
ggplot() +
  geom_tile(data = temp_df, aes(x = lon, y = lat, fill = temperature)) +
  geom_sf(data = world, fill = NA, color = "black") +
  scale_fill_viridis(name = "Temp (°C)", option = "cividis") +
  theme_minimal() +
  labs(
    title = "Temperature Zones with World Overlay",
    subtitle = "Mock Temperature Data",
    x = "Longitude",
    y = "Latitude"
  )