#!/bin/bash

getAllTasks() {
  length_json=$(jq '. | length' $FILE_JSON)

  # Print all task
  echo ""
  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "ID" "Description" "Status" "Created At" "Updated At"
  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "---" "--------------------------------------------------" "-------------" "-------------------" "-------------------"

  for ((i = 0; i < length_json; i++)); do
    id=$(jq ".[$i].id" $FILE_JSON)
    description=$(jq ".[$i].description" $FILE_JSON)
    status=$(jq ".[$i].status" $FILE_JSON)
    timestampCreatedAt=$(jq ".[$i].createdAt" $FILE_JSON)
    timestampUpdateAt=$(jq ".[$i].updateAt" $FILE_JSON)

    createdAt=$(convertDateUnixToYMDHMS $timestampCreatedAt)
    updateAt=$(convertDateUnixToYMDHMS $timestampUpdateAt)

    printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "$id" "$description" "$status" "$createdAt" "$updateAt"
    printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "---" "--------------------------------------------------" "-------------" "-------------------" "-------------------"
  done
  echo ""
}

#Method for filter task by todo, in-progress or done
getTasksFilter() {
  case "$1" in
  -t)
    listFilter=$(jq '[.[] | select(.status == "todo")]' $FILE_JSON)
    ;;
  -i)
    listFilter=$(jq '[.[] | select(.status == "in-progress")]' $FILE_JSON)
    ;;
  -d)
    listFilter=$(jq '[.[] | select(.status == "done")]' $FILE_JSON)
    ;;
  *)
    echo 'Error "$1" not valid.'
    ;;
  esac

  count=$(echo "$listFilter" | jq 'length')

  echo ""
  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "ID" "Description" "Status" "Created At" "Updated At"
  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "---" "--------------------------------------------------" "-------------" "-------------------" "-------------------"

  for ((i = 0; i < $count; i++)); do
    id=$(echo $listFilter | jq ".[$i].id")
    description=$(echo $listFilter | jq ".[$i].description")
    status=$(echo $listFilter | jq ".[$i].status")
    timestampCreatedAt=$(echo $listFilter | jq ".[$i].createdAt")
    timestampUpdateAt=$(echo $listFilter | jq ".[$i].updateAt")

    createdAt=$(convertDateUnixToYMDHMS $timestampCreatedAt)
    updateAt=$(convertDateUnixToYMDHMS $timestampUpdateAt)

    printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "$id" "$description" "$status" "$createdAt" "$updateAt"
    printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "---" "--------------------------------------------------" "-------------" "-------------------" "-------------------"
  done
  echo ""
}

# Method for convert timestamp to date complete
convertDateUnixToYMDHMS() {
  date -d "@$1" +"%Y-%m-%d %H:%M:%S"
}
