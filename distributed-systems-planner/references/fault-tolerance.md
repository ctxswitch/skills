# Fault Tolerance, Reliable Communication, Commit, and Recovery

Use this for failure models, retries, RPC semantics, process groups, reliable multicast, distributed commit, checkpointing, recovery, and durability.

## Table of Contents

- Failure models
- Redundancy
- Reliable communication
- Process groups
- Reliable group communication
- Distributed commit
- Recovery
- Common failure findings
- Test cases

## Failure Models

Crash failure:

- Component stops and emits no more output.

Omission failure:

- Component fails to send or receive expected messages.

Timing failure:

- Component responds outside required time bounds.

Response failure:

- Component responds with wrong value or wrong state transition.

Byzantine failure:

- Component behaves arbitrarily or maliciously.

Review prompts:

- Which failure model does the design assume?
- Which failures are realistic in production?
- What failures are detected, masked, retried, or exposed?

Best practices:

- State the assumed failure model explicitly.
- Design for omission, timing, and response failures, not only crashes, when using networks and dependencies.
- Avoid claiming Byzantine tolerance unless authentication, quorum sizes, and adversarial behavior are actually handled.
- Keep redundant components in independent failure domains.
- Verify dependencies are redundant too; replicated app nodes over one database are not fully redundant.

## Redundancy

Information redundancy:

- extra data for error detection/correction

Time redundancy:

- retry the operation

Physical/process redundancy:

- extra nodes/processes/replicas

Review prompts:

- Are redundant components independent?
- Do replicas share a failure domain?
- Does redundancy cover dependencies, not just app processes?

## Reliable Communication

RPC semantics:

- Maybe: call may execute or not.
- At-least-once: call executes one or more times.
- At-most-once: call executes zero or one times.
- Exactly-once: usually requires idempotency, durable dedupe, and careful recovery; treat claims skeptically.

Review prompts:

- What does timeout mean?
- Can a lost reply follow a committed operation?
- Are retries automatic?
- Is dedupe durable across restart?
- Are operations idempotent?

Best practices:

- Treat client timeout as unknown outcome.
- Use durable idempotency keys for mutating operations.
- Store dedupe records in the same consistency boundary as the mutation.
- Make retry policies bounded and observable.
- Return operation status by operation ID when outcomes can be delayed.

## Process Groups

Primary-backup:

- Simple, but primary failover and backup lag matter.

Active replication:

- Replicas process same requests.
- Requires deterministic execution and ordered delivery.

Review prompts:

- How is group membership managed?
- Are views consistent?
- How does a new member catch up?
- Can replicas process nondeterministic operations differently?

Best practices:

- Use primary-backup when simple ordering is more important than write availability during failover.
- Use active replication only for deterministic state machines with ordered input.
- Order membership changes with messages that depend on membership.
- Define how new replicas catch up before serving.

## Reliable Group Communication

Reliable multicast:

- group members receive messages despite loss/retransmission

Atomic multicast:

- group members receive messages in same order

Review prompts:

- Is delivery reliable, ordered, or both?
- Are membership changes ordered with messages?
- How are missed messages replayed?
- Does ACK/retransmit scale?

## Distributed Commit

Two-phase commit:

- Coordinator asks participants to vote.
- If all vote yes, coordinator commits.
- Can block if coordinator fails after yes votes before decision is known.

Three-phase commit:

- Adds precommit state to avoid some blocking under fail-stop assumptions.
- Less common in practice.

Review prompts:

- What is durably logged before vote/decision?
- Can participants block while holding locks?
- Is coordinator replicated/recoverable?
- What happens if participant recovers after decision?
- Are all resource managers actually transactional?

Best practices:

- Force durable logs before votes and final decisions.
- Minimize lock hold time during commit.
- Avoid 2PC across independently owned services unless blocking and operational recovery are acceptable.
- Prefer sagas or compensation only when temporary invariant violation is acceptable.
- Document recovery action for every coordinator and participant state.

## Recovery

Backward recovery:

- restore prior correct state from checkpoint/log

Forward recovery:

- move from erroneous state to a new correct state

Techniques:

- stable storage
- checkpointing
- distributed snapshots
- message logging
- replay
- recovery lines

Review prompts:

- What state is checkpointed?
- Are checkpoints globally consistent?
- What inputs/messages must be logged?
- Are external side effects replay-safe?
- Can recovery cause duplicate sends?
- Is recovery order specified?

Best practices:

- Define the durable commit point and recovery source of truth.
- Use write-ahead logging or equivalent before external acknowledgment.
- Keep external side effects behind idempotent receivers, outboxes, or ledgers.
- Test crash points across receive, validate, write, publish, side effect, and ack.
- Verify restored state against distributed invariants, not only local checksums.

## Common Failure Findings

Acknowledged data loss:

- Ack before durable write/quorum.

Duplicate side effect:

- Retry/replay resends non-idempotent external call.

Blocked transaction:

- 2PC participant waits forever for coordinator recovery.

False failure detection:

- Slow process treated as dead, causing split brain.

Inconsistent recovery:

- Process restores local state that is incompatible with other nodes.

## Test Cases

- crash before ack
- crash after commit before reply
- retry after timeout
- duplicate request after restart
- primary crash during replication
- backup promotion with lag
- coordinator crash in each 2PC phase
- lost multicast message
- recovery from checkpoint with in-flight messages
