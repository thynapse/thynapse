cluster = require 'cluster'
thynapse = (require 'thynapse').connect 'tcp://localhost:5454'

# The master will spawn workers and emit a "hello::world"
# event every second, with an increasing `seq` number.
if cluster.isMaster

    hello = thynapse.service 'hello'

    seq = 0
    # Start sending when the first greeter is ready
    thynapse.on 'greeter::ready', ->
        setInterval (-> hello.send 'world', seq: seq += 1), 1000

    # Start 4 workers
    for i in [1..4]
        cluster.fork()

# The children will simply listen to these messages,
# both in 'tap' mode and 'worker' mode.
else

    # Log each message we hear
    thynapse.on 'hello::world', (message) ->
        console.log 'Heard message #' + message.seq

    greeter = thynapse.service 'greeter'

    # Only handle each message once
    greeter.on 'hello::world', (message, resp) ->
        console.log 'Handled message #' + message.seq
        resp.success()

    # Notify the master we're ready
    greeter.send 'ready'
