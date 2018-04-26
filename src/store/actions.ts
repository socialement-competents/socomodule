import { ActionTree } from 'vuex'
import TYPES from './types'

const actions: ActionTree<any, any> = {
  // 获取modules
  setLogin({ state, commit }, flag: boolean): void {
    commit(TYPES.SET_LOGIN_STATUS, flag)
  }
}

export default actions
