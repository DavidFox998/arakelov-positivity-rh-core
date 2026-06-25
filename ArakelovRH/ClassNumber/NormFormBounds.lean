/-
  ArakelovRH/ClassNumber/NormFormBounds.lean

  Norm-form impossibilities for K = Q(sqrt(-143)).
  Author: David Fox.  Opera Numerorum.  May 2026.

  O_K = Z[omega], omega = (1+sqrt(-143))/2, omega^2 = omega - 36.
  Norm: N(a + b*omega) = a^2 + ab + 36b^2.  Discriminant: -143.
  Key: 4*N(a,b) = (2a+b)^2 + 143*b^2.

  Proved (nlinarith + interval_cases, 0 sorry):
    norm_form_no_norm_two/three/five/seven
    minkowski_norm_impossibilities  (bundle)
    prime_2_splits, prime_3_splits, prime_5_inert, prime_7_splits  (decide)
    norm_form_gen_1024  (generator certificate: (-28)^2+(-28)*3+36*3^2 = 2^10)

  Minkowski bound (2/pi)*sqrt(143) < 8:
    every ideal class has norm-<=7 representative;
    only norms 1 and 4 achievable => only p_2 contributes non-principal classes.

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}.
  Referee: #print axioms ArakelovRH.ClassNumber.minkowski_norm_impossibilities
-/
import Mathlib.Tactic

namespace ArakelovRH.ClassNumber

/-- N(a + b*omega) = a^2 + ab + 36b^2.  Discriminant: 1 - 4*36 = -143. -/
def normForm (a b : ℤ) : ℤ := a ^ 2 + a * b + 36 * b ^ 2

/-- 4*normForm(a,b) = (2a+b)^2 + 143*b^2.  Proved by ring. -/
theorem normForm_four_eq (a b : ℤ) :
    4 * normForm a b = (2 * a + b) ^ 2 + 143 * b ^ 2 := by
  unfold normForm; ring

private lemma one_le_sq_of_ne_zero {n : ℤ} (hn : n ≠ 0) : 1 ≤ n ^ 2 := by
  rcases lt_or_gt_of_ne hn with h | h
  · nlinarith [sq_nonneg (n + 1)]
  · nlinarith [sq_nonneg (n - 1)]

/-- normForm(a,b) ≠ 2.
    4*N = (2a+b)^2 + 143*b^2 = 8.  b = 0: a^2 = 2, impossible. -/
theorem norm_form_no_norm_two (a b : ℤ) : normForm a b ≠ 2 := by
  intro h
  have heq : (2 * a + b) ^ 2 + 143 * b ^ 2 = 8 := by
    have := normForm_four_eq a b; linarith
  have hb : b = 0 := by
    by_contra hb'; nlinarith [one_le_sq_of_ne_zero hb', sq_nonneg (2 * a + b)]
  subst hb
  simp only [normForm, mul_zero, sq (0:ℤ), mul_zero, add_zero] at h
  have ha_le : a ≤ 1 := by nlinarith [sq_nonneg (a - 1)]
  have ha_ge : -1 ≤ a := by nlinarith [sq_nonneg (a + 1)]
  interval_cases a <;> norm_num at h

/-- normForm(a,b) ≠ 3.
    4*N = (2a+b)^2 + 143*b^2 = 12.  b = 0: a^2 = 3, impossible. -/
theorem norm_form_no_norm_three (a b : ℤ) : normForm a b ≠ 3 := by
  intro h
  have heq : (2 * a + b) ^ 2 + 143 * b ^ 2 = 12 := by
    have := normForm_four_eq a b; linarith
  have hb : b = 0 := by
    by_contra hb'; nlinarith [one_le_sq_of_ne_zero hb', sq_nonneg (2 * a + b)]
  subst hb
  simp only [normForm, mul_zero, sq (0:ℤ), mul_zero, add_zero] at h
  have ha_le : a ≤ 1 := by nlinarith [sq_nonneg (a - 2)]
  have ha_ge : -1 ≤ a := by nlinarith [sq_nonneg (a + 2)]
  interval_cases a <;> norm_num at h

