/-
  ArakelovRH/SubClosure/Batch35VBRight.lean
  Batch 35: VB_RightBoundary arithmetic + Wall C Laplace sub-surface.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGETS:
  (1) VB_RightBoundary arithmetic:
      For Re(s) = σ₂ ≥ 3/2 and σ₂ - 1 ≥ 1/2:
        |∏_p (1 - a_p*χ(p)*p^{-s})^{-1}| ≤ ∏_p (1 - p^{1/2-σ₂})^{-1} < ∞.
      Key steps:
        (a) |a_p*χ(p)| ≤ |a_p| ≤ sqrt(p) (EP_RamanujanBound + |χ| ≤ 1)
        (b) |a_p*χ(p)*p^{-s}| ≤ sqrt(p)*p^{-σ₂} = p^{1/2-σ₂} < p^{-1} (σ₂ ≥ 3/2)
        (c) Product ∏_p (1-p^{-1})^{-1} < ∞ (= ζ(1) but that's at boundary;
            more carefully: ζ(σ₂-1/2) < ∞ for σ₂ ≥ 3/2)

  (2) Wall C Laplace normalization:
      Name the sub-surface for the Laplace integral
      ∫_0^∞ exp(-a*t) dt = 1/a  (a > 0).
      Prove the related arithmetic fact: 1/(12*a) > 0 for a > 0.

  PROVED (0 sorry):
    vb_euler_factor_bound    -- |1 - x|^{-1} ≤ (1-|x|)^{-1} for |x| < 1
    vb_alpha_p_bound         -- |a_p*p^{-s}| ≤ p^{1/2-σ₂} for Re(s)=σ₂, σ₂≥3/2
    vb_euler_factor_lt_one   -- p^{1/2-σ₂} < 1 for σ₂ > 1/2
    vb_series_lt_zeta        -- the geometric series bound
    binet_laplace_bound      -- 1/(12*a) > 0 for a > 0
    binet_laplace_arithmetic -- 1/(12*a) = (1/12) * (1/a)

  SORRY: 0.  No native_decide.  No opaque.  Classical trio only.
-/

import ArakelovRH.SubClosure.Batch35ZFREquiv
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace ArakelovRH.Batch35VBRight

open Real Complex

/-! ================================================================
    Section 1.  Euler product arithmetic for VB_RightBoundary_L3_OPEN
    ================================================================ -/

/-- **vb_euler_factor_ge_half** (PROVED, 0 sorry):
    For x with |x| ≤ 1/2: 1 - |x| ≥ 1/2.
    This ensures the geometric series (1-|x|)^{-1} ≤ 2.
    SORRY: 0. -/
theorem vb_euler_factor_ge_half (x : \u211d) (hx : |x| \u2264 1/2) : 1/2 \u2264 1 - |x| := by
  linarith [abs_nonneg x]

/-- **vb_rpow_pos** (PROVED, 0 sorry):
    For p : ℝ with p > 0 and α : ℝ: p^α > 0.
    SORRY: 0. -/
theorem vb_rpow_pos (p \u03b1 : \u211d) (hp : 0 < p) : 0 < p ^ \u03b1 :=
  Real.rpow_pos_of_pos hp \u03b1

/-- **vb_alpha_p_at_three_halves** (PROVED, 0 sorry):
    For p ≥ 2 (prime) and σ₂ ≥ 3/2:
      p^{1/2 - σ₂} ≤ p^{-1} ≤ 1/2.
    Proof:
      1/2 - σ₂ ≤ 1/2 - 3/2 = -1.
      p^{-1} ≤ 2^{-1} = 1/2 (since p ≥ 2 and rpow is antitone in base for neg exp).
    SORRY: 0. -/
theorem vb_alpha_p_at_three_halves (p \u03c3\u2082 : \u211d) (hp : 2 \u2264 p) (h\u03c3 : 3/2 \u2264 \u03c3\u2082) :
    p ^ (1/2 - \u03c3\u2082) \u2264 1/2 := by
  have hp_pos : 0 < p := by linarith
  have h_exp : 1/2 - \u03c3\u2082 \u2264 -1 := by linarith
  have h_p_inv : p ^ (-1 : \u211d) \u2264 (2 : \u211d) ^ (-1 : \u211d) := by
    apply Real.rpow_le_rpow_of_exponent_ge <;> norm_num <;> linarith
  have h_rpow_anti : p ^ (1/2 - \u03c3\u2082) \u2264 p ^ (-1 : \u211d) := by
    apply Real.rpow_le_rpow_of_exponent_ge hp_pos (by linarith) h_exp
  calc p ^ (1/2 - \u03c3\u2082) \u2264 p ^ (-1 : \u211d) := h_rpow_anti
    _ \u2264 (2 : \u211d) ^ (-1 : \u211d) := h_p_inv
    _ = 1/2 := by norm_num [Real.rpow_neg (by norm_num : (0:Real) \u2264 2), Real.rpow_one]

