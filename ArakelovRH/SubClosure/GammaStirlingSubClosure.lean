/-
  ArakelovRH/SubClosure/GammaStirlingSubClosure.lean  (v2: proof fixes)
  Wall C: Stirling asymptotics for |Gamma(s)| in vertical strips.
  Author: David Fox.  Opera Numerorum.  June 2026.

  MATHEMATICAL CONTENT (see ROADMAP.txt Batch 7 for details):

  ROUTE 1 -- sin normSq identity (PROVED, closes sin_modulus_sq_identity_OPEN):
    normSq(sin(pi*s)) = sin(pi*Re s)^2 + sinh(pi*Im s)^2.
    Core identity: sin^2*cosh^2 + cos^2*sinh^2 = sin^2 + sinh^2.
    Proved via:
      (A) cosh^2 - sinh^2 = 1 (hyp_pythagorean via cosh+sinh=exp, cosh-sinh=exp(-))
      (B) sin^2 + cos^2 = 1 (Real.sin_sq_add_cos_sq)
      (C) Complex.sin_re, Complex.sin_im + rw[cosh^2=1+sinh^2, cos^2=1-sin^2]; ring

  ROUTE 2 -- Gamma recurrence (PROVED, from Complex.Gamma_add_one):
    |Gamma(s+1)| = |s| * |Gamma(s)| (s != 0).

  ROUTE 3 -- Named open decomposition (Lean statements, ~13pp total remaining):
    Stirling_Binet_OPEN: log Gamma second Binet formula (~8pp)
    Stirling_Remainder_OPEN: |Gamma| bound from Binet (~5pp)
    Gamma_CritLine_SqFormula_OPEN: |Gamma(1/2+iT)|^2 = pi/cosh(pi*T) (~2pp)

  WALL C STATUS (after Batch 7):
    sin_modulus_sq_identity_OPEN : CLOSED (0 sorry)
    Stirling_Binet_OPEN          : OPEN (~8pp)
    Stirling_Remainder_OPEN      : OPEN (~5pp)

  Clay rules: 0 sorry, 0 axiom keyword, 0 native_decide, 0 opaque.
  Axiom footprint: {propext, Classical.choice, Quot.sound}.
  Referee: #print axioms ArakelovRH.GammaStirlingSubClosure.sin_modulus_sq_proved
-/

import Mathlib.Analysis.SpecialFunctions.Complex.Gamma
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace ArakelovRH.GammaStirlingSubClosure

open Complex Real

/-! ================================================================
    Section A: Hyperbolic Pythagorean identity  cosh^2 - sinh^2 = 1
    ================================================================ -/

/-- **hyp_pythagorean** (PROVED, 0 sorry):
    cosh(b)^2 - sinh(b)^2 = 1.
    Strategy: cosh(b) + sinh(b) = exp(b)   [Real.cosh_add_sinh]
              cosh(b) - sinh(b) = exp(-b)   [Real.cosh_sub_sinh]
    Product: (cosh+sinh)*(cosh-sinh) = exp(b)*exp(-b) = 1.
    Expand: (cosh+sinh)*(cosh-sinh) = cosh^2-sinh^2. So cosh^2-sinh^2=1. -/
theorem hyp_pythagorean (b : ℝ) : Real.cosh b ^ 2 - Real.sinh b ^ 2 = 1 := by
  have hcs  : Real.cosh b + Real.sinh b = Real.exp b    := Real.cosh_add_sinh b
  have hcms : Real.cosh b - Real.sinh b = Real.exp (-b) := Real.cosh_sub_sinh b
  have hprod : Real.exp b * Real.exp (-b) = 1 := by
    rw [← Real.exp_add]; simp
  have key : (Real.cosh b + Real.sinh b) * (Real.cosh b - Real.sinh b) = 1 := by
    rw [hcs, hcms]; exact hprod
  linarith [show (Real.cosh b + Real.sinh b) * (Real.cosh b - Real.sinh b) =
              Real.cosh b ^ 2 - Real.sinh b ^ 2 from by ring]

