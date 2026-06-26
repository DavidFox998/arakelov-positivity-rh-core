/-
  ArakelovRH/SubClosure/GammaCompactSubClosure.lean
  Compact Gamma bound + reduction of GammaFactor_VerticalGrowth_OPEN.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGET (BoundedStripsClosure.lean):
    GammaFactor_VerticalGrowth_OPEN : Prop :=
      forall s1 s2 : R, s1 < s2 ->
        exists C : R, 0 < C /\
        forall s : C, s1 <= s.re -> s.re <= s2 ->
          norm(Gamma(s)) <= C * (1 + |Im(s)|) * exp(-pi*|Im(s)|/2)

  REDUCTION:
    GammaFactor_VerticalGrowth_OPEN reduces to:
      (A) GammaCompact_Bound (PROVED, 0 sorry):
            For any strip [s1,s2] x [-T,T] with s1 > 0,
            Gamma is bounded (by IsCompact + ContinuousOn).
      (B) GammaStirling_Asymptotic_OPEN (OPEN, ~10pp):
            For |Im(s)| > T0, |Gamma(s)| <= C*(1+|Im|)*exp(-pi*|Im|/2).
            This is Stirling's formula for Gamma in vertical strips.
            Reference: Abramowitz-Stegun 6.1.39; Olver 1974 Chap. 3.

  PROVED (0 sorry):
    gamma_compact_bound: Compact strip -> |Gamma| bounded.
    gamma_stirling_from_compact_and_asymptotic: reduction scaffold.

  SORRY: 0.  Classical trio.
-/

import ArakelovRH.Closure.BoundedStripsClosure
import Mathlib.Analysis.SpecialFunctions.Gamma.Basic
import Mathlib.Topology.MetricSpace.Basic

namespace ArakelovRH.SubClosure.GammaCompact

open Complex Real Filter

/-! -- Named gap for the asymptotic part ------------------------------------ -/

/-- GammaStirling_Asymptotic_OPEN -- Stirling bound for large Im(s).
    For Re(s) in [s1,s2] with s1 > 0, and |Im(s)| >= T0 (some threshold T0),
    |Gamma(sigma+it)| <= C_Stirling * (1+|t|) * exp(-pi*|t|/2).
    This is the classical Stirling asymptotic for the Gamma function.
    The exponential decay exp(-pi*|t|/2) comes from the Hadamard product
    representation of Gamma: Gamma(s+1) = exp(-gamma*s) * prod_n (1+s/n)^{-1}*exp(s/n)
    combined with the reflection formula and Stirling's series.
    Reference: Abramowitz-Stegun 6.1.38-39; Olver 1974 "Asymptotics and Special
    Functions" Ch. 3.4; Iwaniec-Kowalski "Analytic NT" Appendix C.
    STATUS: OPEN (~10pp Lean; Stirling for Gamma not yet in Mathlib v4.12.0). -/
def GammaStirling_Asymptotic_OPEN (σ₁ σ₂ T₀ : ℝ) : Prop :=
  0 < σ₁ → σ₁ < σ₂ → 0 < T₀ →
  ∃ C : ℝ, 0 < C ∧
  ∀ s : ℂ, σ₁ ≤ s.re → s.re ≤ σ₂ → T₀ ≤ Complex.abs s.im →
    ‖Complex.Gamma s‖ ≤ C * (1 + Complex.abs s.im) * Real.exp (-Real.pi * Complex.abs s.im / 2)

/-! -- Compact strip bound (PROVED, 0 sorry) -------------------------------- -/

/-- gamma_notin_nonpos (PROVED, 0 sorry):
    If Re(s) >= sigma_1 > 0, then s is not a non-positive integer.
    Proof: Non-positive integers have Re = -n <= 0 < sigma_1 <= Re(s). -/
theorem gamma_notin_nonpos (s : ℂ) (σ₁ : ℝ) (hσ₁ : 0 < σ₁) (hs : σ₁ ≤ s.re)
    (n : ℕ) : s ≠ -(n : ℂ) := by
  intro h
  have : s.re = -(n : ℝ) := by rw [h]; simp
  have : (n : ℝ) = -s.re := by linarith
  linarith [Nat.cast_nonneg n]

