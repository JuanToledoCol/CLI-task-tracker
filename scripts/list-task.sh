#!/bin/bash

createTask() {
  id=$(jq '.[-1].id' $FILE_JSON)
  id=$(($id + 1))
  createdAt=$(date +%s)
  updateAt=$(date +%s)

  jq --argjson id "$id" \
    --arg description "$2" \
    --arg status "$1" \
    --argjson createdAt "$createdAt" \
    --argjson updateAt "$updateAt" \
    '. += [{"id": $id, "description": $description, "status": $status, "createdAt": $createdAt, "updateAt": $updateAt}]' \
    "$FILE_JSON" >temp.json && mv temp.json "$FILE_JSON"

  echo "Task added successfully:"
  echo ""
  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "ID" "Description" "Status" "Created At" "Updated At"
  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "---" "--------------------------------------------------" "-------------" "-------------------" "-------------------"
  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "$id" "$2" "$1" "$(convertDateUnixToYMDHMS $createdAt)" "$(convertDateUnixToYMDHMS $updateAt)"
  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "---" "--------------------------------------------------" "-------------" "-------------------" "-------------------"
}

updateTask() {
  if [[ -n "$2" && -z "$3" ]]; then
    jq --argjson id "$1" --arg status "$2" \
      '(.[] | select(.id == $id) | .status) = $status' \
      "$FILE_JSON" >temp.json && mv temp.json "$FILE_JSON"

  elif [[ -z "$2" && -n "$3" ]]; then
    jq --argjson id "$1" --arg description "$3" \
      '(.[] | select(.id == $id) | .description) = $description' \
      "$FILE_JSON" >temp.json && mv temp.json "$FILE_JSON"

  elif [[ -n "$2" && -n "$3" ]]; then
    jq --argjson id "$1" \
      --arg status "$2" \
      --arg description "$3" \
      '(.[] | select(.id == $id)) |= (.status = $status | .description = $description)' \
      "$FILE_JSON" >temp.json && mv temp.json "$FILE_JSON"
  else
    echo "No valid parameters provided for update."
    exit 1
  fi

  taskUpdated=$(jq ".[] | select(.id == $1)" $FILE_JSON)

  echo ""
  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "ID" "Description" "Status" "Created At" "Updated At"
  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "---" "--------------------------------------------------" "-------------" "-------------------" "-------------------"

  id=$(echo $taskUpdated | jq ".id")
  description=$(echo $taskUpdated | jq ".description")
  status=$(echo $taskUpdated | jq ".status")
  createdAt=$(echo $taskUpdated | jq ".createdAt")
  updateAt=$(echo $taskUpdated | jq ".updateAt")

  createdAt=$(convertDateUnixToYMDHMS $createdAt)
  updateAt=$(convertDateUnixToYMDHMS $updateAt)

  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "$id" "$description" "$status" "$createdAt" "$updateAt"
  printf "| %-3s | %-50s | %-13s | %-19s | %-19s |\n" "---" "--------------------------------------------------" "-------------" "-------------------" "-------------------"
  echo ""
}

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
