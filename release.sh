#!/bin/sh

# Download the github-release executable
GITHUB_RELEASE_GO=https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2
GR=${PWD}/$(curl -sL $GITHUB_RELEASE_GO | tar xvjf -)
chmod +x $GR

# Create a GitHub release
$GR release \
  --user $CIRCLE_PROJECT_USERNAME \
  --repo $CIRCLE_PROJECT_REPONAME \
  --tag $CIRCLE_TAG \
  --name $CIRCLE_TAG

# Add all files and folders, recursively, to a tag-named .zip
cd umd
UMD_FILENAME="$CIRCLE_PROJECT_REPONAME-umd-$CIRCLE_TAG.zip"
zip -r $UMD_FILENAME *

# Upload the umd .zip to the release as an asset
$GR upload \
  --user $CIRCLE_PROJECT_USERNAME \
  --repo $CIRCLE_PROJECT_REPONAME \
  --tag $CIRCLE_TAG \
  --name $UMD_FILENAME \
  --file $UMD_FILENAME

cd ../cjs
CJS_FILENAME="$CIRCLE_PROJECT_REPONAME-cjs-$CIRCLE_TAG.zip"
zip -r $CJS_FILENAME *

# Upload the cjs .zip to the release as an asset
$GR upload \
  --user $CIRCLE_PROJECT_USERNAME \
  --repo $CIRCLE_PROJECT_REPONAME \
  --tag $CIRCLE_TAG \
  --name $CJS_FILENAME \
  --file $CJS_FILENAME
