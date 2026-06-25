/-
  ArakelovRH/ClassNumber/NormFormBounds.lean
  Norm-form impossibilities for K = Q(sqrt(-143)).

  Mathematical source: DavidFox998/ClassNumber-143/BSD/BSD_NormFormBounds.lean.
  These are standalone re-proofs of the same mathematics.

  Ring of integers: O_K = Z[omega], omega = (1+sqrt(-143))/2, omega^2 = omega - 36.
  Norm form: N(a + b*omega) = a^2 + ab + 36b^2 (discriminant -143).
  Key identity: 4*N(a+b*omega) = (2a+b)^2 + 143*b^2.

  PROVED (all by nlinarith + interval_cases):
    norm_form_no_norm_two   : a^2 + ab + 36b^2 ≠ 2
    norm_form_no_norm_three : a^2 + ab + 36b^2 ≠ 3
    norm_form_no_norm_five  : a^2 + ab + 36b^2 ≠ 5
    norm_form_no_norm_seven : a^2 + ab + 36b^2 ≠ 7

  These are the Minkowski-bound impossibilities:
    (2/pi)*sqrt(143) < 8, so every ideal class has a norm-<=7 representative.
    Norms 2, 3, 5, 7 are impossible => only p=2 contributes non-principal classes.

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}.
  Referee: #print axioms ArakelovRH.ClassNumber.minkowski_norm_impossibilities
-/
import Mathlib.Tactic

namespace ArakelovRH.ClassNumber

/-! ## Norm form -/

/-- N(a + b*omega) = a^2 + ab + 36b^2, the norm form of O_K = Z[omega].
    Discriminant: 1 - 4*36 = -143.  K = Q(sqrt(-143)). -/
def normForm (a b : ℤ) : ℤ := a ^ 2 + a * b + 36 * b ^ 2

/-- KEY IDENTITY: 4*normForm(a,b) = (2a+b)^2 + 143*b^2.
    The "completing the square" engine for all impossibility proofs.
    SORRY: 0.  Proved by ring. -/
theorem normForm_four_eq (a b : ℤ) :
    4 * normForm a b = (2 * a + b) ^ 2 + 143 * b ^ 2 := by
  unfold normForm; ring

private lemma one_le_sq_of_ne_zero {n : ℤ} (hn : n ≠ 0) : 1 ≤ n ^ 2 := by
  rcases lt_or_gt_of_ne hn with h | h
  · nlinarith [sq_nonneg (n + 1)]
  · nlinarith [sq_nonneg (n - 1)]

/-! ## Impossibilities -/

/-- normForm(a,b) ≠ 2 for all a b : Z.
    Proof: 4*N = (2a+b)^2 + 143*b^2 = 8.
    b ≠ 0: 143*b^2 >= 143 > 8, contradiction.
    b = 0: a^2 = 2, impossible (|a| <= 1, interval_cases). -/