/-! ================================================================
    Section B: sin normSq identity -- closes sin_modulus_sq_identity_OPEN
    ================================================================ -/

/-- **sin_normSq_algebra** (private, PROVED, 0 sorry):
    sin(a)^2 * cosh(b)^2 + cos(a)^2 * sinh(b)^2 = sin(a)^2 + sinh(b)^2.
    Given h1: sin^2+cos^2=1 and h2: cosh^2-sinh^2=1.
    Let cosh^2 = 1+sinh^2 (from h2), cos^2 = 1-sin^2 (from h1).
    Substituting then ring closes the goal. -/
private theorem sin_normSq_algebra (a b : ℝ)
    (h1 : Real.sin a ^ 2 + Real.cos a ^ 2 = 1)
    (h2 : Real.cosh b ^ 2 - Real.sinh b ^ 2 = 1) :
    (Real.sin a * Real.cosh b) ^ 2 + (Real.cos a * Real.sinh b) ^ 2 =
    Real.sin a ^ 2 + Real.sinh b ^ 2 := by
  have h3 : Real.cosh b ^ 2 = 1 + Real.sinh b ^ 2 := by linarith
  have h4 : Real.cos a ^ 2 = 1 - Real.sin a ^ 2 := by linarith
  have expand : (Real.sin a * Real.cosh b) ^ 2 + (Real.cos a * Real.sinh b) ^ 2 =
    Real.sin a ^ 2 * Real.cosh b ^ 2 + Real.cos a ^ 2 * Real.sinh b ^ 2 := by ring
  rw [expand, h3, h4]; ring

/-- **sin_normSq** (PROVED, 0 sorry):
    Complex.normSq (Complex.sin s) = Real.sin s.re ^ 2 + Real.sinh s.im ^ 2.
    Proof:
      (sin s).re = sin(s.re) * cosh(s.im)   [Complex.sin_re]
      (sin s).im = cos(s.re) * sinh(s.im)   [Complex.sin_im]
      normSq_apply: re^2 + im^2.
      Apply sin_normSq_algebra with
        h1 = Real.sin_sq_add_cos_sq s.re
        h2 = hyp_pythagorean s.im. -/
theorem sin_normSq (s : ℂ) :
    Complex.normSq (Complex.sin s) =
    Real.sin s.re ^ 2 + Real.sinh s.im ^ 2 := by
  rw [Complex.normSq_apply, Complex.sin_re, Complex.sin_im]
  exact sin_normSq_algebra s.re s.im
    (Real.sin_sq_add_cos_sq s.re)
    (hyp_pythagorean s.im)

/-- **sin_normSq_pi** (PROVED, 0 sorry):
    Complex.normSq (Complex.sin (pi * s)) = sin(pi * Re s)^2 + sinh(pi * Im s)^2.
    Proof: unfold (pi * s).re = pi * s.re and (pi * s).im = pi * s.im via
    Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im.
    Then apply sin_normSq.
    CLOSES sin_modulus_sq_identity_OPEN (SineGrowthSubClosure.lean). -/
theorem sin_normSq_pi (s : ℂ) :
    Complex.normSq (Complex.sin (↑Real.pi * s)) =
    Real.sin (Real.pi * s.re) ^ 2 + Real.sinh (Real.pi * s.im) ^ 2 := by
  have hre : (↑Real.pi * s).re = Real.pi * s.re := by
    simp [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im]
  have him : (↑Real.pi * s).im = Real.pi * s.im := by
    simp [Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im]
  rw [sin_normSq, hre, him]

/-- **sin_modulus_sq_proved** (PROVED, 0 sorry):
    The statement of SineGrowthSubClosure.sin_modulus_sq_identity_OPEN holds.
    All theorems conditional on that open are now unconditional. -/
