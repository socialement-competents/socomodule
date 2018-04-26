import TYPES from './types'
import { MutationTree } from 'vuex'

const mutations: MutationTree<any> = {
  [TYPES.SET_LOGIN_STATUS](state, flag): void {
    state.login = flag
  }
}
export default mutations
