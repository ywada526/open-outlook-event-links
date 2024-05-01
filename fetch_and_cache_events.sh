#!/bin/bash

script_dir=$(dirname "$(realpath "$0")")
cache_file="$script_dir/cache/events.json"
today=$(date "+%Y-%m-%d")

if [ -s "$cache_file" ] && [ "$(date -r "$cache_file" "+%Y-%m-%d")" = "$today" ]; then
  cat "$cache_file"
  "$script_dir"/fetch_events.sh > "$cache_file" &
else
  "$script_dir/fetch_events.sh" | tee "$cache_file"
fi
