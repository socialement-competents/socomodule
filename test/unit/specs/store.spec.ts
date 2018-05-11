import store from '@/app/store'

describe('store', () => {
  it('logs users in', () => {
    store.dispatch('setLogin', true)
    expect(store.getters.isLogin).toBeTruthy()
  })

  it('logs users out', () => {
    store.dispatch('setLogin', true)
    expect(store.getters.isLogin).toBeTruthy()
    store.dispatch('setLogin', false)
    expect(store.getters.isLogin).toBeFalsy()
  })
})
