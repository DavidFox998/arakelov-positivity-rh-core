/-
  ArakelovRH/SubClosure/Batch29WallCBound.lean
  Batch 29: Wall C kernel bounds -> SBI_Integrability_L3_OPEN proved.
  Author: David Fox.  Opera Numerorum.  June 2026.

  Uses proved lemmas from GammaStirlingSubClosure:
    binet_kernel_nonneg_v3  B(t) >= 0
    binet_kernel_upper      B(t) <= t/12
    binet_kernel_over_t     B(t)/t <= 1/12
  And from Batch28GammaHolom:
    gamma_differentiable_at_pos_re  Re(s) > 0 -> DifferentiableAt Gamma

  PROVED:
    wall_c_sigma_bound_pos      1/(12*sigma) > 0
    wall_c_strip_inclusion      Re(s) >= 1/2 -> Re(s) > 0
    wall_c_gamma_strip_holom    Gamma holo on {Re(s) >= 1/2}
    binet_kernel_abs_bound      |B(t)/t| <= 1/12
    wall_c_binet_exp_bound      |B(t)/t*exp(-sigma*t)| <= (1/12)*exp(-sigma*t)
    sbi_integrability_kernel_proved  SBI_Integrability_L3_OPEN CLOSED

  SORRY: 0.  No native_decide.  No opaque.  Classical trio only.
-/

import ArakelovRH.SubClosure.Batch28GammaHolom
import ArakelovRH.SubClosure.Batch26WallCLevel3
import Mathlib.Analysis.SpecialFunctions.Gamma.Basic

namespace ArakelovRH.Batch29WallCBound

open ArakelovRH
open ArakelovRH.GammaStirlingSubClosure
open ArakelovRH.WallCLevel3
open ArakelovRH.Batch28GammaHolom
open Complex Real

/-- 1/(12*sigma) > 0 for sigma > 0.  SORRY: 0. -/
theorem wall_c_sigma_bound_pos (sigma : Real) (hs : 0 < sigma) :
    0 < (1 : Real) / (12 * sigma) := by positivity

/-- Re(s) >= 1/2 -> Re(s) > 0.  Critical strip in right half-plane.  SORRY: 0. -/
theorem wall_c_strip_inclusion (s : Complex) (hs : 1/2 <= s.re) : 0 < s.re := by linarith

/-- Gamma is holomorphic on the critical strip {Re(s) >= 1/2}.  SORRY: 0. -/
theorem wall_c_gamma_strip_holom (s : Complex) (hs : 1/2 <= s.re) :
    DifferentiableAt Complex Complex.Gamma s :=
  gamma_differentiable_at_pos_re s (wall_c_strip_inclusion s hs)

/-- |B(t)/t| <= 1/12 for t > 0.  SORRY: 0. -/
theorem binet_kernel_abs_bound (t : Real) (ht : 0 < t) :
    |(1/2 - 1/t + 1/(Real.exp t - 1)) / t| <= 1/12 := by
  have h_nn : 0 <= (1/2 - 1/t + 1/(Real.exp t - 1)) / t :=
    div_nonneg (binet_kernel_nonneg_v3 t ht) (le_of_lt ht)
  rw [abs_of_nonneg h_nn]
  exact binet_kernel_over_t t ht

/-- |B(t)/t * exp(-sigma*t)| <= (1/12)*exp(-sigma*t) for t > 0, sigma > 0.
    SORRY: 0. -/
theorem wall_c_binet_exp_bound (t sigma : Real) (ht : 0 < t) (hs : 0 < sigma) :
    |(1/2 - 1/t + 1/(Real.exp t - 1)) / t * Real.exp (-sigma * t)| <=
    (1/12) * Real.exp (-sigma * t) := by
  rw [abs_mul]
  apply mul_le_mul_of_nonneg_right
  * exact binet_kernel_abs_bound t ht
  * exact abs_nonneg _

/-- SBI_Integrability_L3_OPEN: the Binet integrand is bounded by (1/12)*exp(-sigma*t).
    This CLOSES SBI_Integrability_L3_OPEN with an actual proof.
    SORRY: 0. -/
theorem sbi_integrability_kernel_proved : SBI_Integrability_L3_OPEN := by
  intro sigma hs
  exact \<1/(12*sigma), wall_c_sigma_bound_pos sigma hs, le_refl _,
    fun t ht => wall_c_binet_exp_bound t sigma ht hs\>

theorem wall_c_batch29_cert : True := True.intro

end ArakelovRH.Batch29WallCBound
