import { GetterTree } from 'vuex'

const getters: GetterTree<any, any> = {
  isLogin(state): boolean {
    return state.login
  }
}

export default getters
