#### Metadata and Schema

|name     |value                                        |
|:--------|:--------------------------------------------|
|name     |hamilton_traffic                             |
|version  |0.1.0                                        |
|title    |Hamilton County Parcel and Household Traffic |
|homepage |https://geomarker.io/hamilton_traffic        |

|name                               |title                                     |type    |description                                                                                   |
|:----------------------------------|:-----------------------------------------|:-------|:---------------------------------------------------------------------------------------------|
|census_tract_id                    |Census Tract Identifier                   |string  |NA                                                                                            |
|n_parcels                          |Number of Parcels                         |integer |number of parcels in tract                                                                    |
|n_parcels_near_traffic             |Number of Parcels Near Traffic            |integer |number of parcels within 400 m of roads with non-zero average annual daily traffic            |
|n_parcels_near_truck_traffic       |Number of Parcels Near Truck Traffic      |integer |number of parcels within 400 m of roads with non-zero average annual daily truck traffic      |
|n_households                       |Number of Households                      |number  |number of households in tract                                                                 |
|n_households_near_traffic          |Number of Households Near Traffic         |number  |number of households within 400 m of roads with non-zero average annual daily traffic         |
|n_households_near_truck_traffic    |Number of Households Near Truck Traffic   |number  |number of households within 400 m of roads with non-zero average annual daily truck traffic   |
|median_parcel_traffic              |Median Parcel Traffic                     |number  |median average annual daily traffic within 400 m of each parcel (vehicle-meters)              |
|median_household_traffic           |Median Household Traffic                  |number  |median average annual daily traffic within 400 m of each household (truck-meters)             |
|median_parcel_truck_traffic        |Median Parcel Truck Traffic               |number  |median average annual daily truck traffic within 400 m of each parcel (vehicle-meters)        |
|median_household_truck_traffic     |Median Household Truck Traffic            |number  |median average annual daily truck traffic within 400 m of each household (truck-meters)       |
|frac_households_near_traffic       |Fraction of Households Near Traffic       |number  |fraction of households within 400 m of roads with non-zero average annual daily traffic       |
|frac_parcels_near_traffic          |Fraction of Parcels Near Traffic          |number  |fraction of parcels within 400 m of roads with non-zero average annual daily traffic          |
|frac_households_near_truck_traffic |Fraction of Households Near Truck Traffic |number  |fraction of households within 400 m of roads with non-zero average annual daily truck traffic |
|frac_parcels_near_truck_traffic    |Fraction of Parcels Near Truck Traffic    |number  |fraction of parcels within 400 m of roads with non-zero average annual daily truck traffic    |
