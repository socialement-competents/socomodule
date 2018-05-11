<template>
  <div id="app">
    <img src="./assets/logo.png">
    <router-view/>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Component from 'vue-class-component'

import { REGISTER } from '@/users/mutations'
import { GET_USERS, GET_USER_BY_ID } from '@/users/queries'
import { UserByIdQueryArgs, AddUserMutationArgs } from '@/typings/types'

@Component
export default class App extends Vue {
  msg: string = 'Welcome to Your Vue.js App'
  name: string = 'app'
  get apollo () {
    return {
      users: {
        query: GET_USERS,
        prefetch: true
      },
      userById: {
        query: GET_USER_BY_ID,
        prefetch: true,
        variables (): UserByIdQueryArgs {
          return { id: '1' }
        }
      }
    }
  }

  async greet () {
    await this.$apollo.mutate({
      mutation: REGISTER,
      variables (): AddUserMutationArgs {
        return {
          username: this.name,
          password: this.msg
        }
      }
    })
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
