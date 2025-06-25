import unittest
import ukpolice

test "get_available_crime_dates()":
  let crime_dates = get_available_crime_dates()
  check crime_dates.len > 0

test "get_forces()":
  let forces = get_forces()
  check forces.len > 0

test "get_force_details(force_id)":
  let details = get_force_details("leicestershire")
  check details.id == "leicestershire"
  check details.name == "Leicestershire Police"
  check details.telephone == "101"

test "get_senior_officers(force_id)":
  let senior_officers = get_senior_officers("leicestershire")
  check senior_officers.len > 0

test "get_crime_categories(date)":
  let crime_categories = get_crime_categories("2024-01")
  check crime_categories.len == 15

test "get_street_crimes_by_coords(lat, lng, category, date)":
  let crimes = get_street_crimes_by_coords("51", "-1.423", date="2024-01")
  check crimes.len == 2

test "get_street_crimes_by_polygon(poly, category, date)":
  let crimes = get_street_crimes_by_polygon(@[("52","0.5"),("52.794","0.4"),("52.1","0.5")], date="2024-01")
  check crimes.len == 10

test "get_street_crime_outcomes_by_location_id(location_id, date)":
  let outcomes = get_street_crime_outcomes_by_location_id("1737432", "2024-01")
  check outcomes.len == 3

test "get_street_crime_outcomes_by_coords(lat, lng, date)":
  let outcomes = get_street_crime_outcomes_by_coords("51", "-1.423", "2024-01")
  check outcomes.len == 4

test "get_street_crime_outcomes_by_polygon(poly, date)":
  let outcomes = get_street_crime_outcomes_by_polygon(@[("52","0.5"),("52.794","0.4"),("52.1","0.5")], date="2024-01")
  check outcomes.len == 9

test "get_crimes_by_location_id(location_id, date)":
  let crimes = get_crimes_by_location_id("1738423", "2024-01")
  check crimes.len == 2

test "get_crimes_by_coords(lat, lng, date)":
  let crimes = get_crimes_by_coords("52.629729", "-1.131592", "2024-01")
  check crimes.len == 2

test "get_crimes_with_no_location(force, category, date)":
  let crimes = get_crimes_with_no_location("leicestershire", "burglary", "2024-01")
  check crimes.len == 19

test "get_crime_last_updated()":
  let last_updated = get_crime_last_updated()
  check last_updated.date.len > 0

test "get_outcomes_for_crime(crime_id)":
  let crime_id = "e11dade0a92a912d12329b9b2abb856ac9520434ad6845c30f503e9901d140f1"
  let crime_outcomes = get_outcomes_for_crime(crime_id)
  check crime_outcomes.crime.persistent_id == crime_id

test "get_neighbourhoods_for_force(force_id)":
  let neighbourhoods = get_neighbourhoods_for_force("leicestershire")
  check neighbourhoods.len == 67

test "get_neighbourhood_details(force_id, neighbourhood_id)":
  let details = get_neighbourhood_details("leicestershire", "NC04")
  check details.id == "NC04"
  check details.name == "City Centre"

test "get_neighbourhood_boundary(force_id, neighbourhood_id)":
  let boundary = get_neighbourhood_boundary("leicestershire", "NC04")
  check boundary.len == 85
  check boundary[0].latitude == "52.6394052587"
  check boundary[0].longitude == "-1.1458618876"
