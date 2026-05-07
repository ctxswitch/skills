# Distributed Systems Security

Use this for trust boundaries, service authentication, authorization, secure channels, key management, group communication security, and stale policy issues.

## Table of Contents

- Security frame
- Threats
- Secure channels
- Authentication and authorization
- Key and secret management
- Group communication security
- Security and consistency
- Security findings pattern

## Security Frame

Distributed systems cross process, machine, network, region, and organization boundaries. Security must be enforced at each boundary, not only at the edge.

Best practices:

- Treat internal networks as untrusted unless there is a specific, verified reason not to.
- Authenticate workload-to-workload calls.
- Authorize at every service boundary that can access protected resources.
- Use least-privilege credentials with rotation and revocation paths.
- Keep security decisions consistent with replication/cache behavior.
- Preserve audit context across async boundaries.

Core questions:

- Who are the principals?
- What are the trust boundaries?
- What can each principal do?
- How is identity proven?
- How are messages protected?
- How are rights revoked?
- How do policies propagate?

## Threats

Consider:

- eavesdropping
- tampering
- replay
- impersonation
- unauthorized access
- privilege escalation
- stale authorization
- compromised node
- malicious peer
- metadata leakage
- denial of service

## Secure Channels

Review prompts:

- Is transport encrypted?
- Is peer identity authenticated?
- Are certificates/keys rotated?
- Is hostname/service identity verified?
- Are replay protections present?
- Are downgrade attacks prevented?

Common issues:

- TLS without identity verification.
- Shared credentials across services.
- Long-lived credentials with no rotation path.
- Logs expose secrets.

Best practices:

- Verify peer identity, not only encryption.
- Prefer short-lived credentials or certificates with automated rotation.
- Pin trust to service/workload identity where possible, not hostnames alone.
- Prevent replay when messages can be captured and resent.

## Authentication and Authorization

Review prompts:

- Is authentication end-user, service, workload, or node based?
- Is authorization checked at every service boundary?
- Are delegated permissions scoped and time-bound?
- Are cached auth decisions versioned or expired?
- What happens if policy store is unavailable?
- Does system fail open or closed?

Common issues:

- Edge authorization assumed by internal services.
- Background workers bypass checks.
- Stale policy permits revoked access.
- Cross-service calls lose user context.

Best practices:

- Use explicit delegated capabilities for async/background work.
- Version or TTL authorization caches.
- Define revocation latency and fail-open/fail-closed behavior.
- Keep authorization checks close to the protected resource.
- Test every read path after permission revocation.

## Key and Secret Management

Review prompts:

- Where are keys generated and stored?
- How are secrets distributed?
- How are they rotated?
- How is compromise contained?
- Are backups and logs protected?

Red flags:

- Static shared secrets in config.
- Manual rotation.
- No revocation path.
- Credentials copied into queues/events.

Best practices:

- Store secrets in a managed secret store, not config or images.
- Rotate credentials without synchronized global deploys.
- Scope credentials per service and environment.
- Audit secret access.
- Exclude secrets from logs, traces, queues, and dead letters.

## Group Communication Security

Review prompts:

- Who can join the group?
- How are group keys distributed?
- Are keys changed when members leave?
- Can old members read future messages?
- Can new members read old messages?

## Security and Consistency

Security decisions are distributed data too.

Review prompts:

- How fast must revocation take effect?
- Can authorization data be stale?
- Is permission state replicated?
- Does cache consistency match security requirements?
- Are audit logs ordered and tamper-evident?

High-risk mismatch:

- Product expects immediate revocation, but system uses eventually consistent policy caches.

Best practices:

- Use stronger consistency for permissions that must revoke immediately.
- If eventual policy propagation is accepted, expose and bound revocation delay.
- Include policy version in authorization decisions and logs.
- Make audit logs tamper-resistant and ordered enough for investigation.

## Security Findings Pattern

```markdown
Severity:
Boundary:
Principal:
Failure mode:
Exploit path:
Recommended control:
Verification:
```
