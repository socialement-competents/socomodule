#!/bin/sh

mkdir tmp

cat docs/Introduction.md >> tmp/Readme.md
cat docs/UseCase1.md >> tmp/Readme.md
cat docs/UseCase2.md >> tmp/Readme.md

cp dist/cjs/* tmp/
cp package/package.json tmp/package.json

version=${CIRCLE_TAG#"v"}
sed -i "s/1.0.0/${version}/g" tmp/package.json

echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc
npm whoami
cat .npmrc
npm publish tmp
