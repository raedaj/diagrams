#!/bin/bash

# Define the output README file
README_FILE="README.md"

# Create a new README header
echo "# System Integrations" > $README_FILE
echo "" >> $README_FILE

# Loop through all markdown files (excluding README.md) and add titles and links
for file in $(ls *.md | grep -v README.md); do
    # Generate a friendly name by replacing underscores with spaces and capitalizing
    friendly_name=$(echo "$file" | sed -r 's/[_-]/ /g' | sed -r 's/\b([a-z])/\u\1/g')

    # Add a section with the friendly name as a title and a link to the file
    echo "## [$friendly_name]($file)" >> $README_FILE
    echo "" >> $README_FILE
done

# Commit and push changes if there are any
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"
git remote set-url origin https://$GH_USERNAME:$GH_TOKEN@github.com/raedaj/integrations.git
git add $README_FILE
git commit -m "Auto-updated README.md based on other markdown files" || echo "No changes to commit"
git push
