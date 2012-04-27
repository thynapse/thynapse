EventEmitter = (require 'events').EventEmitter

class ThynapseLocalConnection extends EventEmitter
    send: (channelID, message) ->
        @emit channelID, message

module.exports =
    local: ->
        new ThynapseLocalConnection
