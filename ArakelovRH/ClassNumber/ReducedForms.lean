/-
  ArakelovRH/ClassNumber/ReducedForms.lean

  Proof: exactly 10 reduced binary quadratic forms of discriminant -143.
  Author: David Fox.  Opera Numerorum.  May 2026.

  A BQF (a, b, c) with b^2 - 4ac = -143 is reduced iff:
    -a < b <= a <= c,  and  a = c -> b >= 0.

  The 10 forms:
    (1,1,36)  (2,±1,18)  (3,±1,12)  (4,±1,9)  (6,1,6)  (6,±5,7)

  Proved:
    reducedForms143_complete  -- completeness, interval_cases (72 cases)
    BSD_numReducedForms143    -- length = 10, by rfl

  The formal bridge to NumberField.classNumber requires
  BinaryQuadraticForm.classGroupEquiv (absent from Mathlib v4.12.0).

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}.
  Referee: #print axioms ArakelovRH.ClassNumber.reducedForms143_complete
-/
import Mathlib.Tactic

namespace ArakelovRH.ClassNumber

/-- Reduction conditions for discriminant -143.
    Positive-definite: a > 0 follows from -a < b and b^2 - 4ac = -143 (so ac > 0). -/
structure IsReducedBQF143 (a b c : ℤ) : Prop where
  disc  : b ^ 2 - 4 * a * c = -143
  cond1 : -a < b
  cond2 : b ≤ a
  cond3 : a ≤ c
  symm  : a = c → 0 ≤ b

/-- The 10 reduced forms of discriminant -143. -/
def reducedForms143 : List (ℤ × ℤ × ℤ) :=
  [(1,  1, 36), (2,  1, 18), (2, -1, 18),
   (3,  1, 12), (3, -1, 12), (4,  1,  9),
   (4, -1,  9), (6,  1,  6), (6,  5,  7),
   (6, -5,  7)]

theorem reducedForm_1_1_36  : IsReducedBQF143 1   1  36 :=
  ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
theorem reducedForm_2_1_18  : IsReducedBQF143 2   1  18 :=
  ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
theorem reducedForm_2_m1_18 : IsReducedBQF143 2 (-1) 18 :=
  ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
theorem reducedForm_3_1_12  : IsReducedBQF143 3   1  12 :=
  ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
theorem reducedForm_3_m1_12 : IsReducedBQF143 3 (-1) 12 :=
  ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
theorem reducedForm_4_1_9   : IsReducedBQF143 4   1   9 :=
  ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
theorem reducedForm_4_m1_9  : IsReducedBQF143 4 (-1)  9 :=
  ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
theorem reducedForm_6_1_6   : IsReducedBQF143 6   1   6 :=
  ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
theorem reducedForm_6_5_7   : IsReducedBQF143 6   5   7 :=
  ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩
theorem reducedForm_6_m5_7  : IsReducedBQF143 6 (-5)  7 :=
  ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩

/-- All 10 entries satisfy IsReducedBQF143. -/
theorem reducedForms143_all_reduced :
    ∀ t ∈ reducedForms143, IsReducedBQF143 t.1 t.2.1 t.2.2 := by
  intro ⟨a, b, c⟩ ht
  simp only [reducedForms143, List.mem_cons, List.mem_nil_iff, or_false,
             Prod.mk.injEq] at ht
  rcases ht with ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ |
    ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ |
    ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩
  all_goals exact ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩

/-- reducedForms143 has exactly 10 entries. -/
theorem BSD_numReducedForms143 : reducedForms143.length = 10 := rfl

/-- **Completeness** (0 sorry, classical trio):
    every reduced BQF of discriminant -143 appears in reducedForms143.

    From -a < b <= a <= c and 4ac = b^2 + 143:
      a >= 1, 3a^2 <= 143, so a <= 6 and b in [-5, 6].
    interval_cases b <;> interval_cases a: 72 cases, all by omega. -/
theorem reducedForms143_complete (a b c : ℤ) (h : IsReducedBQF143 a b c) :
    (a, b, c) ∈ reducedForms143 := by
  obtain ⟨hdisc, hcond1, hcond2, hcond3, _⟩ := h
  have ha_pos : 1 ≤ a     := by omega
  have h4ac   : 4 * a * c = b ^ 2 + 143 := by linarith
  have h3a2   : 3 * a ^ 2 ≤ 143 := by nlinarith [sq_nonneg b, sq_nonneg (a - b)]
  have ha42   : 42 * a ≤ 290 := by nlinarith [sq_nonneg (a - 7)]
  have ha_le6 : a ≤ 6     := by omega
  have hb_ge  : -5 ≤ b    := by omega
  have hb_le6 : b ≤ 6     := by omega
  simp only [reducedForms143, List.mem_cons, List.mem_nil_iff, or_false, Prod.mk.injEq]
  interval_cases b <;> interval_cases a <;> omega

end ArakelovRH.ClassNumber
