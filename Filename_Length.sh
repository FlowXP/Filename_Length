#!/bin/bash

# Get the absolute path of the script's directory
script_directory=$(realpath "$(dirname "$0")")

# Set the default search directory to the script's directory
search_directory="$script_directory"

# Check the number of parameters
if [ $# -eq 2 ]; then
    # If two parameters are provided, assume the first is the directory and the second is the minimum length
    search_directory="$1"
    min_length="$2"
elif [ $# -eq 1 ]; then
    # If one parameter is provided, check if it's a directory or a number
    if [ -d "$1" ]; then
        # If it's a directory, use it as the search directory and interactively ask for the minimum length
        search_directory="$1"
        read -p "Enter the minimum length: " min_length
    else
        # If it's a number, use it as the minimum length and use the default search directory
        min_length="$1"
        read -p "Enter the search directory: " search_directory
    fi
elif [ $# -eq 0 ]; then
    # If no parameters are provided, interactively ask for the folder and minimum length
    read -p "Enter the search directory: " search_directory
    read -p "Enter the minimum length: " min_length
else
    echo "Usage: $0 [<directory>] <min_length>"
    exit 1
fi

# Display header
echo "Here are the files with longer titlenames than $min_length :"

# Group files by folder and list all files (not directories) recursively in the specified directory
find "$search_directory" -type f | sort | while read -r file; do
    # Extract the title of the file (filename without path)
    file_title=$(basename "$file")

    # Get the length of the filename
    filename_length=$(echo -n "$file_title" | wc -c)

    # Check if the filename length is greater than the specified minimum length
    if [ "$filename_length" -gt "$min_length" ]; then
        # Get the relative path from the script's directory
        relative_path=$(realpath --relative-to="$script_directory" "$(dirname "$file")")

        # Print the folder name if it hasn't been printed yet
        if [ "$relative_path" != "$current_folder" ]; then
            echo ">>> $relative_path :"
            current_folder="$relative_path"
        fi

        # Print the formatted output
        echo "$filename_length <:> $file_title"
    fi
done
