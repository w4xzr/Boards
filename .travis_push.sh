#!/bin/sh

setup_git() {
  git config --global user.email "noreply@w4xzr.xyz" > /dev/null 2>&1
  git config --global user.name "PCB Image Exporter" > /dev/null 2>&1
}

commit() {
  git checkout master > /dev/null 2>&1
  # Current month and year, e.g: Apr 2018
  dateAndMonth=`date`
  # Stage the modified files in dist/output
  git add . > /dev/null 2>&1
  # Create a new commit with a custom build message
  # with "[skip ci]" to avoid a build loop
  # and Travis build number for reference
  git commit -m "Updated Gerbers: $dateAndMonth (Build $TRAVIS_BUILD_NUMBER)" -m "[skip ci]" > /dev/null 2>&1
}

upload_files() {
  # Remove existing "origin"
  git remote rm origin
  # Add new "origin" with access token in the git URL for authentication
  git remote add origin https://thomasb9511:${GH_TOKEN}@github.com/thomasb9511/Boards.git > /dev/null 2>&1
  git push origin master --quiet > /dev/null 2>&1
}

setup_git

commit

# Attempt to commit to git only if "git commit" succeeded
if [ $? -eq 0 ]; then
  echo "A new commit with New/Updated Gerbers. Uploading to GitHub"
  upload_files
else
  echo "No changes in  Gerbers. Nothing to do"
fi
