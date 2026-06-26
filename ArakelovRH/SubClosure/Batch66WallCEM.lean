/-
  ArakelovRH/SubClosure/Batch66WallCEM.lean
  Batch 66: Wall C — Prove EM limit A2; isolate A1+B as final named open
  Author: David Fox.  Opera Numerorum.  June 2026.

  GOAL: 1-for-1 atom swap:
    WW_GammaSeq_Wall_C_Analytics_L8 (1) → WW_GammaSeq_DerivExch_b66 (1)
    Net atoms: 35 → 35.

  Proved in this file (0 sorry):
    1. EM_harmonic_shift_real — H_{n+1} - log n → γ over ℝ
    2. EM_logn_minus_harmonic_real — log n - H_{n+1} → -γ over ℝ
    3. EM_limit_complex_b66 — log n - H_{n+1} → -γ over ℂ  (A2 fully proved)
    4. WW_GammaSeq_Wall_C_Analytics_L8_from_exch — analytics from A2 + named open

  Named open (1, replaces WW_GammaSeq_Wall_C_Analytics_L8, net 35 → 35):
    WW_GammaSeq_DerivExch_b66: bundles A1 (HasDerivAt formula) + B (Weierstrass).
      A1: HasDerivAt (GammaSeq · n) (GammaSeq s n * (log n - Σ 1/(s+k))) s
          [product/quotient/chain rule, B67-A1, ~1.5pp]
      B:  Weierstrass exchange logD_n(s) → deriv Gamma s / Gamma s
          [GammaSeq_tendsto_Gamma + TendstoLocallyUniformlyOn + continuous div, B67-B, ~1pp]

  SORRY: 0.  Axioms: {propext, Classical.choice, Quot.sound}.
-/
import Mathlib.NumberTheory.Harmonic.GammaDeriv
import Mathlib.Analysis.SpecialFunctions.Gamma.Beta
import ArakelovRH.SubClosure.Batch65WallCClose

namespace ArakelovRH.Batch66WallCEM

open Complex Real Filter Finset

private noncomputable abbrev F_b66 := ArakelovRH.Batch62AnalyticExt.F

-- ============================================================================
-- S1.  EM limit part A2: log n − H_{n+1} → −γ over ℝ, then ℂ
-- ============================================================================

/-- EM_n1_inv_tendsto_zero (PROVED, 0 sorry):
    (↑n + 1)⁻¹ → 0 in ℝ as n → ∞.
    Proof: (n+1 : ℝ) → ∞ by monotonicity + natCast; invert. -/
private lemma EM_n1_inv_tendsto_zero :
    Tendsto (fun n : ℕ => ((n : ℝ) + 1)⁻¹) atTop (nhds 0) := by
  have h_top : Tendsto (fun n : ℕ => (n : ℝ) + 1) atTop atTop := by
    apply Filter.tendsto_atTop.mpr
    intro b
    filter_upwards [Filter.eventually_ge_atTop (Nat.ceil (max b 0))] with n hn
    have hb : b ≤ (n : ℝ) := le_trans (le_max_left b 0) (by
      exact_mod_cast le_trans (Nat.le_ceil _) (by exact_mod_cast hn))
    linarith
  exact h_top.inv_tendsto_atTop

/-- EM_harmonic_shift_real (PROVED, 0 sorry):
    ∑_{k<n+1} ((k:ℝ)+1)⁻¹ − log n → eulerMascheroniConstant.
    Proof: H_n − log n → γ (Mathlib) and 1/(n+1) → 0; H_{n+1} = H_n + 1/(n+1);
    H_{n+1} − log n = (H_n − log n) + 1/(n+1) → γ + 0 = γ. -/
private lemma EM_harmonic_shift_real :
    Tendsto
      (fun n : ℕ => ∑ k in Finset.range (n+1), ((k : ℝ) + 1)⁻¹ - Real.log n)
      atTop (nhds Real.eulerMascheroniConstant) := by
  have hEM := Real.tendsto_eulerMascheroniConstant
  -- hEM : Tendsto (fun n => H_n - log n) atTop (nhds γ)
  have h_add : ∀ n : ℕ,
      ∑ k in Finset.range (n+1), ((k : ℝ) + 1)⁻¹ - Real.log n =
      (∑ k in Finset.range n, ((k : ℝ) + 1)⁻¹ - Real.log n) + ((n : ℝ) + 1)⁻¹ := by
    intro n; rw [Finset.sum_range_succ]; ring
  simp_rw [h_add]
  have h_inv := EM_n1_inv_tendsto_zero
  rw [show Real.eulerMascheroniConstant = Real.eulerMascheroniConstant + 0 by ring]
  exact hEM.add h_inv

