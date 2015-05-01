# Main javascript file for the application
# contains the angular module and its main controller

receivers = []      # Set of receiving functions


app = angular.module('Veracious', [])

app.controller('LogController', ($scope) ->
    ###
    format: { status: String E { SUCCESS, FAILURE, WARNING, INFO },
                 activity: String E {
                            Batch:$id::$date::numberOfJobs-$n,
                            Job:$id:$description::$k-$v,[$k-$v,..]
                            },
                 message: String
               }
    ###
    # Parts: #loggingWell -> The area of the log
    loggingWell = $("#loggingWell")[0];
    this.logs = []

    ## Set initial logs or add consectutive logs. Needes the event.data from socket
    # this.AddSetLogs = (serverData) ->
    #     if serverData.logs
    #         this.logs = serverData.logs
    #     else
    #         this.logs.push(serverData.log)
    #     loggingWell.scrollTop = loggingWell.scrollHeight
    #     return

    # simple match for status
    this.isStatus = (status, log) ->
        log.status == status

    this.test = () ->
        this.logs.push status: "SUCCESS", message: "Helloooo", activity: "Yohoooo"
        console.log "DEBUG: running test, this.logs: "+JSON.stringify(this.logs)

    # Okay, trying out an IDEA
    # Let us see, If we want to separate everything into different controllers, we need a common receiver for the
    # web-socket...
    # Now, each controller decides to make a function for itself (like a scala partial function) that accepts its kind of
    # data and declares true if it is or else declares false
    # If we add such receiver functions into an array and then make a master receiver that goes through the array with
    # the received server data and stopping till it gets a true, then it might just work right??

    this.receiveFunction = (data) ->    # TODO:check if the model update reflects correctly on the view
        console.log "Debug: received data: "+JSON.stringify(data)
        if data.logs or data.log
            if data.log
                this.logs.push(data.log)
            else this.logs = data.logs
            loggingWell.scrollTop = loggingWell.scrollHeight
            this.AddSetLogs(data)
            console.log "Debug: apparently saved logs/log data"
            console.log "Debug: this.logs: "+JSON.stringify(this.logs)
            true
        else
            console.log "Debug: didn't save logs/log data"
            false

    receivers.push(this.receiveFunction)     # Add this receiver to the

    return
)

app.controller('BatchController', () -> )       # TODO, implement
app.controller('DataController', () -> )

# Now for setting up the websocket connection
testReceiver = (data) ->
    if (data.test)
        console.log "Testing message : "+JSON.stringify(data.test)
        true
    else false

receivers.push(testReceiver)

masterReceive = (data) ->
    for receiver in receivers
        if receiver data
            break
    return

onWSclose = () ->       # TODO, implement
    alert "Closing application"

onWSerror = (d) ->
    alert "Some error occured"+ JSON.stringify d

webSocket = {}

wsCallBack = (ws) -> webSocket = ws
window.connectToApp {
    onMessage: masterReceive
    onError: onWSerror
    onClose: onWSclose
}, wsCallBack
