# Typing and API Design

Use this when adding or reviewing type annotations, public APIs, dataclasses, protocols, generics, overloads, or mypy/pyright behavior.

## Table of Contents

- Typing stance
- Annotation rules
- Public API design
- Protocols and structural typing
- Dataclasses and typed dictionaries
- Generics and collections
- Runtime typing pitfalls
- Common review findings

## Typing Stance

- Type hints document intent and help tools catch errors; they should not make simple code obscure.
- Preserve the project's supported Python versions before using newer syntax.
- Prefer annotations at boundaries: public functions, constructors, complex return values, callbacks, and data models.
- Avoid annotating obvious locals unless it clarifies an empty collection, union, protocol, or type narrowing.
- Do not introduce strict type checking for the whole repo unless requested.

## Annotation Rules

- Use built-in generics (`list[str]`, `dict[str, int]`) when supported by the project's Python version.
- Use `collections.abc` for parameter types like `Sequence`, `Mapping`, `Iterable`, `Callable`.
- Prefer broad read-only protocols for inputs (`Mapping`, `Sequence`) and concrete return types for outputs when useful.
- Avoid `Any` unless there is a real dynamic boundary. Contain it near that boundary.
- Use `object` when accepting any value but not operating dynamically.
- Use `Optional[T]` or `T | None` only when `None` is a valid value.
- Avoid implicit optional behavior through sentinel values unless documented.
- Use `TypeAlias` for non-trivial aliases.

Empty collections:

```python
items: list[User] = []
by_id: dict[str, User] = {}
```

## Public API Design

API rules:

- Keep function signatures explicit and stable.
- Use keyword-only parameters for options that are easy to confuse.
- Avoid exposing internal implementation types.
- Return values should have a predictable shape.
- Avoid returning `None` for failure when exceptions or result objects are clearer.
- Avoid callbacks unless the extension point is real and stable.
- Do not expose a parameter only because one internal helper needs it.

Compatibility:

- Check supported Python versions before using syntax such as `X | Y`, `typing.Self`, `TypeVarTuple`, `ExceptionGroup`, or `asyncio.TaskGroup`.
- Check existing type checker and linter configuration before introducing patterns they reject.

## Protocols and Structural Typing

Use `Protocol` when:

- the consumer needs a narrow capability
- multiple concrete implementations are expected
- tests or adapters need a stable boundary
- the behavior is structural rather than inheritance-based

Avoid protocols when:

- one concrete class is owned and used internally
- the protocol mirrors a single class with no substitution need
- it exists only to make mocks easier

Protocol pattern:

```python
from typing import Protocol

class Clock(Protocol):
    def now(self) -> datetime: ...
```

## Dataclasses and Typed Dictionaries

Use dataclasses when:

- values have stable fields
- runtime instances benefit from attributes
- methods or validation may belong with the data
- equality/repr behavior is useful

Use `TypedDict` when:

- data remains a dictionary at runtime
- shape comes from JSON/API payloads
- values cross serialization boundaries

Review:

- Avoid mutable defaults in dataclasses; use `field(default_factory=list)`.
- Consider `frozen=True` for value objects.
- Keep validation explicit; dataclasses do not validate types at runtime.

## Generics and Collections

Input parameter guidance:

- Accept `Sequence[T]` instead of `list[T]` when mutation is not needed.
- Accept `Mapping[K, V]` instead of `dict[K, V]` when mutation is not needed.
- Accept `Iterable[T]` only when single-pass behavior is acceptable.

Return guidance:

- Return concrete containers when callers reasonably need normal operations.
- Do not expose internal mutable collections directly if callers could corrupt invariants.

Variance pitfall:

- Mutable collections are invariant. A `list[Child]` is not a `list[Parent]`.
- Use immutable/read-only abstractions such as `Sequence[Parent]` for input when possible.

## Runtime Typing Pitfalls

- Type annotations can create runtime imports. Use `TYPE_CHECKING` for type-only imports that would cause cycles or expensive imports.
- Forward references may need quotes or future annotations depending on Python version.
- Do not leave `reveal_type` or type-checker-only debugging calls in runtime code.
- Beware annotations evaluated at runtime in older versions.
- Do not use `cast()` to silence a real design problem; use it only at a boundary where runtime evidence exists.

## Common Review Findings

Unchecked dynamic boundary:

- Problem: JSON/API data enters as `dict[str, Any]` and spreads.
- Fix: parse/validate near boundary into typed shape.

Overly concrete input:

- Problem: function requires `list` but only reads.
- Fix: accept `Sequence` or `Iterable` depending on usage.

Protocol for mock only:

- Problem: protocol mirrors one class and has no domain boundary.
- Fix: use concrete type or define the boundary at the real consumer.

Missing return annotation:

- Problem: public function behavior unclear and type checker cannot check callers.
- Fix: annotate return and important parameters.

Runtime import cycle:

- Problem: type import breaks module import.
- Fix: use `TYPE_CHECKING` and postponed annotations when compatible.
