should = require 'should'

describe 'Thynapse', ->
    
    thynapse = (require '../').local()

    it 'can connect to a local instance', ->
        should.exist thynapse

    it 'can send a message', ->
        thynapse.send 'test'

    it 'can receive a message', (done) ->
        thynapse.on 'hello', ->
            done()
        thynapse.send 'hello'

    it 'can pass data in a message', (done) ->
        thynapse.on 'data', (message) ->
            message.text.should.equal "success"
            done()

        thynapse.send 'data', text: "success"
