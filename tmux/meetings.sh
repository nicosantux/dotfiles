#!/bin/bash

ALERT_IF_IN_NEXT_MINUTES=20
ALERT_POPUP_BEFORE_SECONDS=15
NO_MEETINGS="􁻧  No meetings"

meeting_info() {
  if [[ $1 == 1 ]]; then
    echo "􀧞  Next meeting in $1 minute"
  elif [[ $1 == 0 ]]; then
    echo "􀧞  Next meeting in less than 1 minute"
  else
    echo "􀧞  Next meeting in $1 minutes"
  fi
}

get_attendees() {
	attendees=$(
	icalBuddy \
    --includeEventProps "attendees" \
		--noCalendarNames \
		--dateFormat "%A" \
		--includeOnlyEventsFromNowOn \
		--limitItems 1 \
		--excludeAllDayEvents \
		--excludeEndDates \
		--bullet "" \
		eventsToday
  )

  # Get the length of the attendees array
  number_of_attendees=$(echo $attendees | awk -F ' ' '{print NF}')
}

get_current_event() {
	current_event=$(
  icalBuddy \
		--includeEventProps "datetime" \
		--propertyOrder "datetime" \
		--noCalendarNames \
		--dateFormat "%A" \
		--includeOnlyEventsFromNowOn \
		--limitItems 1 \
		--excludeAllDayEvents \
		--bullet "" \
		eventsToday
  )

  start_time_current_event=$(echo $current_event | awk -F ' - ' '{print $1}')
  end_time_current_event=$(echo $current_event | awk -F ' - ' '{print $2}')
  current_timestamp=$(date +%s)
  current_event_start=$(date -j -f "%T" "$start_time_current_event:00" +%s)
  current_event_end=$(date -j -f "%T" "$end_time_current_event:00" +%s)

  if [[ $current_timestamp -lt $current_event_start ]]; then
    current_event=""
  fi
}

get_next_meeting() {
	next_meeting=$(
  icalBuddy \
		--includeEventProps "title,datetime" \
		--propertyOrder "datetime,title" \
		--noCalendarNames \
		--dateFormat "%A" \
		--includeOnlyEventsFromNowOn \
		--limitItems 1 \
		--excludeAllDayEvents \
		--separateByDate \
		--bullet "" \
		eventsToday
  )
}

get_next_attendees_after_current() {
  # $1 is the end time of the current event
  # We add 1 minute to the end time of the current event to get the next meeting
  add_minute=$(date -j -f "%T" -v +1M "$1:00" +%H:%M)

  attendees=$(
  icalBuddy \
    --includeEventProps "attendees" \
    --noCalendarNames \
    --dateFormat "%A" \
    --limitItems 1 \
    --excludeAllDayEvents \
    --bullet "" \
    eventsFrom:"$add_minute" to:"23:59"
  )

  # Get the length of the attendees array
  number_of_attendees=$(echo $attendees | awk -F ' ' '{print NF}')
}

get_next_meeting_after_current() {
  # $1 is the end time of the current event
  # We add 1 minute to the end time of the current event to get the next meeting
  add_minute=$(date -j -f "%T" -v +1M "$1:00" +%H:%M)

  next_meeting=$(
  icalBuddy \
    --includeEventProps "title,datetime" \
    --propertyOrder "datetime,title" \
    --noCalendarNames \
    --dateFormat "%A" \
    --limitItems 1 \
    --excludeAllDayEvents \
    --bullet "" \
    eventsFrom:"$add_minute" to:"23:59"
  )
}

parse_result() {
	array=()
	for line in $1; do
		array+=("$line")
	done
	time="${array[2]}"
	end_time="${array[4]}"
	title="${array[*]:5:30}"
}

calculate_times(){
	epoc_meeting=$(date -j -f "%T" "$time:00" +%s)
	epoc_now=$(date +%s)
	epoc_diff=$((epoc_meeting - epoc_now))
	minutes_till_meeting=$((epoc_diff/60))
}

display_popup() {
  PANE_STATUS_FILE="/tmp/pane_opened"

  # Verify if the pane has already been opened
  if [ ! -f "$PANE_STATUS_FILE" ]; then
    # Open a floating pane with the event info
    tmux display-popup -w 100 -h 20 -E "icalBuddy --propertyOrder 'datetime,title' --noCalendarNames --formatOutput --includeEventProps 'title,datetime,notes,url,attendees' --includeOnlyEventsFromNowOn --limitItems 1 --excludeAllDayEvents eventsToday; read -n 1 -s"
    # zellij action new-pane --name "Event info:" -f -- icalBuddy --propertyOrder "datetime,title" --noCalendarNames --formatOutput --includeEventProps "title,datetime,notes,url,attendees" --includeOnlyEventsFromNowOn --limitItems 1 --excludeAllDayEvents eventsToday

    # Create the temporary file to avoid opening another pane
    touch "$PANE_STATUS_FILE"

    # After opening the pane, remove the file after a brief delay
    # to allow opening another pane in future executions
    sleep 5
    rm -rf "$PANE_STATUS_FILE"
  fi
}

print_zellij_status() {
  if [[ $number_of_attendees -le 2 ]]; then
    echo "$NO_MEETINGS"
    exit 0
  fi

	if [[ $minutes_till_meeting -lt $ALERT_IF_IN_NEXT_MINUTES && $minutes_till_meeting -gt -60 ]]; then
    meeting_info "$minutes_till_meeting"
	else
    echo "$NO_MEETINGS"
    exit 0
	fi

  if [[ $epoc_diff -le $ALERT_POPUP_BEFORE_SECONDS ]]; then
    display_popup
  fi
}

# Get if there is a meeting in progress
# current_event=$(icalBuddy eventsNow)
get_current_event

# if there is not a meeting in progress, get the next meeting
if [[ "$current_event" == "" ]]; then
  get_attendees
  get_next_meeting

  if [[ $next_meeting == "" ]]; then
    echo "$NO_MEETINGS"
    exit 0
  fi

  parse_result "$next_meeting"
  calculate_times
  print_zellij_status
else 
  # This is the format value in case there is a current event: 22:15 - 23:00
  # We need to get the end time of the current event
  end_time_current_event=$(echo $current_event | awk -F ' - ' '{print $2}')


  get_next_attendees_after_current $end_time_current_event
  # Get the next event after the current event
  get_next_meeting_after_current $end_time_current_event

  if [[ $next_meeting == "" ]]; then
    echo "$NO_MEETINGS"
    exit 0
  fi

  parse_result "$next_meeting"
  calculate_times
  print_zellij_status
fi