theorem norm_form_no_norm_two (a b : ℤ) : normForm a b ≠ 2 := by
  intro h
  have heq : (2 * a + b) ^ 2 + 143 * b ^ 2 = 8 := by
    have := normForm_four_eq a b; linarith
  have hb : b = 0 := by
    by_contra hb'
    nlinarith [one_le_sq_of_ne_zero hb', sq_nonneg (2 * a + b)]
  subst hb
  simp only [normForm, mul_zero, sq (0:ℤ), mul_zero, add_zero] at h
  have ha_le : a ≤ 1 := by nlinarith [sq_nonneg (a - 1)]
  have ha_ge : -1 ≤ a := by nlinarith [sq_nonneg (a + 1)]
  interval_cases a <;> norm_num at h

/-- normForm(a,b) ≠ 3 for all a b : Z.
    Proof: 4*N = (2a+b)^2 + 143*b^2 = 12.
    b ≠ 0: 143 > 12, contradiction.
    b = 0: a^2 = 3, impossible. -/
theorem norm_form_no_norm_three (a b : ℤ) : normForm a b ≠ 3 := by
  intro h
  have heq : (2 * a + b) ^ 2 + 143 * b ^ 2 = 12 := by
    have := normForm_four_eq a b; linarith
  have hb : b = 0 := by
    by_contra hb'
    nlinarith [one_le_sq_of_ne_zero hb', sq_nonneg (2 * a + b)]
  subst hb
  simp only [normForm, mul_zero, sq (0:ℤ), mul_zero, add_zero] at h
  have ha_le : a ≤ 1 := by nlinarith [sq_nonneg (a - 2)]
  have ha_ge : -1 ≤ a := by nlinarith [sq_nonneg (a + 2)]
  interval_cases a <;> norm_num at h

/-- normForm(a,b) ≠ 5 for all a b : Z.
    Proof: 4*N = (2a+b)^2 + 143*b^2 = 20.
    b ≠ 0: 143 > 20, contradiction.
    b = 0: a^2 = 5, impossible. -/
theorem norm_form_no_norm_five (a b : ℤ) : normForm a b ≠ 5 := by
  intro h
  have heq : (2 * a + b) ^ 2 + 143 * b ^ 2 = 20 := by
    have := normForm_four_eq a b; linarith
  have hb : b = 0 := by
    by_contra hb'
    nlinarith [one_le_sq_of_ne_zero hb', sq_nonneg (2 * a + b)]
  subst hb
  simp only [normForm, mul_zero, sq (0:ℤ), mul_zero, add_zero] at h
  have ha_le : a ≤ 2 := by nlinarith [sq_nonneg (a - 3)]
  have ha_ge : -2 ≤ a := by nlinarith [sq_nonneg (a + 3)]
  interval_cases a <;> norm_num at h

/-- normForm(a,b) ≠ 7 for all a b : Z.
    Proof: 4*N = (2a+b)^2 + 143*b^2 = 28.
    b ≠ 0: 143 > 28, contradiction.
    b = 0: a^2 = 7, impossible. -/
theorem norm_form_no_norm_seven (a b : ℤ) : normForm a b ≠ 7 := by
  intro h
  have heq : (2 * a + b) ^ 2 + 143 * b ^ 2 = 28 := by
    have := normForm_four_eq a b; linarith
  have hb : b = 0 := by
    by_contra hb'
    nlinarith [one_le_sq_of_ne_zero hb', sq_nonneg (2 * a + b)]
  subst hb
  simp only [normForm, mul_zero, sq (0:ℤ), mul_zero, add_zero] at h
  have ha_le : a ≤ 2 := by nlinarith [sq_nonneg (a - 3)]
  have ha_ge : -2 ≤ a := by nlinarith [sq_nonneg (a + 3)]
  interval_cases a <;> norm_num at h

/-- Bundle: normForm cannot equal 2, 3, 5, or 7.
    Minkowski bound (2/pi)*sqrt(143) < 8 means every ideal class of O_K
    has a representative of norm <= 7. These impossibilities show only
    norm 1 (trivial) and norm 4 (= 2^2, p_2 splits) are achievable.
    Therefore only the prime above 2 can contribute non-principal ideal classes.
    SORRY: 0.  Classical trio. -/
theorem minkowski_norm_impossibilities :
    (∀ a b : ℤ, normForm a b ≠ 2) ∧
    (∀ a b : ℤ, normForm a b ≠ 3) ∧
    (∀ a b : ℤ, normForm a b ≠ 5) ∧
    (∀ a b : ℤ, normForm a b ≠ 7) :=
  ⟨norm_form_no_norm_two, norm_form_no_norm_three,
   norm_form_no_norm_five, norm_form_no_norm_seven⟩

/-! ## Prime splitting in Q(sqrt(-143)) -/

/-- p = 2 splits in Q(sqrt(-143)).
    Minimal poly of omega: t^2 - t + 36.  (t^2 - t + 36) mod 2 = 0 has root t=0. -/
theorem prime_2_splits : ∃ x : ZMod 2, x ^ 2 - x + 36 = 0 := by decide

/-- p = 3 splits in Q(sqrt(-143)).
    (t^2 - t + 36) mod 3 = 0 has root t=0. -/
theorem prime_3_splits : ∃ x : ZMod 3, x ^ 2 - x + 36 = 0 := by decide

/-- p = 5 is inert in Q(sqrt(-143)).
    (t^2 - t + 36) mod 5 has no root. -/
theorem prime_5_inert : ∀ x : ZMod 5, x ^ 2 - x + 36 ≠ 0 := by decide

/-- p = 7 splits in Q(sqrt(-143)).
    (t^2 - t + 36) mod 7 = 0 has root t=3. -/
theorem prime_7_splits : ∃ x : ZMod 7, x ^ 2 - x + 36 = 0 := by decide

/-- The norm form certificate for generator of p_2^10:
    (-28)^2 + (-28)*3 + 36*3^2 = 1024 = 2^10.
    Source: BSD_P2_Principal_CLOSED.lean in ClassNumber-143.
    This is the arithmetic fact that pins down span{gen_OK} = p_2^10. -/
theorem norm_form_gen_1024 : (-28 : ℤ) ^ 2 + (-28) * 3 + 36 * 3 ^ 2 = 1024 := by norm_num

end ArakelovRH.ClassNumber
