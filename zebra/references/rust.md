# Rust

Things that fail in Rust with no code added. Nothing else in the language is evidenced by construction.

- `unwrap` on external input, network data, file content, env vars, or a parse result panics on the first bad input. Return the error.
- `expect` with a message stating the invariant is the detection for a state the caller cannot produce: a poisoned lock, an impossible enum arm, a slot the type guarantees is filled. Do not write a `match` with an error arm for it.
- Indexing with `[]` panics on absence. That panic is the detection unless the absence is produced on an added line; then use `get`.
- Add error context once, at the call that has a name: path, key, service. Not at every layer. Do not stringify an error before a caller that needs to match on it.
- A future does nothing until awaited, spawned, or polled.
- A dropped `JoinHandle` hides the task's panic. Await it when the result matters.
- A `std::sync::MutexGuard` held across `.await` deadlocks the runtime. If the section must span an await, use `tokio::sync::Mutex` and ask why it must.
- Blocking I/O or CPU-heavy work on an executor thread stalls every task. Use the runtime's blocking pool.
- A dropped future stops at any `.await`. Cleanup on an added line must survive that.
- `clone`, `Arc`, `Mutex`, or a lifetime added to appease the borrow checker is usually an ownership design problem. Understand it before cloning. `Send + Sync + 'static` bounds added by habit are public constraints with no caller.
