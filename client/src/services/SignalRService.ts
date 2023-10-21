import { HubConnectionBuilder } from '@microsoft/signalr'

const hubUrl = `${import.meta.env.VITE_REMOTE_API}/openAIHub`
const connection = new HubConnectionBuilder()
  .withUrl(hubUrl)
  .withAutomaticReconnect()
  .build()

export default {
  startSignalRConnection() {
    connection.start()
      .then(() => console.log('SignalR connected'))
      .catch(error => console.error(`Error connecting to SignalR: ${error}`))
  },

  stopSignalRConnection() {
    if (connection) {
      connection.stop()
    }
  },

  invoke(methodName: string, ...args: any[]) {
    return connection.invoke(methodName, ...args)
  },

  on(methodName: string, newMethod: (args: any[]) => void) {
    return connection.on(methodName, newMethod)
  }
} 