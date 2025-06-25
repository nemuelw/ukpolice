import unittest
import ukpolice

test "get_available_crime_dates() returns non-empty list":
  let crime_dates = get_available_crime_dates()
  check crime_dates.len > 0

test "get_forces() returns non-empty list":
  let forces = get_forces()
  check forces.len > 0

test "get_force_details(force_id) returns correct force details":
  let details = get_force_details("leicestershire")
  check details.id == "leicestershire"
  check details.name == "Leicestershire Police"
  check details.telephone == "101"

test "get_senior_officers(force_id) returns correct senior officers' details":
  let senior_officers = get_senior_officers("leicestershire")
  check senior_officers.len > 0

test "get_crime_categories(date) returns valid data":
  let crime_categories = get_crime_categories("2024-01")
  check crime_categories.len == 15
