import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("morse:progress", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

let progressBar = document.getElementById("morse-progress")

channel.on("update", (content) => {
  progressBar.value = content["value"]
  progressBar.innerHTML = content["value"]
});

export default socket