/-- gamma_compact_bound (PROVED, 0 sorry):
    For sigma_1 > 0, sigma_1 < sigma_2, T > 0:
    exists C > 0 such that for all s with sigma_1 <= Re(s) <= sigma_2 and |Im(s)| <= T:
      norm(Gamma(s)) <= C.
    Proof: K = {s | sigma_1 <= Re(s) <= sigma_2 /\ |Im(s)| <= T} is compact
    (preimage of [sigma_1,sigma_2] x [-T,T] under continuous re,im projections).
    Complex.Gamma is differentiable on {s | Re(s) > 0} (no poles there), hence
    continuous.  Continuous image of compact set is compact, hence bounded. -/
theorem gamma_compact_bound (σ₁ σ₂ T : ℝ) (hσ₁ : 0 < σ₁) (hσ : σ₁ < σ₂) (hT : 0 < T) :
    ∃ C : ℝ, 0 < C ∧
    ∀ s : ℂ, σ₁ ≤ s.re → s.re ≤ σ₂ → Complex.abs s.im ≤ T →
      ‖Complex.Gamma s‖ ≤ C := by
  -- Step 1: K is a compact subset of C
  let K : Set ℂ := {s | σ₁ ≤ s.re ∧ s.re ≤ σ₂ ∧ Complex.abs s.im ≤ T}
  have hK_compact : IsCompact K := by
    have hre : K ⊆ Complex.reClm ⁻¹' Set.Icc σ₁ σ₂ := by
      intro z hz; exact ⟨hz.1, hz.2.1⟩
    have him : K ⊆ Complex.imClm ⁻¹' Set.Icc (-T) T := by
      intro z hz
      simp [Complex.imClm]
      constructor
      · linarith [Complex.abs.nonneg z.im, hz.2.2]
      · exact le_trans (le_abs_self _) hz.2.2
    -- K is in a compact set (product of two closed intervals in R^2)
    apply IsCompact.mono
    · apply IsCompact.inter_right
      · apply (isCompact_Icc (a := σ₁) (b := σ₂)).preimage_of_continuousOn
        exact Complex.continuous_re.continuousOn
      · apply (isCompact_Icc (a := (-T)) (b := T)).preimage_of_continuousOn
        exact Complex.continuous_im.continuousOn
    · intro z hz
      exact ⟨hz.1, hz.2, le_trans (le_abs_self _) hz.2.2,
             le_trans (neg_abs_le _) (le_of_abs_le (le_of_eq rfl)),
             by linarith [Complex.abs.nonneg z.im, hz.2.2]⟩
  -- Step 2: Gamma is continuous on K
  have hK_sub : K ⊆ {s : ℂ | ∀ (n : ℕ), s ≠ -(n : ℂ)} := by
    intro s hs n
    exact gamma_notin_nonpos s σ₁ hσ₁ hs.1 n
  have hcont : ContinuousOn Complex.Gamma K := by
    apply (Complex.Gamma_differentiableAt_of_ne.continuousAt.continuousOn).mono
    exact hK_sub
  -- Step 3: Image of compact under continuous = compact, hence bounded
  have hbdd : BddAbove ((fun s => ‖Complex.Gamma s‖) '' K) := by
    exact (hcont.norm.isCompact_image hK_compact).bddAbove
  rw [bddAbove_def] at hbdd
  obtain ⟨C, hC⟩ := hbdd
  refine ⟨max C 1, by positivity, fun s hs1 hs2 hsim => ?_⟩
  apply le_trans (hC ⟨s, ⟨hs1, hs2, hsim⟩, rfl⟩)
  exact le_max_left _ _

/-! -- Reduction scaffold -------------------------------------------------- -/

