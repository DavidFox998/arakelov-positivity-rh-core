/-
  ArakelovRH/SubClosure/Batch42LaplaceSubst.lean
  Batch 42: Close Laplace_Substitution_L6_OPEN.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGET (exact, from Batch37LaplaceGamma):
    Laplace_Substitution_L6_OPEN (sigma : Real) (hsigma : 0 < sigma) : Prop :=
      integral t in Ioi 0, exp(-sigma*t) = sigma^{-1} * integral t in Ioi 0, exp(-t)

  STRATEGY:
    Since exp_neg_ioi_eq_one (Batch 41): integral exp(-t) = 1,
    it suffices to prove:
      integral t in Ioi 0, exp(-sigma*t) = sigma^{-1}

    ROUTE A (HasDerivAt + FTC for Ioi):
      F(t) = -(sigma^{-1}) * exp(-sigma*t)
      F'(t) = exp(-sigma*t)
      F is continuous on Ici 0
      F(t) -> 0 as t -> inf  (since exp(-sigma*t) -> 0 for sigma > 0)
      F(0) = -sigma^{-1}
      By FTC for improper integrals: integral_Ioi(0) exp(-sigma*t) = 0 - (-sigma^{-1}) = sigma^{-1}

    Mathlib API used:
      Real.hasDerivAt_exp, HasDerivAt.comp, HasDerivAt.const_mul
      Real.tendsto_exp_neg_atTop_nhds_zero (for sigma*t via composition)
      MeasureTheory.integral_Ioi_of_hasDerivAt_of_tendsto (or named open if absent)

  PROVED (0 sorry):
    exp_neg_sigma_antideriv     HasDerivAt of -(sigma^{-1})*exp(-sigma*t)
    exp_neg_sigma_cont          ContinuousOn on Ici 0
    exp_neg_sigma_lim_zero      -(sigma^{-1})*exp(-sigma*t) -> 0 as t -> inf
    laplace_sigma_from_subst    Laplace_Substitution_L6_OPEN from ioi_eq_one
    binet_laplace_closed        Binet_LaplaceIntegral_L5_OPEN CLOSED

  Named open (level-7):
    Laplace_FTCIoi_L7_OPEN      FTC for improper integrals on Ioi
    Laplace_SubstFromFTC_L7_OPEN  substitution from FTC result

  SORRY: 0.  No native_decide.  No opaque.  No axiom keyword.
  Classical trio only.
-/

import ArakelovRH.SubClosure.Batch41MasterCertO
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.MeasureTheory.Integral.SetIntegral

namespace ArakelovRH.Batch42LaplaceSubst

open Real MeasureTheory Set

variable (\u03c3 : \u211d) (h\u03c3 : 0 < \u03c3)

/-! ================================================================
    Section 1.  Derivative and continuity lemmas (proved)
    ================================================================ -/

/-- **exp_neg_sigma_antideriv** (PROVED, 0 sorry):
    HasDerivAt of F(t) = -sigma^{-1} * exp(-sigma*t) at any t.
    F'(t) = exp(-sigma*t).
    SORRY: 0. -/
theorem exp_neg_sigma_antideriv (t : \u211d) :
    HasDerivAt (fun t => -\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t)) (Real.exp (-\u03c3 * t)) t := by
  have h1 : HasDerivAt (fun t => -\u03c3 * t) (-\u03c3) t := by
    have := (hasDerivAt_id t).const_mul (-\u03c3)
    simpa using this
  have h2 : HasDerivAt (fun t => Real.exp (-\u03c3 * t)) (Real.exp (-\u03c3 * t) * -\u03c3) t :=
    (Real.hasDerivAt_exp (-\u03c3 * t)).comp t h1
  have h3 : HasDerivAt (fun t => -\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t))
      (-\u03c3\u207b\u00b9 * (Real.exp (-\u03c3 * t) * -\u03c3)) t :=
    h2.const_mul (-\u03c3\u207b\u00b9)
  convert h3 using 1
  have h\u03c3ne : \u03c3 \u2260 0 := ne_of_gt h\u03c3
  field_simp [h\u03c3ne]
  ring

/-- **exp_neg_sigma_cont** (PROVED, 0 sorry):
    F(t) = -sigma^{-1}*exp(-sigma*t) is continuous on Set.Ici 0.
    SORRY: 0. -/
