#!/bin/bash
FILE_JSON="$HOME/projects/portfolio/CLI-task-tracker/data/task.json"
source ./list-task.sh

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
}

if [[ "$#" -gt 0 ]]; then

  case "$1" in
  -h | --help)
    showHelp
    exit 0
    ;;
  -gt | --get-tasks)

    if [[ "$#" -gt 1 ]]; then

      case "$2" in
      -t | -i | -d)
        getTodoTasks "$2"
        exit 0
        ;;
      *)
        echo "Invalid filter option: $2"
        showHelp
        exit 1
        ;;
      esac
    else
      getAllTasks
    fi
    ;;

  *)

    echo "Invalid option: $1"
    showHelp
    exit 1
    ;;
  esac

else
  echo "No options provided."
  showHelp
  exit 1
fi