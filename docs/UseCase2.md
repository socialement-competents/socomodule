## Use in any web application

[Exemple](https://codepen.io/tsauvajon/pen/JvmrEo) in CodePen

```html
<head>
  <script src="socomodule.min.js" charset="utf-8"></script>
  <script src="https://unpkg.com/vue" charset="utf-8"></script>
  <link rel="stylesheet" type="text/css" href="socomodule.min.css">
</head>

<body>
  <!-- ... your application -->
  <div id="app">
	  <socomodule></socomodule>
  </div>

  <script>
	var sc = Vue.component('socomodule', window.Socomodule.default);
    var app = new Vue({el: '#app'})
  </script>
</body>
```
