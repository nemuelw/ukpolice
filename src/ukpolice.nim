import httpclient, json, options, sequtils, strutils
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

  Street* = object
    id*: int
    name*: string

  Location* = object
    latitude*: string
    street*: Street
    longitude*: string

  CrimeOutcomeStatus* = object
    category*: string
    date*: string

  CrimeRecord* = object
    category*: string
    persistent_id*: string
    location_subtype*: string
    id*: int
    location*: Location
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
    location*: Location
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

  NeighbourhoodLocation* = object
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
    locations*: seq[NeighbourhoodLocation]

  Coords* = object
    latitude*: string
    longitude*: string

  Event* = object
    contact_details*: ContactDetails
    title*: string
    description*: string
    address*: string
    event_type*: string
    start_date*: string
    end_date*: string

  Priority* = object
    issue*: string
    issue_date*: string
    action*: string
    action_date*: string

  PolicingTeam* = object
    force*: string
    neighbourhood*: string

  OutcomeObject* = object
    id*: string
    name*: string

  StopAndSearch* = object
    stop_and_search_type*: string
    involved_person*: bool
    datetime*: string
    operation*: string
    operation_name*: string
    location*: Option[Location]
    gender*: string
    age_range*: string
    self_defined_ethnicity*: string
    officer_defined_ethnicity*: string
    legislation*: string
    object_of_search*: string
    outcome_object*: OutcomeObject
    outcome*: string
    outcome_linked_to_object_of_search*: Option[bool]
    removal_of_more_than_outer_clothing*: Option[bool]

proc renameHook(c: var CrimeDate, fieldName: var string) =
  if fieldName == "stop-and-search": fieldName = "stop_and_search"

proc renameHook(e: var EngagementMethod, fieldName: var string) =
  if fieldName == "type": fieldName = "engagement_type"

proc renameHook(e: var ContactDetails, fieldName: var string) =
  if fieldName == "google-plus": fieldName = "google_plus"
  if fieldName == "e-messaging": fieldName = "e_messaging"

proc renameHook(l: var NeighbourhoodLocation, fieldName: var string) =
  if fieldName == "type": fieldName = "location_type"

proc renameHook(e: var Event, fieldName: var string) =
  if fieldName == "type": fieldName = "event_type"

proc renameHook(p: var Priority, fieldName: var string) =
  if fieldName == "issue-date": fieldName = "issue_date"
  if fieldName == "action-date": fieldName = "action_date"

proc parseHook(s: string, i: var int, v: var StopAndSearch) =
  var raw: JsonNode
  parseHook(s, i, raw)

  # parse all fields manually
  v.stop_and_search_type = raw["type"].str
  v.involved_person = raw["involved_person"].bval
  v.datetime = raw["datetime"].str
  v.operation = if "operation" in raw: raw["operation"].getStr else: ""
  v.operation_name = if "operation_name" in raw: raw["operation_name"].getStr else: ""
  v.gender = raw["gender"].getStr
  v.age_range = raw["age_range"].getStr
  v.self_defined_ethnicity = raw["self_defined_ethnicity"].getStr
  v.officer_defined_ethnicity = raw["officer_defined_ethnicity"].getStr
  v.legislation = raw["legislation"].getStr
  v.object_of_search = raw["object_of_search"].getStr
  v.outcome_object = raw["outcome_object"].to(OutcomeObject)

  case raw["location"].kind:
  of JObject:
    v.location = some(raw["location"].to(Location))
  of JNull:
    v.location = none(Location)
  else:
    raise newException(ValueError, "invalid type for 'location' field")

  let outcomeNode = raw["outcome"]
  case outcomeNode.kind
  of JBool:
    if outcomeNode.bval:
      v.outcome = "true"
    else:
      v.outcome = "false"
  of JString:
    v.outcome = outcomeNode.str
  else:
    raise newException(ValueError, "invalid type for 'outcome' field")

  case raw["outcome_linked_to_object_of_search"].kind:
  of JBool:
    v.outcome_linked_to_object_of_search = some(raw["outcome_linked_to_object_of_search"].bval)
  of JNull:
    v.outcome_linked_to_object_of_search = none(bool)
  else:
    raise newException(ValueError, "invalid type for 'outcome_linked_to_object_of_search' field")

  case raw["removal_of_more_than_outer_clothing"].kind:
  of JBool:
    v.removal_of_more_than_outer_clothing = some(raw["removal_of_more_than_outer_clothing"].bval)
  of JNull:
    v.removal_of_more_than_outer_clothing = none(bool)
  else:
    raise newException(ValueError, "invalid type for 'removal_of_more_than_outer_clothing' field")

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

proc get_neighbourhood_events*(force_id: string, neighbourhood_id: string): seq[Event] =
  let resp = client.getContent(BaseUrl & force_id & "/" & neighbourhood_id & "/events")
  resp.fromJson(seq[Event])

proc get_neighbourhood_priorities*(force_id: string, neighbourhood_id: string): seq[Priority] =
  let resp = client.getContent(BaseUrl & force_id & "/" & neighbourhood_id & "/priorities")
  resp.fromJson(seq[Priority])

proc get_policing_team_for_area*(lat, lng: string): PolicingTeam =
  let coordsParam = lat & "," & lng
  let resp = client.getContent(BaseUrl & "locate-neighbourhood?q=" & coordsParam)
  resp.fromJson(PolicingTeam)

proc get_stops_and_searches(url: string): seq[StopAndSearch] =
  let resp = client.getContent(url)
  resp.fromJson(seq[StopAndSearch])

proc get_street_stops_and_searches_by_coords*(lat, lng: string, date = ""): seq[StopAndSearch] =
  var url = BaseUrl & "stops-street?lat=" & lat & "&lng=" & lng
  if date != "":
    url &= "&date=" & date
  get_stops_and_searches(url)

proc get_street_stops_and_searches_by_polygon*(poly: seq[(string, string)], date = ""): seq[StopAndSearch] =
  let polyParam = poly.mapIt(it[0] & "," & it[1]).join(":")
  var url = BaseUrl & "stops-street?poly=" & polyParam
  if date != "":
    url &= "&date=" & date
  get_stops_and_searches(url)

proc get_stops_and_searches_by_location_id*(location_id: string, date: string = ""): seq[StopAndSearch] =
  var url = BaseUrl & "stops-at-location?location_id=" & location_id
  if date != "":
    url &= "&date=" & date
  get_stops_and_searches(url)

proc get_stops_and_searches_with_no_location*(force_id: string, date = ""): seq[StopAndSearch] =
  var url = BaseUrl & "stops-no-location?force=" & force_id
  if date != "":
    url &= "&date=" & date
  get_stops_and_searches(url)