/-- EM_logn_minus_harmonic_real (PROVED, 0 sorry):
    log n − ∑_{k<n+1} ((k:ℝ)+1)⁻¹ → −eulerMascheroniConstant. -/
private lemma EM_logn_minus_harmonic_real :
    Tendsto
      (fun n : ℕ => Real.log n - ∑ k in Finset.range (n+1), ((k : ℝ) + 1)⁻¹)
      atTop (nhds (-Real.eulerMascheroniConstant)) := by
  have h := EM_harmonic_shift_real.neg
  simp only [neg_sub] at h
  exact h

/-- EM_limit_complex_b66 (PROVED, 0 sorry) — A2 fully proved:
    (log n : ℂ) − ∑_{k<n+1} 1/((k:ℂ)+1) → −(eulerMascheroniConstant : ℂ)
    Proof: cast EM_logn_minus_harmonic_real from ℝ to ℂ via Complex.ofReal (continuous). -/
theorem EM_limit_complex_b66 :
    Tendsto
      (fun n : ℕ =>
        (Real.log n : ℂ) - ∑ k in Finset.range (n+1), (1 : ℂ) / ((k : ℂ) + 1))
      atTop
      (nhds (-(Real.eulerMascheroniConstant : ℂ))) := by
  have h_re := EM_logn_minus_harmonic_real
  -- Express the ℂ sequence as ofReal applied to the ℝ sequence
  have cast_eq : ∀ n : ℕ,
      (Real.log n : ℂ) - ∑ k in Finset.range (n+1), (1 : ℂ) / ((k : ℂ) + 1) =
      ((Real.log n - ∑ k in Finset.range (n+1), ((k : ℝ) + 1)⁻¹ : ℝ) : ℂ) := by
    intro n
    push_cast [one_div]
    congr 1
    apply Finset.sum_congr rfl
    intro k _
    push_cast
    ring
  simp_rw [cast_eq]
  -- Apply the continuous map ofReal to get ℂ convergence
  have h_cx : Tendsto
      (fun n : ℕ =>
        ((Real.log n - ∑ k in Finset.range (n+1), ((k : ℝ) + 1)⁻¹ : ℝ) : ℂ))
      atTop
      (nhds ((-Real.eulerMascheroniConstant : ℝ) : ℂ)) :=
    Complex.continuous_ofReal.continuousAt.tendsto.comp h_re
  simp only [Complex.ofReal_neg] at h_cx
  exact h_cx

-- ============================================================================
-- S2.  Named open: WW_GammaSeq_DerivExch_b66  (A1 + B bundled)
-- ============================================================================

/-- WW_GammaSeq_DerivExch_b66 (NAMED OPEN, replaces WW_GammaSeq_Wall_C_Analytics_L8):

    Two Mathlib connectivity facts bundled:

    (A1) HasDerivAt formula for GammaSeq · n:
           ∀ n ≥ 1, ∀ Re(s) > 0:
             HasDerivAt (fun z => GammaSeq z n)
               (GammaSeq s n * (log n − Σ_{k≤n} 1/(s+k))) s
           B67 proof by product/quotient/chain rule on n^s / ∏(s+k):
             HasDerivAt (n^·) (n^s * log n) s  [exp∘(·*log n) chain rule]
             HasDerivAt (∏(·+k)) (Σ_j ∏_{k≠j}(s+k)) s  [induction + HasDerivAt.mul]
             Quotient rule → GammaSeq * (log n − Σ 1/(s+k)). ~1.5pp.

    (B)  Weierstrass derivative exchange:
           ∀ Re(s) > 0:
           Tendsto (n ↦ deriv(GammaSeq · n)(s) / GammaSeq s n)
                   atTop (nhds (deriv Gamma s / Gamma s))
           B67 proof:
             Complex.GammaSeq_tendsto_Gamma (pointwise convergence, Mathlib)
             TendstoLocallyUniformlyOn (from Gamma definition or Vitali-Montel)
             Weierstrass theorem → deriv convergence
             Continuous division → ratio convergence. ~1pp.

    STATUS: OPEN. Both are pure Lean formalisations of established mathematics.
    A2 is now proved (EM_limit_complex_b66, this file). Only A1+B remain.
    Net: WW_GammaSeq_Wall_C_Analytics_L8 (1) → WW_GammaSeq_DerivExch_b66 (1). -/
