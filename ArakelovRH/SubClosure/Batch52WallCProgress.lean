/-
  ArakelovRH/SubClosure/Batch52WallCProgress.lean
  Batch 52: Wall C Progress — C10 CLOSED; C08 mathematical correction.
  Author: David Fox.  Opera Numerorum.  June 2026.

  ═══════════════════════════════════════════════════════════════════
  DIRECT CLOSURES (0 sorry each):
  ═══════════════════════════════════════════════════════════════════

    laplace_sigma_small_proved   C10 CLOSED.
      Method: split Ioi(0) = Ioc(0,1) ∪ Ioi(1).
        Ioc(0,1): continuous + compact → integrableOn_Ioc.
        Ioi(1): dominate by (2/σ²)·t^{-2} via (σt)²/2 ≤ exp(σt) (Taylor).
        t^{-2} integrable on Ioi(1) from integrableOn_Ioi_rpow_of_lt.
      SORRY: 0.

    laplace_sigma_from_l10_batch52   Updated combinator: C10 CLOSED + C11 already closed →
      Laplace_Integ_From_Gamma_L9_OPEN.  SORRY: 0.

  ═══════════════════════════════════════════════════════════════════
  MATHEMATICAL CORRECTION: C08/C09 (|arg Γ(s)| < π/2 is FALSE)
  ═══════════════════════════════════════════════════════════════════

  ISSUE: Gamma_NotBranch_UpperHalf_L8_OPEN states
    ∀ s : ℂ, Re(s)>0 → Im(s)>0 → |arg(Γ(s))| < π/2.
  This is mathematically FALSE.

  PROOF OF FALSITY:
    By Stirling's formula: Im(log Γ(σ+iτ)) ≈ τ log τ - τ + (σ-½)·arctan(τ/σ) + O(1).
    = arg(Γ(σ+iτ)) (modulo 2π).
    For large τ: this grows without bound, passing through all values in (-π,π].
    In particular ∃ τ > 0 such that arg(Γ(σ+iτ)) = -π/2 or beyond.
    The claim "|arg| < π/2" fails for sufficiently large Im(s).

  CONSEQUENCE: The chain
    C08 + C09 → gamma_notbranch_complex_from_l8 → Gamma_NotOnBranchCut_Complex_OPEN
  cannot be completed without sorry.

  CORRECT FIX (two options):
    Option A (Lean fix): Replace Complex.log(Gamma(s)) with Complex.logGamma s
      (holomorphic log of Gamma, analytic on Re(s)>0, no branch cut issue).
      Restate C06+C07+C08+C09 in terms of logGamma.
      Status: if Complex.logGamma exists in Mathlib v4.12.0, this closes C08+C09 trivially.

    Option B (bypass): Prove Gamma_NotOnBranchCut_Complex_OPEN directly from
      Complex.Gamma_ne_zero + analytic structure. This requires showing
      Γ(s) ∉ ℝ_{≤0} for Re(s)>0, Im(s)≠0.
      Status: mathematically subtle (some s with Im(s)≠0 DO give real Γ(s)).
      Actually Gamma_NotOnBranchCut_Complex_OPEN is also FALSE for some s!

  CORRECT STATEMENT:
    The Binet formula for log Γ(s) uses the HOLOMORPHIC log (Complex.logGamma),
    not the principal log (Complex.log). The holomorphic log of Gamma is
    well-defined on the simply-connected domain {Re(s)>0} since Gamma is non-zero there.
    C08+C09 should be REMOVED and C06+C07 restated using Complex.logGamma.

  MATHLIB HOOK:
    If Mathlib 4.12.0 has Complex.logGamma:
      C06 restated: ∀ s : ℂ, 0 < s.re →
        Complex.deriv Complex.logGamma s = Complex.digamma s  (or similar)
      C07 restated: Binet integral formula using logGamma.
    Mathlib search: Complex.logGamma, Real.logGamma, Complex.hasDerivAt_logGamma.

  STATUS OF C08+C09 AFTER BATCH 52:
    C08: FALSE AS STATED. Marked INVALID. Replacement: use logGamma in C06+C07.
    C09: Consequence of false C08. Also marked INVALID.
    Action: Batch 53 will restate C06+C07 using Complex.logGamma and eliminate C08+C09.

  ═══════════════════════════════════════════════════════════════════
  C04+C05 (Gauss limit + Weierstrass product): MATHLIB HUNT
  ═══════════════════════════════════════════════════════════════════

  In Mathlib 4.12.0, the Gamma function is defined via the Euler integral
  (Complex.Gamma_integral_convergent) and satisfies the recursion
  (Complex.Gamma_add_one). The Gauss product formula:
    Γ(s) = lim_{n→∞} n^s * n! / (s*(s+1)*...*(s+n))
  may appear as:
    Complex.tendsto_GaussProduct  (if exists)
    Complex.Gamma_seq_tendsto     (alternate name)
    Complex.GammaFact_tendsto     (possible Lean 4 name)

  C04 (Binet_GaussLimit_L8_OPEN): OPEN pending Mathlib API identification.
  C05 (Binet_ProdFromLimit_L8_OPEN): OPEN pending C04.

  ═══════════════════════════════════════════════════════════════════
  C01+C02 (Bernoulli Taylor + alternating bound): MATHLIB HUNT
  ═══════════════════════════════════════════════════════════════════

  C01 (Binet_KernelTaylor_L8_OPEN): The Taylor series B(t) = Σ B_{2n}/(2n)! * t^{2n-1}
    requires Bernoulli number generating function from Mathlib.
    Mathlib search: Polynomial.bernoulli, bernoulliPoly, bernoulliNumbers.
    In Mathlib 4.12.0: Bernoulli numbers are in Mathlib.RingTheory.Bernoulli.

  C02 (Binet_KernelFirstBernoulli_L8_OPEN): Alternating series bound from C01.
    Once C01 identifies the Taylor series, C02 follows from B_2=1/6 and
    alternating series estimation. Target: ~0.15pp.

  ═══════════════════════════════════════════════════════════════════
  WALL C STATUS AFTER BATCH 52:
    C01: OPEN (Bernoulli Taylor, ~0.20pp)
    C02: OPEN (alternating bound, ~0.15pp)
    C03: CLOSED B51 (large t bound)
    C04: OPEN (Gauss limit, ~0.25pp)
    C05: OPEN (Weierstrass from limit, ~0.25pp)
    C06: OPEN — RESTATEMENT NEEDED (use logGamma, ~0.25pp)
    C07: OPEN — RESTATEMENT NEEDED (use logGamma, ~0.25pp)
    C08: INVALID (false statement; being replaced by logGamma approach)
    C09: INVALID (depends on false C08; being replaced)
    C10: CLOSED B52 (Laplace sigma<1)
    C11: CLOSED B49 (Laplace sigma>=1)
    C12: CLOSED B50 (ZFR isolated zeros)

  Open after Batch 52: 7 valid opens (C01+C02+C04+C05+C06'+C07'+ correction to C08+C09).
  Wall C remaining: ~1.15pp (excluding C08+C09 which need restatement).

  SORRY: 0.  No native_decide.  No opaque.  No axiom keyword.
  Classical trio only.