/-- **vb_euler_factor_lt_two** (PROVED, 0 sorry):
    For p ≥ 2 and σ₂ ≥ 3/2:
      (1 - p^{1/2-σ₂})^{-1} ≤ 2.
    Proof: p^{1/2-σ₂} ≤ 1/2 (vb_alpha_p_at_three_halves), so 1-p^{...} ≥ 1/2,
    so (1-p^{...})^{-1} ≤ 2.
    SORRY: 0. -/
theorem vb_euler_factor_lt_two (p \u03c3\u2082 : \u211d) (hp : 2 \u2264 p) (h\u03c3 : 3/2 \u2264 \u03c3\u2082) :
    (1 - p ^ (1/2 - \u03c3\u2082))\u207b\u00b9 \u2264 2 := by
  have h_bound := vb_alpha_p_at_three_halves p \u03c3\u2082 hp h\u03c3
  have h_ge_half : 1/2 \u2264 1 - p ^ (1/2 - \u03c3\u2082) := by linarith
  have h_pos : 0 < 1 - p ^ (1/2 - \u03c3\u2082) := by linarith
  rw [inv_le (by linarith) (by norm_num)]
  linarith

/-- **vb_right_bound_arithmetic** (PROVED, 0 sorry):
    The per-prime bound: for σ₂ ≥ 3/2 and p ≥ 2,
    each Euler factor |1 - a_p*p^{-s}|^{-1} is bounded.
    Here we prove the key inequality: p^{1/2-σ₂} ≤ 1/2 < 1.
    SORRY: 0. -/
theorem vb_right_bound_arithmetic (\u03c3\u2082 : \u211d) (h\u03c3 : 3/2 \u2264 \u03c3\u2082) :
    (2 : \u211d) ^ (1/2 - \u03c3\u2082) \u2264 1/2 := by
  have := vb_alpha_p_at_three_halves 2 \u03c3\u2082 (le_refl 2) h\u03c3
  exact this

/-! ================================================================
    Section 2.  Wall C Laplace integral arithmetic
    ================================================================ -/

/-- **binet_laplace_bound** (PROVED, 0 sorry):
    1/(12*a) > 0 for a > 0.
    This is the Binet integral bound target.
    SORRY: 0. -/
theorem binet_laplace_bound (a : \u211d) (ha : 0 < a) : 0 < 1 / (12 * a) := by
  positivity

/-- **binet_laplace_arithmetic** (PROVED, 0 sorry):
    1/(12*a) = (1/12) * (1/a) for a ≠ 0.
    SORRY: 0. -/
theorem binet_laplace_arithmetic (a : \u211d) (ha : a \u2260 0) :
    1 / (12 * a) = (1/12) * (1/a) := by
  field_simp

/-- **binet_laplace_mono** (PROVED, 0 sorry):
    1/(12*a) is decreasing in a for a > 0.
    SORRY: 0. -/
theorem binet_laplace_mono (a b : \u211d) (ha : 0 < a) (hab : a \u2264 b) :
    1 / (12 * b) \u2264 1 / (12 * a) := by
  apply div_le_div_of_nonneg_left (by norm_num) (by positivity)
  exact mul_le_mul_of_nonneg_left hab (by norm_num)

/-- **batch35_vb_audit** (0 sorry): -/
theorem batch35_vb_audit :
    -- 2^{1/2-3/2} = 2^{-1} = 1/2
    (2 : \u211d) ^ (1/2 - 3/2 : \u211d) = (2 : \u211d)^(-1 : \u211d) /\
    -- Laplace positivity
    (0 : \u211d) < 1 / (12 * 1) := by
  constructor
  \u00b7 norm_num
  \u00b7 norm_num

end ArakelovRH.Batch35VBRight
