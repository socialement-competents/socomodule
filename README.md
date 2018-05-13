![Node](https://img.shields.io/badge/node-9.11.1-brightgreen.svg)
[![Styled with ESLint](https://img.shields.io/badge/styled%20with-eslint-brightgreen.svg)](https://github.com/eslint/eslint)
[![CircleCI](https://img.shields.io/circleci/project/github/socialement-competents/hackafront.svg)](https://circleci.com/gh/socialement-competents/hackafront)
[![Code coverage with Codecov](https://img.shields.io/codecov/c/github/socialement-competents/hackafront.svg)](https://codecov.io/gh/socialement-competents/hackafront)
[![Code quality with Codacy](https://img.shields.io/codacy/grade/e27821fb6289410b8f58338c7e0bc686.svg)](https://app.codacy.com/app/tsauvajon/hackafront)
![No license](https://img.shields.io/github/license/socialement-competents/hackafront.svg)
[![CircleCI](https://img.shields.io/docker/pulls/socialementcompetents/hackafront.svg)](https://hub.docker.com/r/socialementcompetents/hackafront/)

# hackafront

> Hackaton front-end template with Vue.js, TypeScript, GraphQL, JWT and some
CI set up.

## Abstract

This project is a boilerplate for hackatons.
Instead of spending hours or days initialiazing a project, the CI, the
deployments and so on, when you already have a short time span just clone
this and a GraphQL backend
and you're set to go.

It is meant to be used with
[Backathon](https://github.com/socialement-competents/backathon),
but can be used with any GraphQL back-end.

Consider the use of [Graphcool](https://www.graph.cool/) if you want to focus
on the front-end because you don't have the time / need / knowledge to build
a GraphQL back-end.

## Getting started

``` bash
# install dependencies
yarn

# serve with hot reload at localhost:8080
yarn dev

# build for production with minification
yarn build

# build for production and view the bundle analyzer report
yarn build --report

# run unit tests
yarn unit

# run e2e tests
yarn e2e

# run all tests
yarn test
```

# Workflow

- `git checkout dev`
- `git fetch`
- `git pull`
- `git branch -b '(feat|fix|refacto)/branch_name` pull out a branch from
dev (up to date)
- dev your stuff
- `git add .`
- `git commit -S -m 'Your commit description'`
- `git push origin (feat|fix|refacto)/branch_name`
- create a pull request to run checks (conflicts, CI)
- ask for a review
- squash and merge
- repeat
- create a pull request from dev to master when you are ready for production

## Vue.js

[Vue.js](https://vuejs.org/) (or just `Vue`) is a JavaScript front-end
framework, competing with Angular and React, amongst others. We have chosen to
use Vue over any other framework for its simplicity, modularity and performance.

While on a rush to have a working application, learning Vue will be easier
for developers unfamiliar with it than learning React or Angular. That's
obviously in the case you don't know your teammates in advance !

We recommand using [Vuetify](http://vuetifyjs.com) for the UI components.

## GraphQL

We believe that [GraphQL](http://graphql.org/) is the future of APIs, while not
adding too much boilerplate code for small applications. Changing to a REST
API would be easy: nothing to add, just remove every `graphql` and `apollo`
package and reference.

To generate the schema from an existing GraphQL endpoint, set the `SERVER_URL`
environment variable and run `yarn gql`.
The generated types will be placed at `src/typings/types.ts`.

## TypeScript

We chose to use TypeScript over regular JavaScript to capitalize on the
advantages of strong typing: build time type checking, auto completion,
self-documentation ...

## CI

The code is linted with [ESLint](https://eslint.org/) and
[TSLint](https://palantir.github.io/tslint/), and tested with
[Jest](https://facebook.github.io/jest/) and
[Nightwatch](http://nightwatchjs.org/).
The test coverage results are uploaded to
[Codecov](https://codecov.io/gh/socialement-competents/hackafront).

It is continuously tested and build with [CircleCI](https://circleci.com),
and published to the
[Docker Hub](https://hub.docker.com/r/socialementcompetents/hackafront/)
on every push to the master branch.

Every branch is automatically deployed and updated at
`https://[branch]--hackafront.netlify.com` and every pull request at
`https://deploy-preview-[#pr]--hackafront.netlify.com`, with
[Netlify](https://www.netlify.com).

The code is reviewed by 2 static analysis providers:
- [Deepscan](https://deepscan.io/dashboard/#view=project&pid=2362&bid=14124)
- [Codacy](https://app.codacy.com/app/tsauvajon/hackafront/dashboard)

## CircleCI

Environment variables to set on CircleCI:
- `CODACY_PROJECT_TOKEN`: Settings > Integrations > Project API > Settings
- `CODECOV_TOKEN`: Settings > Repository Upload Token
- `DOCKER_USER`: Docker Hub username to push the images
- `DOCKER_PASS`: Docker Hub password
- `GITHUB_API_TOKEN`: https://github.com/settings/tokens > generate new token >
  scopes `repo` and `admin:repo_hook` (used to publish release + publish recaps)
- `GITHUB_TOKEN`: same ^
