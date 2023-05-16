#!/usr/bin/env python3
"""
Deletes all local git branches on the current repository that are older than a specified number of days or start with at least 5 numbers followed by a dash.

default 7 days
"""
import subprocess
import datetime
import re
import textwrap

# Set the threshold for branch age (in days)
age_threshold = 7

# Regular expression to match branches starting with at least 5 numbers followed by a dash
branch_pattern = re.compile(r'^\d{5,}-.*')

# Get the current date and time
now = datetime.datetime.now()

# Create an ASCII banner
banner_width = 60
title = f'Git Hygiene: Expunging Stale (older than {age_threshold} days) and Numeric-Tagged Branches (ppr)'
banner = '*' * banner_width
print(banner)
print(textwrap.fill(title, width=banner_width, initial_indent=' ', subsequent_indent=' ').center(banner_width))
print(banner)

# Get a list of all local branches
branches = subprocess.check_output(['git', 'branch']).decode('utf-8').split('\n')

# Loop through the branches and delete those that are older than the threshold or match the pattern
for branch in branches:
    if not branch or "->" in branch or branch.strip().startswith('*'):
        continue
    # Strip the branch name and check its age
    branch_name = branch.strip()
    branch_age_cmd = f"git log -1 --format=%ct {branch_name}"
    try:
        branch_age = int(subprocess.check_output(branch_age_cmd, shell=True))
        age_in_days = (now - datetime.datetime.fromtimestamp(branch_age)).days
        if age_in_days > age_threshold or branch_pattern.match(branch_name):
            # Ask for confirmation before deleting the branch
            confirmation = input(f"Are you sure you want to delete the branch '{branch_name}'? It is {age_in_days} days old. (yes/no): ")
            if confirmation.lower() == 'yes':
                # Delete the branch
                delete_cmd = f"git branch -D {branch_name}"
                subprocess.run(delete_cmd, shell=True)
    except subprocess.CalledProcessError:
        print(f"Failed to get the age for branch: {branch_name}")
