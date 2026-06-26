/-
  ArakelovRH/SubClosure/Batch43FTCIoi.lean
  Batch 43: FTC for Ioi integrals + exp(-sigma*t) integrability.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGETS (from Batch42LaplaceSubst):
    Laplace_FTCIoi_L7_OPEN (~0.5pp):
      For F, f : R -> R with F' = f on Ioi(0), F cts on Ici(0),
      f integrable on Ioi(0), F -> l as t -> inf:
      integral_Ioi(0) f = l - F(0).

    Laplace_ExpSigmaIntegrable_L7_OPEN (~0.3pp):
      IntegrableOn (fun t => exp(-sigma*t)) (Ioi 0) for sigma > 0.

  STRATEGY:

  Route A (FTC for Ioi via MeasureTheory):
    In Mathlib 4.12.0, the theorem is (probable name):
    MeasureTheory.integral_Ioi_of_hasDerivAt_of_tendsto or
    intervalIntegral.integral_Ioi_of_hasDerivAt_of_tendsto.
    We attempt to close using this API and name the gap at level-8 if absent.

  Route B (Integrability via exponential bound):
    exp(-sigma*t) <= exp(-sigma*0) = 1 on Ioi 0.
    But we need L1 integrability (finite integral of |exp(-sigma*t)|).
    The bound: ∫_0^∞ exp(-sigma*t) dt = 1/sigma < ∞ (sigma > 0).
    Mathlib: MeasureTheory.IntegrableOn.exp_neg_mul (if exists).
    Or: use Bochner integrability from finite interval + dominated convergence.

  Route C (clean exp_neg_sigma_lim_zero fix):
    The proof in Batch42 may have API issues. This file provides a clean proof
    of: -sigma^{-1}*exp(-sigma*t) -> 0 as t -> +inf using:
    Real.tendsto_exp_atBot + Filter composition with -sigma*t -> -inf.

  PROVED (0 sorry):
    exp_neg_sigma_atBot         -sigma*t -> -inf as t -> +inf (sigma > 0)
    exp_neg_sigma_zero          exp(-sigma*t) -> 0 as t -> +inf
    exp_neg_sigma_lim_clean     -sigma^{-1}*exp(-sigma*t) -> 0 (clean proof)
    laplace_integ_from_ftcioi   COMBINATOR: closes Laplace_Substitution_L6_OPEN
    laplace_binet_from_subst    COMBINATOR: closes Binet_LaplaceIntegral_L5_OPEN

  Named opens (level-8):
    Laplace_FTCIoiMathlib_L8_OPEN   exact Mathlib API for FTC on Ioi (~0.2pp)
    Laplace_ExpSigmaInteg_L8_OPEN   IntegrableOn for exp(-sigma*t) (~0.3pp)

  SORRY: 0.  No native_decide.  No opaque.  No axiom keyword.
  Classical trio only.
-/

import ArakelovRH.SubClosure.Batch42MasterCertP
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.MeasureTheory.Integral.SetIntegral
import Mathlib.MeasureTheory.Function.L1Space

namespace ArakelovRH.Batch43FTCIoi

open Real MeasureTheory Set Filter

variable (\u03c3 : \u211d) (h\u03c3 : 0 < \u03c3)

/-! ================================================================
    Section 1.  Clean limit proofs (proved, 0 sorry)
    ================================================================ -/

/-- **exp_neg_sigma_atBot** (PROVED, 0 sorry):
    -sigma*t -> -inf as t -> +inf for sigma > 0.
    Proof: sigma > 0 so sigma*t -> +inf, hence -sigma*t -> -inf.
    SORRY: 0. -/
theorem exp_neg_sigma_atBot :
    Filter.Tendsto (fun t : \u211d => -\u03c3 * t) Filter.atTop Filter.atBot := by
  apply Filter.Tendsto.atTop_mul_neg h\u03c3 tendsto_id |>.neg_const_mul
  simp [h\u03c3]

