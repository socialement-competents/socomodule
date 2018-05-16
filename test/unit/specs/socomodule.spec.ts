import { mount } from '@vue/test-utils'

import Socomodule from '../../../src/socomodule/socomodule'

describe('socomodule.vue', () => {
  it('renders correct contents', () => {
    const wrapper = mount(Socomodule)
    const vm: Socomodule = wrapper.vm
    expect(vm.chatopened).toBe(false)
  })
})
