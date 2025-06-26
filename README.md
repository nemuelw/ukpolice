# ukpolice

Nim wrapper for the UK Police Data API

## Installation

- Run this command in your project directory:

```bash
nimble install ukpolice
```

## Usage

> This library provides complete coverage of the UK Police API and can be used to query all available
> endpoints.

### Import the package

```nim
import ukpolice
```

### Get available crime dates

```nim
# get_available_crime_dates(): seq[CrimeDate]
let crime_dates: seq[CrimeDate] = get_available_crime_dates()
```

### Get a list of all the forces

```nim
# get_forces(): seq[Force]
let forces: seq[Force] = get_forces()
```

### Get details of a particular force

```nim
# get_force_details(force_id): ForceDetails
let force: ForceDetails = get_force_details("leicestershire")
```

### Get the list of senior officers for a particular force

```nim
# get_senior_officers(force_id): seq[Officer]
let senior_officers: seq[Officer] = get_senior_officers("leicestershire")
```

### Get street-level crime data

#### By coordinates (lat,lng)

```nim
# get_street_crimes_by_coords(lat, lng, date): seq[CrimeRecord]
let crimes: seq[CrimeRecord] = get_street_crimes_by_coords("51", "-1.423", "2024-01")
```

#### By polygon (sequence of coordinates)

```nim
# get_street_crimes_by_polygon(poly, date): seq[CrimeRecord]
let crimes: seq[CrimeRecord] = get_street_crimes_by_polygon(@[("52", "0.5"), ("52.794", "0.4"),
    ("52.1", "0.5")], date = "2024-01")
```

### Get street-crime outcomes

#### By location ID

```nim
# get_street_crime_outcomes_by_location_id(location_id, date): seq[CrimeOutcomeRecord]
let outcomes: seq[CrimeOutcomeRecord] = get_street_crime_outcomes_by_location_id("1737432", "2024-01")
```

#### By coordinates (lat,lng)

```nim
# get_street_crime_outcomes_by_coords(lat, lng, date): seq[CrimeOutcomeRecord]
let outcomes: seq[CrimeOutcomeRecord] = get_street_crime_outcomes_by_coords("51", "-1.423", "2024-01")
```

#### By polygon

```nim
# get_street_crime_outcomes_by_polygon(poly, date): seq[CrimeOutcomeRecord]
let outcomes: seq[CrimeOutcomeRecord] = get_street_crime_outcomes_by_polygon(
    @[("52", "0.5"), ("52.794", "0.4"), ("52.1", "0.5")], date = "2024-01")
```

### Get crimes at a location

#### By location ID

```nim
# get_crimes_by_location_id(location_id, date): seq[CrimeRecord]
let crimes: seq[CrimeRecord] = get_crimes_by_location_id("1738423", "2024-01")
```

#### By coordinates

```nim
# get_crimes_by_coords(lat, lng, date): seq[CrimeRecord]
let crimes: seq[CrimeRecord] = get_crimes_by_coords("52.629729", "-1.131592", "2024-01")
```

### Get crimes with no location

```nim
# get_crimes_with_no_location(force_id, category, date): seq[CrimeRecord]
let crimes: seq[CrimeRecord] = get_crimes_with_no_location("leicestershire", "burglary", "2024-01")
```

### Get a list of all available crime categories

```nim
# get_crime_categories(date): seq[CrimeCategory]
let crime_categories: seq[CrimeCategory] = get_crime_categories("2024-01")
```

### Get the last time the crime data was updated

```nim
# get_crime_last_updated(): LastUpdated
let last_updated: LastUpdated = get_crime_last_updated()
```

### Get outcomes (case history) for a specific crime

```nim
# get_outcomes_for_crime(crime_id): CrimeOutcomes
let crime_id = "e11dade0a92a912d12329b9b2abb856ac9520434ad6845c30f503e9901d140f1"
let crime_outcomes: CrimeOutcomes = get_outcomes_for_crime(crime_id)
```

### Get a list of all neighbourhoods for a force

```nim
# get_neighbourhoods_for_force(force_id): seq[Neighbourhood]
let neighbourhoods: seq[Neighbourhood] = get_neighbourhoods_for_force("leicestershire")
```

### Get details for a specific neighbourhood

```nim
# get_neighbourhood_details(force_id, neighbourhood_id): NeighbourhoodDetails
let details: NeighbourhoodDetails = get_neighbourhood_details("leicestershire", "NC04")
```

### Get neighbourhood boundary

```nim
# get_neighbourhood_boundary(force_id, neighbourhood_id): seq[Coords]
let boundary: seq[Coords]  = get_neighbourhood_boundary("leicestershire", "NC04")
```

### Get neighbourhood team

```nim
# get_neighbourhood_team(force_id, neighbourhood_id): seq[Coords]
let team: seq[Officer] = get_neighbourhood_team("leicestershire", "NC04")
```

### Get neighbourhood events

```nim
# get_neighbourhood_events(force_id, neighbourhood_id): seq[Event]
let events: seq[Event] = get_neighbourhood_events("leicestershire", "NC04")
```

### Get neighbourhood priorities

```nim
# get_neighbourhood_priorities(force_id, neighbourhood_id): seq[Priority]
let priorities: seq[Priority] = get_neighbourhood_priorities("leicestershire", "NC04")
```

### Get the policing team for an area

```nim
# get_policing_team_for_area(lat, lng): PolicingTeam
let team: PolicingTeam = get_policing_team_for_area("51.500617", "-0.124629")
```

### Get stops and searches in a given area

#### By coordinates

```nim
# get_street_stops_and_searches_by_coords(lat, lng, date): seq[StopAndSearch]
let stops_and_searches: seq[StopAndSearch] = get_street_stops_and_searches_by_coords("52.001",
    "-1.001", "2024-01")
```

#### By polygon

```nim
# get_street_stops_and_searches_by_polygon(poly, date): seq[StopAndSearch]
let stops_and_searches: seq[StopAndSearch] = get_street_stops_and_searches_by_polygon(
    @[("52", "0.5"), ("52.794", "0.4"), ("52.1", "0.5")], "2024-01")
```

### Get stops and searches at a given point (location ID)

```nim
# get_stops_and_searches_by_location_id(location_id, date)
let stops_and_searches: seq[StopAndSearch] = get_stops_and_searches_by_location_id("1609590", "2024-01")
```

### Get stops and searches with no location

```nim
# get_stops_and_searches_with_no_location(force_id, date): seq[StopAndSearch]
let stops_and_searches: seq[StopAndSearch] = get_stops_and_searches_with_no_location(
    "leicestershire", "2024-01")
```

### Get stops and searches for a particular force

```nim
# get_stops_and_searches_by_force(force_id, date)
let stops_and_searches: seq[StopAndSearch] = get_stops_and_searches_by_force("leicestershire", "2024-01")
```

## Tests

- To run tests, simply run this command:

```nim
nimble test -d:ssl
```

## Contributing

Contributions are welcome! Feel free to create an issue or open a pull request.

## License

This project is licensed under the terms of the [MIT License](https://opensource.org/licenses/MIT).

SPDX-License-Identifier: `MIT`
