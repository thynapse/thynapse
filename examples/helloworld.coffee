cluster = require 'cluster'
thynapse = require 'thynapse'

# The master will spawn workers and emit a "hello::world"
# event every second, with an increasing `seq` number.
if cluster.isMaster

    hello = thynapse.register 'hello', 'tcp://localhost:5454/'

    seq = 0
    # Start sending when the first greeter is ready
    hello.on 'greeter::ready', tap: true, ->
        setInterval (-> hello.send 'world', seq: seq += 1), 1000

    # Start 4 workers
    for i in [1..4]
        cluster.fork()

# The children will simply listen to these messages,
# both in 'tap' mode and 'worker' mode.
else

    greeter = thynapse.register 'greeter', 'tcp://localhost:5454/'

    # Log each message we hear
    greeter.all.on 'hello::world', (message) ->
        console.log 'Heard message #' + message.seq

    # Only handle each message once
    greeter.on 'hello::world', (message, resp) ->
        console.log 'Handled message #' + message.seq
        resp.success()

    # Notify the master we're ready
    greeter.send 'ready'