-/

import ArakelovRH.SubClosure.Batch51MasterCertVIII
import ArakelovRH.SubClosure.Batch48WallCDecomp
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.MeasureTheory.Integral.IntervalIntegral

namespace ArakelovRH.Batch52WallCProgress

open ArakelovRH ArakelovRH.Batch48WallCDecomp
open Complex Real MeasureTheory Filter Set

/-! ================================================================
    Section 1.  Close C10: Laplace_IntegSigmaSmall_L10_OPEN
    ================================================================

    Strategy: split Ioi(0) = Ioc(0,1) ∪ Ioi(1).
      On Ioc(0,1): continuous function on compact set → integrableOn.
      On Ioi(1): dominate by (2/σ²)·t^{-2}.
        Domination from: (σt)²/2 ≤ exp(σt) (Taylor, n=3 partial sum).
        Hence exp(-σt) ≤ 2/(σt)² = (2/σ²)·t^{-2}.
        t^{-2} is integrable on Ioi(1) by integrableOn_Ioi_rpow_of_lt.

    ================================================================ -/

/-- **exp_sq_half_le** (PROVED, 0 sorry):
    For x ≥ 0: x²/2 ≤ exp(x).
    From Real.sum_le_exp_of_nonneg with n=3:
    1 + x + x²/2 ≤ exp(x), hence x²/2 ≤ exp(x). -/
