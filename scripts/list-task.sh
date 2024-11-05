#!/bin/bash

getAllTasks() {
  length_json=$(jq '. | length' $FILE_JSON)

  # Print all task
  echo ""
  printf "| %-3s | %-50s | %-13s | %-14s | %-14s |\n" "ID" "Description" "Status" "Created At" "Updated At"
  printf "| %-3s | %-50s | %-13s | %-14s | %-14s |\n" "---" "--------------------------------------------------" "-------------" "--------------" "--------------"

  for ((i = 0; i < length_json; i++)); do
    id=$(jq ".[$i].id" $FILE_JSON)
    description=$(jq ".[$i].description" $FILE_JSON)
    status=$(jq ".[$i].status" $FILE_JSON)
    createdAt=$(jq ".[$i].createdAt" $FILE_JSON)
    updateAt=$(jq ".[$i].updateAt" $FILE_JSON)

    printf "| %-3s | %-50s | %-13s | %-14s | %-14s |\n" "$id" "$description" "$status" "$createdAt" "$updateAt"
    printf "| %-3s | %-50s | %-13s | %-14s | %-14s |\n" "---" "--------------------------------------------------" "-------------" "--------------" "--------------"
  done
  echo ""
}

getTodoTasks() {
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

  # Print all task
  echo ""
  printf "| %-3s | %-50s | %-13s | %-14s | %-14s |\n" "ID" "Description" "Status" "Created At" "Updated At"
  printf "| %-3s | %-50s | %-13s | %-14s | %-14s |\n" "---" "--------------------------------------------------" "-------------" "--------------" "--------------"

  for ((i = 0; i < $count; i++)); do
    id=$(echo $listFilter | jq ".[$i].id")
    description=$(echo $listFilter | jq ".[$i].description")
    status=$(echo $listFilter | jq ".[$i].status")
    createdAt=$(echo $listFilter | jq ".[$i].createdAt")
    updateAt=$(echo $listFilter | jq ".[$i].updateAt")

    printf "| %-3s | %-50s | %-13s | %-14s | %-14s |\n" "$id" "$description" "$status" "$createdAt" "$updateAt"
    printf "| %-3s | %-50s | %-13s | %-14s | %-14s |\n" "---" "--------------------------------------------------" "-------------" "--------------" "--------------"
  done
  echo ""
}
