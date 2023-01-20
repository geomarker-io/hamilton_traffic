library(CODECtools)
library(sf)
library(tidyverse)

d <- readRDS("hamilton_household_traffic_proximity_tract.rds")

d <-
  d |>
  st_drop_geometry() |>
  as_tibble()

d <- d |>
  add_attrs(
    name = "hamilton_traffic",
    title = "Hamilton County Parcel and Household Traffic",
    version = "0.1.0",
    homepage = "https://geomarker.io/hamilton_traffic"
  )

d <-
  d |>
  add_col_attrs(census_tract_id, title = "Census Tract Identifier") |>
  add_col_attrs(n_parcels, title = "Number of Parcels", description = "number of parcels in tract") |>
  add_col_attrs(n_parcels_near_traffic, title = "Number of Parcels Near Traffic", description = "number of parcels within 400 m of roads with non-zero average annual daily traffic") |>
  add_col_attrs(n_parcels_near_truck_traffic, title = "Number of Parcels Near Truck Traffic", description = "number of parcels within 400 m of roads with non-zero average annual daily truck traffic") |>
  add_col_attrs(n_households, title = "Number of Households", description = "number of households in tract") |>
  add_col_attrs(n_households_near_traffic, title = "Number of Households Near Traffic", description = "number of households within 400 m of roads with non-zero average annual daily traffic") |>
  add_col_attrs(n_households_near_truck_traffic, title = "Number of Households Near Truck Traffic", description = "number of households within 400 m of roads with non-zero average annual daily truck traffic") |>
  add_col_attrs(median_parcel_traffic, title = "Median Parcel Traffic", description = "median average annual daily traffic within 400 m of each parcel (vehicle-meters)") |>
  add_col_attrs(median_household_traffic, title = "Median Household Traffic", description = "median average annual daily traffic within 400 m of each household (truck-meters)") |>
  add_col_attrs(median_parcel_truck_traffic, title = "Median Parcel Truck Traffic", description = "median average annual daily truck traffic within 400 m of each parcel (vehicle-meters)") |>
  add_col_attrs(median_household_truck_traffic, title = "Median Household Truck Traffic", description = "median average annual daily truck traffic within 400 m of each household (truck-meters)") |>
  add_col_attrs(frac_households_near_traffic, title = "Fraction of Households Near Traffic", description = "fraction of households within 400 m of roads with non-zero average annual daily traffic") |>
  add_col_attrs(frac_parcels_near_traffic, title = "Fraction of Parcels Near Traffic", description = "fraction of parcels within 400 m of roads with non-zero average annual daily traffic") |>
  add_col_attrs(frac_households_near_truck_traffic, title = "Fraction of Households Near Truck Traffic", description = "fraction of households within 400 m of roads with non-zero average annual daily truck traffic") |>
  add_col_attrs(frac_parcels_near_truck_traffic, title = "Fraction of Parcels Near Truck Traffic", description = "fraction of parcels within 400 m of roads with non-zero average annual daily truck traffic")

d <- add_type_attrs(d)

# write metadata.md
cat("#### Metadata and Schema\n\n", file = "metadata.md", append = FALSE)
CODECtools::glimpse_tdr(d) |>
  knitr::kable() |>
  cat(file = "metadata.md", sep = "\n", append = TRUE)

write_tdr_csv(d)

