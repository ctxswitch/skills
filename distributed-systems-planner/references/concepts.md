# Distributed Systems Concept Map

Use this when you need the broad Tanenbaum-style map before planning or reviewing.

## Table of Contents

- Definition and goals
- Architecture
- Processes and communication
- Naming
- Synchronization
- Replication and consistency
- Fault tolerance
- Security
- Cross-cutting review lens

## Definition and Goals

A distributed system is a collection of independent computers that appears as a single coherent system. Analyze both sides: the physical reality of independent nodes and the illusion the system presents.

Core goals:

- Resource sharing: expose data, compute, devices, or services across nodes.
- Transparency: hide access, location, migration, replication, concurrency, or failure where useful.
- Openness: specify interoperable interfaces and protocols.
- Scalability: scale by size, geography, and administrative domain.

Review concerns:

- Which transparency is promised, and where does it break?
- Is hiding distribution useful, or does it hide latency/failure/correctness uncertainty the caller needs?
- What centralized mechanism limits scale?
- Which assumptions change across regions or organizations?

## Architecture

Common styles:

- Layered: clean abstraction boundaries, but risk of leaky layers and hidden distributed calls.
- Object-based/RPC: familiar interfaces, but remote calls can become chatty and failure-prone.
- Data-centered: shared repository simplifies integration, but can become a bottleneck and coupling point.
- Event-based: decouples producers and consumers, but requires schema/version/order discipline.

System forms:

- Centralized client-server: simpler coordination, higher bottleneck and single-failure risk.
- Decentralized peer-to-peer/DHT: scalable and autonomous, harder membership, trust, routing, and debugging.
- Hybrid: central control plane plus distributed data plane; review failure of each separately.

## Processes and Communication

Processes, threads, clients, servers, virtualization, clusters, and code migration define where execution happens and how concurrency is handled.

Communication styles:

- RPC: convenient, but must specify timeout/retry/duplicate semantics.
- Persistent messaging: decouples time and location, but must specify durability, ordering, ack, dead-letter, and idempotency.
- Streams: optimize for latency/jitter/freshness, not only throughput.
- Multicast/gossip: useful for dissemination and membership, but convergence and duplicate handling matter.

Review concerns:

- Is the communication pattern compatible with latency and failure requirements?
- Are retries safe?
- Are messages ordered only per connection, queue, partition, key, group, or globally?
- Is backpressure defined end to end?

## Naming

Separate:

- Name: human/system reference.
- Identifier: stable identity.
- Address: access location.

Naming models:

- Flat naming: opaque IDs need lookup/routing.
- Structured naming: hierarchical namespaces need delegation and cache rules.
- Attribute naming: directory/search results need freshness semantics.

Review concerns:

- Does identity survive movement?
- Can names be reused?
- Are lookup results cached, and for how long?
- What happens when an entity moves or is deleted?

## Synchronization

Physical clocks drift. Logical clocks order events.

Topics:

- Clock synchronization: NTP/GPS/skew/drift/leap seconds.
- Lamport clocks: order happened-before, but cannot fully detect concurrency.
- Vector clocks: detect causality/concurrency, with metadata cost.
- Mutual exclusion: coordinator, distributed voting, token ring, leases.
- Election: choose coordinators under failure.

Review concerns:

- Does correctness depend on wall time?
- Are leases safe under pauses and clock skew?
- Can two leaders exist under partition?
- Is the system ordering events or measuring elapsed time?

## Replication and Consistency

Replication improves latency, availability, and fault tolerance while creating consistency problems.

Consistency models:

- Linearizability: atomic operations respecting real time.
- Sequential consistency: one global order respecting process order.
- Causal consistency: causally related operations observed in order.
- FIFO consistency: writes from each process observed in order.
- Client-centric: monotonic reads, monotonic writes, read-your-writes, writes-follow-reads.
- Weak/release/entry consistency: synchronization defines when consistency is enforced.

Protocols:

- Primary-based: central write ordering, simpler, failover-sensitive.
- Replicated-write: writes go to multiple replicas, more conflict/order complexity.
- Quorum: read/write overlap controls freshness and conflict detection.
- Cache coherence: invalidation/update/check-on-use/check-on-commit.

Review concerns:

- What model is actually guaranteed, including caches and failover?
- Which replicas accept writes?
- Are conflicts possible and deterministically resolved?
- Do quorums overlap correctly?
- Are client sessions preserved across replicas?

## Fault Tolerance

Failure classes:

- Crash: component stops.
- Omission: send/receive missing.
- Timing: response too early/late.
- Response: wrong value/state transition.
- Byzantine: arbitrary or malicious behavior.

Mechanisms:

- Redundancy: information, time, physical/process.
- Process groups: primary-backup or active replication.
- Reliable communication: at-least-once, at-most-once, maybe.
- Reliable multicast and atomic multicast.
- Distributed commit: 2PC blocks under coordinator failure; 3PC reduces blocking under assumptions.
- Recovery: checkpointing, distributed snapshots, message logging, stable storage.

Review concerns:

- Which failure model is assumed?
- Are dependencies replicated too?
- What happens after timeout?
- Can recovery replay side effects?
- Is failover correctness tested, not just liveness?

## Security

Distributed security requires identity, secure channels, authorization, key management, and policy consistency across nodes.

Review concerns:

- What are the principals and trust boundaries?
- Are service-to-service calls authenticated and authorized?
- Are credentials rotated and revoked?
- Are group keys updated on membership change?
- Does cached authorization go stale?

## Cross-Cutting Review Lens

For any operation, identify:

- caller and callee
- idempotency key
- timeout behavior
- retry behavior
- durability point
- visibility point
- ordering rule
- authorization point
- recovery behavior
- observable signals

For any invariant, identify:

- scope: local, shard, region, global
- operations that can violate it
- required coordination
- partition behavior
- repair/compensation path
