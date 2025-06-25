import httpclient, sequtils, strutils
import jsony

const BaseUrl = "https://data.police.uk/api/"

type
  CrimeDate* = object
    date*: string
    stop_and_search*: seq[string]

  Force* = object
    id*: string
    name*: string

  EngagementMethod* = object
    engagement_type*: string
    title*: string
    description*: string
    url*: string

  ForceDetails* = object
    id*: string
    name*: string
    description*: string
    url*: string
    telephone*: string
    engagement_methods*: seq[EngagementMethod]

  ContactDetails* = object
    email*: string
    telephone*: string
    mobile*: string
    fax*: string
    web*: string
    address*: string
    facebook*: string
    twitter*: string
    youtube*: string
    myspace*: string
    bebo*: string
    flickr*: string
    google_plus*: string
    forum*: string
    e_messaging*: string
    blog*: string
    rss*: string

  Officer* = object
    name*: string
    rank*: string
    bio*: string
    contact_details: ContactDetails

  CrimeCategory* = object
    url*: string
    name*: string

  CrimeStreet* = object
    id*: int
    name*: string

  CrimeLocation* = object
    latitude*: string
    street*: CrimeStreet
    longitude*: string

  CrimeOutcomeStatus* = object
    category*: string
    date*: string

  CrimeRecord* = object
    category*: string
    persistent_id*: string
    location_subtype*: string
    id*: int
    location*: CrimeLocation
    context*: string
    month*: string
    location_type*: string
    outcome_status*: CrimeOutcomeStatus

  CrimeOutcomeCategory* = object
    code*: string
    name*: string

  Crime* = object
    category*: string
    id*: int
    persistent_id*: string
    location_type*: string
    location_subtype*: string
    location*: CrimeLocation
    context*: string
    month*: string

  CrimeOutcomeRecord* = object
    category*: CrimeOutcomeCategory
    date*: string
    person_id*: string
    crime*: Crime

  LastUpdated* = object
    date*: string

  CrimeOutcome* = object
    category*: CrimeOutcomeCategory
    date*: string
    person_id*: string

  CrimeOutcomes* = object
    crime*: Crime
    outcomes*: seq[CrimeOutcome]

  Neighbourhood* = object
    id*: string
    name*: string

  Link* = object
    url*: string
    description*: string
    title*: string

  Centre* = object
    latitude*: string
    longitude*: string

  Location* = object
    name*: string
    latitude*: string
    longitude*: string
    postcode*: string
    address*: string
    telephone*: string
    location_type*: string
    description*: string

  NeighbourhoodDetails* = object
    id*: string
    description*: string
    url_force*: string
    contact_details*: ContactDetails
    name*: string
    welcome_message*: string
    links*: seq[Link]
    centre*: Centre
    population*: string
    locations*: seq[Location]

  Coords* = object
    latitude*: string
    longitude*: string

proc renameHook(c: var CrimeDate, fieldName: var string) =
  if fieldName == "stop-and-search": fieldName = "stop_and_search"

proc renameHook(e: var EngagementMethod, fieldName: var string) =
  if fieldName == "type": fieldName = "engagement_type"

proc renameHook(e: var ContactDetails, fieldName: var string) =
  if fieldName == "google-plus": fieldName = "google_plus"
  if fieldName == "e-messaging": fieldName = "e_messaging"

proc renameHook(l: var Location, fieldName: var string) =
  if fieldName == "type": fieldName = "location_type"

let client = newHttpClient()
client.headers["User-Agent"] = "ukpolice/0.1.0 (Nim)"

proc get_available_crime_dates*(): seq[CrimeDate] =
  let resp = client.getContent(BaseUrl & "crimes-street-dates")
  resp.fromJson(seq[CrimeDate])

proc get_forces*(): seq[Force] =
  let resp = client.getContent(BaseUrl & "forces")
  resp.fromJson(seq[Force])

proc get_force_details*(force_id: string): ForceDetails =
  let resp = client.getContent(BaseUrl & "forces" & "/" & force_id)
  resp.fromJson(ForceDetails)

proc get_senior_officers*(force_id: string): seq[Officer] =
  let resp = client.getContent(BaseUrl & "forces" & "/" & force_id & "/people")
  resp.fromJson(seq[Officer])

proc get_street_crimes(url: string): seq[CrimeRecord] =
  let resp = client.getContent(url)
  resp.fromJson(seq[CrimeRecord])

