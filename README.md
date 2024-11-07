# Task Tracker

Sample solution for the task-tracker challenge from [roadmap.sh](https://roadmap.sh/projects/task-tracker).

---

## How to Run

This script is currently tested and verified only on Linux Debian 12.

To install and run the project, clone the repository and follow the steps below:

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/JuanToledoCol/CLI-task-tracker.git
    cd CLI-task-tracker/bin
    ```

2. **Make the Script Accessible from Anywhere:**

    If you want to be able to run the script from any location, you need to add its path to your system’s PATH. You can do this by adding the following line to your `.bashrc` or `.zshrc` file:

    ```bash
    export PATH="$PATH:/path/of/folder/with/task/Tracker"
    ```

    Then reload your shell configuration:

    ```bash
    source ~/.bashrc    # for Bash users
    source ~/.zshrc     # for Zsh users
    ```
3. **Make the Script Executable:**

   Before running the script, you'll need to make it executable. Run the following command:

    ```bash
    chmod +x bin/task-tracker
    ```
---

## Usage

### Add a Task

To add a new task with a specified status and description:

```bash
task-tracker create -t -D "Buy groceries"
```

Options:

- `-t` for `todo` status (default).
- `-i` for `in-progress` status.
- `-d` for `done` status.
- `-D` or `--description` followed by the task description (required).

### Update a Task

To update an existing task’s status and/or description:

```bash
task-tracker update -id 6 -i -D "Visit the dentist on Friday"
```

Options:

- `-id` followed by the task ID (required).
- `-D` or `--description` followed by the task description (optional).
- `-t` for change status to `todo`.
- `-i` for change status to `in-progress`.
- `-d` for change status to `done`.

### Delete a Task

To delete an existing task by its ID:

```bash
task-tracker delete -id 6
```
Option:

- `-id` followed by the task ID (required).

### List All Task

To list all tasks, or filter them by status:

```bash
task-tracker list            # List all task
task-tracker list -t         # List tasks with status 'todo'
task-tracker list -i         # List tasks with status 'in-progress'
task-tracker list -d         # List tasks with status 'done'
```

### Help

To view a help message with all available commands and options:

```bash
task-tracker -h
```

---

## Thank You!
If you found this project helpful, please consider giving it a ⭐ on [GitHub](https://github.com/JuanToledoCol/CLI-task-tracker.git).
Your support motivates me and helps me know that I'm on the right track. Thank you!
