#!/bin/sh

if [ -z "$GITHUB_API_TOKEN" ]; then
  echo "Please add the GITHUB_API_TOKEN env var"
  exit 1
fi

if [ -z "$CIRCLE_TAG" || -z "$CIRCLE_BRANCH" ]; then
  echo "Run this script in Circle CI (or setup CIRCLE_TAG and CIRCLE_BRANCH manually to test)"
  exit 1
fi

ORG=socialement-competents
REPO=hackafront
RELEASES_URL=https://api.github.com/repos/${ORG}/${REPO}/releases

# Add all files and folders, recursively, to a tag-named .zip 
FILENAME="${REPO}-${CIRCLE_TAG}.zip"
zip -r ${FILENAME} *

# Make sure the release has already been created, otherwise create it
PAYLOAD='{"tag_name":"'${CIRCLE_TAG}'","target_commitish":"'${CIRCLE_BRANCH}'","name":"'${CIRCLE_TAG}'","draft":false,"prerelease":false}'
curl -i -s -X POST -H "Content-Type:application/json" -H "Authorization: token ${GITHUB_API_TOKEN}" ${RELEASES_URL} -d ${PAYLOAD}

# Get the assets upload URL and truncate the last weird part
UPLOAD_URL=$(curl -sS "${RELEASES_URL}/tags/${CIRCLE_TAG}" | jq -r '.upload_url' | cut -d{ -f1)
# Build the actual upload URL from it
ASSET_URL="${UPLOAD_URL}/assets?name=${FILENAME}"
# Send the file as binary in the request body
curl -i -X POST -H "Content-Type:application/zip" -H "Authorization: token ${GITHUB_API_TOKEN}" ${ASSET_URL} --data-binary "@${FILENAME}"
echo ""
