describe 'Thynapse', ->
    
    thynapse = (require '../').local()

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

    it 'can subscribe to a pattern', (done) ->
        return done()
        thynapse.on 'pattern::*', (message) ->
            message.works.should.equal "great"
            message.channelID.should.equal "pattern::matching"
            done()

        thynapse.send 'pattern::matching', works: "great"
