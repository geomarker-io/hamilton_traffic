# Hamilton County Parcel and Household Traffic

## About

This R code generates the **Hamilton County Parcel and Household Traffic** (`hamilton_traffic`) data resource. Census tract-level measures of parcel and household traffic proximity (including all vehicles and only truck traffic) and parcel and household median average annual daily traffic are derived from the Average Annual Daily Traffic (AADT) resource provided by the U.S. Department of Transportation [Federal Highway
Administration](https://www.fhwa.dot.gov/policyinformation/hpms/shapefiles_2017.cfm).

See [metadata.md](./metadata.md) for detailed metadata and schema information.

## Accessing Data

Read this CSV file into R directly from the [release](https://github.com/geomarker-io/hamilton_traffic/releases) with:

```
readr::read_csv("https://github.com/geomarker-io/hamilton_traffic/releases/download/v0.1.0/hamilton_traffic.csv")
```

Metadata can be imported from the accompanying `tabular-data-resource.yaml` file by using [{CODECtools}](https://geomarker.io/CODECtools/).

## Data Details

#### Hamilton Parcels

`hamilton_traffic` consists of parcel-based measures in Hamilton County, Ohio. See [`hamilton_parcels`](https://github.com/geomarker-io/hamilton_parcels) for more information about parcels and households in Hamilton County. 

#### AADT

For more information on AADT, see the [`{addAadtData`}](https://github.com/geomarker-io/addAadtData) R package or the [`aadt`](https://github.com/degauss-org/aadt) degauss container.



