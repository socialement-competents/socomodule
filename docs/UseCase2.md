## Use in any web application

```html
<head>
  <script src="https://unpkg.com/vue" charset="utf-8"></script>
  <script src="socomodule.min.js" charset="utf-8"></script>
  <link rel="stylesheet" type="text/css" href="socomodule.min.css">
</head>

<body>
  <!-- ... your application -->
  <socomodule></socomodule>
  <script type="text/javascript">
    Vue.component('socomodule', window.Socomodule);
  </script>
</body>
```
