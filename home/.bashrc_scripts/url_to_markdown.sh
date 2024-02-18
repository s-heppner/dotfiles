# This script will take an url inside the clipboard
# and create a markdown link from it.
#
# Note: This requires `xclip`
# Install on WSL via `sudo apt install xclip`
# 
# At the moment, the following links are supported:
# 
# GitHub Project
# From: https://github.com/eclipse-basyx/basyx-python-sdk
# To: [eclipse-basyx/basyx-python-sdk](https://github.com/eclipse-basyx/basyx-python-sdk)
#
# GitHub Issue/PR
# From: https://github.com/eclipse-basyx/basyx-python-sdk/issues/235
# To: [eclipse-basyx/basyx-python-sdk#235](https://github.com/eclipse-basyx/basyx-python-sdk/issues/235)

url_to_markdown() {
    # Get the clipboard content
    clipboard=$(xclip -selection clipboard -o)

    # Check if the clipboard content is a GitHub issue or PR link
    if echo "$clipboard" | grep -Eq 'github\.com/[^/]+/[^/]+/(issues|pull)/[0-9]+'; then
        # Extract repository and issue number using sed
        repo=$(echo "$clipboard" | sed -E 's/.*github\.com\/([^\/]+\/[^\/]+)\/(issues|pull)\/[0-9]+.*/\1/')
        issue_number=$(echo "$clipboard" | sed -E 's/.*github\.com\/[^\/]+\/[^\/]+\/(issues|pull)\/([0-9]+).*/\2/')

        # Generate Markdown link
        markdown_link="[$repo#$issue_number]($clipboard)"
        
        # Put the Markdown link into clipboard
        echo -n "$markdown_link" | xclip -selection clipboard

        echo "Markdown link copied to clipboard:"
        echo "$markdown_link"
    elif echo "$clipboard" | grep -Eq 'github\.com/[^/]+/[^/]+$'; then
        # Extract repository using sed
        repo=$(echo "$clipboard" | sed -E 's|.*/([^/]+/[^/]+)$|\1|')

        # Generate Markdown link
        markdown_link="[$repo]($clipboard)"
        
        # Put the Markdown link into clipboard
        echo -n "$markdown_link" | xclip -selection clipboard

        echo "Markdown link copied to clipboard:"
        echo "$markdown_link"
    else
        echo "No suiting URL found in clipboard."
    fi

}

alias md="url_to_markdown"
