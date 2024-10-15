# This file defines some practical functions for specifying the content 
# of a directory. 
# 
# Firstly, we assume we have content specification files with the name:
# `$CONTENT_SPECIFICATION_FILE_NAME`
# These file should consist of a first line, that is no longer than 
# `$CONTENT_SPECIFICATION_MAX_TITLE_LENGTH` (as it is used for 
# displaying in trees); and a content after an empty line, however long
# you want it to be.
# These files specify what the content of the directory they are in 
# should be. 
# 
# Now, you can use the following functions:
# - `c`: Display the title of the current content specification file
# - `ca`: Display the whole current content specification file
# - `ctree`: Display the tree of content specification files starting
#            at the current directory and listing all subdirectories.
#            Note: `ctree --all` also displays directories without 
#            content specification files.
# - `cm`: Modify the content specification file in the current directory


# Configuration
CONTENT_SPECIFICATION_FILE_NAME=".content.md"
CONTENT_SPECIFICATION_MAX_TITLE_LENGTH=52


# Alias defintion
alias c='print_first_line_of_spec_file'
alias ca='print_whole_spec_file'
alias ctree='content_specification_tree'
alias cm='modify_spec_file'


# Print the first line of the closest spec file
print_first_line_of_spec_file() {
    # Find the closest specification file
    local spec_file
    spec_file=$(find_closest_spec_file)
    check_content_spec_conformity "$spec_file"
    # Check if the spec file was found
    if [ $? -eq 0 ]; then
        # Print the first line of the file
        echo "$spec_file:"
        head -n 1 "$spec_file"
    else
    	echo "$spec_file"
    fi
}


# Print the whole content of the closest spec file
print_whole_spec_file() {
    # Find the closest specification file
    local spec_file
    spec_file=$(find_closest_spec_file)
    check_content_spec_conformity "$spec_file"
    # Check if the spec file was found
    if [ $? -eq 0 ]; then
        # Print the whole content of the file
        echo "$spec_file:"
        cat "$spec_file"
    else
    	echo "$spec_file"
    fi
}


# Print content specification tree, starting with the current directory
content_specification_tree() {
    # Check if --all option is provided
    local show_all=false
    if [ "$1" == "--all" ]; then
        show_all=true
    fi

    # Define a recursive function to explore each directory
    explore_directories() {
        local dir="$1"
        local indent="$2"
        local is_last="$3"
        # Get the basename of the current directory
        local dir_name
        dir_name=$(basename "$dir")
        # Check for the content specification file in the current directory
        local spec_file="$dir/$CONTENT_SPECIFICATION_FILE_NAME"
        local first_line
        # If the content specification file exists or --all option is provided
        if [ -f "$spec_file" ]; then
            # Get the first line of the content specification file
            first_line=$(head -n 1 "$spec_file")
            # Print directory name with the first line of the spec file
            if [ "$is_last" = true ]; then
                echo -e "${indent}└── $dir_name: ${COLOR_GOLD}$first_line${COLOR_RESET}"
            else
                echo -e "${indent}├── $dir_name: ${COLOR_GOLD}$first_line${COLOR_RESET}"
            fi
        elif [ "$show_all" = true ]; then
            # Print directory name with "NO $CONTENT_SPECIFICATION_FILE_NAME" message if --all is provided
            if [ "$is_last" = true ]; then
                echo -e "${indent}└── $dir_name: ${COLOR_RED}No $CONTENT_SPECIFICATION_FILE_NAME${COLOR_RESET}"
            else
                echo -e "${indent}├── $dir_name: ${COLOR_RED}No $CONTENT_SPECIFICATION_FILE_NAME${COLOR_RESET}"
            fi
        fi
        # Get a list of child directories
        local children=("$dir"/*/)
        local total_children=${#children[@]}
        # Explore child directories
        for ((i=0; i<total_children; i++)); do
            local child_dir="${children[i]}"
            if [ -d "$child_dir" ]; then
                # Determine if this is the last child directory to manage "└──" or "├──" correctly
                if [ $i -eq $((total_children - 1)) ]; then
                    explore_directories "$child_dir" "$indent    " true
                else
                    explore_directories "$child_dir" "$indent    " false
                fi
            fi
        done
    }

    # Start exploring from the current directory
    explore_directories "$PWD"
}


modify_spec_file() {
    # Check if CONTENT_SPECIFICATION_FILE_NAME is set
    if [ -z "$CONTENT_SPECIFICATION_FILE_NAME" ]; then
        echo "Error: CONTENT_SPECIFICATION_FILE_NAME is not set."
        return 1
    fi
    # Define the full path to the content specification file in the current directory
    local spec_file="./$CONTENT_SPECIFICATION_FILE_NAME"
    # Check if the file exists
    if [ -f "$spec_file" ]; then
        echo "Existing spec file: $spec_file"
    else
        # Create the file if it doesn't exist
        echo "New spec file: $spec_file"
        touch "$spec_file"
    fi
    # Open the file using nano
    nano "$spec_file"
}



# Check content specification file conformity
check_content_spec_conformity() {
    # Check if a filename is provided
    if [ -z "$1" ]; then
        echo "Error: No file provided."
        return 1
    fi
    # Ensure the file exists
    if [ ! -f "$1" ]; then
        echo "Error: File '$1' not found."
        return 1
    fi
    # Get the first line of the file
    local first_line
    first_line=$(head -n 1 "$1")
    # Check the length of the first line
    if [ ${#first_line} -lt $CONTENT_SPECIFICATION_MAX_TITLE_LENGTH ]; then
        return 0
    else
        echo "Warning: The first line of $1 is $CONTENT_SPECIFICATION_MAX_TITLE_LENGTH characters or more."
        return 1
    fi
}


# Find the closest content specification file
find_closest_spec_file() {
    # Ensure the CONTENT_SPECIFICATION_FILE_NAME variable is set
    if [ -z "$CONTENT_SPECIFICATION_FILE_NAME" ]; then
        echo "Error: CONTENT_SPECIFICATION_FILE_NAME is not set."
        return 1
    fi
    # Start searching from the current directory
    local dir="$PWD"
    # Traverse up through the parent directories
    while [ "$dir" != "/" ]; do
        if [ -f "$dir/$CONTENT_SPECIFICATION_FILE_NAME" ]; then
            # Return the path to the found file
            echo "$dir/$CONTENT_SPECIFICATION_FILE_NAME"
            return 0
        fi
        # Go to the parent directory
        dir=$(dirname "$dir")
    done
    # If no file is found, return an error
    echo "No $CONTENT_SPECIFICATION_FILE_NAME found in the current or any parent directories."
    return 1
}