proc get_street_crimes_by_coords*(lat, lng: string, category: string = "all-crime", date: string = ""): seq[CrimeRecord] =
  var url = BaseUrl & "crimes-street/" & category & "?lat=" & lat & "&lng=" & lng
  if date != "":
    url &= "&date=" & date
  get_street_crimes(url)

proc get_street_crimes_by_polygon*(poly: seq[(string, string)], category: string = "all-crime", date: string = ""): seq[CrimeRecord] =
  let polyParam = poly.mapIt(it[0] & "," & it[1]).join(":")
  var url = BaseUrl & "crimes-street/all-crime?poly=" & polyParam
  if date != "":
    url &= "&date=" & date
  get_street_crimes(url)

proc get_street_crime_outcomes(url: string): seq[CrimeOutcomeRecord] =
  let resp = client.getContent(url)
  resp.fromJson(seq[CrimeOutcomeRecord])

proc get_street_crime_outcomes_by_location_id*(location_id: string, date = ""): seq[CrimeOutcomeRecord] =
  var url = BaseUrl & "outcomes-at-location?location_id=" & location_id
  if date != "":
    url &= "&date=" & date
  get_street_crime_outcomes(url)

proc get_street_crime_outcomes_by_coords*(lat, lng: string, date = ""): seq[CrimeOutcomeRecord] =
  var url = BaseUrl & "outcomes-at-location?lat=" & lat & "&lng=" & lng
  if date != "":
    url &= "&date=" & date
  get_street_crime_outcomes(url)

proc get_street_crime_outcomes_by_polygon*(poly: seq[(string, string)], date = ""): seq[CrimeOutcomeRecord] =
  let polyParam = poly.mapIt(it[0] & "," & it[1]).join(":")
  var url = BaseUrl & "outcomes-at-location?poly=" & polyParam
  if date != "":
    url &= "&date=" & date
  get_street_crime_outcomes(url)

proc get_crimes_at_location(url: string): seq[CrimeRecord] =
  let resp = client.getContent(url)
  resp.fromJson(seq[CrimeRecord])

proc get_crimes_by_location_id*(location_id: string, date: string = ""): seq[CrimeRecord] =
  var url = BaseUrl & "crimes-at-location?location_id=" & location_id
  if date != "":
    url &= "&date=" & date
  get_crimes_at_location(url)

proc get_crimes_by_coords*(lat, lng: string, date: string = ""): seq[CrimeRecord] =
  var url = BaseUrl & "crimes-at-location?lat=" & lat & "&lng=" & lng
  if date != "":
    url &= "&date=" & date
  get_crimes_at_location(url)

proc get_crimes_with_no_location*(force: string, category = "all-crime", date = ""): seq[CrimeRecord] =
  var url = BaseUrl & "crimes-no-location?category=" & category & "&force=" & force
  if date != "":
    url &= "&date=" & date
  let resp = client.getContent(url)
  resp.fromJson(seq[CrimeRecord])

proc get_crime_categories*(date: string): seq[CrimeCategory] =
  let resp = client.getContent(BaseUrl & "crime-categories" & "?date=" & date)
  resp.fromJson(seq[CrimeCategory])

proc get_crime_last_updated*(): LastUpdated =
  let resp = client.getContent(BaseUrl & "crime-last-updated")
  resp.fromJson(LastUpdated)

proc get_outcomes_for_crime*(crime_id: string): CrimeOutcomes =
  let resp = client.getContent(BaseUrl & "outcomes-for-crime/" & crime_id)
  resp.fromJson(CrimeOutcomes)

proc get_neighbourhoods_for_force*(force_id: string): seq[Neighbourhood] =
  let resp = client.getContent(BaseUrl & force_id & "/neighbourhoods")
  resp.fromJson(seq[Neighbourhood])

proc get_neighbourhood_details*(force_id: string, neighbourhood_id: string): NeighbourhoodDetails =
  let resp = client.getContent(BaseUrl & force_id & "/" & neighbourhood_id)
  resp.fromJson(NeighbourhoodDetails)

proc get_neighbourhood_boundary*(force_id: string, neighbourhood_id: string): seq[Coords] =
  let resp = client.getContent(BaseUrl & force_id & "/" & neighbourhood_id & "/boundary")
  resp.fromJson(seq[Coords])

proc get_neighbourhood_team*(force_id: string, neighbourhood_id: string): seq[Officer] =
  let resp = client.getContent(BaseUrl & force_id & "/" & neighbourhood_id & "/people")
  resp.fromJson(seq[Officer])
