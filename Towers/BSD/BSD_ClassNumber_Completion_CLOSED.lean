import Towers.BSD.BSD_ClassNum_Upper_CLOSED
import Towers.BSD.BSD_NormFormBounds
import Towers.BSD.BSD_ClassNumberBounds
import Towers.BSD.BSD_ReducedForms

/-!
# BSD_ClassNumber_Completion_CLOSED — Milestone 5.5: Class-number sub-surface closures

Five `_OPEN` sub-surfaces discharged from `NumberField.classNumber K = 10`,
which was proved unconditionally in `BSD_ClassNum_Upper_CLOSED.lean` (Milestone 5.2).

## Mathematical content

| Surface | Statement | Source |
|---------|-----------|--------|
| `BSD_ClassNumber_Upper_CLOSED` | `classNumber K ≤ 10` | `BSD_classNumber_K_10.le` |
| `BSD_ClassNumber_Lower_CLOSED` | `10 ≤ classNumber K` | `BSD_classNumber_K_10.symm.le` |
| `BSD_classGroupCard_le_10_CLOSED` | `classNumber K ≤ 10` | same |
| `BSD_BQF_ClassNumber_bridge_CLOSED` | `classNumber K = reducedForms143.length` | numerical: both = 10 |
| `K1_Upper_Gate_CLOSED` | `K1_ClassNumber_Upper_BSD` | gate alias |
| `K1_Lower_Gate_CLOSED` | `K1_ClassNumber_Lower_BSD` | gate alias |

**Honesty note on `BSD_BQF_ClassNumber_bridge_CLOSED`:**
This proves the NUMERICAL equality (both sides = 10), NOT the Gauss–Dirichlet
structural bijection `BinaryQuadraticForm.classGroupEquiv` — which is absent
from Mathlib v4.12.0. The two counts are independently certified:
  - classNumber K = 10: via ClassGroup API + norm-form impossibility chain
  - reducedForms143.length = 10: by `rfl` (explicit list of 10 reduced BQFs)

## SORRY: 0   ## AXIOMS: classical trio only
-/

namespace Towers.BSD

/-- **CLOSED — ClassNumber upper bound** (Milestone 5.5):
    `NumberField.classNumber K ≤ 10`.

    Proof: `K1_ClassNumber_Upper_CLOSED` (BSD_ClassNum_Upper_CLOSED, M5.2),
    which derives from `BSD_classNumber_K_10 : classNumber K = 10`. -/
theorem BSD_ClassNumber_Upper_CLOSED : BSD_ClassNumber_Upper_OPEN :=
  K1_ClassNumber_Upper_CLOSED

/-- **CLOSED — ClassNumber lower bound** (Milestone 5.5):
    `10 ≤ NumberField.classNumber K`.

    Proof: `K1_ClassNumber_Lower_CLOSED` (BSD_ClassNum_Upper_CLOSED, M5.2),
    which derives from `BSD_classNumber_K_10 : classNumber K = 10`. -/
theorem BSD_ClassNumber_Lower_CLOSED : BSD_ClassNumber_Lower_OPEN :=
  K1_ClassNumber_Lower_CLOSED

/-- **CLOSED — classGroupCard ≤ 10** (Milestone 5.5):
    `NumberField.classNumber K ≤ 10`.

    Same bound as `BSD_ClassNumber_Upper_CLOSED`; different surface name from
    `BSD_ClassNumberBounds.lean`. -/
theorem BSD_classGroupCard_le_10_CLOSED : BSD_classGroupCard_le_10_OPEN :=
  K1_ClassNumber_Upper_CLOSED

/-- **CLOSED — BQF class-number bridge** (Milestone 5.5):
    `NumberField.classNumber K = reducedForms143.length`.

    Proof: both sides equal 10.
      `BSD_classNumber_K_10  : classNumber K = 10`      (M5.2, ClassGroup API)
      `BSD_numReducedForms143 : reducedForms143.length = 10` (by rfl, explicit list)
    Hence `classNumber K = reducedForms143.length` by transitivity.

    **Honest caveat**: this is a verified NUMERICAL equality. The deeper structural
    fact — that classNumber K equals the number of reduced forms via the Gauss–
    Dirichlet bijection — requires `BinaryQuadraticForm.classGroupEquiv` which is
    absent from Mathlib v4.12.0. -/
theorem BSD_BQF_ClassNumber_bridge_CLOSED : BSD_BQF_ClassNumber_bridge_OPEN :=
  BSD_classNumber_K_10.trans BSD_numReducedForms143.symm

/-- **CLOSED — K1_Upper gate** (Milestone 5.5):
    The named gate `K1_ClassNumber_Upper_BSD` (classNumber K ≤ 10) is discharged. -/
theorem K1_Upper_Gate_CLOSED : K1_ClassNumber_Upper_BSD :=
  K1_ClassNumber_Upper_CLOSED

/-- **CLOSED — K1_Lower gate** (Milestone 5.5):
    The named gate `K1_ClassNumber_Lower_BSD` (10 ≤ classNumber K) is discharged. -/
theorem K1_Lower_Gate_CLOSED : K1_ClassNumber_Lower_BSD :=
  K1_ClassNumber_Lower_CLOSED

/-- **Milestone 5.5 classNumber surface ledger**: all 6 sub-surfaces closed.
    No sorry, classical trio only. -/
theorem BSD_ClassNumber_completion_CLOSED :
    BSD_ClassNumber_Upper_OPEN ∧
    BSD_ClassNumber_Lower_OPEN ∧
    BSD_classGroupCard_le_10_OPEN ∧
    BSD_BQF_ClassNumber_bridge_OPEN ∧
    K1_ClassNumber_Upper_BSD ∧
    K1_ClassNumber_Lower_BSD :=
  ⟨K1_ClassNumber_Upper_CLOSED,
   K1_ClassNumber_Lower_CLOSED,
   K1_ClassNumber_Upper_CLOSED,
   BSD_classNumber_K_10.trans BSD_numReducedForms143.symm,
   K1_ClassNumber_Upper_CLOSED,
   K1_ClassNumber_Lower_CLOSED⟩

/-- Open surface count for classNumber completion: 0 (all 6 closed at Milestone 5.5). -/
def BSD_classNumber_completion_open_count : ℕ := 0

end Towers.BSD
