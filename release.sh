#!/bin/sh

# Add all files and folders, recursively, to a tag-named .zip 
FILENAME="$CIRCLE_PROJECT_REPONAME-$CIRCLE_TAG.zip"
zip -r $FILENAME *

# Download the github-release executable
GITHUB_RELEASE_GO=https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2
curl -sL $GITHUB_RELEASE_GO | tar xvjf -
GR=bin/linux/amd64/github-release
chmod +x $GR

# Create a GitHub release
$GR release \
  --user $CIRCLE_PROJECT_USERNAME \
  --repo $CIRCLE_PROJECT_REPONAME \
  --tag $CIRCLE_TAG \
  --name $CIRCLE_TAG

# Upload the .zip to the release as an asset
$GR upload \
  --user $CIRCLE_PROJECT_USERNAME \
  --repo $CIRCLE_PROJECT_REPONAME \
  --tag $CIRCLE_TAG \
  --name $FILENAME \
  --file $FILENAME
