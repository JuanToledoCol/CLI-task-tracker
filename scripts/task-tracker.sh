#!/bin/bash
FILE_JSON="$HOME/projects/portfolio/CLI-task-tracker/data/task.json"
source ./list-task.sh

showHelp() {
  echo "Usage: $0 [flags]"
  echo ""
  echo "Available flags:"
  echo ""
  echo "    -ct, --create-task       Create a task by default with status 'todo'"
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
  -ct | --create-task)
    shift
    status=""
    description=""

    while [[ "$#" -gt 0 ]]; do
      case "$1" in
      -t)
        if [[ -n "$status" ]]; then
          echo "Error: Only one task status (-t, -i, or -d) can be specified."
          exit 1
        fi
        status="todo"
        ;;
      -i)
        if [[ -n "$status" ]]; then
          echo "Error: Only one task status (-t, -i, or -d) can be specified."
          exit 1
        fi
        status="in-progress"
        ;;
      -d)
        if [[ -n "$status" ]]; then
          echo "Error: Only one task status (-t, -i, or -d) can be specified."
          exit 1
        fi
        status="done"
        ;;
      -D | --description)
        shift
        description="$1"
        ;;
      *)
        echo "Invalid option: $1"
        showHelp
        exit 1
        ;;
      esac
      shift
    done

    if [[ -z "$status" ]]; then
      status="todo"
    fi

    if [[ -z "$description" ]]; then
      echo "Error: No task description provided. Use -D or --description followed by the task description."
      exit 1
    fi

    createTask "$status" "$description"
    exit 0
    ;;

  -ut | --update-task)
    shift
    id=""
    status=""
    description=""

    while [[ "$#" -gt 0 ]]; do
      case "$1" in
      -t)
        if [[ -n "$status" ]]; then
          echo "Error: Only one task status (-t, -i, or -d) can be specified."
          exit 1
        fi
        status="todo"
        ;;
      -i)
        if [[ -n "$status" ]]; then
          echo "Error: Only one task status (-t, -i, or -d) can be specified."
          exit 1
        fi
        status="in-progress"
        ;;
      -d)
        if [[ -n "$status" ]]; then
          echo "Error: Only one task status (-t, -i, or -d) can be specified."
          exit 1
        fi
        status="done"
        ;;
      -D | --description)
        shift
        description="$1"
        ;;
      -id)
        shift
        id="$1"
        ;;
      *)
        echo "Invalid option: $1"
        showHelp
        exit 1
        ;;
      esac
      shift
    done

    if [[ -z "$id" ]]; then
      echo "Error: No id task provided. Use -id followed by id task."
      exit 1
    fi

    if [[ -z "$status" && -z "$description" ]]; then
      echo "Error: No status or description task provided."
      echo ""
      echo "      Use -t, -i, or -d for specified the update status"
      echo "        OR"
      echo "      Use -D or --description followed by the task description."
      exit 1
    fi

    updateTask "$id" "$status" "$description"
    exit 0
    ;;

  -gt | --get-tasks)
    if [[ "$#" -gt 1 ]]; then

      case "$2" in
      -t | -i | -d)
        getTasksFilter "$2"
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

  -h | --help)
    showHelp
    exit 0
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
