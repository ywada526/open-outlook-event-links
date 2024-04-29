#!/bin/bash

now="$(date "+%Y-%m-%dT%H:%M:%S%z")"
end_of_today="$(date "+%Y-%m-%dT")23:59:59$(date "+%z")"

mgc me calendar-view list \
  --headers 'Prefer=outlook.timezone="Asia/Tokyo"' \
  --select "subject,organizer,start,end,location,body,responseStatus" \
  --start-date-time "$now" \
  --end-date-time "$end_of_today" \
  --filter "isCancelled eq false" \
  --orderby "isAllDay,start/dateTime" \
  --top 50 \
| jq '.value' \
| jq '[.[] | select(.responseStatus.response != "declined")]' \
| jq '.[] |= (. + { links: [[.location.displayName, .body.content] | join(" ") | match("https?://[a-zA-Z0-9./?=_-]+"; "g") | .string] | unique })'
