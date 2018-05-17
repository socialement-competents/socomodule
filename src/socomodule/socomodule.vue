<template lang="html">
  <div>
    <div class="message-card" v-if="chatopened">
      <div class="header">
        <img width="20px" src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRv%0D%0AcjogQWRvYmUgSWxsdXN0cmF0b3IgMTguMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVy%0D%0Ac2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RU%0D%0ARCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2%0D%0AZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4%0D%0AbGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2Fw%0D%0AYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDYwIDYwIiBzdHlsZT0iZW5hYmxlLWJh%0D%0AY2tncm91bmQ6bmV3IDAgMCA2MCA2MDsiIHhtbDpzcGFjZT0icHJlc2VydmUiIHdpZHRoPSI1MTJw%0D%0AeCIgaGVpZ2h0PSI1MTJweCI+CjxwYXRoIGQ9Ik01NCwySDZDMi43NDgsMiwwLDQuNzQ4LDAsOHYz%0D%0AM2MwLDMuMjUyLDIuNzQ4LDYsNiw2aDI4LjU1OGw5LjcwMywxMC42NzNDNDQuNDU0LDU3Ljg4NSw0%0D%0ANC43MjQsNTgsNDUsNTggIGMwLjEyMSwwLDAuMjQzLTAuMDIyLDAuMzYxLTAuMDY3QzQ1Ljc0Niw1%0D%0ANy43ODQsNDYsNTcuNDEzLDQ2LDU3VjQ3aDhjMy4yNTIsMCw2LTIuNzQ4LDYtNlY4QzYwLDQuNzQ4%0D%0ALDU3LjI1MiwyLDU0LDJ6IiBmaWxsPSIjRkZGRkZGIi8+Cjwvc3ZnPgo=" alt="icon"/>
        <p class="card-name">Live support chat</p>
      </div>
      <div v-if="operator != undefined" class="operator">
        <p>You are now connected with <span>{{ operator.firstname }}</span></p>
      </div>
      <div class="chat-container" ref="chatcontainer">
        <button @click="captureScreen">Capture</button>
        <div class="message" v-for="m in messages" :key="m._id">
          <div v-if="(m.user != null && m.user.image != null)" class="op-pp">
            <img width="30px" height="30px" :src="operator.image"/>
          </div>
          <div :class="{ 'content': true, 'op-message': m.user != null }">
            <p>{{ m.content }}</p>
          </div>
        </div>
      </div>
      <div ref="messageform" class="message-form">
        <textarea ref="messageinput" @input="updateHeight" rows='2'></textarea>
        <button @click="sendMessage">SEND</button>
      </div>
    </div>
    <div
      :class="{ socobutton: true, opened: chatopened}"
      @click="chatopened = !chatopened"
    >
    </div>
    <div class="overlay" @click="showping = !showping" v-show="showping">
      <div ref="pingbutton" class="ping-button"></div>
    </div>
  </div>
</template>

<script>
import { ApolloClient } from 'apollo-client'
import { createHttpLink } from 'apollo-link-http'
import { InMemoryCache } from 'apollo-cache-inmemory'
import { WebSocketLink } from 'apollo-link-ws'
import { getMainDefinition } from 'apollo-utilities'
import { split } from 'apollo-link'
import gql from 'graphql-tag'
import fetch from 'unfetch'
import domtoimage from 'dom-to-image';

const httpLink = new createHttpLink({
  //uri: 'https://soco-back.herokuapp.com/graphql',
  uri: 'http://172.20.10.2:3000/graphql',
  fetch
})

const wsLink = new WebSocketLink({
  //uri: 'wss://soco-back.herokuapp.com/subscriptions',
  uri: 'ws://172.20.10.2:3000/subscriptions',
  options: {
    reconnect: true
  }
})

const link = split(
  // split based on operation type
  ({ query }) => {
    const definition = getMainDefinition(query)
    return definition.kind === 'OperationDefinition' &&
    definition.operation === 'subscription'
  },
  wsLink,
  httpLink
)

