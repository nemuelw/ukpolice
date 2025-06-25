import unittest
import ukpolice

test "get_available_crime_dates() returns non-empty list":
  let crime_dates = get_available_crime_dates()
  check crime_dates.len > 0

test "get_forces() returns non-empty list":
  let forces = get_forces()
  check forces.len > 0
