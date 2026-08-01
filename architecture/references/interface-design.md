# Interface Design

When the user wants to explore alternative interfaces for a chosen deepening candidate, use this parallel sub-agent pattern. Based on "Design It Twice" (Ousterhout) — your first idea is unlikely to be the best.

Uses the vocabulary in [language.md](./language.md) — **module**, **interface**, **seam**, **adapter**, **leverage**.

## Process

### 1. Frame the problem space

Before spawning sub-agents, write a user-facing explanation of the problem space for the chosen candidate:

- The constraints any new interface would need to satisfy
- The dependencies it would rely on, and which category they fall into (see [deepening.md](./deepening.md))
- A rough illustrative code sketch to ground the constraints — not a proposal, just a way to make the constraints concrete

Show this to the user, then immediately proceed to Step 2.

### 2. Produce three or more radically different designs

Each design must be genuinely different in shape, not the same interface with renamed methods. Converging on one idea and varying it cosmetically is the default failure here — the point of designing it twice is that the first shape is rarely the best one.

If the harness supports parallel sub-agents, fan the variants out and give each its own technical brief (file paths, coupling details, dependency category from [deepening.md](./deepening.md), what sits behind the seam) plus one design constraint. Otherwise work through the constraints in sequence, committing to each fully before moving on.

The constraints:

- **Minimal** — 1–3 entry points max. Maximise leverage per entry point.
- **Flexible** — support many use cases and extension.
- **Common-caller** — make the default case trivial.
- **Ports & adapters** — if the module has cross-seam dependencies.

Use both [language.md](./language.md) vocabulary and `CONTEXT.md` vocabulary so every design names things consistently with the architecture language and the project's domain language.

Each design states:

1. Interface (types, methods, params — plus invariants, ordering, error modes)
2. Usage example showing how callers use it
3. What the implementation hides behind the seam
4. Dependency strategy and adapters (see [deepening.md](./deepening.md))
5. Trade-offs — where leverage is high, where it's thin

### 3. Present and compare

Present designs sequentially so the user can absorb each one, then compare them in prose. Contrast by **depth** (leverage at the interface), **locality** (where change concentrates), and **seam placement**.

After comparing, give your own recommendation: which design you think is strongest and why. If elements from different designs would combine well, propose a hybrid. Be opinionated — the user wants a strong read, not a menu.
