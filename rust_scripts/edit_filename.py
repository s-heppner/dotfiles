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

class Operation(Enum):
    PREFIX = "prefix"
    SUFFIX = "suffix"
    REPLACE = "replace"

def list_files(pattern: str) -> List[str]:
    """
    Lists all files in the current working directory that match the given pattern.

    :param pattern: Filepath or wildcard pattern (e.g., '*.jpeg').
    :return: List of matching absolute file paths.
    """
    cwd = os.getcwd()  # Get the current working directory
    full_pattern = os.path.join(cwd, pattern)  # Combine cwd with the pattern
    return [os.path.abspath(file) for file in glob.glob(full_pattern)]

def check_for_conflicts(new_filenames: List[str]) -> bool:
    """
    Checks if any of the new filenames would conflict with existing files in the directory.

    :param new_filenames: List of new absolute filenames to check.
    :return: True if there are conflicts, False otherwise.
    """
    existing_files = set(os.path.abspath(os.path.join(os.getcwd(), f)) for f in os.listdir())
    return any(new_name in existing_files for new_name in new_filenames)

def prefix_filenames(prefix: str, filenames: List[str]) -> List[str]:
    """
    Prefixes a given string to the filenames, respecting ISO 8601 datetime timestamps.

    :param prefix: String to prefix to the filenames.
    :param filenames: List of absolute filenames to modify.
    :return: List of modified absolute filenames.
    """
    iso_regex = re.compile(r"^(.*/)?(\d{4}-\d{2}-\d{2}(?:T\d{2}:\d{2}:\d{2})?) (.+)$")
    prefixed_files = []

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

def replace_filename(new_name: str, filenames: List[str]) -> List[str]:
    """
    Replaces the main part of the filename with a new name, leaving the timestamp and extension intact, and ignoring content after " -- ".

    :param new_name: String to replace the main part of the filename.
    :param filenames: List of absolute filenames to modify.
    :return: List of modified absolute filenames.
    """
    iso_regex = re.compile(r"^(.*/)?(\d{4}-\d{2}-\d{2}(?:T\d{2}:\d{2}:\d{2})?) (.+?)(\.[^.]+)?$")
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

def main():
    parser = argparse.ArgumentParser(description="Edit filenames by adding a prefix, suffix, or replacing the main part of the name.")

    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("-p", "--prefix", action="store_true", help="Add a prefix to the filenames.")
    group.add_argument("-s", "--suffix", action="store_true", help="Add a suffix to the filenames.")
    group.add_argument("-r", "--replace", action="store_true", help="Replace the main part of the filenames.")

    parser.add_argument("modification", type=str, help="The string to use as the prefix, suffix, or replacement.")
    parser.add_argument("file_pattern", type=str, help="The file pattern to match (e.g., '*.jpeg').")

    args = parser.parse_args()

    if args.prefix:
        operation = Operation.PREFIX
    elif args.suffix:
        operation = Operation.SUFFIX
    elif args.replace:
        operation = Operation.REPLACE
    else:
        raise ValueError("Invalid operation specified.")

    matching_files = list_files(args.file_pattern)
    if not matching_files:
        print("No files matched the pattern.")
        return

    if operation == Operation.PREFIX:
        new_filenames = prefix_filenames(args.modification, matching_files)
    elif operation == Operation.SUFFIX:
        new_filenames = suffix_filenames(args.modification, matching_files)
    elif operation == Operation.REPLACE:
        new_filenames = replace_filename(args.modification, matching_files)

    if check_for_conflicts(new_filenames):
        print("Naming conflict detected. No files were renamed.")
        return

    # Perform the renaming
    for old_name, new_name in zip(matching_files, new_filenames):
        os.rename(old_name, new_name)

    print("Files renamed successfully.")

if __name__ == "__main__":
    main()
