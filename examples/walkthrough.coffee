thynapse = require 'thynapse'

# A thynapse cell has to belong to a service. In
# order to connect to the rest of the system, it
# registers itself as part of its service.
#
# In this case, our cell belongs to the "hello" service.
hello = thynapse.register 'hello', 'tcp://localhost:5454'


# A simple example: when we see the 'Hello World' event,
# print a message to standard out
hello.on 'hello::world', ->
    console.log 'Hello world'

# Send the message
hello.send 'world' # sends "hello::world"


# We can also subscribe to patterns using *
hello.on 'hello::user::*', (message) ->
    console.log 'Hello, ' + message.name

# When can send data along with a message
hello.send 'user::dave', name: "Dave"


# If we want to listen to *every* event of a given
# type, we can use .all. This ignores the logic
# to ensure each message is delivered only once.
hello.all.on 'hello::*', ->
    console.log "Just saw a 'hello' event go whizzing by!"

# You can also bypass the default namespaceing by
# sending to .raw
hello.raw.send 'hello::world'
hello.raw.send 'greetings::earth'


# We can use service.on to guarantee the event is only received
# once by a member of this service. It also passes a `resp`
# object, which must be used to mark the tast as done or failed.
hello.on 'user::registered', (message, resp) ->
    console.log "Sending an email to " + message.email
    
    # simulate success or failure randomly
    if Math.random() < 0.5
        resp.success()
        # Equivalent to:
        #   thynapse.send 'hello::email::send::success', re: message.id
    else
        resp.failure "Could not send the email!"
        # Equivalent to:
        #   thynapse.send 'hello::email::send::failure',
        #     message: "Could not send the email!"
        #     re: message.id