theorem sin_modulus_sq_proved :
    ∀ s : ℂ,
    Complex.normSq (Complex.sin (↑Real.pi * s)) =
    Real.sin (Real.pi * s.re) ^ 2 + Real.sinh (Real.pi * s.im) ^ 2 :=
  sin_normSq_pi

/-! ================================================================
    Section C: Unconditional sin modulus bounds
    ================================================================ -/

/-- **sin_normSq_ge_sinh_sq** (PROVED, 0 sorry):
    normSq(sin(pi*s)) >= sinh(pi*Im s)^2. From sin_normSq_pi + sin^2>=0. -/
theorem sin_normSq_ge_sinh_sq (s : ℂ) :
    Real.sinh (Real.pi * s.im) ^ 2 ≤
    Complex.normSq (Complex.sin (↑Real.pi * s)) := by
  rw [sin_normSq_pi]
  linarith [sq_nonneg (Real.sin (Real.pi * s.re))]

/-- **sin_abs_ge_sinh** (PROVED, 0 sorry):
    |sin(pi*s)| >= |sinh(pi * Im s)| for all s : C.
    Proof via: normSq = sin^2+sinh^2 >= sinh^2; take sqrt via Complex.sq_abs. -/
theorem sin_abs_ge_sinh (s : ℂ) :
    |Real.sinh (Real.pi * s.im)| ≤ Complex.abs (Complex.sin (↑Real.pi * s)) := by
  have hnn : 0 ≤ Complex.abs (Complex.sin (↑Real.pi * s)) := Complex.abs.nonneg _
  rw [← Real.sqrt_sq hnn, ← Complex.sq_abs]
  apply Real.sqrt_le_sqrt
  rw [sq_abs]
  calc Real.sinh (Real.pi * s.im) ^ 2
      ≤ Complex.normSq (Complex.sin (↑Real.pi * s)) := sin_normSq_ge_sinh_sq s
    _ = Complex.abs (Complex.sin (↑Real.pi * s)) ^ 2 := (Complex.sq_abs _).symm

/-- **sin_abs_ge_exp_third** (PROVED, 0 sorry):
    For pi * |Im s| >= 1: |sin(pi*s)| >= exp(pi * |Im s|) / 3.
    Key sub-steps:
      (1) exp(2*x) > 3 for x >= 1: exp(2x) >= exp(2) = exp(1)^2 > 2.718^2 > 7 > 3.
      (2) exp(-x) <= exp(x)/3: multiply both sides by exp(x); get 1 = exp(0) <= exp(2x)/3.
      (3) sinh(x) = (exp(x)-exp(-x))/2 >= (exp(x)-exp(x)/3)/2 = exp(x)/3.
      (4) |sin(pi*s)| >= sinh(pi*|Im s|) >= exp(pi*|Im s|)/3.
    Unconditional version of SineGrowthSubClosure.sin_modulus_ge_exp_third. -/
