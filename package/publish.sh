#!/bin/sh

mkdir tmp

# Append all the documentation into 1 file
cat docs/Introduction.md >> tmp/Readme.md
cat docs/UseCase1.md >> tmp/Readme.md
cat docs/UseCase2.md >> tmp/Readme.md

# Copy the required assets
cp dist/cjs/* tmp/
cp package/npm-package.json tmp/package.json

# Update the version defined in package.json to the tag version
version=${CIRCLE_TAG#"v"}
sed -i "s/1.0.0/${version}/g" tmp/package.json

# Log in to npm with a token
echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc

# Publish a folder to npm
npm publish tmp
