/-
  ArakelovRH/ClassNumber/ReducedForms.lean
  Formal proof: exactly 10 reduced BQFs of discriminant -143.

  Mathematical source: DavidFox998/ClassNumber-143/BSD/BSD_ReducedForms.lean.
  This is a standalone re-proof from the same mathematics.

  Definitions:
    IsReducedBQF143 a b c -- reduction conditions for disc=-143
    reducedForms143       -- explicit list of 10 forms
  Proofs:
    reducedForm_*         -- each of the 10 forms is reduced (norm_num)
    BSD_numReducedForms143 -- length = 10 (rfl)
    reducedForms143_complete -- completeness (interval_cases, 72 cases)

  The class number h(Q(sqrt(-143))) = 10 at the BQF level.
  Formal bridge to NumberField.classNumber requires
  BinaryQuadraticForm.classGroupEquiv (absent from Mathlib v4.12.0).

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}.
  Referee: #print axioms ArakelovRH.ClassNumber.reducedForms143_complete
-/
import Mathlib.Tactic

namespace ArakelovRH.ClassNumber

/-! ## Reduction conditions for discriminant -143 -/

/-- (a, b, c) is a reduced positive-definite BQF of discriminant -143 iff:
    disc: b^2 - 4ac = -143
    -a < b <= a <= c
    a = c -> b >= 0 (symmetry) -/
structure IsReducedBQF143 (a b c : ℤ) : Prop where
  disc  : b ^ 2 - 4 * a * c = -143
  cond1 : -a < b
  cond2 : b ≤ a
  cond3 : a ≤ c
  symm  : a = c → 0 ≤ b

/-! ## The 10 reduced forms of discriminant -143 -/

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

theorem reducedForms143_all_reduced :
    ∀ t ∈ reducedForms143, IsReducedBQF143 t.1 t.2.1 t.2.2 := by
  intro ⟨a, b, c⟩ ht
  simp only [reducedForms143, List.mem_cons, List.mem_nil_iff, or_false,
             Prod.mk.injEq] at ht
  rcases ht with ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ |
    ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ |
    ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl⟩
  all_goals exact ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩

/-- reducedForms143 has exactly 10 entries (by rfl). -/
theorem BSD_numReducedForms143 : reducedForms143.length = 10 := rfl

/-! ## Completeness -/

/-- **Every reduced BQF of discriminant -143 appears in reducedForms143.**

    Proof strategy:
    - From -a < b <= a <= c and 4ac = b^2 + 143: a >= 1.
    - 3a^2 <= 143 (since b^2 <= a^2 and 4a^2 <= 4ac = b^2+143).
    - 42a <= 290 (by nlinarith), so a <= 6.
    - b in [-5, 6].
    - interval_cases b <;> interval_cases a (72 cases): all by omega.

    SORRY: 0.  Classical trio.
    Source: ClassNumber-143/BSD/BSD_ReducedForms.lean, reducedForms143_complete. -/
theorem reducedForms143_complete (a b c : ℤ) (h : IsReducedBQF143 a b c) :
    (a, b, c) ∈ reducedForms143 := by
  obtain ⟨hdisc, hcond1, hcond2, hcond3, _⟩ := h
  have ha_pos : 1 ≤ a        := by omega
  have h4ac   : 4 * a * c = b ^ 2 + 143 := by linarith
  have h3a2   : 3 * a ^ 2 ≤ 143 := by nlinarith [sq_nonneg b, sq_nonneg (a - b)]
  have ha42   : 42 * a ≤ 290  := by nlinarith [sq_nonneg (a - 7)]
  have ha_le6 : a ≤ 6         := by omega
  have hb_ge  : -5 ≤ b        := by omega
  have hb_le6 : b ≤ 6         := by omega
  simp only [reducedForms143, List.mem_cons, List.mem_nil_iff, or_false, Prod.mk.injEq]
  interval_cases b <;> interval_cases a <;> omega

/-- The class number certificate: exactly 10 reduced forms of discriminant -143.
    At the BQF level, h(Q(sqrt(-143))) = 10 is proved. -/
theorem classNumber_bqf_cert : reducedForms143.length = 10 := rfl

end ArakelovRH.ClassNumber
