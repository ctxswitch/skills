# Refactoring While Green

Use this after tests pass.

## Rule

Never refactor while red. First make the behavior pass, then improve structure with tests protecting the behavior.

## Refactor Candidates

Look for:

- duplication that represents the same concept
- long functions with mixed responsibilities
- shallow modules that mostly pass data through
- scattered rules for one domain concept
- feature envy: logic living far from the data or capability it governs
- primitive obsession where a named value object would protect invariants
- test setup that reveals the public interface is awkward
- code the new behavior made harder to understand

## Safe Refactor Loop

1. Pick one structural improvement.
2. Make the smallest coherent edit.
3. Run the focused tests.
4. Continue only while green.

Do not combine behavioral changes and refactors in the same step when avoidable.

## Refactor Output

When reporting, separate:

- behavior added or fixed
- tests added or changed
- refactors made while green
- tests run
