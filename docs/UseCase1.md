## Use in a Vue.js app

```html
<template>
  <div>
    ...
    <socomodule></socomodule>
    ...
  </div>
</template>

<script>
import Vue from 'vue'
import socomodule from 'socomodule'
import 'socomodule/socomodule.min.css'

Vue.component('socomodule', socomodule.default)

export default {
  name: 'my-component'
}
</script>
```
