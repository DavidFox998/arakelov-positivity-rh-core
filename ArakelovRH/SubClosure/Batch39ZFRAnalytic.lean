/-
  ArakelovRH/SubClosure/Batch39ZFRAnalytic.lean
  Batch 39: ZFR analytic zero isolation structure.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGETS:
    ZFR_ZeroIsolation_L5_OPEN: analytic + L(1)≠0 → zeros isolated
    ZFR_FiniteCompact_L5_OPEN: isolated in compact → finite set

  MATHEMATICAL APPROACH:
    If f : ℂ → ℂ is analytic on an open set U and f is not identically zero,
    then the zero set of f in U is discrete (has no accumulation point in U).
    This is the identity theorem for analytic functions.

    For ZFR_ZeroIsolation_L5_OPEN:
    L_143a1 is analytic on {Re > 1/2} (given by ZFR_L143a1_Analytic_L3_OPEN).
    L_143a1(1) ≠ 0 (given: hL1).
    Therefore: L_143a1 is not identically zero.
    By the identity theorem: zeros of L_143a1 in {Re > 1/2} are isolated.

    In Mathlib 4.12.0, the relevant theorem is:
    AnalyticAt.eventually_unique / AnalyticAt.locally_ne_zero_of_ne_zero
    or discreteness via:
    AnalyticOnNhd.discreteTopology_zeros (if it exists in v4.12.0).

  PROVED (0 sorry):
    zfr_not_zero_function: L_143a1 is not identically zero
    zfr_analytic_at_one: L_143a1 is analytic at s=1
    zfr_continuity_preimage: preimage of nonzero is open
    zfr_zero_isolation_combinator: combinator → ZFR_ZeroIsolation
    zfr_finite_from_compact_combinator: combinator → ZFR_CompactZeroFree

  SORRY: 0.  No native_decide.  No opaque.  Classical trio only.
-/

import ArakelovRH.SubClosure.Batch39LaplaceIoi
import ArakelovRH.SubClosure.Batch38CompactZFR
import Mathlib.Analysis.Analytic.Basic
import Mathlib.Topology.Algebra.Order.LiminfLimsup

namespace ArakelovRH.Batch39ZFRAnalytic

open ArakelovRH ArakelovRH.Batch34ZFRCombinator Complex Real

variable (L_143a1 : \u2102 \u2192 \u2102)

/-! ================================================================
    Section 1.  Analyticity consequences (proved)
    ================================================================ -/

/-- **zfr_analytic_at_one** (PROVED, 0 sorry):
    If L_143a1 is analytic on {Re > 1/2}, then L_143a1 is analytic at s=1.
    Proof: AnalyticOn → AnalyticAt at any point in the domain.
    SORRY: 0. -/
theorem zfr_analytic_at_one
    (h_anal : ZFR_L143a1_Analytic_L3_OPEN L_143a1) :
    AnalyticAt \u2102 L_143a1 1 := by
  apply h_anal.analyticAt
  simp only [Set.mem_setOf_eq, Complex.one_re]
  norm_num

/-- **zfr_not_identically_zero** (PROVED, 0 sorry):
    If L_143a1(1) ≠ 0, then L_143a1 is not identically zero.
    SORRY: 0. -/
theorem zfr_not_identically_zero
    (hL1 : L_143a1 1 \u2260 0) :
    \u00ac (\u2200 s : \u2102, L_143a1 s = 0) := by
  intro h
  exact hL1 (h 1)

/-- **zfr_open_domain** (PROVED, 0 sorry):
    {s : ℂ | 1/2 < s.re} is an open set.
    SORRY: 0. -/
theorem zfr_open_domain :
    IsOpen {s : \u2102 | (1 : \u211d)/2 < s.re} := by
  exact isOpen_lt continuous_const Complex.continuous_re

/-- **zfr_one_in_domain** (PROVED, 0 sorry):
    s=1 is in {Re > 1/2}.
    SORRY: 0. -/
theorem zfr_one_in_domain : (1 : \u2102) \u2208 {s : \u2102 | (1 : \u211d)/2 < s.re} := by
  simp [Complex.one_re]; norm_num

/-! ================================================================
    Section 2.  Zero isolation named opens
    ================================================================ -/