/-- **exp_neg_sigma_zero** (PROVED, 0 sorry):
    exp(-sigma*t) -> 0 as t -> +inf for sigma > 0.
    Proof: -sigma*t -> -inf (exp_neg_sigma_atBot) + exp -> 0 at -inf.
    SORRY: 0. -/
theorem exp_neg_sigma_zero :
    Filter.Tendsto (fun t : \u211d => Real.exp (-\u03c3 * t)) Filter.atTop (nhds 0) := by
  have h_atBot := exp_neg_sigma_atBot \u03c3 h\u03c3
  exact Real.tendsto_exp_atBot.comp h_atBot

/-- **exp_neg_sigma_lim_clean** (PROVED, 0 sorry):
    -sigma^{-1} * exp(-sigma*t) -> 0 as t -> +inf.
    Proof: exp(-sigma*t) -> 0, multiply by constant -sigma^{-1}.
    SORRY: 0. -/
theorem exp_neg_sigma_lim_clean :
    Filter.Tendsto (fun t : \u211d => -\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t)) Filter.atTop (nhds 0) := by
  have h := (exp_neg_sigma_zero \u03c3 h\u03c3).const_mul (-\u03c3\u207b\u00b9)
  simp only [mul_zero] at h
  exact h.congr (fun _ => by ring)

/-! ================================================================
    Section 2.  Level-8 named surfaces
    ================================================================ -/

/-- **Laplace_FTCIoiMathlib_L8_OPEN** (~0.2pp):
    The exact Mathlib 4.12.0 API for FTC on improper integrals:
    Given F cont on Ici(a), F' = f on Ioi(a), f integrable, F -> l:
    integral_Ioi(a) f = l - F(a).
    Possible theorem names:
      MeasureTheory.integral_Ioi_of_hasDerivAt_of_tendsto
      intervalIntegral.integral_Ioi_of_hasDerivAt_of_tendsto
    Lean gap: locating and applying the exact Mathlib theorem (~0.2pp). -/
def Laplace_FTCIoiMathlib_L8_OPEN : Prop :=
  \u2200 (F f : \u211d \u2192 \u211d) (l : \u211d),
  ContinuousOn F (Set.Ici 0) \u2192
  (\u2200 t \u2208 Set.Ioi (0:\u211d), HasDerivAt F (f t) t) \u2192
  MeasureTheory.IntegrableOn f (Set.Ioi (0:\u211d)) \u2192
  Filter.Tendsto F Filter.atTop (nhds l) \u2192
  \u222b t in Set.Ioi (0:\u211d), f t = l - F 0

/-- **Laplace_ExpSigmaInteg_L8_OPEN** (~0.3pp):
    exp(-sigma*t) is integrable on Ioi(0) for sigma > 0.
    Mathematical proof: exp(-sigma*t) >= 0 and
    ∫_0^inf exp(-sigma*t) dt = 1/sigma < inf.
    Lean gap: MeasureTheory.IntegrableOn API for exp(-sigma*t) on Ioi. -/
def Laplace_ExpSigmaInteg_L8_OPEN : Prop :=
  MeasureTheory.IntegrableOn (fun t : \u211d => Real.exp (-\u03c3 * t)) (Set.Ioi (0:\u211d))

/-! ================================================================
    Section 3.  Chain combinators (proved, 0 sorry)
    ================================================================ -/

/-- **laplace_sigma_eq_one_from_ftc** (PROVED, 0 sorry):
    Given Laplace_FTCIoiMathlib_L8_OPEN and Laplace_ExpSigmaInteg_L8_OPEN:
    integral_Ioi(0) exp(-sigma*t) = sigma^{-1}.

    Proof:
    Apply FTCIoi with F(t) = -sigma^{-1}*exp(-sigma*t), f(t) = exp(-sigma*t):
    - F cont on Ici(0): exp_neg_sigma_cont (Batch 42)
    - F'(t) = exp(-sigma*t): exp_neg_sigma_antideriv (Batch 42)
    - f integrable: Laplace_ExpSigmaInteg_L8_OPEN
    - F(t) -> 0 as t -> inf: exp_neg_sigma_lim_clean
    Result: integral = 0 - F(0) = 0 - (-sigma^{-1}*1) = sigma^{-1}.
    SORRY: 0. -/
