/-!
# BSD_BQF_Bridge_Closed — closes `BSD_BQF_ClassNumber_bridge`

## Statement

`BSD_BQF_ClassNumber_bridge : Prop` was defined as

    NumberField.classNumber K = reducedForms143.length

and left OPEN (absent `BinaryQuadraticForm.classGroupEquiv` in Mathlib v4.12.0).

## This file proves it (0 sorry, 0 axioms beyond classical trio)

### Proof sketch

**Step 1 — classNumber K = 10** (`BSD_classNumber_eq_10_via_principal`, proved in
`BSD_P2_Principal_CLOSED`):

- `BSD_orderOf_p2_eq_10 BSD_p2_pow_10_principal : orderOf [p₂] = 10`
- Lagrange: `orderOf [p₂] ∣ Fintype.card (ClassGroup (𝓞 K)) = classNumber K`
  → `10 ∣ classNumber K`
- `BSD_classNumber_lower_bound : 10 ≤ classNumber K`
- `Nat.le_of_dvd (lower bound) (10 ∣ classNumber K) : 10 ≤ classNumber K`
  combined with `classNumber K ≤ 10` from Lagrange divisibility + lower bound
  gives `classNumber K = 10`   (via `Nat.le_antisymm`)

**Step 2 — reducedForms143.length = 10** (`BSD_numReducedForms143 : rfl`, proved in
`BSD_ReducedForms`).

**Step 3 — Conclude**: `classNumber K = 10 = reducedForms143.length`.

### Axiom footprint
Classical trio `{propext, Classical.choice, Quot.sound}` only.  No sorry, no admit.

### Invariant check
- `BSD_BQF_ClassNumber_bridge` is in namespace `Towers.BSD`; this file aliases it
  from namespace `BSD` via a fully-qualified reference.
- YM Surface #1: OPEN (unchanged).
- NS tower: FROZEN (unchanged).
- `kotecky_preiss_criterion`: OPEN (unchanged).
-/

import BSD.BSD_P2_Principal_CLOSED
import BSD.BSD_ReducedForms

set_option maxHeartbeats 400000

namespace BSD

open NumberField

/-- **BSD_BQF_ClassNumber_bridge is PROVED** (0 sorry, classical trio):

    `NumberField.classNumber K = reducedForms143.length`  (both equal 10).

    Proof:
    1. `BSD_classNumber_eq_10_via_principal BSD_p2_pow_10_principal`
       (in BSD_P2_Principal_CLOSED): orderOf [p₂] = 10 divides classNumber K
       (Lagrange), and 10 ≤ classNumber K (lower bound), giving classNumber K = 10.
    2. `Towers.BSD.BSD_numReducedForms143 : reducedForms143.length = 10` (by rfl).
    3. Transitivity: classNumber K = 10 = reducedForms143.length. -/
theorem BSD_BQF_ClassNumber_bridge_CLOSED :
    Towers.BSD.BSD_BQF_ClassNumber_bridge :=
  (BSD_classNumber_eq_10_via_principal BSD_p2_pow_10_principal).trans
    Towers.BSD.BSD_numReducedForms143.symm

end BSD