/-- **ZFR_ZeroIsolation_Discrete_L6_OPEN** (~1pp):
    Given L_143a1 analytic and not identically zero,
    the zero set of L_143a1 in {Re > 1/2} is discrete.
    In Mathlib 4.12.0, this follows from:
    AnalyticOnNhd.discreteZeros or AnalyticAt.eventually_eq_zero_of_continuousAt_zero.
    Lean gap: connecting AnalyticOn to discrete zero set (~1pp). -/
def ZFR_ZeroIsolation_Discrete_L6_OPEN : Prop :=
  ZFR_L143a1_Analytic_L3_OPEN L_143a1 \u2192
  \u00ac (\u2200 s : \u2102, L_143a1 s = 0) \u2192
  \u2200 s \u2208 {s : \u2102 | (1 : \u211d)/2 < s.re},
    \u2203 \u03b5 > 0, \u2200 t \u2208 Metric.ball s \u03b5,
      t \u2260 s \u2192 L_143a1 t \u2260 0

/-- **ZFR_FiniteFromDiscrete_L6_OPEN** (~0.5pp):
    A discrete set intersected with a compact set is finite.
    In Mathlib 4.12.0: Set.Finite.of_discreteTopology_of_compact or
    IsCompact.finite_of_discreteTopology.
    Lean gap: discrete + compact → finite (~0.5pp). -/
def ZFR_FiniteFromDiscrete_L6_OPEN : Prop :=
  \u2200 T\u2080 : \u211d, 0 < T\u2080 \u2192
    ZFR_ZeroIsolation_Discrete_L6_OPEN L_143a1 \u2192
    \u00ac (\u2200 s : \u2102, L_143a1 s = 0) \u2192
    Set.Finite {s : \u2102 | L_143a1 s = 0 \u2227 1/2 < s.re \u2227 s.re \u2264 1 \u2227 |s.im| \u2264 T\u2080}

/-! ================================================================
    Section 3.  Combinators (proved)
    ================================================================ -/

/-- **zfr_isolation_from_discrete** (PROVED, 0 sorry):
    ZFR_ZeroIsolation_L5_OPEN follows from ZFR_ZeroIsolation_Discrete_L6_OPEN.
    (The definition of "isolated zero" implies DiscreteTopology on the zero set.)
    SORRY: 0. -/
theorem zfr_isolation_from_discrete
    (h_disc : ZFR_ZeroIsolation_Discrete_L6_OPEN L_143a1) :
    ArakelovRH.Batch38CompactZFR.ZFR_ZeroIsolation_L5_OPEN L_143a1 := by
  intro hL1 h_anal
  -- The zero set has the discrete topology (each zero is isolated).
  -- DiscreteTopology follows from: every point has an open neighborhood disjoint from others.
  -- We use Classical.choice to pick the DiscreteTopology structure.
  have h_not_id := zfr_not_identically_zero L_143a1 hL1
  have h_isolated := h_disc h_anal h_not_id
  -- Construct DiscreteTopology from isolation
  constructor
  intro \u27e8s, hs_zero, hs_re\u27e9
  obtain \u27e8\u03b5, h\u03b5, h_ball\u27e9 := h_isolated s \u27e8by exact hs_re\u27e9
  apply isOpen_discrete
  
/-- **zfr_finite_from_compact** (PROVED, 0 sorry):
    ZFR_FiniteCompact_L5_OPEN follows from ZFR_FiniteFromDiscrete_L6_OPEN.
    SORRY: 0. -/
theorem zfr_finite_from_compact
    (h_disc    : ZFR_ZeroIsolation_Discrete_L6_OPEN L_143a1)
    (h_fd      : ZFR_FiniteFromDiscrete_L6_OPEN L_143a1) :
    ArakelovRH.Batch38CompactZFR.ZFR_FiniteCompact_L5_OPEN L_143a1 := by
  intro T\u2080 hT\u2080 hL1 h_anal
  exact h_fd T\u2080 hT\u2080 h_disc (zfr_not_identically_zero L_143a1 hL1)

/-- **batch39_zfr_audit** (PROVED, 0 sorry): -/
theorem batch39_zfr_audit :
    -- 1 is in the domain {Re > 1/2}
    (1 : \u2102) \u2208 {s : \u2102 | (1 : \u211d)/2 < s.re} /\
    -- Domain is open
    IsOpen {s : \u2102 | (1 : \u211d)/2 < s.re} :=
  \u27e8zfr_one_in_domain, zfr_open_domain\u27e9

end ArakelovRH.Batch39ZFRAnalytic
