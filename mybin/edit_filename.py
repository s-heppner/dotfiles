#!/usr/bin/env python3

"""
A (temporary) Python utility for modifying filenames in bulk.
You can add prefixes, suffixes, or replace specific parts of filenames while preserving
key patterns like timestamps or tags.

Usage:
edit_filename.py {-p|--prefix, -s|--suffix, -r|--replace} modification file_pattern
"""

import os
import glob
import re
from typing import List
from enum import Enum
import argparse
import tempfile
import subprocess
import difflib


# ANSI color codes
GREEN = "\033[32m"
RED = "\033[31m"
YELLOW = "\033[33m"
RESET = "\033[0m"


class Operation(Enum):
    PREFIX = "prefix"
    SUFFIX = "suffix"
    REPLACE = "replace"
    EDIT = "edit"


def list_files(patterns: List[str]) -> List[str]:
    """
    Lists all files in the current working directory that match any of the given patterns.

    :param patterns: List of filepath or wildcard patterns (e.g., ['*.jpeg', 'file1.txt']).
    :return: List of matching absolute file paths.
    """
    cwd = os.getcwd()  # Get the current working directory
    matched_files = []
    for pattern in patterns:
        full_pattern = os.path.join(cwd, pattern)  # Combine cwd with the pattern
        matched_files.extend([os.path.abspath(file) for file in glob.glob(full_pattern)])
    return matched_files


def check_for_conflicts(new_filenames: List[str]) -> bool:
    """
    Checks if any of the new filenames conflict with existing files in the current directory.

    :param new_filenames: List of new absolute filenames to check.
    :return: True if there are conflicts, False otherwise.
    """
    # Get absolute paths of all files in the current directory
    existing_files = {os.path.abspath(f) for f in os.listdir()}

    # Check if any of the new filenames would collide with any other new filename
    if len(new_filenames) != len(set(new_filenames)):
        print(f"Naming Conflict: At least 2 files would be renamed to the same name.")
        return True

    # Check if any of the new filenames already exist
    # Todo: Note that this creates a problem in the interactive mode, if we do not change the line.
    for new_name in new_filenames:
        if new_name in existing_files:
            print(f"Naming Conflict: '{new_name}' is already existing in the directory and would be overwritten.")
            return True  # Conflict found
    return False  # No conflicts


def prefix_filenames(prefix: str, filenames: List[str]) -> List[str]:
    """
    Prefixes a given string to the filenames, respecting ISO 8601 datetime timestamps.

    :param prefix: String to prefix to the filenames.
    :param filenames: List of absolute filenames to modify.
    :return: List of modified absolute filenames.
    """
    prefixed_files = []

    # (2025-04-03, s-heppner)
    # We expect either: `YYYY-mm-dd` or `YYYY-mm-ddTHHMMSS` as ISO-8601 format
    # I know this is not exactly standard, but it's the best we can do with Windows file systems.
    iso_regex = re.compile(r"^(.*/)?(\d{4}-\d{2}-\d{2}(?:T\d{6})?) (.+)$")

    for filename in filenames:
        dir_name, base_name = os.path.split(filename)
        match = iso_regex.match(base_name)
        if match:
            _, timestamp, rest = match.groups()
            new_name = os.path.join(dir_name, f"{timestamp} {prefix}{rest}")
        else:
            new_name = os.path.join(dir_name, f"{prefix}{base_name}")

        prefixed_files.append(new_name)

    return prefixed_files


def suffix_filenames(suffix: str, filenames: List[str]) -> List[str]:
    """
    Suffixes a given string to the filenames, adding it before the file extension and ignoring content after " -- ".

    :param suffix: String to suffix to the filenames.
    :param filenames: List of absolute filenames to modify.
    :return: List of modified absolute filenames.
    """
    suffixed_files = []

    for filename in filenames:
        dir_name, base_name = os.path.split(filename)
        name, sep, ignore = base_name.partition(" -- ")
        if "." in name:
            name, ext = name.rsplit(".", 1)
            new_name = os.path.join(dir_name, f"{name}{suffix}.{ext}")
        else:
            new_name = os.path.join(dir_name, f"{name}{suffix}")

        suffixed_files.append(new_name + (" -- " + ignore if sep else ""))

    return suffixed_files


