<template lang="html">
  <div>
    <div class="message-card" v-if="chatopened">
      <div class="header">
        <img width="20px" src="../assets/chat.svg" alt="icon"/>
        <p class="card-name">Live support chat</p>
      </div>
      <div class="operator">
        <p>You are now connected with <span>{{operator.name}}</span></p>
      </div>
      <div class="chat-container">
        <div class="message" v-for="m in messages" :key="m.id">
          <div v-if="m.operator" class="op-pp"><img width="30px" height="30px" :src="operator.picture"/></div>
          <div :class="{'content':true,'op-message':m.operator}"><p>{{m.content}}</p></div>
        </div>
      </div>
      <div class="message-form">
        <textarea></textarea>
        <button>SEND</button>
      </div>
    </div>
    <div :class="{socobutton:true,opened:chatopened}" @click="chatopened=!chatopened">
    </div>
  </div>
</template>

<script>
/**
 * Socomponent documentation
 */
export default {
  name: 'socomodule',
  data: () => {
    return ({
      chatopened: false,
      operator: {
        id: '8292',
        name: 'Guita',
        picture: 'https://randomuser.me/api/portraits/women/21.jpg'
      },
      messages: [
        {id:'e42fzozjd503rfnfz',operator:false,content:'I need some assistance on this app'},
        {id:'ac20daz2038daafav',operator:true,content:'Hey, how can I help you ?'},
        {id:'e30fjzzdo939fkeiz',operator:false,content:'Hi, sorry I\'m completely lost I don\'t know how to use this app, can you help me please ?'},
        {id:'da494543fehez3874',operator:true,content:'Yes sure ! \nTo help you in the best possible way, do you agree to attach a screenshot of the page on which you are located ?'},
      ]
    })
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
    background-image: url("../assets/chat.svg");
    background-size: 22px;
    background-repeat: no-repeat;
    background-position-x: 50%;
    background-position-y: 50%;
  }
  .socobutton.opened{
    background-image: url("../assets/cross.svg");
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
    padding: 10px;
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
    width: calc(100% - 30px);
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
    height: 12%;
    background: #F5F5F5;
    z-index: 10;
    position: relative;
    box-shadow: 0px 0px 10px grey;
    display: flex;
    align-items: center;
  }

  .message-card .message-form textarea{
    resize: none;
    width: 80%;
    margin: 0px 8px 0px 16px;
    max-height: calc(50% - 10px);
    border: 2px solid rgb(41, 3, 122);
    border-radius: 4px;
    padding: 5px;
  }

  .message-card .message-form button{
    width: 20%;
    margin-right: 16px;
    height: 50%;
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

</style>
