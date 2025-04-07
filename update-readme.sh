#!/bin/bash

# Define the output README file
README_FILE="README.md"

# Create a new README header
echo "# System Integrations" > $README_FILE
echo "" >> $README_FILE

# Loop through all markdown files under the docs folder (excluding README.md)
# Group the files by their subdirectories
for dir in $(find docs -type d); do
    # Get a friendly folder name for the subsection header
    folder_name=$(basename "$dir" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')  # Make it more human-readable (capitalize, replace hyphens)
    
    # Skip the 'docs' folder itself and other directories that are empty
    if [[ "$dir" != "docs" && $(find "$dir" -name '*.md' | wc -l) -gt 0 ]]; then
        # Create a section for the directory (folder) in the README file
        echo "## $folder_name" >> $README_FILE
        echo "" >> $README_FILE

        # Loop through all markdown files in the current directory (excluding README.md)
        for file in $(find "$dir" -name '*.md' | grep -v 'README.md'); do
            # Extract the first line (title) from the markdown file
            title=$(head -n 1 "$file" | sed 's/^# //')

            # Add the title and link to the README file
            echo "[$title]($file)" >> $README_FILE
            echo "" >> $README_FILE
        done
    fi
done  # Closing the main for loop here

# Always fetch and update the PunchOut Reference Implementations section
# Remove the existing "PunchOut Reference Implementations" section and its content if it exists
sed -i '/## PunchOut Reference Implementations/,$d' "$README_FILE"

# Add the PunchOut Reference Implementations section and update it
echo "## PunchOut Reference Implementations" >> $README_FILE
echo "" >> $README_FILE

# Fetch private repositories and filter them by the description for "PunchOut"
gh repo list "$ORG_NAME" --private --limit 100 --json name,description,language \
  --jq ".[] | select(.language == \"C#\" and (.description // \"\" | test(\"PunchOut\"; \"i\"))) |
    \"- [\\(.name)](https://github.com/$ORG_NAME/\\(.name)): \\(.description)\"" >> $README_FILE

# Commit and push changes if there are any
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"
git remote set-url origin https://$GH_USERNAME:$GH_TOKEN@github.com/raedaj/integrations.git
git add $README_FILE
git commit -m "Auto-updated README.md based on other markdown files" || echo "No changes to commit"
git push