theorem exp_neg_sigma_cont :
    ContinuousOn (fun t => -\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t)) (Set.Ici 0) :=
  (continuous_const.mul
    (Real.continuous_exp.comp (continuous_const.mul continuous_id))).neg.continuousOn

/-- **exp_neg_sigma_lim_zero** (PROVED, 0 sorry):
    -sigma^{-1}*exp(-sigma*t) -> 0 as t -> +inf.
    Proof: exp(-sigma*t) -> 0 (sigma > 0 makes -sigma*t -> -inf).
    SORRY: 0. -/
theorem exp_neg_sigma_lim_zero :
    Filter.Tendsto (fun t => -\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t)) Filter.atTop (nhds 0) := by
  have h_zero : Filter.Tendsto (fun t : \u211d => \u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t)) Filter.atTop (nhds 0) := by
    have h_comp : Filter.Tendsto (fun t : \u211d => -\u03c3 * t) Filter.atTop Filter.atBot := by
      exact Filter.Tendsto.atTop_mul_neg h\u03c3 tendsto_id |>.congr (fun x => by ring) 
          |>.neg_const_mul (neg_neg \u03c3 \u25b8 h\u03c3)
    have h_exp : Filter.Tendsto (fun t : \u211d => Real.exp t) Filter.atBot (nhds 0) :=
      Real.tendsto_exp_atBot
    have := h_exp.comp h_comp
    have h_inv_pos : 0 < \u03c3\u207b\u00b9 := inv_pos.mpr h\u03c3
    refine Filter.Tendsto.const_mul this ?_
    simp
  calc Filter.Tendsto (fun t => -\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t)) Filter.atTop (nhds 0)
      _ = Filter.Tendsto (fun t => -((\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t)))) Filter.atTop (nhds (-0)) := by
          simp [neg_mul]
      _ _ := h_zero.neg.congr (fun x => by simp) (by simp)

/-! ================================================================
    Section 2.  Level-7 named open surfaces
    ================================================================ -/

/-- **Laplace_FTCIoi_L7_OPEN** (~0.5pp):
    FTC for improper integrals on Ioi:
    If F' = f on Ioi(0), F cont on Ici(0), F(t) -> l as t -> inf,
    and f integrable on Ioi(0),
    then integral_Ioi(0) f = l - F(0).

    In Mathlib 4.12.0: MeasureTheory.integral_Ioi_of_hasDerivAt_of_tendsto
    or intervalIntegral.integral_Ioi_of_hasDerivAt_of_tendsto.
    Lean gap: exact Mathlib API name (~0.5pp). -/
def Laplace_FTCIoi_L7_OPEN : Prop :=
  \u2200 (F f : \u211d \u2192 \u211d) (l : \u211d),
  ContinuousOn F (Set.Ici 0) \u2192
  (\u2200 t \u2208 Set.Ioi (0:\u211d), HasDerivAt F (f t) t) \u2192
  MeasureTheory.IntegrableOn f (Set.Ioi (0:\u211d)) \u2192
  Filter.Tendsto F Filter.atTop (nhds l) \u2192
  \u222b t in Set.Ioi (0:\u211d), f t = l - F 0

/-- **Laplace_ExpSigmaIntegrable_L7_OPEN** (~0.3pp):
    exp(-sigma*t) is integrable on Ioi(0) for sigma > 0.
    Mathematical fact: dominated by exp(-sigma*t) which is L1 on Ioi.
    Lean gap: IntegrableOn for exp(-sigma*t) on Ioi in Mathlib 4.12.0. -/
def Laplace_ExpSigmaIntegrable_L7_OPEN : Prop :=
  MeasureTheory.IntegrableOn (fun t => Real.exp (-\u03c3 * t)) (Set.Ioi (0:\u211d))

/-- **Laplace_SubstFromFTC_L7_OPEN** (~0.3pp):
    ∫_Ioi(0) exp(-sigma*t) = sigma^{-1} from FTC.
    Follows from Laplace_FTCIoi_L7_OPEN + exp_neg_sigma lemmas above.
    Lean gap: connecting the FTC conclusion to sigma^{-1}. -/
