# Async and Concurrency

Use this reference for async Rust, Tokio, tasks, channels, locks, cancellation, timeouts, threads, `Send`/`Sync`, shared state, atomics, and blocking work.

## Core Stance

- Know the runtime. Tokio, async-std, smol, embedded executors, and sync thread pools have different APIs and constraints.
- Async work must have ownership: who starts it, cancels it, observes failure, and waits for cleanup.
- Prefer message passing or owned state transitions before shared mutable state.
- Use shared locks deliberately and keep lock scopes short.
- Do not block async executor threads with CPU-heavy work, filesystem-heavy work, synchronous network calls, or long mutex waits.
- Treat cancellation as normal control flow. Dropping a future can stop it at any `.await`.

## Futures and Tasks

- Futures are lazy until polled. Creating a future does not start work unless it is awaited, spawned, or driven by the runtime.
- Await task handles when the task result matters. Dropped join handles can hide panics or errors depending on runtime behavior.
- Spawned tasks usually need `'static` captures. Prefer moving owned values in deliberately instead of forcing lifetimes or globals.
- Avoid fire-and-forget tasks unless there is a supervisor, shutdown path, error reporting, and clear ownership.
- Use structured concurrency patterns where available: scopes, join sets, cancellation tokens, select loops with shutdown branches.
- Be explicit about task names/spans when observability matters.

## Cancellation, Timeouts, and Shutdown

- Add cancellation or stale-result guards for request-scoped work, watchers, retries, background tasks, and UI/service request handling.
- Use timeouts around external systems when unbounded waits would consume resources or block shutdown.
- Ensure cleanup runs when a future is dropped. RAII helps, but async cleanup may require explicit shutdown.
- In `select!`-style code, consider branch cancellation safety. Some operations lose progress when cancelled.
- Shutdown should stop intake, signal workers, wait within a bounded period, and surface unfinished work according to product semantics.

## Shared State and Locks

- Use `Arc<T>` for shared ownership across tasks/threads. Add `Mutex`, `RwLock`, atomics, or channels only for the actual synchronization need.
- Prefer `tokio::sync::Mutex` or async-aware primitives when a lock is held across `.await`; prefer `std::sync::Mutex` only for short, non-async critical sections.
- Do not hold a lock across `.await` unless the primitive and design explicitly support it and the critical section must span the await.
- Avoid nested locks or inconsistent lock ordering.
- Remember lock poisoning for `std::sync` locks. Decide whether poisoning should fail, recover, or be impossible.
- `RwLock` helps only when read-heavy access dominates and writer starvation/priority behavior is acceptable.

## Send, Sync, and Interior Mutability

- `Send` means a value can move to another thread. `Sync` means shared references can be used from multiple threads.
- Do not add `Send + Sync + 'static` bounds by habit. They are public API constraints.
- `Rc`, `RefCell`, and raw pointers are usually not cross-thread. Use them only in single-threaded contexts or behind clear boundaries.
- `Cell`/`RefCell` move borrow checking to runtime; use them for local interior mutability, not as a shortcut around design.
- Atomics require a clear memory-ordering reason. Prefer channels/locks unless atomic state is genuinely simpler.

## Blocking and CPU Work

- Use runtime-specific blocking pools for CPU-heavy or blocking IO work inside async services.
- Avoid synchronous DNS, filesystem walks, compression, crypto, JSON processing of huge payloads, or subprocess waits on executor threads.
- Apply backpressure to unbounded task spawning, channels, queues, and streams.
- Avoid unbounded buffering of request bodies, stream items, or channel messages.

## Common Findings

- Spawned task errors or panics are never observed.
- Request-scoped async work has no cancellation or stale-result guard.
- `std::sync::MutexGuard` or another blocking guard is held across `.await`.
- Blocking IO/CPU work runs on an async executor thread.
- Channel or task spawning is unbounded.
- `Send + Sync + 'static` bound rejects valid callers without need.
- Shutdown signal stops intake but leaves workers running.
- Atomic ordering is chosen without a correctness argument.
