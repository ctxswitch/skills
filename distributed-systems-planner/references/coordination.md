# Coordination, Time, Locks, and Elections

Use this for clocks, ordering, distributed locks, leader election, mutual exclusion, leases, and coordinator designs.

## Table of Contents

- Physical clocks
- Logical clocks
- Mutual exclusion
- Leases and fencing
- Election
- Ordering
- Coordination decision rule

## Physical Clocks

Physical clocks drift and can move due to synchronization corrections.

Best practices:

- Use monotonic clocks for durations, deadlines, and retry timing.
- Use wall clocks for human/audit time, not correctness ordering, unless bounded skew is enforced.
- Monitor clock skew and alert before it violates lease or timestamp assumptions.
- Include deterministic tie-breakers for timestamp ordering.

Review prompts:

- Does correctness depend on wall-clock order?
- What max skew is assumed?
- Are clocks monotonic?
- Can a process pause longer than a lease?
- How are leap seconds/time jumps handled?
- Is NTP/GPS/chrony configured and monitored?

Red flags:

- Last-writer-wins with physical timestamps and no skew bound.
- Lease safety based only on local wall time.
- Security token expiry used as ordering mechanism.
- Audit order inferred solely from timestamps.

## Logical Clocks

Lamport clocks:

- Capture happened-before.
- Provide a total order with tie-breaker.
- Do not prove concurrency.

Vector clocks:

- Detect causality and concurrency.
- Metadata grows with participants.

Review prompts:

- Do you need real time or causal order?
- Is concurrency detection required?
- Can metadata be compacted safely?
- Are clock domains mixed incorrectly?

Best practices:

- Use Lamport clocks when total ordering compatible with happened-before is enough.
- Use vector clocks when detecting concurrency matters.
- Keep logical-clock metadata scoped to the smallest useful domain.
- Define metadata compaction and garbage-collection rules explicitly.

## Mutual Exclusion

Patterns:

- Centralized coordinator.
- Distributed voting.
- Token ring.
- Lease-based lock.
- Consensus-backed lock.

Review prompts:

- What resource is protected?
- Is every mutation path protected?
- What happens if holder crashes or pauses?
- Can lock expiry create two holders?
- Does the protected resource enforce fencing tokens?
- Is fairness required?

Rule:

- A distributed lock without fencing is usually insufficient for protecting external resources.

Best practices:

- Prefer single-writer ownership, database constraints, compare-and-swap, or queued serialization before distributed locks.
- If using locks, require the protected resource to reject stale fencing tokens.
- Keep lock scope narrow and lock duration bounded.
- Define behavior for holder crash, holder pause, network partition, and renewal failure.

## Leases and Fencing

Leases allow time-bounded ownership. Fencing tokens prevent stale owners from acting after losing ownership.

Safe lease design requires:

- bounded clock drift or monotonic time assumptions
- max pause assumptions
- renewal protocol
- fencing token checked by protected resource
- clear behavior under partition

Review prompts:

- Is the token monotonically increasing?
- Does storage/resource reject stale tokens?
- Can a paused holder resume and write?

## Election

Election chooses a coordinator or leader.

Review prompts:

- What triggers election?
- How is failure detected?
- Is election tied to a term/epoch?
- Can two candidates both win under partition?
- Do clients learn the new leader safely?
- Is state transfer complete before leadership starts?

Red flags:

- Leader identity without epoch/fencing.
- Heartbeat timeout treated as proof of failure.
- Split-brain not tested.
- New leader serves before catching up.

Best practices:

- Attach a monotonically increasing term or epoch to leadership.
- Make clients and storage reject stale epochs.
- Require quorum-backed leadership for write authority.
- Gate write serving on log/state catch-up.
- Emit leader changes and election duration as first-class telemetry.

## Ordering

Ordering mechanisms:

- single sequencer
- consensus log
- total-order multicast
- partition-local sequence numbers
- causal dependencies
- physical timestamps

Review prompts:

- Is order global or per key/partition/session?
- What breaks if messages are delivered out of order?
- Are order and durability coupled?
- Does failover preserve sequence continuity?

Best practices:

- State whether order is global, per partition, per key, per producer, or per session.
- Use one sequencer or consensus log for total order.
- Use partition keys to align ordering with invariants.
- Include sequence numbers for consumers that must reject gaps or stale events.

## Coordination Decision Rule

Use coordination when:

- uniqueness must be exact
- a global invariant must always hold
- externally visible ordering must be total
- irreversible side effects must be serialized
- two writers cannot both succeed

Avoid coordination when:

- operations commute
- stale reads are acceptable
- conflicts can be merged or surfaced
- availability/latency dominate and invariants are local
