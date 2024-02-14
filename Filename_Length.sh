#!/bin/bash

# Set the default search directory to the directory of the script
search_directory="$(dirname "$(readlink -f "$0")")"

# Check the number of parameters
if [ $# -eq 0 ]; then
    # If no parameters are provided, interactively ask for the path and minimum length
    read -p "Enter the search directory: " search_directory
    read -p "Enter the minimum length: " min_length
elif [ $# -eq 1 ]; then
    # If only one parameter is provided, check if it's a directory or a number
    if [ -d "$1" ]; then
        # If it's a directory, use it as the search directory and interactively ask for the minimum length
        search_directory="$1"
        read -p "Enter the minimum length: " min_length
    else
        # If it's a number, use it as the minimum length and use the default search directory
        min_length="$1"
    fi
elif [ $# -eq 2 ]; then
    # If two parameters are provided, assume the first is the directory and the second is the minimum length
    search_directory="$1"
    min_length="$2"
else
    echo "Usage: $0 [<directory>] <min_length>"
    exit 1
fi

# Check if the provided path is a valid directory
if [ ! -d "$search_directory" ]; then
    echo "Error: '$search_directory' is not a valid directory."
    exit 1
fi

# Display the folder path in square brackets followed by a colon
echo "[\"$search_directory\"] :"

# List all files (not directories) recursively in the specified directory
find "$search_directory" -type f | while read -r file; do
    # Get the length of the filename
    filename_length=$(echo -n "$file" | wc -c)

    # Check if the filename length is greater than the specified minimum length
    if [ "$filename_length" -gt "$min_length" ]; then
        # Extract the title of the file
        file_title=$(basename "$file")

        # Print the formatted output
        echo "$filename_length <:> $file_title"
    fi
done
