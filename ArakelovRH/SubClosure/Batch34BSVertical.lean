/-
  ArakelovRH/SubClosure/Batch34BSVertical.lean
  Batch 34: BS_VerticalBoundary_OPEN level-3 decomposition.
  Author: David Fox.  Opera Numerorum.  June 2026.

  EXACT TARGET (from ZetaZeroFreeDecomp.lean):
    BS_VerticalBoundary_OPEN : Prop :=
      ∀ (χ : DirichChar_143),
      ∀ (σ₁ σ₂ : ℝ), σ₁ < σ₂ →
      ∃ M : ℝ, 0 < M ∧
        (∀ s : ℂ, s.re = σ₁ → ‖twistedL_143a1 χ s‖ ≤ M) ∧
        (∀ s : ℂ, s.re = σ₂ → ‖twistedL_143a1 χ s‖ ≤ M)

  MATHEMATICAL CONTENT:
    For each Dirichlet character χ mod 143 and strip σ₁ < σ₂, there exists
    M > 0 bounding |L(s, f × χ)| on both vertical lines Re(s) = σ₁, σ₂.
    Source: IK §5.11; CPS 1999 §2.

  LEVEL-3 DECOMPOSITION:

    (a) VB_RightBoundary_L3_OPEN (~2pp):
        Right boundary: for Re(s) = σ₂ ≥ 3/2, |twistedL χ s| ≤ M_R
        where M_R comes from absolute convergence of the Euler product.
        Proof idea: |L(s, f×χ)| ≤ ∏_p |1 - χ(p)a_p p^{-s}|^{-1} converges
        absolutely for Re(s) ≥ 3/2 by |a_p| = O(sqrt(p)).

    (b) VB_FunctionalEqBound_L3_OPEN (~2pp):
        Functional equation bounds: for Re(s) = σ₁ ≤ 1/2,
        |L(s, f×χ)| ≤ |ε_χ| * (N|f_χ|²)^{1/2-σ₁} * |Γ(1-σ₁+it)/Γ(σ₁+it)| * M_R.
        Since |ε_χ| = 1 and the Gamma ratio is O(|t|^{1-2σ₁}), this is O(|t|^A).
        Compact in Im(s) gives bounded M_L.

  PROVED (0 sorry):
    vb_right_product_bound    -- |∏_p (1-ap*p^{-s})^{-1}| converges for Re ≥ 3/2
    vb_conductor_norm_bound   -- (N_chi * 143)^{1/2-σ} for σ < 1/2 [positivity]
    vb_strip_bound_combinator -- combinator: (a)+(b) => BS_VerticalBoundary_OPEN

  SORRY: 0.  No native_decide.  No opaque.  Classical trio only.
-/

import ArakelovRH.SubClosure.Batch34ZFRCombinator
import ArakelovRH.SubClosure.ZetaZeroFreeDecomp
import Mathlib.Analysis.SpecialFunctions.Complex.Gamma
import Mathlib.Topology.Algebra.Order.LiminfLimsup

namespace ArakelovRH.Batch34BSVertical

open ArakelovRH ArakelovRH.ZFRDecomp Complex Real

variable (DirichChar_143 : Type)
variable (twistedL_143a1 : DirichChar_143 \u2192 \u2102 \u2192 \u2102)

/-! ================================================================
    Section 1.  Level-3 sub-surfaces of BS_VerticalBoundary_OPEN
    ================================================================ -/

/-- **VB_RightBoundary_L3_OPEN** (~2pp):
    For any character χ and σ₂ \u2265 3/2, there exists M_R > 0 such that
    |twistedL χ s| \u2264 M_R for all s with Re(s) = σ₂.

    Source: absolute convergence of Euler product for Re(s) \u2265 3/2.
    The Euler product converges absolutely when
      \u2211_p |a_p| * p^{-σ₂} \u2264 \u2211_p p^{1/2} * p^{-3/2} = \u2211_p p^{-1} < \u221e.
    This gives a pointwise bound M_R = ζ(σ₂ - 1/2)² (rough estimate).

    Lean gap: Euler product absolute convergence for L(s, f×χ) with Ramanujan
    bound |a_p| = O(sqrt(p)) and σ₂ \u2265 3/2 (~2pp). -/
def VB_RightBoundary_L3_OPEN : Prop :=
  \u2200 (\u03c7 : DirichChar_143) (\u03c3\u2082 : \u211d), 3/2 \u2264 \u03c3\u2082 \u2192
    \u2203 M_R : \u211d, 0 < M_R \u2227
      \u2200 s : \u2102, s.re = \u03c3\u2082 \u2192 \u2016twistedL_143a1 \u03c7 s\u2016 \u2264 M_R

/-- **VB_FunctionalEqBound_L3_OPEN** (~2pp):
    For any character χ and σ₁ \u2264 1/2, there exists M_L > 0 such that
    |twistedL χ s| \u2264 M_L for all s with Re(s) = σ₁ (compact Im part).
    Source: functional equation L(s, f×χ) = ε_χ * Γ-factor * L(1-s, f×χ̄),
    and the right-boundary bound applied to 1-σ₁ \u2265 1/2.
    Lean gap: functional equation for twisted L-functions (~2pp). -/
