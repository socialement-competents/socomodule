import Vue from 'vue';
import Component from '../../../src/socomodule/socomodule';

describe('socomodule.vue', () => {
  const Constructor = Vue.extend(Component);
  const propsData = {text: 'Test text'};

  it('should instance the right component', () => {
    const vm = new Constructor({propsData});
    expect(vm.$options.name).to.equal('socomodule');
  });

  it('should render correct content', () => {
    const vm = new Constructor({propsData}).$mount();
    expect(vm.$el.innerHTML).to.include('socobutton');
  });
});
