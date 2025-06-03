# This file contains upgrade function shortcuts that I commonly use 

upgrade() {
    # This function calls all package managers commonly used (by me)
    # and updates them

    # Please note, that there are sudo calls inside this function
    echo "Update system files"
    # Check if apt exists
    if command -v apt &> /dev/null; then
        echo "Using APT package manager"
        sudo apt update && apt list --upgradable
        sudo apt upgrade
    # Check if dnf exists
    elif command -v dnf &> /dev/null; then
        echo "Using DNF package manager is currently not supported"
        echo "Please upgrade manually"
        # (2024-02-08, s-heppner)
        # sudo dnf upgrade does not work when being called from inside
        # the .bashrc for whatever reason
    # If neither apt nor dnf is found
    else
        echo "Neither APT nor DNF package manager found."
        exit 1
    fi

    echo "Update snap"
    if command -v snap &> /dev/null; then
        sudo snap refresh
    else
        echo "Snap package manager not found."
    fi

    echo "Update flatpak"
    if command -v flatpak &> /dev/null; then
        sudo flatpak update -y
    else
        echo "Flatpak package manager not found."
    fi
}

docker_compose_update() {
    # This function rebuilds and updates the containers in a 
	# Docker `compose.yaml`. 
	# Note: User needs to be part of the `docker` group.
	docker compose build --no-cache --pull
	docker compose pull
	docker compose up -d
}