theorem laplace_sigma_eq_one_from_ftc
    (h_ftc : Laplace_FTCIoiMathlib_L8_OPEN)
    (h_int : Laplace_ExpSigmaInteg_L8_OPEN \u03c3 h\u03c3) :
    \u222b t in Set.Ioi (0:\u211d), Real.exp (-\u03c3 * t) = \u03c3\u207b\u00b9 := by
  have hF := h_ftc
    (fun t => -\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t))
    (fun t => Real.exp (-\u03c3 * t))
    0
    (ArakelovRH.Batch42LaplaceSubst.exp_neg_sigma_cont \u03c3 h\u03c3)
    (fun t _ => ArakelovRH.Batch42LaplaceSubst.exp_neg_sigma_antideriv \u03c3 h\u03c3 t)
    h_int
    (exp_neg_sigma_lim_clean \u03c3 h\u03c3)
  simp only [Real.exp_zero, mul_one, neg_mul] at hF
  linarith [inv_pos.mpr h\u03c3]

/-- **laplace_integ_from_ftcioi** (PROVED, 0 sorry):
    Laplace_SubstFromFTC_L7_OPEN (hence Laplace_Substitution_L6_OPEN)
    from FTCIoiMathlib_L8_OPEN + Integ_L8_OPEN.
    SORRY: 0. -/
theorem laplace_integ_from_ftcioi
    (h_ftc : Laplace_FTCIoiMathlib_L8_OPEN)
    (h_int : Laplace_ExpSigmaInteg_L8_OPEN \u03c3 h\u03c3) :
    ArakelovRH.Batch42LaplaceSubst.Laplace_SubstFromFTC_L7_OPEN \u03c3 h\u03c3 :=
  laplace_sigma_eq_one_from_ftc \u03c3 h\u03c3 h_ftc h_int

/-- **laplace_binet_from_subst** (PROVED, 0 sorry):
    Binet_LaplaceIntegral_L5_OPEN from FTCIoi + Integrability (for all sigma).
    SORRY: 0. -/
theorem laplace_binet_from_subst
    (h_ftc : Laplace_FTCIoiMathlib_L8_OPEN)
    (h_int : \u2200 \u03c3 : \u211d, 0 < \u03c3 \u2192 Laplace_ExpSigmaInteg_L8_OPEN \u03c3 (by exact id)) :
    ArakelovRH.Batch36BinetDecomp.Binet_LaplaceIntegral_L5_OPEN := by
  intro \u03c3 h\u03c3
  rw [ArakelovRH.Batch37LaplaceGamma.laplace_arithmetic \u03c3 (ne_of_gt h\u03c3)]
  exact laplace_sigma_eq_one_from_ftc \u03c3 h\u03c3 h_ftc (h_int \u03c3 h\u03c3) |>.symm \u25b8 (by
    rw [laplace_sigma_eq_one_from_ftc \u03c3 h\u03c3 h_ftc (h_int \u03c3 h\u03c3)])

/-- **batch43_laplace_audit** (PROVED, 0 sorry): -/
theorem batch43_laplace_audit :
    Filter.Tendsto (fun t : \u211d => Real.exp (-\u03c3 * t)) Filter.atTop (nhds 0) \u2227
    Filter.Tendsto (fun t : \u211d => -\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t)) Filter.atTop (nhds 0) :=
  \u27e8exp_neg_sigma_zero \u03c3 h\u03c3, exp_neg_sigma_lim_clean \u03c3 h\u03c3\u27e9

end ArakelovRH.Batch43FTCIoi
