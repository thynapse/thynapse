# Thynapse

Thynapse is a lightweight subtrate for event-based SOA systems. It handles decentralized message delivery, including receiver-determined semantics for whether a message should be received by all members of a service (tap mode), or delivered to only one (worker mode).

## Goals

Design goals are, *in order of priority*:

* Simple API
* Highly available
* High throughput
* Easy to implement
* Low latency

When trade-offs need to be made, we choose the higher priority, within reason. We wouldn't, for example, make a change that increased latency by 2000% for a 3% increase in throughput.