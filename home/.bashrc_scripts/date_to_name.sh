# !/bin/bash

# These are some temporary functions to bulk modify filenames with
# date(time)s. They are a temporary solution until I get smart enough
# to create these functions as a Rust CLI.

date_to_filename() {
    if [ "$#" -eq 0 ]; then
        echo "Adds an isoformat date to the specified file(s) based on their last modification."
        echo "Format: YYYY-mm-dd"
        echo "Usage: date_to_filename <path or wildcard>"
        return 1
    fi

    for file in "$@"; do
        if [ -f "$file" ]; then
            mod_date=$(date -r "$file" +%Y-%m-%d)
            dir=$(dirname "$file")
            base=$(basename "$file")
            mv "$file" "$dir/$mod_date $base"
        else
            echo "Skipping: $file is not a file"
        fi
    done
}



datetime_to_filename() {
    # (2025-04-03, s-heppner)
    # I decided to remove the colons (:) between the hour, minute and 
    # seconds of the ISO-8601 format. While this is not exactly 
    # standard-conform, it is the only way the filenames are valid on 
    # Windows machines, which I sadly cannot get around fully at this moment.
    if [ "$#" -eq 0 ]; then
        echo "Adds an isoformat datetime to the specified file(s) based on their last modification."
        echo "Format: YYYY-mm-ddTHHMMSS"
        echo "Usage: datetime_to_filename <path or wildcard>"
        return 1
    fi

    for file in "$@"; do
        if [ -f "$file" ]; then
            mod_date=$(date -r "$file" +%Y-%m-%dT%H%M%S)
            dir=$(dirname "$file")
            base=$(basename "$file")
            mv "$file" "$dir/$mod_date $base"
        else
            echo "Skipping: $file is not a file"
        fi
    done
}


replace_filename_with_datetime() {
    if [ "$#" -eq 0 ]; then
        echo "Usage: replace_filename_with_datetime <path or wildcard>"
        return 1
    fi

    for file in "$@"; do
        if [ -f "$file" ]; then
            mod_date=$(date -r "$file" +%Y-%m-%dT%H:%M:%S)
            dir=$(dirname "$file")
            ext=".${file##*.}"
            new_file="$dir/$mod_date$ext"
            if [ -e "$new_file" ]; then
                echo "Error: $new_file already exists. Aborting to prevent overwriting."
                return 1
            fi
            mv "$file" "$new_file"
        else
            echo "Skipping: $file is not a file"
        fi
    done
}
