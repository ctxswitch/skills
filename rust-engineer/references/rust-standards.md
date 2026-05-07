# Rust Standards

Use this reference for Rust source, crate/module structure, public APIs, ownership, borrowing, traits, generics, lifetimes, iterators, and type design.

## Core Stance

- Let ownership express the program's invariants. Prefer a clear owner, borrowed views, and small value types over shared mutable state.
- Start with the simplest correct shape: concrete types before generics, borrowing before cloning, enums before trait objects, safe Rust before unsafe.
- Match local style, edition, module layout, visibility, error strategy, and feature usage.
- Public APIs carry semver weight. Treat exported structs, enums, traits, type aliases, functions, feature flags, and error variants as contracts.
- Use the type system to make invalid states unrepresentable when it reduces real runtime checks.
- Avoid clever lifetime or trait-bound designs unless they simplify the caller's code.
- Keep unsafe-free code unsafe-free unless the requested behavior truly requires an unsafe boundary.

## Ownership and Borrowing

- Accept borrowed data when the function only reads it: `&str` over `&String`, `&[T]` over `&Vec<T>`, `&Path` over `&PathBuf`.
- Return owned values when the result is newly constructed, independent of inputs, or must outlive the borrowed source.
- Avoid cloning to appease the borrow checker until you understand the ownership model. A clone is fine when data is small, shared deliberately, or it removes worse complexity.
- Keep mutable borrows short. Use smaller scopes, helper functions, or `split_at_mut`-style APIs to express disjoint mutation.
- Avoid storing references in structs unless the struct is a true borrowed view. Owned data is usually simpler for long-lived domain objects.
- Prefer `Cow<'a, T>` only when both borrowed and owned paths are common and the allocation savings matter.
- Use `Arc` for shared ownership across threads/tasks, `Rc` for single-thread shared ownership, and interior mutability only when mutation through shared references is part of the design.

## Types and APIs

- Prefer domain newtypes for IDs, tokens, units, validated strings, and values with constraints.
- Use enums for closed sets, state machines, parse results, and variant-specific data.
- Avoid boolean flag pairs when a small enum or options struct communicates intent better.
- Constructors should be inherent methods. Use `new` when there is one obvious construction path; use `with_*` or builders when configuration is non-trivial.
- Validate constructor arguments before constructing an invalid value.
- Public structs should usually have private fields unless callers are meant to construct them freely.
- Implement common traits when meaningful: `Debug`, `Clone`, `Copy`, `Default`, `Eq`, `Hash`, `Ord`, `Display`, `From`, `TryFrom`, `AsRef`, `Borrow`, `Iterator`, `IntoIterator`.
- Do not implement traits with surprising semantics just to satisfy a bound.

## Traits and Generics

- Prefer generic parameters when callers should keep static dispatch and the implementation is independent of the concrete type.
- Prefer trait objects when runtime heterogeneity, object safety, or smaller compile-time/code-size impact matters.
- Put trait bounds where they are used, commonly in a `where` clause for readability.
- Do not over-constrain types. Require `Clone`, `Send`, `Sync`, `'static`, `Debug`, or `Default` only when the implementation actually needs it.
- Use sealed traits when downstream implementations would constrain future evolution or require hidden invariants.
- Keep trait methods object-safe if trait objects are a plausible use case.
- Avoid blanket impls that can conflict with future downstream or upstream implementations.

## Modules and Visibility

- Keep modules cohesive: domain types, parsing, IO boundaries, adapters, and orchestration should not be tangled without need.
- Use `pub(crate)` or private items by default. Export only the API intended for callers.
- Prefer explicit re-exports from crate roots or prelude modules when that is the crate's convention.
- Avoid cyclic module dependencies and "god" utility modules.
- Keep top-level initialization minimal. Work should happen in functions, builders, or runtime setup.
- Do not deep-import private modules from sibling crates; use exported contracts.

## Iterators and Collections

- Prefer iterator adapters when they make flow clearer; use loops when branching, mutation, early exits, or error handling is clearer.
- Avoid collecting just to iterate again unless ownership, sorting, deduplication, or reuse requires it.
- Pick collection types for semantics: `Vec` for order, `HashMap`/`BTreeMap` for lookup/order, `HashSet` for uniqueness, `VecDeque` for queue behavior.
- Use `entry` APIs to avoid duplicate lookups.
- Keep allocation visible. Avoid hidden `to_string`, `format!`, `collect`, and clone calls in hot loops unless acceptable.

## Common Findings

- `clone`, `Arc`, `Mutex`, or lifetime annotations hide an ownership design issue.
- Public API takes `&String`, `&Vec<T>`, or `PathBuf` where a borrowed abstraction would work.
- Type allows invalid states that every caller must remember to check.
- Trait bound is broader than needed and rejects valid callers.
- Error, enum, or public struct variant is changed without considering semver.
- Module exports leak implementation details or bypass crate boundaries.
- Iterator chain is less clear than a loop with explicit error handling.
- Safe code depends on a hidden invariant that should be represented by a type or constructor.
