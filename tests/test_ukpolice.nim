import unittest
import ukpolice

test "get_available_crime_dates() returns non-empty list":
  let crime_dates = get_available_crime_dates()
  check crime_dates.len > 0