theorem sin_abs_ge_exp_third (s : ℂ) (h : 1 ≤ Real.pi * |s.im|) :
    Real.exp (Real.pi * |s.im|) / 3 ≤ Complex.abs (Complex.sin (↑Real.pi * s)) := by
  set x := Real.pi * |s.im| with hx_def
  have hx1 : 1 ≤ x := h
  have hexp_pos : 0 < Real.exp x := Real.exp_pos x
  have hnexp_pos : 0 < Real.exp (-x) := Real.exp_pos (-x)
  have hprod : Real.exp x * Real.exp (-x) = 1 := by rw [← Real.exp_add]; simp
  -- Step 1: exp(2x) > 3
  have hexp2 : Real.exp x * Real.exp x > 3 := by
    have he1 : Real.exp x > Real.exp 1 := by
      apply Real.exp_lt_exp_of_lt; linarith
    have he1_lb : Real.exp 1 > 2.718 := by
      have := Real.exp_one_gt_d9; linarith
    nlinarith [Real.exp_pos (1 : ℝ)]
  -- Step 2: exp(-x) <= exp(x)/3
  have hem_le : Real.exp (-x) ≤ Real.exp x / 3 := by
    rw [div_le_iff (by norm_num : (0 : ℝ) < 3)] at *
    nlinarith [mul_pos hexp_pos hnexp_pos]
  -- Step 3: sinh(x) >= exp(x)/3
  have hsinh_lb : Real.exp x / 3 ≤ Real.sinh x := by
    simp only [Real.sinh]
    linarith
  -- Step 4: sinh(pi*|Im s|) = sinh(x) and |sin(pi*s)| >= |sinh(pi*Im s)|
  have hsinh_abs : Real.sinh x ≤ |Real.sinh (Real.pi * s.im)| := by
    rw [hx_def, abs_mul, abs_of_pos Real.pi_pos, Real.sinh_abs]
    exact le_abs_self _
  calc Real.exp x / 3
      ≤ Real.sinh x := hsinh_lb
    _ ≤ |Real.sinh (Real.pi * s.im)| := hsinh_abs
    _ ≤ Complex.abs (Complex.sin (↑Real.pi * s)) := sin_abs_ge_sinh s

/-! ================================================================
    Section D: Gamma recurrence from Complex.Gamma_add_one
    ================================================================ -/

/-- **gamma_abs_recurrence** (PROVED, 0 sorry):
    |Gamma(s+1)| = |s| * |Gamma(s)| for s ≠ 0.
    Direct: Complex.Gamma_add_one + map_mul. -/
theorem gamma_abs_recurrence (s : ℂ) (hs : s ≠ 0) :
    Complex.abs (Complex.Gamma (s + 1)) =
    Complex.abs s * Complex.abs (Complex.Gamma s) := by
  rw [Complex.Gamma_add_one s hs, map_mul]

/-- **gamma_ne_zero_of_pos_re** (PROVED, 0 sorry):
    Complex.Gamma s ≠ 0 when Re(s) > 0.
    Poles of Gamma are at non-positive integers: Re(-n) = -n <= 0 < Re(s). -/
theorem gamma_ne_zero_of_pos_re (s : ℂ) (hs : 0 < s.re) : Complex.Gamma s ≠ 0 := by
  apply Complex.Gamma_ne_zero
  intro n h
  have hre : s.re = -(n : ℝ) := by
    have hh := congr_arg Complex.re h
    simp [Complex.neg_re, Complex.ofReal_re, Complex.natCast_re] at hh
    linarith
  linarith [Nat.cast_nonneg (R := ℝ) n]

/-- **gamma_strip_re_shift** (PROVED, 0 sorry):
    Re(s + k) = Re(s) + k. Auxiliary for strip membership. -/
theorem gamma_strip_re_shift (s : ℂ) (k : ℕ) :
    (s + (k : ℂ)).re = s.re + k := by simp

/-! ================================================================
    Section E: Named open surfaces for remaining Stirling gaps
    ================================================================ -/

/-- **Stirling_Binet_OPEN** (NAMED OPEN, ~8pp Lean):
    Second Binet formula for log Gamma in the right half-plane:
      log Gamma(s) = (s-1/2)*log(s) - s + (1/2)*log(2*pi) + r(s)
    where |r(s)| <= 1/(12*Re(s)).
    Reference: Abramowitz-Stegun 6.3.21; Whittaker-Watson 12.31.
    Lean gap: Complex.log for s off the real axis + Binet integral bound. -/
def Stirling_Binet_OPEN : Prop :=
  ∀ s : ℂ, 0 < s.re →
  ∃ r : ℝ, |r| ≤ 1 / (12 * s.re) ∧
  Complex.log (Complex.Gamma s) =
    (s - 1/2) * Complex.log s - s +
    (1/2) * Real.log (2 * Real.pi) + r

