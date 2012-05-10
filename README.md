# Thynapse

## WARNING: Thynapse is *NOT* ready for production use

[![Build Status](https://secure.travis-ci.org/thynapse/thynapse.png?branch=master)](http://travis-ci.org/thynapse/thynapse)

Thynapse is a lightweight substrate for event-based SOA systems. It handles decentralized message delivery, including receiver-specified semantics for whether a message should be received by all members of a service, or delivered to only one.

The main difference to other systems is that the senders are "dumb", and merely broadcast events out, while the listeners determine, for a given event pattern, whether to listen in multicast or anycast mode. In effect, this means instead of multicast or anycast, it would be more accurate to speak of *multicatch* and *anycatch*.

## Goals

Design goals are, *in order of priority*:

* Correctness / Well-tested
* Simple API
* Highly available
* High throughput
* Easy to implement (client libraries)
* Easy to implement (transmitters)
* Low latency

When trade-offs need to be made, we choose the higher priority, within reason. We wouldn't, for example, make a change that increased latency by 2000% for a 3% increase in throughput.

## Terms

A Thynapse system is made up of three types of components:

* **Transmitters** are the processes that form the connective tissue of the network. Think of them like routers and switches - they are *infrastructure*.
* **Services** are the conceptual building blocks of your system. Each service has a distinct task, and runs the same code.
* **Cells** are individual worker nodes that form a service. Ideal cells are crash-only, share-nothing, and cheap to spin up arbitrary quantities of.

* **THID** is the THynapse IDentifier, a 160-bit integer encoded as a hex value. Each cell or transmitter has randomly-generated THIDs, while a message's THID is the SHA1 hash of its contents.

## Transmitters

Transmitters are ØMQ servers responsible for maintaining the thynapse network; receiving, sending, and propagating events; handling cells joining and leaving the network; and ensuring that 'worker' messages are delivered to precisely one cell in a service.

Whew! That's a lot to do!

How do we accomplish this?

Each transmitter has two ØMQ sockets: a "command" `ROUTER` socket and an "event" `PUB` socket. The "command" socket is used for communication bidirectionally with cells, used for initial service discovery and for receiving events from a cell. The "event" socket is *only* for propagating system events.

All "command" messages follow a format:

1. 1 character version/encoding identifier
2. single space
3. 4 character command
4. single space
5. message payload, encoded as per 1.

As of right now, only the encoding 'J' is defined, which encodes the message payload as JSON.

Available commands:

* Cell-to-Transmitter:
    * `HELO` - A cell's first command, requesting to connect to the network
      * `id` - The cell's THID
      * `service` - The cell's service name
    * `EVNT` - Send an event to the thynapse network
      * `channel` - The message's channel
* Transmitter-to-Cell:
    * `WLCM` - Welcome the cell to the network.
      * `id` - The transmitter's THID
      * `pub` - The address of the welcoming transmitter's event socket
* Transmitter-to-Transmitter:
    * Trick question! All T2T communication goes over the "event" socket.

## License

Under MIT License
