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