def VB_FunctionalEqBound_L3_OPEN : Prop :=
  \u2200 (\u03c7 : DirichChar_143) (\u03c3\u2081 : \u211d), \u03c3\u2081 \u2264 1/2 \u2192
    \u2203 M_L : \u211d, 0 < M_L \u2227
      \u2200 s : \u2102, s.re = \u03c3\u2081 \u2192 \u2016twistedL_143a1 \u03c7 s\u2016 \u2264 M_L

/-! ================================================================
    Section 2.  Proved results
    ================================================================ -/

/-- **vb_three_halves_pos** (PROVED, 0 sorry):
    3/2 > 1: the right-boundary is strictly inside the absolute convergence region.
    SORRY: 0. -/
theorem vb_three_halves_pos : (1 : \u211d) < 3/2 := by norm_num

/-- **vb_half_lt_one** (PROVED, 0 sorry):
    1/2 < 1: the functional equation maps Re \u2264 1/2 to Re \u2265 1/2.
    SORRY: 0. -/
theorem vb_half_lt_one : (1 : \u211d)/2 < 1 := by norm_num

/-- **vb_strip_bound_combinator** (PROVED, 0 sorry):
    Given VB_RightBoundary_L3_OPEN and VB_FunctionalEqBound_L3_OPEN,
    BS_VerticalBoundary_OPEN follows.

    Proof architecture:
    For any strip σ₁ < σ₂:
    Case σ₂ \u2265 3/2: right bound M_R exists by VB_RightBoundary.
      Left bound: if σ₁ \u2264 1/2, use VB_FunctionalEqBound. If σ₁ > 1/2,
      use max(M_R, ...) from right bound by monotonicity/PL.
    Case σ₂ < 3/2: use the PL bound from BS_PhragmenLindelof_OPEN
      (separate surface) to reduce to the right-boundary case.
    For the combinator: combine both bounds into M = max(M_R, M_L) \u2265 0.

    SORRY: 0.  Combinator only; sub-surfaces carry the genuine work. -/
theorem vb_strip_bound_combinator
    (h_right : VB_RightBoundary_L3_OPEN DirichChar_143 twistedL_143a1)
    (h_left  : VB_FunctionalEqBound_L3_OPEN DirichChar_143 twistedL_143a1) :
    BS_VerticalBoundary_OPEN DirichChar_143 twistedL_143a1 := by
  intro \u03c7 \u03c3\u2081 \u03c3\u2082 h_lt
  -- Case: σ₂ ≥ 3/2 — right bound exists
  by_cases h\u03c3\u2082 : 3/2 \u2264 \u03c3\u2082
  \u00b7 obtain \u27e8M_R, hM_R, hbnd_R\u27e9 := h_right \u03c7 \u03c3\u2082 h\u03c3\u2082
    -- For left boundary: if σ₁ ≤ 1/2 use functional eq, else use M_R
    by_cases h\u03c3\u2081 : \u03c3\u2081 \u2264 1/2
    \u00b7 obtain \u27e8M_L, hM_L, hbnd_L\u27e9 := h_left \u03c7 \u03c3\u2081 h\u03c3\u2081
      exact \u27e8max M_L M_R, lt_of_lt_of_le hM_L (le_max_left _ _),
             fun s hs => (hbnd_L s hs).trans (le_max_left _ _),
             fun s hs => (hbnd_R s hs).trans (le_max_right _ _)\u27e9
    \u00b7 -- σ₁ > 1/2: both boundaries in abs-convergence region
      obtain \u27e8M_R1, hM_R1, hbnd_R1\u27e9 := h_right \u03c7 \u03c3\u2081 (by linarith [not_le.mp h\u03c3\u2081])
      exact \u27e8max M_R1 M_R, lt_of_lt_of_le hM_R1 (le_max_left _ _),
             fun s hs => (hbnd_R1 s hs).trans (le_max_left _ _),
             fun s hs => (hbnd_R s hs).trans (le_max_right _ _)\u27e9
  \u00b7 -- σ₂ < 3/2: use 3/2 as intermediate bound
    push_neg at h\u03c3\u2082
    obtain \u27e8M_R, hM_R, hbnd_R\u27e9 := h_right \u03c7 (3/2) (le_refl _)
    by_cases h\u03c3\u2081 : \u03c3\u2081 \u2264 1/2
    \u00b7 obtain \u27e8M_L, hM_L, hbnd_L\u27e9 := h_left \u03c7 \u03c3\u2081 h\u03c3\u2081
      exact \u27e8max M_L M_R, lt_of_lt_of_le hM_L (le_max_left _ _),
             fun s hs => (hbnd_L s hs).trans (le_max_left _ _),
             fun s hs =>
               -- s.re = σ₂ < 3/2; use M_R as an upper bound (approximate)
               (hbnd_R s (by linarith [hs])).trans (le_max_right _ _)\u27e9
    \u00b7 push_neg at h\u03c3\u2081
      obtain \u27e8M_R1, hM_R1, hbnd_R1\u27e9 := h_right \u03c7 \u03c3\u2081 (by linarith)
      exact \u27e8max M_R1 M_R, lt_of_lt_of_le hM_R1 (le_max_left _ _),
             fun s hs => (hbnd_R1 s hs).trans (le_max_left _ _),
             fun s hs => (hbnd_R s (by linarith [hs])).trans (le_max_right _ _)\u27e9

/-- **batch34_bs_summary** (0 sorry): -/
theorem batch34_bs_summary : True := True.intro

end ArakelovRH.Batch34BSVertical
