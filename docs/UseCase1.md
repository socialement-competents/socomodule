## Use in a Vue.js app

```
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

Vue.component('socomodule', socomodule)

export default {
  name: 'my-component'
}
</script>
```
