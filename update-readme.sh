#!/bin/bash

# Define the output README file
README_FILE="README.md"

# Create a new README header
echo "# Project Documentation" > $README_FILE
echo "" >> $README_FILE

# Loop through all markdown files (excluding README.md) and append them
for file in $(ls *.md | grep -v README.md); do
    echo "## $(basename "$file" .md)" >> $README_FILE
    echo "" >> $README_FILE
    cat "$file" >> $README_FILE
    echo "" >> $README_FILE
done

# Commit and push changes if there are any
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"
git add $README_FILE
git commit -m "Auto-updated README.md based on other markdown files" || echo "No changes to commit"
git push
