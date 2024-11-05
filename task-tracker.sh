#!/bin/bash

FILE_JSON="$HOME/projects/portfolio/task.json"

showHelp() {
  echo "Usage: $0 [flags]"
  echo ""
  echo "Available flags:"
  echo ""
  echo "    -gt, --get-tasks         Show all tasks saved in task.json."
  echo "                              You can add other flags like -d, -i, or -t to filter the response."
  echo "                              Example: $0 -gt -d  <- filter tasks with status 'done'."
  echo ""
  echo "    -t                        Filter the list by 'todo' status."
  echo "    -i                        Filter the list by 'in-progress' status."
  echo "    -d                        Filter the list by 'done' status."
  echo ""
  echo "    -h, --help               Show this help message."
  echo ""
  echo "Usage examples:"
  echo "    $0 -gt -t               <- Show tasks with 'todo' status."
  echo "    $0 -gt -i               <- Show tasks with 'in-progress' status."
  echo "    $0 -gt -d               <- Show tasks with 'done' status."
  echo ""
  echo "For more information, please refer to the README or documentation."
}

getAllTasks() {
  length_json=$(jq '. | length' $FILE_JSON)

  # Print all task
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
}

if [[ "$#" -gt 0 ]]; then
  case "$1" in
  -h | --help) showHelp ;;
  -gt | --get-tasks) getAllTasks ;;
  esac
else
  echo "Need pass arguments. See --help form more information about options."
fi
