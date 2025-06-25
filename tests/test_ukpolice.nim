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

test "get_street_crimes_by_location(lat, lng, category, date)":
  let crimes = get_street_crimes_by_location("51", "-1.423", date="2024-01")
  check crimes.len == 2

test "get_street_crimes_by_polygon(poly, category, date)":
  let crimes = get_street_crimes_by_polygon(@[("52","0.5"),("52.794","0.4"),("52.1","0.5")], date="2024-01")
  check crimes.len == 10
