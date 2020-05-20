# socomodule


## Project documentation

See [sococoin](https://github.com/socialement-competents/sococoin).

## Installation

### Using yarn

`yarn add socomodule`

### Using npm

`npm i --save socomodule`

## Demo and Docs

`npm run serve`

## Usage

### ES6 Modules / CommonJS

```js
import Socomodule from 'socomodule';
import 'socomodule/dist/socomodule.min.css';

Vue.component('socomodule', Socomodule);
```

```html
<socomodule text="Hello World!"></socomodule>
```

### UMD

```html
<socomodule text="Hello World!"></socomodule>

<script src="https://unpkg.com/vue" charset="utf-8"></script>
<script src="./dist/umd/socomodule.min.js" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" href="./dist/umd/socomodule.min.css">

<script type="text/javascript">
  Vue.component('socomodule', window.Socomodule);
</script>
```

## Build

Build configuration is located in the `poi.config.js` file, to build just run: `npm run build`, it will build to `cjs` and `umd` directories.

## Tests

This template uses karma with chai by default, you can change test settings in poi.config.js

`npm run test`
`npm run test:watch`
`npm run test:cov`

## License

This project is licensed under [MIT License](http://en.wikipedia.org/wiki/MIT_License)
