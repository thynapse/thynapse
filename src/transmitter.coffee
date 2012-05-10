zmq = require 'zmq'
EventEmitter = (require 'events').EventEmitter
util = require './util'

class CommandSocket extends EventEmitter
    constructor: () ->
        @socket = zmq.socket 'router'
        @socket.on 'message', (env, msg) =>
            msg = msg.toString('utf8')
            if /^HELO /.test msg
                client = new Client @socket, env
                @emit 'connect', client, msg

    bind: (address) ->
        @socket.bindSync address
        this


class Client extends EventEmitter
    constructor: (@socket, @envelope) ->
        @socket.on 'message', (env, msg) =>
            @emit msg if env == @envelope

    send: (msg, data) ->
        msg = msg + ' ' + JSON.stringify(data) if data
        console.log 'sending: ', msg
        @socket.send [@envelope, msg]

class Transmitter
    constructor: (@cmdPort, @evtPort) ->
        @id = new util.THID()

    handle: (env, msg) ->
        console.log env.toString('hex') + ">", msg.toString('utf8')
        @cmdSock.send [env, "WLCM"]
        @cmdSock.send [env, "WLCM2"]
        @publish msg

    publish: (msg) ->
        @evtSock.send "EVNT " + msg.channel + ' ' + JSON.stringify(msg)

    start: ->
        @cmdSock = new CommandSocket
        @cmdSock.bind 'tcp://*:' + @cmdPort

        @evtSock = zmq.socket 'pub'
        @evtSock.identity = 'transmitter-' + @id
        @evtSock.bindSync('tcp://*:' + @evtPort)

        @cmdSock.on 'connect', (client, msg) =>
            console.log('Got a new client: ', client.envelope.toString('hex'))
            client.send "WLCM", id: @id.toString(), pub: @evtPort

        console.log "Transmitter " + @id + " listening."


module.exports = Transmitter
