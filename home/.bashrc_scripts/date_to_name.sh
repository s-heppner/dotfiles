# !/bin/bash

# These are some temporary functions to bulk modify filenames with
# date(time)s. They are a temporary solution until I get smart enough
# to create these functions as a Rust CLI.

date_to_filename() {
    if [ "$#" -eq 0 ]; then
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
    if [ "$#" -eq 0 ]; then
        echo "Usage: datetime_to_filename <path or wildcard>"
        return 1
    fi

    for file in "$@"; do
        if [ -f "$file" ]; then
            mod_date=$(date -r "$file" +%Y-%m-%dT%H:%M)
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
