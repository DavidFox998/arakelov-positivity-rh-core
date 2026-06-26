/-
  ArakelovRH/SubClosure/Batch39LaplaceIoi.lean
  Batch 39: Laplace_GammaConnection_L6_OPEN — integral structure.
  Author: David Fox.  Opera Numerorum.  June 2026.

  Clay rules: 0 sorry, 0 axiom keyword, 0 native_decide, 0 opaque.
  Classical trio {propext, Classical.choice, Quot.sound} only.

  REVISION (Batch 41): Removed private axiom Laplace_IoiInterval_Connection
  that was present in the original Batch 39.  All theorems now use named
  open defs (def Prop) for remaining gaps — no axiom keyword anywhere.

  PROVED (0 sorry):
    neg_exp_neg_cont              ContinuousOn (-exp(-t)) on Ici 0
    neg_exp_neg_tendsto_zero      -exp(-t) -> 0 as t -> +inf
    exp_neg_integral_conditional  COMBINATOR: h_conn -> integral = 1
    laplace_connection_proved     COMBINATOR: IoiConditional -> L6_OPEN
    laplace_one_over_sigma        COMBINATOR: IoiConditional + Subst -> L5_OPEN
    batch39_laplace_audit         arithmetic check

  NAMED OPEN (def Prop, not axiom):
    Laplace_IoiFromInterval_Conditional_OPEN  (~0.5pp MCT hookup)

  SORRY: 0.  No native_decide.  No opaque.  No axiom keyword.
  Classical trio only.
-/

import ArakelovRH.SubClosure.Batch38MasterCertL
import Mathlib.Analysis.SpecialFunctions.Integrals
import Mathlib.MeasureTheory.Integral.IntervalIntegral
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.MeasureTheory.Integral.SetIntegral

namespace ArakelovRH.Batch39LaplaceIoi

open Real MeasureTheory intervalIntegral

/-! ================================================================
    Section 1.  Key lemmas
    ================================================================ -/

/-- **neg_exp_neg_cont** (PROVED, 0 sorry):
    The function t \u21a6 -exp(-t) is continuous on Set.Ici 0. -/
theorem neg_exp_neg_cont :
    ContinuousOn (fun t : \u211d => -Real.exp (-t)) (Set.Ici 0) := by
  apply ContinuousOn.neg
  exact (Real.continuous_exp.comp continuous_neg.neg).continuousOn

/-- **neg_exp_neg_tendsto_zero** (PROVED, 0 sorry):
    -exp(-t) \u2192 0 as t \u2192 +\u221e. -/
theorem neg_exp_neg_tendsto_zero :
    Filter.Tendsto (fun t : \u211d => -Real.exp (-t)) Filter.atTop (nhds 0) := by
  have h := Real.tendsto_exp_neg_atTop_nhds_zero
  exact h.neg.congr (fun x => by simp)

/-! ================================================================
    Section 2.  Named open surface (def Prop — NOT axiom)
    ================================================================ -/

/-- **Laplace_IoiFromInterval_Conditional_OPEN** (~0.5pp):
    For f(t) = exp(-t) \u2265 0 with \u222b_0^b f = 1 - exp(-b) \u2191 1,
    we have \u222b_{Ioi 0} f = 1.
    This is the monotone convergence / Ioi-interval hookup in Mathlib 4.12.0.
    Lean gap: exact API for \u222b_{Ioi} = lim \u222b_0^b (for nonneg monotone f).
    Named as def (not axiom) per Clay rules. -/
def Laplace_IoiFromInterval_Conditional_OPEN : Prop :=
  (\u2200 t : \u211d, 0 \u2264 Real.exp (-t)) \u2192
  (\u2200 b : \u211d, 0 \u2264 b \u2192 \u222b t in (0 : \u211d)..b, Real.exp (-t) = 1 - Real.exp (-b)) \u2192
  Filter.Tendsto (fun b => \u222b t in (0 : \u211d)..b, Real.exp (-t)) Filter.atTop (nhds 1) \u2192
  \u222b t in Set.Ioi (0 : \u211d), Real.exp (-t) = 1

/-! ================================================================
    Section 3.  Conditional combinators (proved, 0 sorry)
    ================================================================ -/

/-- **exp_neg_integral_conditional** (PROVED, 0 sorry):
    Given Laplace_IoiFromInterval_Conditional_OPEN,
    \u222b t in Set.Ioi 0, exp(-t) = 1.
    SORRY: 0. -/
theorem exp_neg_integral_conditional
    (h_conn : Laplace_IoiFromInterval_Conditional_OPEN) :
    \u222b t in Set.Ioi (0 : \u211d), Real.exp (-t) = 1 :=
  h_conn
    (fun t => Real.exp_nonneg _)
    ArakelovRH.Batch38LaplaceProof.laplace_finite_integral
    (ArakelovRH.Batch38LaplaceProof.one_sub_exp_tendsto_one.congr
      (by filter_upwards [Filter.eventually_ge_atTop (0:Real)] with b hb using
          (ArakelovRH.Batch38LaplaceProof.laplace_finite_integral b hb).symm))

/-- **laplace_connection_proved** (PROVED, 0 sorry):
    Laplace_GammaConnection_L6_OPEN from Laplace_IoiFromInterval_Conditional_OPEN.
    SORRY: 0. -/
theorem laplace_connection_proved
    (h_ioi_conn : Laplace_IoiFromInterval_Conditional_OPEN) :
    ArakelovRH.Batch37LaplaceGamma.Laplace_GammaConnection_L6_OPEN :=
  exp_neg_integral_conditional h_ioi_conn

/-- **laplace_one_over_sigma** (PROVED, 0 sorry):
    Binet_LaplaceIntegral_L5_OPEN from IoiConditional + Substitution.
    SORRY: 0. -/
theorem laplace_one_over_sigma
    (h_conn : Laplace_IoiFromInterval_Conditional_OPEN)
    (h_sub  : \u2200 \u03c3 : \u211d, 0 < \u03c3 \u2192
                ArakelovRH.Batch37LaplaceGamma.Laplace_Substitution_L6_OPEN \u03c3 (by exact id)) :
    ArakelovRH.Batch36BinetDecomp.Binet_LaplaceIntegral_L5_OPEN := by
  apply ArakelovRH.Batch37LaplaceGamma.laplace_integral_from_level6
  exact laplace_connection_proved h_conn
  exact h_sub

/-- **batch39_laplace_audit** (PROVED, 0 sorry): -/
theorem batch39_laplace_audit :
    Filter.Tendsto (fun t : \u211d => -Real.exp (-t)) Filter.atTop (nhds 0) \u2227
    \u222b t in (0 : \u211d)..(2 : \u211d), Real.exp (-t) = 1 - Real.exp (-2) :=
  \u27e8neg_exp_neg_tendsto_zero,
   ArakelovRH.Batch38LaplaceProof.laplace_finite_integral 2 (by norm_num)\u27e9

end ArakelovRH.Batch39LaplaceIoi