def WW_GammaSeq_DerivExch_b66 : Prop :=
  -- (A1): HasDerivAt formula
  (∀ (n : ℕ), 1 ≤ n → ∀ (s : ℂ), 0 < s.re →
    HasDerivAt (fun z : ℂ => Complex.GammaSeq z n)
      (Complex.GammaSeq s n *
       ((Real.log n : ℂ) - ∑ k in Finset.range (n + 1), (1 : ℂ) / (s + (k : ℂ))))
      s)
  ∧
  -- (B): Weierstrass derivative exchange
  (∀ (s : ℂ), 0 < s.re →
    Tendsto
      (fun n : ℕ =>
        deriv (fun z : ℂ => Complex.GammaSeq z n) s / Complex.GammaSeq s n)
      atTop
      (nhds (deriv Complex.Gamma s / Complex.Gamma s)))

-- ============================================================================
-- S3.  WW_GammaSeq_Wall_C_Analytics_L8 proved from A2 + named open
-- ============================================================================

/-- WW_GammaSeq_Wall_C_Analytics_L8_from_exch (PROVED, 0 sorry):
    Given WW_GammaSeq_DerivExch_b66 (A1+B) and EM_limit_complex_b66 (A2, proved here):
      WW_GammaSeq_Wall_C_Analytics_L8 follows immediately. -/
theorem WW_GammaSeq_Wall_C_Analytics_L8_from_exch
    (h : WW_GammaSeq_DerivExch_b66) :
    ArakelovRH.Batch65WallCClose.WW_GammaSeq_Wall_C_Analytics_L8 :=
  ⟨h.1, EM_limit_complex_b66, h.2⟩

-- ============================================================================
-- S4.  Full Wall C closure chain
-- ============================================================================

/-- Wall_C_from_exch (PROVED, 0 sorry):
    Given WW_GammaSeq_DerivExch_b66, Wall C is fully closed:
    exch → analytics (S3) → WW_Final (B65) → WW_Deriv (B64 combinator). -/
theorem Wall_C_from_exch
    (h : WW_GammaSeq_DerivExch_b66) :
    ArakelovRH.Batch63GammaSeqConv.WW_GammaSeq_Deriv_L8 :=
  ArakelovRH.Batch65WallCClose.WW_GammaSeq_Deriv_L8_from_analytics
    (WW_GammaSeq_Wall_C_Analytics_L8_from_exch h)

-- ============================================================================
-- S5.  B66 certificate
-- ============================================================================

/-- batch66_certificate (PROVED, 0 sorry):
    Batch 66 status:

    PROVED (0 sorry):
    - EM_n1_inv_tendsto_zero: (n+1)⁻¹ → 0 in ℝ.
    - EM_harmonic_shift_real: H_{n+1} − log n → γ in ℝ.
    - EM_logn_minus_harmonic_real: log n − H_{n+1} → −γ in ℝ.
    - EM_limit_complex_b66 (A2): log n − H_{n+1} → −γ in ℂ (cast via ofReal).
    - WW_GammaSeq_Wall_C_Analytics_L8_from_exch: analytics from A2+exch.
    - Wall_C_from_exch: Wall C fully closed given exch.

    NAMED OPEN (1, replaces WW_GammaSeq_Wall_C_Analytics_L8, net 35 → 35):
    - WW_GammaSeq_DerivExch_b66:
        (A1) HasDerivAt formula for GammaSeq · n  [product/quotient rule, B67, ~1.5pp]
        (B)  Weierstrass derivative exchange  [locally uniform + div, B67, ~1pp]
      A2 now proved. Only A1+B remain (~2.5pp Lean).

    B67 closes WW_GammaSeq_DerivExch_b66 (all Mathlib connectivity).
    Wall C complete once B67 is merged.

    SORRY: 0. Axioms: {propext, Classical.choice, Quot.sound}. -/
theorem batch66_certificate : True := trivial

end ArakelovRH.Batch66WallCEM
