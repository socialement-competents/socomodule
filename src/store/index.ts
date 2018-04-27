import Vue from 'vue'
import Vuex from 'vuex'
import actions from '@/store/actions'
import mutations from '@/store/mutations'
import getters from '@/store/getters'

Vue.use(Vuex)

interface State {
  login: boolean
}

let state: State = {
  login: false
}

export default new Vuex.Store({
  state,
  actions,
  getters,
  mutations
})