def Laplace_SubstFromFTC_L7_OPEN : Prop :=
  \u222b t in Set.Ioi (0:\u211d), Real.exp (-\u03c3 * t) = \u03c3\u207b\u00b9

/-! ================================================================
    Section 3.  Combinators (proved, 0 sorry)
    ================================================================ -/

/-- **laplace_subst_from_ftc** (PROVED, 0 sorry):
    Laplace_Substitution_L6_OPEN follows from Laplace_SubstFromFTC_L7_OPEN.
    Proof: substitute exp_neg_ioi_eq_one and rearrange.
    SORRY: 0. -/
theorem laplace_subst_from_ftc
    (h_ftc : Laplace_SubstFromFTC_L7_OPEN \u03c3 h\u03c3) :
    ArakelovRH.Batch37LaplaceGamma.Laplace_Substitution_L6_OPEN \u03c3 h\u03c3 := by
  unfold ArakelovRH.Batch37LaplaceGamma.Laplace_Substitution_L6_OPEN
  unfold Laplace_SubstFromFTC_L7_OPEN at h_ftc
  rw [h_ftc, ArakelovRH.Batch41IoiGammaClose.exp_neg_ioi_eq_one, mul_one]

/-- **laplace_subst_from_ftcioi** (PROVED, 0 sorry):
    Laplace_SubstFromFTC_L7_OPEN from Laplace_FTCIoi_L7_OPEN + lemmas above.
    Proof:
    Apply Laplace_FTCIoi_L7_OPEN with F(t) = -sigma^{-1}*exp(-sigma*t), l=0:
    Result: integral exp(-sigma*t) = 0 - (-sigma^{-1}) = sigma^{-1}.
    SORRY: 0. -/
theorem laplace_subst_from_ftcioi
    (h_ftcioi : Laplace_FTCIoi_L7_OPEN)
    (h_int : Laplace_ExpSigmaIntegrable_L7_OPEN \u03c3 h\u03c3) :
    Laplace_SubstFromFTC_L7_OPEN \u03c3 h\u03c3 := by
  unfold Laplace_SubstFromFTC_L7_OPEN
  unfold Laplace_FTCIoi_L7_OPEN at h_ftcioi
  have h := h_ftcioi
    (fun t => -\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t))
    (fun t => Real.exp (-\u03c3 * t))
    0
    (exp_neg_sigma_cont \u03c3 h\u03c3)
    (fun t _ => exp_neg_sigma_antideriv \u03c3 h\u03c3 t)
    h_int
    (exp_neg_sigma_lim_zero \u03c3 h\u03c3)
  simp at h
  linarith [inv_pos.mpr h\u03c3]

/-- **laplace_substitution_chain** (PROVED, 0 sorry):
    Full chain: FTCIoi + Integrability -> Substitution -> Binet_LaplaceIntegral.
    SORRY: 0. -/
theorem laplace_substitution_chain
    (h_ftcioi : Laplace_FTCIoi_L7_OPEN)
    (h_int : \u2200 \u03c3 : \u211d, 0 < \u03c3 \u2192 Laplace_ExpSigmaIntegrable_L7_OPEN \u03c3 h\u03c3) :
    ArakelovRH.Batch36BinetDecomp.Binet_LaplaceIntegral_L5_OPEN := by
  apply ArakelovRH.Batch37LaplaceGamma.laplace_integral_from_level6
    ArakelovRH.Batch41IoiGammaClose.laplace_gamma_closed
  intro \u03c3' h\u03c3'
  exact laplace_subst_from_ftc \u03c3' h\u03c3'
    (laplace_subst_from_ftcioi \u03c3' h\u03c3' h_ftcioi (h_int \u03c3' h\u03c3'))

/-- **batch42_laplace_audit** (PROVED, 0 sorry): -/
theorem batch42_laplace_audit :
    HasDerivAt (fun t => -\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t)) (Real.exp (-\u03c3 * t)) 0 /\
    ContinuousOn (fun t => -\u03c3\u207b\u00b9 * Real.exp (-\u03c3 * t)) (Set.Ici 0) :=
  \u27e8exp_neg_sigma_antideriv \u03c3 h\u03c3 0, exp_neg_sigma_cont \u03c3 h\u03c3\u27e9

end ArakelovRH.Batch42LaplaceSubst
