import {Socket} from "phoenix"

const socket = new Socket("/socket")
socket.connect()

let chat = document.getElementsByClassName("container")[0]
chat.innerHTML = ""

function onJoin() {
  chat.innerHTML = "<p>Joined</p>"
}

function onError({reason}) {
  chat.innerHTML = `<p>Error: ${reason}</p>`
}

// Messages:
// {
//   "text": "test10",
//   "sent":"2016-06-27T10:18:46.332Z",
//   "fromUser": {
//     "displayName": "jnbt",
//     "avatarUrlSmall":"https://avatars1.githubusercontent.com/u/678542?v=3&s=60",
//   }
// }
function onUpdate({messages}) {
  const html = messages.reverse().map(message => {
    return (
      `<dt>
         <img src="${message.fromUser.avatarUrlSmall}" width=20/>
         ${message.fromUser.displayName}:
       </dt>
       <dd>${message.text}</dd>`
    )
  }).join("")
  chat.innerHTML = `<dl> ${html} </dl>`
}

const channel = socket.channel("gitter", {})

channel.on("update", onUpdate)

channel.join()
  .receive("ok", onJoin)
  .receive("error", onError)