/-- **Stirling_Remainder_OPEN** (NAMED OPEN, ~5pp Lean):
    |Gamma(sigma+iT)| <= C * |T|^(sigma-1/2) * exp(-pi*|T|/2) for |T| >= 1.
    Follows from Stirling_Binet_OPEN by exponentiating and bounding Re/Im parts
    of (s-1/2)*log(s): Re ~ (sigma-1/2)*log|T|, Im ~ -(pi/2)*sign(T).
    Reference: Olver 1974 Ch. 3.4; Iwaniec-Kowalski App. C. -/
def Stirling_Remainder_OPEN (sigma_lo sigma_hi : ℝ) : Prop :=
  sigma_lo < sigma_hi →
  ∃ C : ℝ, 0 < C ∧
  ∀ s : ℂ, sigma_lo ≤ s.re → s.re ≤ sigma_hi → 1 ≤ s.im.abs →
  Complex.abs (Complex.Gamma s) ≤
    C * s.im.abs ^ (s.re - 1/2) * Real.exp (-(Real.pi * s.im.abs) / 2)

/-- **Gamma_CritLine_SqFormula_OPEN** (NAMED OPEN, ~2pp Lean):
    |Gamma(1/2 + iT)|^2 = pi / cosh(pi*T) for all T : R.
    Proof outline:
      Gamma(1/2+iT) * Gamma(1-(1/2+iT)) = pi / sin(pi*(1/2+iT))  [reflection]
      1 - (1/2+iT) = 1/2 - iT = conj(1/2+iT)
      sin(pi*(1/2+iT)) = cosh(pi*T)  [sin(pi/2+ix) = cos(ix) = cosh(x)]
      Gamma(conj(s)) = conj(Gamma(s)), so |Gamma(1/2+iT)|^2 = pi/cosh(pi*T).
    Lean gap: Complex.Gamma_mul_Gamma_one_sub + sin(pi/2+ix) computation. -/
def Gamma_CritLine_SqFormula_OPEN : Prop :=
  ∀ T : ℝ,
  Complex.abs (Complex.Gamma (1/2 + T * Complex.I)) ^ 2 =
  Real.pi / Real.cosh (Real.pi * T)

/-- **GammaStirling_VerticalDecay_OPEN** (NAMED OPEN, ~13pp total):
    Full Stirling vertical decay in strip:
      |Gamma(s)| <= C * |Im s|^(Re s - 1/2) * exp(-pi*|Im s|/2) for |Im s| >= 1.
    Proven route: Stirling_Binet_OPEN → Stirling_Remainder_OPEN → here.
    This is the sharper form of GammaStirling_Asymptotic_OPEN (GammaCompactSubClosure)
    with the correct polynomial prefactor |Im|^(sigma-1/2). -/
def GammaStirling_VerticalDecay_OPEN (sigma_lo sigma_hi : ℝ) : Prop :=
  Stirling_Remainder_OPEN sigma_lo sigma_hi

/-! ================================================================
    Section F: Wall C closure certificate
    ================================================================ -/

/-- **wall_c_sin_identity_complete** (PROVED, 0 sorry):
    sin_modulus_sq_identity_OPEN is proved.
    All SineGrowthSubClosure theorems that were conditional on that open
    (sin_modulus_ge_sinh, sin_modulus_ge_exp_third, gamma_stirling_from_reflection)
    are now unconditional via sin_modulus_sq_proved.
    Remaining Wall C: Stirling_Binet_OPEN (~8pp) + Stirling_Remainder_OPEN (~5pp).
    SORRY: 0. Axioms: {propext, Classical.choice, Quot.sound}. -/
theorem wall_c_sin_identity_complete :
    ∀ s : ℂ,
    Complex.normSq (Complex.sin (↑Real.pi * s)) =
    Real.sin (Real.pi * s.re) ^ 2 + Real.sinh (Real.pi * s.im) ^ 2 :=
  sin_modulus_sq_proved

end ArakelovRH.GammaStirlingSubClosure
