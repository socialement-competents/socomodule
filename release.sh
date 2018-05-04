#!/bin/sh

FILENAME="hackafront${CIRCLE_TAG}.zip"
# Add all files and folders, recursively, to $FILENAME 
zip -r ${FILENAME} *

# Make sure the release has already been created, otherwise create it
RELEASES_URL="https://api.github.com/repos/socialement-competents/hackafront/releases"
PAYLOAD='{"tag_name":"'${CIRCLE_TAG}'","target_commitish":"'${CIRCLE_BRANCH}'","name":"'${CIRCLE_TAG}'","draft":false,"prerelease":false}'
curl -i -X POST -H "Content-Type:application/json" -H "Authorization: token ${GITHUB_API_TOKEN}" ${RELEASES_URL} -d ${PAYLOAD}

# Get the assets upload URL and truncate the last weird part
UPLOAD_URL=$(curl -s "https://api.github.com/repos/socialement-competents/hackafront/releases/tags/${CIRCLE_TAG}" | jq -r '.upload_url' | cut -d{ -f1)
# Build the actual upload URL from it
LABEL="transpiled_files_to_serve_from_a_Web_Server"
ASSET_URL="${UPLOAD_URL}/assets?name=${FILENAME}&label=${LABEL}"
# Send the file as binary in the request body
curl -i -X POST -H "Content-Type:application/zip" -H "Authorization: token ${GITHUB_API_TOKEN}" ${ASSET_URL} --data-binary "@${FILENAME}"
