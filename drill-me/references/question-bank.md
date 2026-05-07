# Question Bank

Use this when the user asks for a batch, a mock interview, or a broad readiness drill. Prefer one question at a time during normal sessions.

## System Shape

- What is the authoritative owner for each mutable piece of state?
- Which calls are synchronous on the user-visible path?
- Which work is async, and what tells the user it completed?
- Where does backpressure apply when downstream capacity drops?
- What degrades first under overload?

## Guarantees

- What exact consistency guarantee does this workflow need?
- Which reads are allowed to be stale, and for how long?
- Where is success acknowledged, and what is durable at that point?
- What operation can violate the most important invariant?
- If a network partition happens, do you preserve availability or the invariant?

## Communication

- What does a client timeout mean for a mutating operation?
- Is the retry safe, and where is the idempotency record stored?
- What is the ordering scope: global, per tenant, per entity, or none?
- Can poison messages block unrelated work?
- Can the event be published without the state change, or the state change without the event?

## Replication and Caches

- Which read path includes caches or replicas?
- How does the caller get read-your-writes behavior?
- What happens when two regions accept conflicting writes?
- How are deletes represented until every replica has seen them?
- How do you detect and repair divergence?

## Coordination

- What prevents two leaders from writing at the same time?
- Does the protected resource enforce fencing tokens?
- What happens if a process pauses past its lease and then resumes?
- How does a new leader prove it has caught up?
- What test demonstrates split-brain cannot corrupt state?

## Recovery

- Can an operation commit and then be forgotten?
- Can replay duplicate an external side effect?
- What state must be reconstructed before serving traffic?
- How does recovery know whether an in-flight operation committed?
- What is the manual repair path when automated reconciliation fails?

## Security

- Where is authorization checked relative to the state change?
- Does async work preserve caller authority or switch to service authority?
- How quickly does revocation take effect across caches and workers?
- What prevents cross-tenant reads through shared indexes, caches, or logs?
- What happens during key rotation with mixed versions?

## Operations

- What metric tells you the invariant is being violated?
- Can traces connect request, queue message, worker, database write, and external side effect?
- What failure is exercised before launch: timeout, duplicate, partition, failover, stale read, replay, or clock skew?
- Can the system run safely with mixed versions during deploy?
- What does the on-call do when reconciliation finds divergence?
