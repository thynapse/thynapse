thynapse = require 'thynapse'

# A thynapse node needs to have a way to connect to the rest
# of the system. The simplest way is with `connect`
thynapse = thynapse.connect 'tcp://localhost:5454'

# An alternative is to use mdns to auto-discover other thynapse
# members on the network
#
#   thynapse = thynapse.autoDiscover()


# A simple example: when we see the 'Hello World' event,
# print a message to standard out
thynapse.on 'hello::world', ->
    console.log 'Hello world'

# Send the message
thynapse.send 'hello::world'


# We can also subscribe to patterns using *
thynapse.on 'hello::*', (message) ->
    console.log 'Hello, ' + message.name

# When can send data along with a message
thynapse.send 'hello::user', name: "Dave"


# If we want to guarantee that only one member of a service
# receives a given message, use a 'service' to listen instead
notifications = thynapse.service 'notifications'

# Service.send will automatically prefix the event name with
# the service name
notifications.send 'ready' # == thynapse.send 'notifications::ready'

# We can use service.on to guarantee the event is only received
# once by a member of this service. It also passes a `resp`
# object, which must be used to mark the tast as done or failed.
notifications.on 'email::send', (message, resp) ->
    console.log "Sending an email to " + message.email
    
    # simulate success or failure randomly
    if Math.random() < 0.5
        resp.success()
        # Equivalent to:
        #   thynapse.send 'email::send::notifications::success', re: message.id
    else
        resp.failure "Could not send the email!"
        # Equivalent to:
        #   thynapse.send 'email::send::notifications::failure',
        #     message: "Could not send the email!"
        #     re: message.id
