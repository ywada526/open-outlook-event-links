#!/bin/bash

script_dir=$(dirname "$(realpath "$0")")

"$script_dir/fetch_and_cache_events.sh" \
  | jq \
    '
    if . == [] then
      { items: [{ title: "There are no more events today!" }] }
    else
      {
        items: [.[] | {
          title: .subject,
          subtitle: (
            (.start.dateTime | split(".")[0] | strptime("%Y-%m-%dT%H:%M:%S") | strftime("%b %d (%a) %H:%M"))
            + " - "
            + (.end.dateTime | split(".")[0] | strptime("%Y-%m-%dT%H:%M:%S") | strftime("%b %d (%a) %H:%M"))
          ),
          arg: .links
        }]
      }
    end'
