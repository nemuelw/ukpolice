import httpclient, jsony

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

  SeniorOfficer* = object
    name*: string
    rank*: string
    bio*: string
    contact_details: ContactDetails

  CrimeCategory* = object
    url*: string
    name*: string

proc renameHook(c: var CrimeDate, fieldName: var string) =
  if fieldName == "stop-and-search": fieldName = "stop_and_search"

proc renameHook(e: var EngagementMethod, fieldName: var string) =
  if fieldName == "type": fieldName = "engagement_type"

proc renameHook(e: var ContactDetails, fieldName: var string) =
  if fieldName == "google-plus": fieldName = "google_plus"
  if fieldName == "e-messaging": fieldName = "e_messaging"

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

proc get_senior_officers*(force_id: string): seq[SeniorOfficer] =
  let resp = client.getContent(BaseUrl & "forces" & "/" & force_id & "/people")
  resp.fromJson(seq[SeniorOfficer])

proc get_crime_categories*(date: string): seq[CrimeCategory] =
  let resp = client.getContent(BaseUrl & "crime-categories" & "?date=" & date)
  resp.fromJson(seq[CrimeCategory])