/-- normForm(a,b) ≠ 5.
    4*N = (2a+b)^2 + 143*b^2 = 20.  b = 0: a^2 = 5, impossible. -/
theorem norm_form_no_norm_five (a b : ℤ) : normForm a b ≠ 5 := by
  intro h
  have heq : (2 * a + b) ^ 2 + 143 * b ^ 2 = 20 := by
    have := normForm_four_eq a b; linarith
  have hb : b = 0 := by
    by_contra hb'; nlinarith [one_le_sq_of_ne_zero hb', sq_nonneg (2 * a + b)]
  subst hb
  simp only [normForm, mul_zero, sq (0:ℤ), mul_zero, add_zero] at h
  have ha_le : a ≤ 2 := by nlinarith [sq_nonneg (a - 3)]
  have ha_ge : -2 ≤ a := by nlinarith [sq_nonneg (a + 3)]
  interval_cases a <;> norm_num at h

/-- normForm(a,b) ≠ 7.
    4*N = (2a+b)^2 + 143*b^2 = 28.  b = 0: a^2 = 7, impossible. -/
theorem norm_form_no_norm_seven (a b : ℤ) : normForm a b ≠ 7 := by
  intro h
  have heq : (2 * a + b) ^ 2 + 143 * b ^ 2 = 28 := by
    have := normForm_four_eq a b; linarith
  have hb : b = 0 := by
    by_contra hb'; nlinarith [one_le_sq_of_ne_zero hb', sq_nonneg (2 * a + b)]
  subst hb
  simp only [normForm, mul_zero, sq (0:ℤ), mul_zero, add_zero] at h
  have ha_le : a ≤ 2 := by nlinarith [sq_nonneg (a - 3)]
  have ha_ge : -2 ≤ a := by nlinarith [sq_nonneg (a + 3)]
  interval_cases a <;> norm_num at h

/-- Bundle: normForm cannot equal 2, 3, 5, or 7.
    Consequence: in the Minkowski bound analysis for K = Q(sqrt(-143)),
    only norms 1 and 4 are achievable, so only p_2 gives non-principal classes. -/
theorem minkowski_norm_impossibilities :
    (∀ a b : ℤ, normForm a b ≠ 2) ∧
    (∀ a b : ℤ, normForm a b ≠ 3) ∧
    (∀ a b : ℤ, normForm a b ≠ 5) ∧
    (∀ a b : ℤ, normForm a b ≠ 7) :=
  ⟨norm_form_no_norm_two, norm_form_no_norm_three,
   norm_form_no_norm_five, norm_form_no_norm_seven⟩

/-- p = 2 splits in Q(sqrt(-143)): t^2 - t + 36 ≡ 0 (mod 2) has root t = 0. -/
theorem prime_2_splits : ∃ x : ZMod 2, x ^ 2 - x + 36 = 0 := by decide

/-- p = 3 splits in Q(sqrt(-143)): t^2 - t + 36 ≡ 0 (mod 3) has root t = 0. -/
theorem prime_3_splits : ∃ x : ZMod 3, x ^ 2 - x + 36 = 0 := by decide

/-- p = 5 is inert in Q(sqrt(-143)): t^2 - t + 36 ≡ 0 (mod 5) has no root. -/
theorem prime_5_inert : ∀ x : ZMod 5, x ^ 2 - x + 36 ≠ 0 := by decide

/-- p = 7 splits in Q(sqrt(-143)): t^2 - t + 36 ≡ 0 (mod 7) has root t = 3. -/
theorem prime_7_splits : ∃ x : ZMod 7, x ^ 2 - x + 36 = 0 := by decide

/-- Generator certificate for p_2^10:
    (-28)^2 + (-28)*3 + 36*3^2 = 1024 = 2^10.
    This pins down span{gen_OK} = p_2^10 in O_K. -/
theorem norm_form_gen_1024 : (-28 : ℤ) ^ 2 + (-28) * 3 + 36 * 3 ^ 2 = 1024 := by norm_num

end ArakelovRH.ClassNumber
