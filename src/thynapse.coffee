EventEmitter = (require 'events').EventEmitter
Pattern = require './pattern'

# A Subscription listens to a patten on a connection
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

module.exports =
    local: ->
        new Hub (new EventEmitter)
