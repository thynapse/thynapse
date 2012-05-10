EventEmitter = (require 'events').EventEmitter
Pattern = require './pattern'
util = require './util'
zmq = require 'zmq'

# A Subscription listens to a pattern on a connection
# and emits a 'message' event when it finds a match
class Subscription extends EventEmitter
    constructor: (@pattern, connection) ->
        @connections = []
        @pattern = Pattern.compile @pattern
        @listenTo connection if connection

    listenTo: (connection) ->
        @connections.push connection
        connection.on 'message', @receive

    receive: (message) =>
        @emit 'message', message if @pattern.match message.channelID

    close: ->
        for connection in @connections
            connection.removeListener 'message', @receive

class Hub extends EventEmitter
    constructor: (@connection) ->

    subscribe: (pattern) ->
        new Subscription pattern, @connection

    on: (pattern, callback) ->
        subscription = @subscribe pattern
        subscription.on 'message', callback

    send: (channelID, message = {}) ->
        message.channelID = channelID
        @connection.emit 'message', message

class Service extends EventEmitter
    constructor: (@service) ->
        @id = new util.THID()
        @cmdSock = zmq.socket 'dealer'
        @evtSock = zmq.socket 'sub'

        @cmdSock.on 'message', (msg) =>
            @command msg

    connect: (address) ->
        @cmdSock.connect address
        @cmdSock.identity = @service + '/' + @id.toString('hex')
        helo = id: @id.toString('hex'), service: @service
        @cmdSock.send 'HELO ' + JSON.stringify helo

    command: (msg) ->
        console.log "T> " + msg.toString('utf8')

module.exports =
    local: ->
        new Hub (new EventEmitter)

    register: (serviceID, address) ->
        service = new Service serviceID
        service.connect address
        service
