library(sf)
library(dplyr, warn.conflicts = FALSE)
library(qs)
library(addAadtData)

d <-
  CODECtools::read_tdr_csv("hamilton_parcels") |>
  st_as_sf(coords = c("parcel_centroid_lon", "parcel_centroid_lat"), crs = st_crs(4326)) |>
  st_transform(st_crs(5072)) |>
  select(parcel_id, land_use)

lu_households <-
  c(
    "single family dwelling" = 1,
    "two family dwelling" = 2,
    "three family dwelling" = 3,
    "condominium unit" = 1,
    "apartment, 4-19 units" = 4,
    "apartment, 20-39 units" = 20,
    "apartment, 40+ units" = 40,
    "nursing home / private hospital" = 1,
    "independent living (seniors)" = 1,
    "mobile home / trailer park" = 1,
    "other commercial housing" = 1,
    "office / apartment over" = 1,
    "single fam dw 0-9 acr" = 1,
    "landominium" = 1,
    "manufactured home" = 1,
    "metropolitan housing authority" = 1,
    "resid unplat 10-19 acres" = 0,
    "resid unplat 20-29 acres" = 0,
    "resid unplat 30-39 acres" = 0,
    "condominium office building" = 0,
    "boataminium" = 0,
    "lihtc res" = 0,
    "residential vacant land" = 0,
    "other residential structure" = 0,
    "condo or pud garage" = 0,
    "charities, hospitals, retir" = 0
  )

d$households <- lu_households[as.character(d$land_use)]

aadt <- s3::s3_get("s3://geomarker/aadt/aadt_by_state/ohio2017.qs") |>
  qread() |>
  filter(road_type %in% c('Interstate',
                          'Principal Arterial - Other Freeways and Expressways',
                          'Principal Arterial - Other', 'Minor Arterial'))

d_aadt <-
  d |>
  st_buffer(400) |>
  st_intersection(aadt)

d_aadt <-
  d_aadt |>
  dplyr::mutate(length = as.numeric(sf::st_length(geometry)),
                aadt = as.numeric(aadt),
                aadt_length = aadt*length,
                aadt_truck = as.numeric(aadt_single_unit) + as.numeric(aadt_combination),
                aadt_truck_length = aadt_truck*length) |>
  sf::st_drop_geometry() |>
  dplyr::group_by(parcel_id) |>
  dplyr::summarize(vehicle_meters = round(sum(aadt_length, na.rm = TRUE)),
                   truck_meters = round(sum(aadt_truck_length, na.rm = TRUE))) |>
  dplyr::mutate_at(dplyr::vars(vehicle_meters, truck_meters), as.numeric)

d <- d |>
  left_join(d_aadt, by = "parcel_id") |>
  tidyr::replace_na(list(vehicle_meters = 0,
                         truck_meters = 0))

# add zcta, census tract id, and census block id for each parcel
d <- d |>
  st_join(cincy::zcta_tigris_2010) |>
  st_join(cincy::tract_tigris_2010)

block_tigris_2010 <-
  tigris::blocks(state = "39", county = "061", year = 2010) |>
  select(census_block_id = GEOID10) |>
  st_transform(st_crs(5072))

d <- st_join(d, block_tigris_2010)

# calculate metrics for each type of geography
d_geography <-
  d |>
  st_drop_geometry() |>
  select(-land_use) |>
  filter(households != 0) |> # filter out parcels with no households before calculations?
  tidyr::pivot_longer(c(zcta, census_tract_id, census_block_id), names_to = "geography", values_to = "id") |>
  group_by(geography, id) |>
  summarize(n_parcels = n(),
            n_parcels_near_traffic = sum(vehicle_meters > 0),
            n_parcels_near_truck_traffic = sum(truck_meters > 0),
            n_households = sum(households),
            n_households_near_traffic = sum(households * (vehicle_meters > 0)),
            n_households_near_truck_traffic = sum(households * (truck_meters > 0)),
            median_parcel_traffic = median(vehicle_meters),
            median_household_traffic = median(households * vehicle_meters),
            median_parcel_truck_traffic = median(truck_meters),
            median_household_truck_traffic = median(households * truck_meters)
            ) |>
  mutate(frac_households_near_traffic = round(n_households_near_traffic / n_households, 3),
         frac_parcels_near_traffic = round(n_parcels_near_traffic / n_parcels, 3),
         frac_households_near_truck_traffic = round(n_households_near_truck_traffic / n_households, 3),
         frac_parcels_near_truck_traffic = round(n_parcels_near_truck_traffic / n_parcels, 3)) |>
  ungroup() |>
  nest_by(geography) |>
  tibble::deframe()

# join each geography-specific metrics back to their geographic files and save as RDS files
purrr::pmap(list(x = list(block_tigris_2010, cincy::tract_tigris_2010, cincy::zcta_tigris_2010),
                 y = d_geography,
                 by = list(c("census_block_id" = "id"),
                           c("census_tract_id" = "id"),
                           c("zcta" = "id"))),
            left_join) |>
  rlang::set_names(c("block", "tract", "zcta")) |>
  purrr::iwalk(~ saveRDS(.x, glue::glue("hamilton_household_traffic_proximity_{.y}.rds")))
