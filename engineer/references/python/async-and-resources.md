# Async and Resources

Use this when touching `asyncio`, concurrency, cancellation, files, network clients, database sessions, context managers, or cleanup.

## Table of Contents

- Async stance
- asyncio rules
- Cancellation and timeouts
- Task ownership
- Context managers
- File and network resources
- Database/session resources
- Common review findings

## Async Stance

- Prefer synchronous code unless concurrency is required by the caller, framework, or performance target.
- Do not mix blocking I/O into async functions without moving it to an executor/thread or using async-compatible clients.
- Make task lifetime and cancellation obvious.
- Avoid background work without ownership, logging, and shutdown behavior.

## asyncio Rules

- Await coroutines; calling an async function does not run it.
- Prefer high-level APIs.
- Use `asyncio.TaskGroup` when supported and structured concurrency is appropriate.
- Keep `asyncio.gather` behavior clear, especially failure and cancellation semantics.
- Do not create tasks and drop references unless there is a managed background-task registry.
- Name tasks when useful for debugging.

Compatibility:

- `TaskGroup` requires Python 3.11+.
- Check supported Python versions before using new async APIs.

## Cancellation and Timeouts

Rules:

- Treat cancellation as normal control flow in async code.
- Do not swallow `asyncio.CancelledError` unless you re-raise after cleanup.
- Use timeouts around external operations.
- Ensure cleanup runs in `finally` or context managers.
- Avoid retry loops that ignore cancellation.

Pattern:

```python
async def worker() -> None:
    try:
        await run_loop()
    finally:
        await cleanup()
```

## Task Ownership

Every background task should have:

- owner
- cancellation path
- exception handling
- lifecycle tied to app/session/request
- observability when it fails

Review red flags:

- `asyncio.create_task(...)` with ignored result
- task created in constructor/import path
- infinite loop without cancellation wait
- background task exceptions never observed
- tests rely on arbitrary sleeps

## Context Managers

Use context managers for:

- files
- locks
- temporary directories
- database transactions
- network sessions
- monkeypatching or mocks
- spans/traces if repo uses them

For async resources, use `async with` when the library provides it.

## File and Network Resources

Rules:

- Use `pathlib.Path` where consistent with the repo.
- Specify encoding for text file I/O when content is not intentionally platform-default.
- Close files and response bodies.
- Use timeouts on network clients.
- Avoid reading unbounded input into memory.
- Validate paths when accepting user input.
- Avoid path traversal by normalizing and checking containment.

## Database and Session Resources

Rules:

- Keep transactions scoped and explicit.
- Do not hold transactions across unrelated network calls.
- Roll back or close sessions on failure.
- Parameterize queries.
- Keep connection/session ownership clear.
- Avoid global sessions unless framework-managed.

## Common Review Findings

Dropped task:

- Problem: task can fail silently or outlive owner.
- Fix: use task group, await it, or register/manage lifecycle.

Swallowed cancellation:

- Problem: shutdown hangs or caller cannot cancel.
- Fix: re-raise after cleanup.

Blocking in async:

- Problem: synchronous I/O blocks event loop.
- Fix: use async client or executor.

Leaked resource:

- Problem: file/client/session not closed.
- Fix: use context manager or explicit close in `finally`.

Unbounded read:

- Problem: reads entire user-controlled input.
- Fix: stream, bound size, or validate before read.
