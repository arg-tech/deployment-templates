#!/bin/bash

# Note: if using this, set PRs to rebase instead of merge in the destination repository settings. 
# Otherwise, the 'Check if main branch is up to date' check will fail.

# 1. Create empty destination repository within arg-tech
# 2. Specify the source and destination repositories in the SOURCE_REPO and DESTINATION_REPO variables
# 3. After running the script, create a new main branch in the destination repository
# 4. Add the .github deployment config to the source repository
# 5. Run the script again
# 6. Open a pull request from the deploy branch to the main branch in the destination repository
# 7. To update code, repeat 5 and 6

set -e

SOURCE_REPO=""
SOURCE_BRANCH="main"
DESTINATION_REPO=""
DESTINATION_BRANCH="deploy"

echo "Deleting leftover files in case last run was interrupted..."
rm -rf source-repo-bare.git

echo "Cloning source repository..."
git clone --bare "$SOURCE_REPO" source-repo-bare.git
cd source-repo-bare.git

echo "Adding destination as a remote..."
git remote add destination "$DESTINATION_REPO"

echo "Fetching all branches from source..."
git fetch origin

echo "Renaming source to destination branch..."
git branch -m "$SOURCE_BRANCH" "$DESTINATION_BRANCH"

echo "Pushing to destination..."
git push destination "$DESTINATION_BRANCH"

echo "Deleting leftover files"
cd .. && rm -rf source-repo-bare.git

echo "Done"
