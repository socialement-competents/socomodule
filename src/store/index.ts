import Vue from 'vue'
import Vuex, { ActionTree, MutationTree } from 'vuex'
import actions from './actions'
import mutations from './mutations'
import getters from './getters'

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