def edit_interactively(filenames: List[str]) -> List[str]:
    """
    Open a temporary file in `nano` to allow interactive editing of filenames.

    This function creates a temporary file where each filename (without its path) is written on a new line.
    It appends a help text as comments at the end of the file. The file is opened in `nano`
    for editing, and the user can modify the filenames interactively. After editing, the
    function reads the file, ignores lines starting with `#` (comments), and returns the
    modified list of filenames with their original absolute paths restored. If no changes are
    made, the original list of filenames is returned.

    Todo: Lines with no changes after saving should be removed from the list of filenames

    Parameters:
        filenames (List[str]): A list of absolute path filenames to edit.

    Returns:
        List[str]: A list of modified filenames with their absolute paths.

    Notes:
        - The temporary file is deleted after the editing process.
        - If the user makes no changes, the original filenames are returned.
    """
    help_text = """
# Edit the filenames below. Each filename is on a new line.
# Lines starting with '#' are ignored.
# Save and close the file when done. If no changes are made, the original filenames will be kept.
    """

    # Extract only the base filenames (without paths)
    base_filenames = [os.path.basename(filename) for filename in filenames]

    with tempfile.NamedTemporaryFile(mode="w+", delete=False) as temp_file:
        temp_filename = temp_file.name

        # Write the base filenames and help text to the temporary file
        temp_file.write("\n".join(base_filenames) + "\n")
        temp_file.write(help_text)

    try:
        # Open the temporary file in nano
        subprocess.run(["nano", temp_filename], check=True)

        # Read the file after editing
        with open(temp_filename, "r") as temp_file:
            edited_lines = temp_file.readlines()

        # Filter out comments and whitespace lines
        edited_base_filenames = [line.strip() for line in edited_lines if line.strip() and not line.startswith("#")]

        # Check if filenames were modified
        if edited_base_filenames == base_filenames:
            print("No changes were made to the filenames.")
            return filenames

        # Restore the absolute paths to the edited filenames
        new_filenames = [os.path.join(os.path.dirname(original), edited)
                         for original, edited in zip(filenames, edited_base_filenames)]

        return new_filenames

    finally:
        # Clean up the temporary file
        os.remove(temp_filename)


def replace_filename(new_name: str, filenames: List[str]) -> List[str]:
    """
    Replaces the main part of the filename with a new name, leaving the timestamp and extension intact, and ignoring content after " -- ".

    :param new_name: String to replace the main part of the filename.
    :param filenames: List of absolute filenames to modify.
    :return: List of modified absolute filenames.
    """
    iso_regex = re.compile(r"^(.*/)?(\d{4}-\d{2}-\d{2}(?:T\d{6})?) (.+?)(\.[^.]+)?$")
    replaced_files = []

    for filename in filenames:
        dir_name, base_name = os.path.split(filename)
        base_name, sep, ignore = base_name.partition(" -- ")
        match = iso_regex.match(base_name)
        if match:
            _, timestamp, _, ext = match.groups()
            ext = ext or ""  # Handle cases without an extension
            new_filename = os.path.join(dir_name, f"{timestamp} {new_name}{ext}")
        else:
            name, ext = os.path.splitext(base_name)
            new_filename = os.path.join(dir_name, f"{new_name}{ext}")

        replaced_files.append(new_filename + (" -- " + ignore if sep else ""))

    return replaced_files