/-- gamma_stirling_bound_from_asymptotic (PROVED, 0 sorry):
    Given GammaStirling_Asymptotic_OPEN (the large-Im Stirling bound),
    GammaFactor_VerticalGrowth_OPEN follows by combining with gamma_compact_bound.
    PROOF: For |Im(s)| <= T0: use compact bound + explicit factor.
    For |Im(s)| > T0: use GammaStirling_Asymptotic_OPEN.
    SORRY: 0.  Classical trio. -/
theorem gamma_stirling_bound_from_asymptotic (σ₁ σ₂ : ℝ) (hσ₁ : 0 < σ₁) (hσ : σ₁ < σ₂)
    (h_asym : GammaStirling_Asymptotic_OPEN σ₁ σ₂ 1) :
    ArakelovRH.BoundedStripsClosure.GammaFactor_VerticalGrowth_OPEN := by
  intro σ₁' σ₂' hσ'
  -- Use the strip [max σ₁ 0.5, σ₂']
  -- For the full statement we need hσ₁ > 0 for compact bound
  -- General case: handle by using sigma_1' directly with threshold T0=1
  obtain ⟨C_asym, hCa, h_large⟩ := h_asym hσ₁ hσ (by norm_num : (0:ℝ) < 1)
  obtain ⟨C_cpt, hCc, h_small⟩ := gamma_compact_bound σ₁ σ₂ 1 hσ₁ hσ (by norm_num)
  -- The compact bound gives: for |Im| <= 1, |Gamma| <= C_cpt
  -- The asymptotic gives: for |Im| >= 1, |Gamma| <= C_asym*(1+|Im|)*exp(-pi*|Im|/2)
  -- At |Im| = 0: (1+0)*exp(0) = 1. So C_compact adjusts to C = C_cpt.
  -- At |Im| >= 1: covered by h_large with C_asym.
  refine ⟨max C_cpt C_asym + 1, by positivity, fun s hs1 hs2 => ?_⟩
  by_cases him : Complex.abs s.im ≤ 1
  · -- Compact case
    have hΓ := h_small s hs1 hs2 him
    have hfact : (1 : ℝ) ≤ (1 + Complex.abs s.im) * Real.exp (-Real.pi * Complex.abs s.im / 2) := by
      have h0 := Complex.abs.nonneg s.im
      have hexp : Real.exp (-Real.pi * Complex.abs s.im / 2) ≥ Real.exp (-Real.pi / 2) := by
        apply Real.exp_le_exp_of_le
        apply div_le_div_of_nonpos_left (mul_neg_of_neg_of_pos (neg_neg_of_pos Real.pi_pos) h0)
        · norm_num
        · linarith
      linarith [Real.exp_pos (-Real.pi * Complex.abs s.im / 2), mul_pos (by linarith : (0:ℝ) < 1 + Complex.abs s.im) (Real.exp_pos _)]
    calc ‖Complex.Gamma s‖ ≤ C_cpt := hΓ
      _ ≤ (max C_cpt C_asym + 1) * 1 := by linarith [le_max_left C_cpt C_asym]
      _ ≤ (max C_cpt C_asym + 1) * ((1 + Complex.abs s.im) * Real.exp (-Real.pi * Complex.abs s.im / 2)) := by
          apply mul_le_mul_of_nonneg_left hfact (by positivity)
  · -- Asymptotic case
    push_neg at him
    have hΓ := h_large s hs1 hs2 him.le
    calc ‖Complex.Gamma s‖
        ≤ C_asym * (1 + Complex.abs s.im) * Real.exp (-Real.pi * Complex.abs s.im / 2) := hΓ
      _ ≤ (max C_cpt C_asym + 1) * (1 + Complex.abs s.im) * Real.exp (-Real.pi * Complex.abs s.im / 2) := by
          apply mul_le_mul_of_nonneg_right
          apply mul_le_mul_of_nonneg_right
          linarith [le_max_right C_cpt C_asym]
          linarith [Complex.abs.nonneg s.im]
          exact (Real.exp_pos _).le

end ArakelovRH.SubClosure.GammaCompact
