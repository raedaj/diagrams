#!/bin/bash

# Define the output README file
README_FILE="README.md"

# Create a new README header
echo "# System Integrations" > $README_FILE
echo "" >> $README_FILE

# Loop through all markdown files (excluding README.md) and add titles and links
for file in $(ls *.md | grep -v README.md); do
    # Extract the first line (title) from the markdown file
    title=$(head -n 1 "$file" | sed 's/^# //')

    # Add title and link to the README file
    echo "## [$title]($file)" >> $README_FILE
    echo "" >> $README_FILE
done

# Commit and push changes if there are any
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"
git remote set-url origin https://$GH_USERNAME:$GH_TOKEN@github.com/raedaj/integrations.git
git add $README_FILE
git commit -m "Auto-updated README.md based on other markdown files" || echo "No changes to commit"
git push