const apolloClient = new ApolloClient({
  link,
  cache: new InMemoryCache(),
  connectToDevTools: true
})

/**
 * Socomponent documentation
 */
export default {
  name: 'socomodule',
  data: () => ({
    chatopened: false,
    operator: undefined,
    messages: [],
    baseScrollHeight: 0,
    maxRows: 8,
    minRows: 2,
    convId: undefined,
    showping: false
  }),
  methods: {
    updateHeight () {
      if (this.baseScrollHeight == 0) {
        this.baseScrollHeight = this.$refs.messageinput.scrollHeight
        this.baseMessageHeight = this.$refs.messageform.offsetHeight
        this.baseChatContainer = this.$refs.chatcontainer.offsetHeight
      }
      this.$refs.messageinput.rows = this.minRows
      let rows = Math.ceil((this.$refs.messageinput.scrollHeight - this.baseScrollHeight) / 16)
      if (!(rows >= (this.maxRows - 1))) {
        this.$refs.messageinput.rows = this.minRows + rows
      }else{
        this.$refs.messageinput.rows = this.maxRows
      }
      if(this.$refs.messageform.scrollHeight - this.baseMessageHeight > 0 && !(rows >= (this.maxRows - 1))){
        this.$refs.chatcontainer.style.height = this.baseChatContainer - (this.$refs.messageform.scrollHeight - this.baseMessageHeight) + 'px'
      }
    },
    subscribeToConversation (id) {
      let vm = this

      const CONVERSATION_SUBSCRIPTION = gql`
        subscription message ($id: String!) {
          messageAdded(id: $id) {
            _id
            content
            user {
              _id
              firstname
              lastname
              image
            }
          }
        }
      `;
      const observer = apolloClient.subscribe({
        query: CONVERSATION_SUBSCRIPTION,
        variables: {
          id,
        },
      })
      observer.subscribe({
        next(data) {
          console.log(data)
          if(data.data.messageAdded.user != null){
            vm.operator = data.data.messageAdded.user
          }
          vm.messages.push(data.data.messageAdded)
        },
        error(error) {
          console.error(error)
        },
      })

    },
    async createConversation () {
      const mutation = gql`
        mutation {
          addConversation {
            _id
          }
        }
      `
      const { data: { addConversation: { _id } } } = await apolloClient.mutate({ mutation })

      this.subscribeToConversation(_id)

      console.log('id : ', _id)
      return _id
    },
    async sendMessage () {
      if (this.convId === undefined) {
        this.convId = await this.createConversation()
      }
      const mutation = gql`
        mutation{
          addMessage(conversationId:"${this.convId}",content:"${this.$refs.messageinput.value}"){
            _id
          }
        }
      `
      await apolloClient.mutate({ mutation })

      this.$refs.messageinput.value = ''
    },
    captureScreen () {
      let node = document.getElementsByTagName('html')[0]
      let vm = this
      domtoimage.toBlob(node).then(function (blob) {
        let img = new Image()
        img.src = URL.createObjectURL(blob)
        document.body.appendChild(img)
        vm.pingScreen(150,40)
      }).catch(function (error) {
        console.error('oops, something went wrong!', error)
      });
    },
    pingScreen (x, y){
      this.showping = true
      this.$refs.pingbutton.style.top = y + 'px'
      this.$refs.pingbutton.style.left = x + 'px'
    } 
  }
}
</script>