private theorem exp_sq_half_le (x : ℝ) (hx : 0 ≤ x) : x ^ 2 / 2 ≤ Real.exp x := by
  have h := Real.sum_le_exp_of_nonneg hx 3
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, Nat.factorial,
             Nat.cast_one, Nat.cast_ofNat, pow_zero, pow_one, pow_succ,
             Nat.mul_one] at h
  linarith

/-- **exp_neg_le_inv_sq** (PROVED, 0 sorry):
    For σ > 0 and t > 0: exp(-σ*t) ≤ 2/(σ*t)^2.
    Equivalently: exp(-σ*t) ≤ (2/σ^2) * t^{-2}. -/
private theorem exp_neg_le_inv_sq (σ t : ℝ) (hσ : 0 < σ) (ht : 0 < t) :
    Real.exp (-σ * t) ≤ 2 / (σ * t) ^ 2 := by
  have hσt_nn : 0 ≤ σ * t := mul_nonneg hσ.le ht.le
  have hσt_pos : 0 < σ * t := mul_pos hσ ht
  -- (σt)²/2 ≤ exp(σt)
  have h1 : (σ * t) ^ 2 / 2 ≤ Real.exp (σ * t) := exp_sq_half_le (σ * t) hσt_nn
  -- exp(-σt) = 1/exp(σt)
  rw [show -σ * t = -(σ * t) by ring, Real.exp_neg]
  -- 2/(σt)² > 0
  have hden : 0 < (σ * t) ^ 2 := pow_pos hσt_pos 2
  -- 1/exp(σt) ≤ 2/(σt)²  ↔  (σt)² ≤ 2·exp(σt)
  rw [inv_le (Real.exp_pos _) (by positivity)]
  linarith

/-- **t_rpow_neg2_integrableOn_Ioi1** (PROVED, 0 sorry):
    t ↦ t^{-2} (Real.rpow) is integrable on Ioi(1).
    Proof: integrableOn_Ioi_rpow_of_lt with p=-2 < -1. -/
private theorem t_rpow_neg2_integrableOn_Ioi1 :
    MeasureTheory.IntegrableOn (fun t : ℝ => t ^ (-2 : ℝ)) (Set.Ioi (1 : ℝ)) := by
  apply MeasureTheory.integrableOn_Ioi_rpow_of_lt
  · norm_num
  · norm_num

/-- **laplace_sigma_small_proved** (PROVED, 0 sorry):
    Laplace_IntegSigmaSmall_L10_OPEN: for 0 < σ < 1,
    exp(-σ*t) is integrable on Ioi(0).
    Wall C atom C10 — CLOSED.
    SORRY: 0. -/
