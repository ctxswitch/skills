# Rust

Each row is code you would type by reflex. The reflex is wrong; write the third column instead.

| Reflex | Why it is wrong | Instead |
|---|---|---|
| `.unwrap()` on input, a parse, an env var, a file, or the network | Panics on the first bad input | `?` with context |
| `match m.lock() { Err(_) => return Err(...) }` | Recovery code for a state the caller cannot produce | `.lock().expect("invariant: ...")` |
| `.map_err(\|e\| e.to_string())` low in the stack | Callers can no longer match | Keep the typed error; convert once at the boundary |
| `.context("...")` at every layer | Redundant | Once, at the operation with a name: path, key, service |
| `.clone()` to satisfy the borrow checker | Hides an ownership problem | Fix the borrow; clone only when small or deliberate |
| `Arc<Mutex<T>>` by reflex | Shared mutable state nobody asked for | A single owner and message passing; a lock only where contention exists |
| `fn f<T: Send + Sync + 'static>` by habit | Rejects valid callers | Only the bounds the body needs |
| `#[derive(Debug, Clone, Default, PartialEq, Eq, Hash, PartialOrd, Ord)]` on every type | Derives nothing uses | Derive what a caller in the diff uses |
| A newtype, builder, or sealed trait for a value with one use | One caller | The plain type |
| A generic or `dyn Trait` before a second concrete type exists | One implementation | The concrete type |
| `std::sync::MutexGuard` held across `.await` | Deadlocks the runtime | Drop before the await, or `tokio::sync::Mutex` |
| `tokio::spawn(...)` with the `JoinHandle` dropped | Hides the panic | Await the handle, or say in the code where its error goes |
| `std::fs`, CPU-heavy work, or a sync client in an `async fn` | Stalls the executor | `spawn_blocking` |
| `AtomicUsize` with `Relaxed` to coordinate | No ordering | A lock or channel, unless the ordering argument is written down |
| `#![allow(clippy::...)]` at crate level | Masks the lint everywhere | `#[allow]` at the site, with the reason |
| `unsafe impl Send for T {}` | Unsound without a proof | Write the proof or do not write the impl |
| `anyhow`, `thiserror`, `tracing` added to a crate that does not use them | Dependency churn | What the workspace already uses |
| A dependency added to the workspace root | Wrong crate | The crate that uses it |
| `proptest`, `trybuild`, `cargo fuzz` in a crate without that infrastructure | Infrastructure for one test | Only where the crate already has it |
| `/// Does X.` on every new `pub` item in a crate with none | Density rule | Where the crate already has them |
| Editing `Cargo.lock` | Regenerated over | Cargo |