<style lang="css" scoped>
  /* La socofont :D */
  @import url('https://fonts.googleapis.com/css?family=Raleway:200,300,400,500,600,700,800,900');

  .socobutton {
    height: 50px;
    position: fixed;
    bottom: 0px;
    right: 0px;
    width: 50px;
    background: #29047A;
    border-radius: 50%;
    margin: 20px;
    box-shadow: 0px 0px 15px #29037ab5;
    background-image: url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRv%0D%0AcjogQWRvYmUgSWxsdXN0cmF0b3IgMTguMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVy%0D%0Ac2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RU%0D%0ARCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2%0D%0AZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4%0D%0AbGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2Fw%0D%0AYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDYwIDYwIiBzdHlsZT0iZW5hYmxlLWJh%0D%0AY2tncm91bmQ6bmV3IDAgMCA2MCA2MDsiIHhtbDpzcGFjZT0icHJlc2VydmUiIHdpZHRoPSI1MTJw%0D%0AeCIgaGVpZ2h0PSI1MTJweCI+CjxwYXRoIGQ9Ik01NCwySDZDMi43NDgsMiwwLDQuNzQ4LDAsOHYz%0D%0AM2MwLDMuMjUyLDIuNzQ4LDYsNiw2aDI4LjU1OGw5LjcwMywxMC42NzNDNDQuNDU0LDU3Ljg4NSw0%0D%0ANC43MjQsNTgsNDUsNTggIGMwLjEyMSwwLDAuMjQzLTAuMDIyLDAuMzYxLTAuMDY3QzQ1Ljc0Niw1%0D%0ANy43ODQsNDYsNTcuNDEzLDQ2LDU3VjQ3aDhjMy4yNTIsMCw2LTIuNzQ4LDYtNlY4QzYwLDQuNzQ4%0D%0ALDU3LjI1MiwyLDU0LDJ6IiBmaWxsPSIjRkZGRkZGIi8+Cjwvc3ZnPgo=");
    background-size: 22px;
    background-repeat: no-repeat;
    background-position-x: 50%;
    background-position-y: 50%;
    animation: socomation-close;
    animation-duration: 0.5s;
  }
  .socobutton.opened{
    animation-duration: 0.5s;
    animation-name: socomation-open;
    background-image: url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRv%0D%0AcjogQWRvYmUgSWxsdXN0cmF0b3IgMTkuMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVy%0D%0Ac2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIw%0D%0AMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lv%0D%0Abj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDMxLjExMiAz%0D%0AMS4xMTIiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDMxLjExMiAzMS4xMTI7IiB4%0D%0AbWw6c3BhY2U9InByZXNlcnZlIiB3aWR0aD0iNTEycHgiIGhlaWdodD0iNTEycHgiPgo8cG9seWdv%0D%0AbiBwb2ludHM9IjMxLjExMiwxLjQxNCAyOS42OTgsMCAxNS41NTYsMTQuMTQyIDEuNDE0LDAgMCwx%0D%0ALjQxNCAxNC4xNDIsMTUuNTU2IDAsMjkuNjk4IDEuNDE0LDMxLjExMiAxNS41NTYsMTYuOTcgICAy%0D%0AOS42OTgsMzEuMTEyIDMxLjExMiwyOS42OTggMTYuOTcsMTUuNTU2ICIgZmlsbD0iI0ZGRkZGRiIv%0D%0APgo8L3N2Zz4K");
    background-size: 12px;
  }
  .socobutton:hover{
    cursor: pointer;
  }
  .message-card{
    position: fixed;
    height: 65%;
    width: 350px;
    background: #ffffff;
    right: 0px;
    bottom: 70px;
    margin: 20px;
    border-radius: 4px;
    box-shadow: 2px 2px 15px #8e8e8ea6;
    overflow: hidden;
    font-family: 'Raleway', sans-serif;
  }
  .message-card .header{
    height: 12%;
    background: #29037a;
    display: flex;
    align-items: center;
    color: white;
    font-weight: 400;
  }
  .message-card .header>img{
    margin-left: 10px;
  }
  .message-card .operator{
    height: 8%;
    background: #02FAA8;
    display: flex;
    justify-content: center;
    color: white;
  }
  .message-card .operator>p{
    margin: 0px;
    align-self: center;
  }
  .message-card .operator>p>span{
    font-weight: 800;
  }
  .message-card .chat-container{
    height: 68%;
    overflow-y: scroll;
    font-size: 13px;
  }

  .message-card .chat-container .message{
    display: flex;
    padding: 4px;
  }

  .message-card .chat-container .message .op-pp{
    display: inline-flex;
    align-items: flex-end;
  }

  .message-card .chat-container .message .op-pp>img{
    border-radius: 50%;
  }

  .message-card .chat-container .message .content{
    white-space: pre-wrap;
    text-align: justify;
    display: inline-flex;
  }
  
  .message-card .chat-container .message .content.op-message{
    display: inline-flex;
    margin-right: 15px;
    margin-left: 15px;
    background: whitesmoke;
    padding: 10px;
    color: #4a4a4a;
    border-radius: 10px;
    border-bottom-left-radius: 0px;
  }

  .message-card .chat-container .message .content:not(.op-message){  
    justify-content: flex-end;
    width: 100%;
  }

  .message-card .chat-container .message .content>p{
    display: inline-flex;
  }

  .message-card .chat-container .message .content.op-message>p{
    margin: 0px;
  }

  .message-card .chat-container .message .content:not(.op-message)>p{
    background: #95A5A6;
    padding: 10px;
    border-radius: 10px;
    border-bottom-right-radius: 0px;
    margin: 0px;
    margin-right: 15px;
    color: white;
  }

  .message-card .message-form{
    background: #F5F5F5;
    z-index: 10;
    position: absolute;
    box-shadow: 0px 0px 10px grey;
    display: flex;
    align-items: flex-end;
    width: 100%;
    bottom: 0px;
  }

  .message-card .message-form textarea{
    resize: none;
    width: 80%;
    margin: 8px 8px 8px 16px;
    border: 2px solid rgb(41, 3, 122);
    border-radius: 4px;
    padding: 5px;
    font-family: 'Raleway', sans-serif;
    font-weight: 400;
  }

  .message-card .message-form button{
    width: 20%;
    margin-right: 16px;
    margin-bottom: 8px;
    height: 33px;
    box-sizing: content-box;
    border: 2px solid #29037a;
    color: white;
    border-radius: 4px;
    background: #29037a;
  }

  .message-card .message-form button:hover{
    cursor: pointer;
  }

  .message-card .card-name{
    margin-left: 10px;
  }

  .overlay{
    position: absolute;
    width: 100%;
    top: 0px;
    height: 100%;
    left: 0px;
    background: #1f1f1f91;
  }

  .overlay .ping-button{
    width: 35px;
    height: 35px;
    background: red;
    border-radius: 50%;
    box-shadow: 0px 0px 25px red;
    position: absolute;
  }

  @keyframes socomation-open {
    from {
      background-size: 22px;
      background-image: url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRv%0D%0AcjogQWRvYmUgSWxsdXN0cmF0b3IgMTguMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVy%0D%0Ac2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RU%0D%0ARCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2%0D%0AZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4%0D%0AbGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2Fw%0D%0AYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDYwIDYwIiBzdHlsZT0iZW5hYmxlLWJh%0D%0AY2tncm91bmQ6bmV3IDAgMCA2MCA2MDsiIHhtbDpzcGFjZT0icHJlc2VydmUiIHdpZHRoPSI1MTJw%0D%0AeCIgaGVpZ2h0PSI1MTJweCI+CjxwYXRoIGQ9Ik01NCwySDZDMi43NDgsMiwwLDQuNzQ4LDAsOHYz%0D%0AM2MwLDMuMjUyLDIuNzQ4LDYsNiw2aDI4LjU1OGw5LjcwMywxMC42NzNDNDQuNDU0LDU3Ljg4NSw0%0D%0ANC43MjQsNTgsNDUsNTggIGMwLjEyMSwwLDAuMjQzLTAuMDIyLDAuMzYxLTAuMDY3QzQ1Ljc0Niw1%0D%0ANy43ODQsNDYsNTcuNDEzLDQ2LDU3VjQ3aDhjMy4yNTIsMCw2LTIuNzQ4LDYtNlY4QzYwLDQuNzQ4%0D%0ALDU3LjI1MiwyLDU0LDJ6IiBmaWxsPSIjRkZGRkZGIi8+Cjwvc3ZnPgo=");
    }
    50%{
      background-size: 0px;
      background-image: url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRv%0D%0AcjogQWRvYmUgSWxsdXN0cmF0b3IgMTguMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVy%0D%0Ac2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RU%0D%0ARCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2%0D%0AZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4%0D%0AbGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2Fw%0D%0AYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDYwIDYwIiBzdHlsZT0iZW5hYmxlLWJh%0D%0AY2tncm91bmQ6bmV3IDAgMCA2MCA2MDsiIHhtbDpzcGFjZT0icHJlc2VydmUiIHdpZHRoPSI1MTJw%0D%0AeCIgaGVpZ2h0PSI1MTJweCI+CjxwYXRoIGQ9Ik01NCwySDZDMi43NDgsMiwwLDQuNzQ4LDAsOHYz%0D%0AM2MwLDMuMjUyLDIuNzQ4LDYsNiw2aDI4LjU1OGw5LjcwMywxMC42NzNDNDQuNDU0LDU3Ljg4NSw0%0D%0ANC43MjQsNTgsNDUsNTggIGMwLjEyMSwwLDAuMjQzLTAuMDIyLDAuMzYxLTAuMDY3QzQ1Ljc0Niw1%0D%0ANy43ODQsNDYsNTcuNDEzLDQ2LDU3VjQ3aDhjMy4yNTIsMCw2LTIuNzQ4LDYtNlY4QzYwLDQuNzQ4%0D%0ALDU3LjI1MiwyLDU0LDJ6IiBmaWxsPSIjRkZGRkZGIi8+Cjwvc3ZnPgo=");
    }
    51%{
      background-image: url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRv%0D%0AcjogQWRvYmUgSWxsdXN0cmF0b3IgMTkuMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVy%0D%0Ac2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIw%0D%0AMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lv%0D%0Abj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDMxLjExMiAz%0D%0AMS4xMTIiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDMxLjExMiAzMS4xMTI7IiB4%0D%0AbWw6c3BhY2U9InByZXNlcnZlIiB3aWR0aD0iNTEycHgiIGhlaWdodD0iNTEycHgiPgo8cG9seWdv%0D%0AbiBwb2ludHM9IjMxLjExMiwxLjQxNCAyOS42OTgsMCAxNS41NTYsMTQuMTQyIDEuNDE0LDAgMCwx%0D%0ALjQxNCAxNC4xNDIsMTUuNTU2IDAsMjkuNjk4IDEuNDE0LDMxLjExMiAxNS41NTYsMTYuOTcgICAy%0D%0AOS42OTgsMzEuMTEyIDMxLjExMiwyOS42OTggMTYuOTcsMTUuNTU2ICIgZmlsbD0iI0ZGRkZGRiIv%0D%0APgo8L3N2Zz4K");
    }
    to {
      background-size: 12px;
    }
  }

  @keyframes socomation-close {
    from {
      background-size: 12px;
      background-image: url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRv%0D%0AcjogQWRvYmUgSWxsdXN0cmF0b3IgMTkuMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVy%0D%0Ac2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIw%0D%0AMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lv%0D%0Abj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDMxLjExMiAz%0D%0AMS4xMTIiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDMxLjExMiAzMS4xMTI7IiB4%0D%0AbWw6c3BhY2U9InByZXNlcnZlIiB3aWR0aD0iNTEycHgiIGhlaWdodD0iNTEycHgiPgo8cG9seWdv%0D%0AbiBwb2ludHM9IjMxLjExMiwxLjQxNCAyOS42OTgsMCAxNS41NTYsMTQuMTQyIDEuNDE0LDAgMCwx%0D%0ALjQxNCAxNC4xNDIsMTUuNTU2IDAsMjkuNjk4IDEuNDE0LDMxLjExMiAxNS41NTYsMTYuOTcgICAy%0D%0AOS42OTgsMzEuMTEyIDMxLjExMiwyOS42OTggMTYuOTcsMTUuNTU2ICIgZmlsbD0iI0ZGRkZGRiIv%0D%0APgo8L3N2Zz4K");
    }
    50%{
      background-size: 0px;
      background-image: url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRv%0D%0AcjogQWRvYmUgSWxsdXN0cmF0b3IgMTkuMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVy%0D%0Ac2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIw%0D%0AMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lv%0D%0Abj0iMS4xIiBpZD0iQ2FwYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDMxLjExMiAz%0D%0AMS4xMTIiIHN0eWxlPSJlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDMxLjExMiAzMS4xMTI7IiB4%0D%0AbWw6c3BhY2U9InByZXNlcnZlIiB3aWR0aD0iNTEycHgiIGhlaWdodD0iNTEycHgiPgo8cG9seWdv%0D%0AbiBwb2ludHM9IjMxLjExMiwxLjQxNCAyOS42OTgsMCAxNS41NTYsMTQuMTQyIDEuNDE0LDAgMCwx%0D%0ALjQxNCAxNC4xNDIsMTUuNTU2IDAsMjkuNjk4IDEuNDE0LDMxLjExMiAxNS41NTYsMTYuOTcgICAy%0D%0AOS42OTgsMzEuMTEyIDMxLjExMiwyOS42OTggMTYuOTcsMTUuNTU2ICIgZmlsbD0iI0ZGRkZGRiIv%0D%0APgo8L3N2Zz4K");
    }
    51%{
      background-image: url("data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8IS0tIEdlbmVyYXRv%0D%0AcjogQWRvYmUgSWxsdXN0cmF0b3IgMTguMC4wLCBTVkcgRXhwb3J0IFBsdWctSW4gLiBTVkcgVmVy%0D%0Ac2lvbjogNi4wMCBCdWlsZCAwKSAgLS0+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RU%0D%0ARCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2%0D%0AZzExLmR0ZCI+CjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4%0D%0AbGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgdmVyc2lvbj0iMS4xIiBpZD0iQ2Fw%0D%0AYV8xIiB4PSIwcHgiIHk9IjBweCIgdmlld0JveD0iMCAwIDYwIDYwIiBzdHlsZT0iZW5hYmxlLWJh%0D%0AY2tncm91bmQ6bmV3IDAgMCA2MCA2MDsiIHhtbDpzcGFjZT0icHJlc2VydmUiIHdpZHRoPSI1MTJw%0D%0AeCIgaGVpZ2h0PSI1MTJweCI+CjxwYXRoIGQ9Ik01NCwySDZDMi43NDgsMiwwLDQuNzQ4LDAsOHYz%0D%0AM2MwLDMuMjUyLDIuNzQ4LDYsNiw2aDI4LjU1OGw5LjcwMywxMC42NzNDNDQuNDU0LDU3Ljg4NSw0%0D%0ANC43MjQsNTgsNDUsNTggIGMwLjEyMSwwLDAuMjQzLTAuMDIyLDAuMzYxLTAuMDY3QzQ1Ljc0Niw1%0D%0ANy43ODQsNDYsNTcuNDEzLDQ2LDU3VjQ3aDhjMy4yNTIsMCw2LTIuNzQ4LDYtNlY4QzYwLDQuNzQ4%0D%0ALDU3LjI1MiwyLDU0LDJ6IiBmaWxsPSIjRkZGRkZGIi8+Cjwvc3ZnPgo=");
    }
    to {
      background-size: 22px;
    }
  }

</style>