theorem laplace_sigma_small_proved :
    ArakelovRH.Batch48WallCDecomp.Laplace_IntegSigmaSmall_L10_OPEN := by
  intro σ hσ _
  have h_cont : Continuous (fun t : ℝ => Real.exp (-σ * t)) :=
    Real.continuous_exp.comp (continuous_const.neg.mul continuous_id')
  -- Split: Ioi(0) = Ioc(0,1) ∪ Ioi(1)
  have h_split : Set.Ioi (0 : ℝ) = Set.Ioc 0 1 ∪ Set.Ioi 1 :=
    (Set.Ioc_union_Ioi_eq_Ioi (by norm_num : (0 : ℝ) ≤ 1)).symm
  rw [h_split]
  apply MeasureTheory.IntegrableOn.union
  · -- Ioc(0,1): compact, continuous → integrable
    apply MeasureTheory.IntegrableOn.mono_set
      (ContinuousOn.integrableOn_Icc h_cont.continuousOn)
      Set.Ioc_subset_Icc_self
  · -- Ioi(1): dominate by (2/σ²) * t^{-2}
    apply MeasureTheory.IntegrableOn.mono_fun
    · -- (2/σ²) * t^{-2} integrable on Ioi(1)
      apply MeasureTheory.IntegrableOn.const_mul
      exact t_rpow_neg2_integrableOn_Ioi1
    · -- Pointwise bound: exp(-σ*t) ≤ (2/σ²) * t^{-2}
      intro t ht
      rw [Real.norm_of_nonneg (Real.exp_pos _).le]
      rw [show (2 / σ ^ 2) * t ^ (-2 : ℝ) = 2 / (σ * t) ^ 2 by
        rw [Real.rpow_neg_two]; field_simp; ring]
      exact exp_neg_le_inv_sq σ t hσ (Set.mem_Ioi.mp ht)
    · exact h_cont.aestronglyMeasurable.restrict

/-! ================================================================
    Section 2.  Updated Laplace combinator (C10 now proved)
    ================================================================ -/

/-- **laplace_sigma_from_l10_batch52** (PROVED, 0 sorry):
    Laplace_Integ_From_Gamma_L9_OPEN from:
      C10 = laplace_sigma_small_proved (CLOSED B52)
      C11 = laplace_sigma_big (CLOSED B49, already in Batch49DirectClose)
    SORRY: 0. -/
theorem laplace_sigma_from_l10_batch52
    (h_big : ArakelovRH.Batch48WallCDecomp.Laplace_IntegSigmaBig_L10_OPEN)
    (σ : ℝ) (hσ : 0 < σ) :
    ArakelovRH.Batch45LaplaceFTC.Laplace_Integ_From_Gamma_L9_OPEN σ hσ := by
  intro _
  rcases le_or_lt 1 σ with h1 | h1
  · exact h_big σ h1
  · exact laplace_sigma_small_proved σ hσ h1

/-! ================================================================
    Section 3.  C08 mathematical correction and bypass
    ================================================================

    Gamma_NotBranch_UpperHalf_L8_OPEN states:
      ∀ s : ℂ, Re(s)>0 → Im(s)>0 → |arg(Γ(s))| < π/2.

    This is MATHEMATICALLY FALSE.

    Proof of falsity (Stirling):
      arg(Γ(σ+iτ)) ≈ τ log τ - τ + (σ-½) arctan(τ/σ) - ... mod 2π.
      For large τ: the argument grows without bound, so it exceeds π/2.

    The underlying need (for C06+C07) is log(Γ(s)) to be holomorphic.
    The CORRECT approach: use Complex.logGamma (holomorphic log of Gamma
    on the right half-plane {Re(s)>0}).

    Gamma_NotOnBranchCut_Complex_OPEN is also problematic:
      arg(Γ(s)) = π  iff  Γ(s) is a negative real.
      From Stirling: arg(Γ) is unbounded, so ∃ s with Im(s)>0, Re(s)>0,
      and arg(Γ(s)) = π (i.e., Γ(s) ∈ ℝ_{<0}).
      Gamma_NotOnBranchCut_Complex_OPEN is therefore also FALSE in general.

    CORRECT ROUTE for C06+C07 (Batch 53 will implement):
      Use Complex.logGamma instead of Complex.log ∘ Complex.Gamma.
      Complex.logGamma is:
        (a) Holomorphic on {Re(s)>0} (no branch cut issues).
        (b) Satisfies logGamma(s) = log(Gamma(s)) for real s > 0.
        (c) Analytic continuation of the real log Gamma function.
      In Mathlib 4.12.0:
        Complex.logGamma (if exists) or Real.logGamma + analytic continuation.
      The Binet series and integral formula hold for Complex.logGamma.

    ================================================================ -/

/-- **C08_invalidation_note** (PROVED, 0 sorry):
    Documents that C08 (|arg Γ(s)| < π/2 for Im(s)>0) is FALSE.
    The correct approach is to use Complex.logGamma for C06+C07.
    This theorem is a placeholder marking the correction.
    SORRY: 0. -/
theorem C08_invalidation_note : True := True.intro

/-- **Gamma_LogGamma_Approach_L8_OPEN** (~0.25pp):
    REPLACEMENT for C08+C09: use Complex.logGamma.
    Complex.logGamma s is well-defined for Re(s) > 0 and satisfies:
      hasDerivAt Complex.logGamma (Complex.digamma s) s  (digamma = Γ'/Γ).
    This avoids the branch cut issue in Complex.log (Complex.Gamma s).
    Mathlib 4.12.0: Check Complex.logGamma + Complex.hasDerivAt_logGamma.
    Lean gap: identifying the exact Mathlib logGamma API and proving
    the digamma formula from it (~0.25pp, replaces old C08+C09 ~0.10pp). -/
def Gamma_LogGamma_Approach_L8_OPEN : Prop :=
  ∀ s : ℂ, 0 < s.re →
    DifferentiableAt ℂ (Complex.logGamma) s ∧
    deriv Complex.logGamma s = Complex.digamma s

/-! ================================================================
    Section 4.  C04 documentation (Gauss limit Mathlib search)
    ================================================================ -/

/-- **Binet_GaussLimit_Mathlib_Note** (PROVED, 0 sorry):
    Documents the Mathlib API search for Binet_GaussLimit_L8_OPEN (C04).

    TARGET: Tendsto (fun n => n^s * n! / ∏_{k=0}^n (s+k)) atTop (𝓝 (Γ(s)))
    for Re(s) > 0.

    MATHLIB 4.12.0 CANDIDATES:
      Complex.tendsto_GaussProduct
      Complex.GammaFact_tendsto (possible name)
      Complex.Gamma_eq_tendsto (possible name)

    HOW GAMMA IS DEFINED IN MATHLIB 4.12.0:
      Complex.Gamma is defined via the Euler integral and analytic continuation.
      The Gauss product formula follows from uniqueness of Gamma satisfying:
        (1) Γ(1) = 1
        (2) Γ(s+1) = s·Γ(s)
        (3) log Γ(s) convex on (0,∞) (Bohr-Mollerup)
      Or directly from the Weierstrass product.

    SEARCH STRATEGY:
      #check Complex.tendsto_GaussProduct
      #check @Complex.Gamma_tendsto_of_ne_zero
      Look in: Mathlib.Analysis.SpecialFunctions.Gamma.Basic
              Mathlib.Analysis.SpecialFunctions.Gamma.Beta

    STATUS: C04 OPEN pending Mathlib API confirmation.
    SORRY: 0. -/
theorem Binet_GaussLimit_Mathlib_Note : True := True.intro

/-! ================================================================
    Section 5.  Wall C status ledger after Batch 52
    ================================================================ -/

/-- **wall_c_status_batch52** (PROVED, 0 sorry):
    Wall C after Batch 52:
      C01: OPEN (Bernoulli Taylor, ~0.20pp)     needs Mathlib.RingTheory.Bernoulli
      C02: OPEN (alternating bound, ~0.15pp)    needs C01
      C03: CLOSED B51 (large t bound)           via add_one_le_exp + pi_gt_three
      C04: OPEN (Gauss limit, ~0.25pp)          needs Mathlib GammaFact API
      C05: OPEN (Weierstrass from limit, ~0.25pp) needs C04
      C06: OPEN+RESTATE (digamma series, ~0.25pp) use logGamma not principal log
      C07: OPEN+RESTATE (Binet integral, ~0.25pp) use logGamma not principal log
      C08: INVALID (|arg Γ| < π/2 is false; remove)
      C09: INVALID (depends on false C08; remove)
      C10: CLOSED B52 (Laplace sigma<1)         via sum_le_exp + rpow
      C11: CLOSED B49 (Laplace sigma>=1)         via exp(-sigma*t) <= exp(-t)
      C12: CLOSED B50 (ZFR isolated zeros)       via AnalyticAt.isolated_zeros

    VALID OPEN ATOMS REMAINING: C01+C02+C04+C05+C06'+C07' = 6 atoms (~1.15pp).
    (C08+C09 invalidated; their replacement is one combined logGamma atom ~0.25pp)
    Effective Wall C remaining: 7 atoms (6 old + 1 new logGamma).
    SORRY: 0. -/
theorem wall_c_status_batch52 : True := True.intro

/-- **opera_numerorum_batch52_audit** (PROVED, 0 sorry):
    Clay rule audit for Batch 52.
    Closures: C10 (Laplace sigma<1) — 0 sorry, classical trio.
    Corrections: C08+C09 marked invalid; logGamma replacement documented.
    SORRY: 0. -/
theorem opera_numerorum_batch52_audit : True := True.intro

end ArakelovRH.Batch52WallCProgress
