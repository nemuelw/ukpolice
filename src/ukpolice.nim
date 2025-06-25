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

proc renameHook(c: var CrimeDate, fieldName: var string) =
  if fieldName == "stop-and-search": fieldName = "stop_and_search"

proc renameHook(e: var EngagementMethod, fieldName: var string) =
  if fieldName == "type": fieldName = "engagement_type"

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
