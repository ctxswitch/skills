# Unsafe, Security, and Performance

Use this reference for unsafe code, FFI, raw pointers, atomics, serialization, external input, secrets, filesystem/process/network boundaries, allocation, hot paths, memory layout, and performance-sensitive code.

## Unsafe Stance

- Prefer safe Rust. Unsafe is a boundary for invariants the compiler cannot check, not a performance decoration.
- Every unsafe block should be small, justified, and surrounded by safe code that enforces its preconditions.
- Public unsafe functions and unsafe traits need a `# Safety` section documenting caller or implementer obligations.
- Safe APIs wrapping unsafe internals must be sound for every safe caller.
- Enable or respect `unsafe_op_in_unsafe_fn` when present: unsafe operations inside unsafe functions should still sit in explicit unsafe blocks.
- Do not add `unsafe impl Send` or `unsafe impl Sync` without a concrete thread-safety proof.

## Raw Pointers, Layout, and FFI

- Raw pointer dereference requires validity, alignment, initialization, aliasing, lifetime, and provenance reasoning.
- Respect aliasing: do not create mutable access while shared references can observe the same data.
- Use `MaybeUninit` for uninitialized memory; do not use invalid zeroed values for types that cannot be zero.
- Be careful with `repr(C)`, `repr(transparent)`, padding, alignment, and enum layout when crossing FFI or serialization boundaries.
- FFI boundaries must define ownership transfer, allocation/freeing side, nullability, string encoding, thread affinity, panic behavior, and error reporting.
- Panics should not unwind across FFI boundaries.

## External Input and Serialization

- Treat network data, files, env vars, CLI args, database rows, JSON/YAML/TOML, binary protocols, and FFI inputs as untrusted.
- Validate size, format, ranges, enum values, path targets, version fields, and resource limits before use.
- Avoid deserializing into overly permissive structures when unknown fields or defaults can hide mistakes.
- Use `deny_unknown_fields`, custom validators, or domain constructors when the format requires strictness.
- Avoid `serde(untagged)` when ambiguous variants can parse incorrectly.
- Bound recursion, nesting, allocation, and decompression where inputs can be large or adversarial.

## Filesystem, Process, and Network Boundaries

- Avoid path traversal. Normalize or validate paths relative to intended roots when accepting user-controlled paths.
- Be deliberate with symlinks, permissions, temp files, and atomic writes.
- Do not pass untrusted strings through a shell. Prefer command APIs with argument arrays.
- Set timeouts and resource limits for external processes and network calls when hangs matter.
- Do not log secrets from env vars, headers, configs, tokens, credentials, or connection strings.
- Client-side or local checks are not authorization; enforce permissions at trusted boundaries.

## Performance

- Optimize measured or plausible hot paths, not cosmetic micro-costs.
- Watch allocation in loops: `to_string`, `format!`, `collect`, cloning, boxing, dynamic dispatch, regex compilation, and repeated parsing.
- Prefer borrowing and streaming for large inputs.
- Use `with_capacity` when final size is known or bounded and allocation dominates.
- Avoid unnecessary synchronization in hot paths.
- Avoid holding locks while doing expensive work or IO.
- Use `Cow`, arenas, interning, smallvec, bytes, or specialized data structures only when the tradeoff is justified and local convention supports it.
- Benchmarks should use stable inputs, avoid optimizing away work, and measure the actual operation.

## Atomics and Memory Ordering

- Prefer locks/channels when they make correctness obvious.
- If using atomics, state the invariant and why the ordering is sufficient.
- `Relaxed` only provides atomicity for that variable, not ordering of other memory.
- Avoid lock-free code unless contention, latency, or allocation constraints justify the complexity.

## Common Findings

- Unsafe block lacks a documented invariant or is larger than necessary.
- Safe function can trigger UB through an unsafe internal assumption.
- `unsafe impl Send/Sync` has no proof.
- FFI boundary does not specify ownership, nullability, or panic behavior.
- Untrusted input can cause path traversal, unbounded allocation, recursion, or ambiguous deserialization.
- Secret appears in logs/errors.
- Hot path repeatedly allocates, clones, compiles regexes, or holds locks during IO.
- Atomic ordering is weaker than the data dependency requires.
