import Vue from 'vue'
import HelloWorld from '@/components/HelloWorld'

describe('HelloWorld.vue', () => {
  it('rends correct contents', () => {
    const Constructor = Vue.extend(HelloWorld)
    const vm = new Constructor().$mount()
    const selector = vm.$el.querySelector('.hello h1')
    if (!selector) {
      throw new Error(`The element wasn't found`)
    }
    expect(selector.textContent)
    .toEqual('Welcome to Your Vue.js App')
  })
})