def show_inline_diff(old_names, new_names):
    """
    Show a git-style inline diff between a list of old names and new names

    :param old_names: String to replace the main part of the filename.
    :param new_names: List of absolute filenames to modify.
    """
    for old_full, new_full in zip(old_names, new_names):
        old = os.path.basename(old_full)
        new = os.path.basename(new_full)
        if old == new:
            print(f"  {old}")  # unchanged, no color
            continue

        diff = difflib.SequenceMatcher(None, old, new)
        line = ""
        # This checks, if the strings are totally different words and then prints them as replaced rather than
        # doing a character based diff. Else, we do a character based diff. The limit ratio itself is chosen at random.
        print(diff.ratio())
        if diff.ratio() < 0.55:
            line += f"{RED}{old}{RESET}{GREEN}{new}{RESET}"
        else:
            for opcode, a0, a1, b0, b1 in diff.get_opcodes():
                if opcode == "equal":
                    line += old[a0:a1]
                elif opcode == "delete":
                    line += f"{RED}{old[a0:a1]}{RESET}"
                elif opcode == "insert":
                    line += f"{GREEN}{new[b0:b1]}{RESET}"
                elif opcode == "replace":
                    line += f"{RED}{old[a0:a1]}{RESET}{GREEN}{new[b0:b1]}{RESET}"
        print(line)


def main():
    parser = argparse.ArgumentParser(
        description="Edit filenames by adding a prefix, suffix, or replacing the main part of the name."
    )

    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("-p", "--prefix", action="store_true", help="Add a prefix to the filenames.")
    group.add_argument("-s", "--suffix", action="store_true", help="Add a suffix to the filenames.")
    group.add_argument("-r", "--replace", action="store_true", help="Replace the main part of the filenames.")
    group.add_argument("-e", "--edit", action="store_true", help="Edit the filenames interactively.")

    parser.add_argument("modification", type=str, help="The string to use as the prefix, suffix, or replacement.")
    parser.add_argument(
        "file_patterns",
        nargs="+",
        help="The file patterns to match (e.g., '*.jpeg', 'file1.txt', 'file2.doc'). "
             "This argument should always be in quotation marks!"
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Skip confirmation and rename without prompting."
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be renamed, but do not perform changes."
    )

    args = parser.parse_args()

    if args.prefix:
        operation = Operation.PREFIX
    elif args.suffix:
        operation = Operation.SUFFIX
    elif args.replace:
        operation = Operation.REPLACE
    elif args.edit:
        operation = Operation.EDIT
    else:
        raise ValueError("Invalid operation specified.")

    # Expand file patterns into a list of files
    if isinstance(args.file_patterns, str):
        patterns: List[str] = [args.file_patterns]
    else:
        patterns = args.file_patterns
    matching_files: List[str] = list_files(patterns)
    if not matching_files:
        print("No files matched the pattern.")
        return

    if operation == Operation.PREFIX:
        new_filenames = prefix_filenames(args.modification, matching_files)
    elif operation == Operation.SUFFIX:
        new_filenames = suffix_filenames(args.modification, matching_files)
    elif operation == Operation.REPLACE:
        new_filenames = replace_filename(args.modification, matching_files)
    elif operation == Operation.EDIT:
        new_filenames = edit_interactively(matching_files)
    else:
        raise KeyError(f"Invalid Operation '{operation}'.")

    # Unless we defined the `--force` option, we display a diff and check for conflicts before performing the renaming.
    if not args.force:
        print("\nRename preview:")
        show_inline_diff(matching_files, new_filenames)

        if check_for_conflicts(new_filenames):
            print("No files were renamed.")
            return

        while True:
            answer = input("Do you want to continue [y/n]? ").strip().lower()
            if answer in {"y", "yes"}:
                break
            elif answer in {"n", "no"}:
                print("No files were renamed.")
                return
            else:
                continue

    if args.dry_run:
        print("Dry run: No files were renamed.")
        return

    # Perform the renaming
    for old_name, new_name in zip(matching_files, new_filenames):
        os.rename(old_name, new_name)

    print(f"Renamed {len(new_filenames)} file(s).")

if __name__ == "__main__":
    main()
