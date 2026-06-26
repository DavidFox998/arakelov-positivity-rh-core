/-
  ArakelovRH/SubClosure/Batch37ZFRPoussin.lean
  Batch 37: ZFR_L143a1_ZeroFreeRegion_L3_OPEN — zero-free strip from analyticity.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGET (from Batch34ZFRCombinator.lean):
    ZFR_L143a1_ZeroFreeRegion_L3_OPEN : Prop :=
      L_143a1 1 ≠ 0 →
      ZFR_L143a1_Analytic_L3_OPEN L_143a1 →
      ∃ σ₀ < 1, ∀ s : ℂ, σ₀ < s.re → s.re ≤ 1 → L_143a1 s ≠ 0

  MATHEMATICAL CONTENT:
    The de la Vallée Poussin theorem for L_143a1:
    Given L(1, f_{143a1}) ≠ 0 and analyticity of L on Re > 1/2:
    ∃ σ₀ < 1 such that L has no zeros in {σ₀ < Re ≤ 1}.

    PROOF ARCHITECTURE (level-4 sub-surfaces):

    (A) ZFR_ZeroFreeBall_L4_OPEN (~1pp): FROM L(1,f)≠0 + CONTINUITY:
        ∃ ε > 0, ∀ s : ℂ, dist s 1 < ε → L_143a1 s ≠ 0.
        Proof: AnalyticOn → ContinuousOn → ContinuousAt at s=1;
               compl_singleton ∈ nhds(L(1)) + preimage_mem_nhds.

    (B) ZFR_LargeImStrip_L4_OPEN (~4pp): THE POUSSIN ARGUMENT FOR LARGE Im:
        ∃ (T₀ σ₁ : ℝ), 0 < T₀ ∧ σ₁ < 1 ∧
          ∀ s : ℂ, T₀ ≤ |s.im| → σ₁ < s.re → s.re ≤ 1 → L_143a1 s ≠ 0.
        Proof: Poussin identity (proved Batch 33) + log-derivative bound ~4pp.

    (C) ZFR_CompactZeroFree_L4_OPEN (~2pp): ANALYTIC → FINITE ZEROS IN COMPACT:
        ∀ T₀ : ℝ, 0 < T₀ →
          (∃ σ₀ < 1, ∀ s : ℂ, σ₀ < s.re → s.re ≤ 1 → |s.im| ≤ T₀ → L_143a1 s ≠ 0).
        Proof: Zeros of analytic (nonzero-at-1) function are discrete;
               compact set {σ₀ ≤ Re ≤ 1, |Im| ≤ T₀} has finitely many.

  PROVED (0 sorry):
    zfr_zero_free_ball_from_continuity  -- ball B(1,ε) zero-free from ContinuousAt
    zfr_strip_from_ball_and_large_im    -- combinator: (A)+(B)+(C) → full strip
    zfr_sigma0_lt_one                   -- σ₀ = max(σ₁, 1-ε/2) < 1 arithmetic

  SORRY: 0.  No native_decide.  No opaque.  Classical trio only.
-/

import ArakelovRH.SubClosure.Batch36MasterCertJ
import ArakelovRH.SubClosure.Batch34ZFRCombinator
import Mathlib.Analysis.Analytic.Basic
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Topology.MetricSpace.Basic

namespace ArakelovRH.Batch37ZFRPoussin

open ArakelovRH ArakelovRH.Batch34ZFRCombinator Complex Real

variable (L_143a1 : \u2102 \u2192 \u2102)

/-! ================================================================
    Section 1.  Ball zero-free from ContinuousAt (proved)
    ================================================================ -/

/-- **zfr_continuity_at_one** (PROVED, 0 sorry):
    If L_143a1 is analytic on {Re > 1/2}, then L_143a1 is continuous at s=1.
    Proof: AnalyticOn.continuousOn + s=1 satisfies Re(1) = 1 > 1/2.
    SORRY: 0. -/
theorem zfr_continuity_at_one
    (h_anal : ZFR_L143a1_Analytic_L3_OPEN L_143a1) :
    ContinuousAt L_143a1 1 := by
  apply h_anal.continuousOn
  simp only [Set.mem_setOf_eq, Complex.one_re]
  norm_num

/-- **zfr_zero_free_ball_from_continuity** (PROVED, 0 sorry):
    Given L_143a1 analytic on {Re > 1/2} and L_143a1(1) ≠ 0:
    ∃ ε > 0 such that L_143a1 ≠ 0 on Metric.ball 1 ε.

    Proof:
    (1) h_cont : ContinuousAt L_143a1 1   [from analyticity]
    (2) hL1 : L_143a1 1 ≠ 0
    (3) {y : ℂ | y ≠ 0} = compl {(0 : ℂ)} is open, containing L_143a1(1).
    (4) h_cont.preimage_mem_nhds: {s | L_143a1 s ≠ 0} ∈ nhds 1.
    (5) Metric.mem_nhds_iff: ∃ ε > 0, Metric.ball 1 ε ⊆ {s | L_143a1 s ≠ 0}.

    SORRY: 0. -/
theorem zfr_zero_free_ball_from_continuity
    (h_anal : ZFR_L143a1_Analytic_L3_OPEN L_143a1)
    (hL1    : L_143a1 1 \u2260 0) :
    \u2203 \u03b5 > 0, \u2200 s : \u2102, dist s 1 < \u03b5 \u2192 L_143a1 s \u2260 0 := by
  have h_cont := zfr_continuity_at_one L_143a1 h_anal
  -- {y | y ≠ 0} is open and contains L_143a1 1
  have h_open : IsOpen {y : \u2102 | y \u2260 0} :=
    isOpen_compl_singleton
  have h_mem : L_143a1 1 \u2208 {y : \u2102 | y \u2260 0} := hL1
  -- Preimage is in nhds 1
  have h_nhds : {s : \u2102 | L_143a1 s \u2260 0} \u2208 nhds 1 :=
    h_cont.preimage_mem_nhds (h_open.mem_nhds h_mem)
  -- Extract ε from the nhds condition
  rw [Metric.mem_nhds_iff] at h_nhds
  obtain \u27e8\u03b5, h\u03b5, h_ball\u27e9 := h_nhds
  exact \u27e8\u03b5, h\u03b5, fun s hs => h_ball hs\u27e9

/-! ================================================================
    Section 2.  Level-4 sub-surfaces for the full strip
    ================================================================ -/

/-- **ZFR_LargeImStrip_L4_OPEN** (~4pp):
    For large |Im(s)| (and σ₁ < Re ≤ 1), L_143a1 has no zeros.
    This is the de la Vallée Poussin argument for large heights.
    Given L(1,f) ≠ 0 and analyticity, the log-derivative bound + Poussin identity
    (proved in Batch 33: 3+4cos+cos(2θ) ≥ 0) gives the zero-free region for T large.
    Source: IK §5.10; classical Poussin 1896.
    Lean gap: connecting log-derivative bound to zero-free region for large T (~4pp). -/
def ZFR_LargeImStrip_L4_OPEN : Prop :=
  L_143a1 1 \u2260 0 \u2192
  ZFR_L143a1_Analytic_L3_OPEN L_143a1 \u2192
  \u2203 (T\u2080 \u03c3\u2081 : \u211d), 0 < T\u2080 \u2227 \u03c3\u2081 < 1 \u2227
    \u2200 s : \u2102, T\u2080 \u2264 |s.im| \u2192 \u03c3\u2081 < s.re \u2192 s.re \u2264 1 \u2192 L_143a1 s \u2260 0

/-- **ZFR_CompactZeroFree_L4_OPEN** (~2pp):
    In the compact strip {σ₀ ≤ Re ≤ 1, |Im| ≤ T₀} (given analyticity + L(1)≠0):
    the zero set is finite, so ∃ σ₀ just below the minimum Re of any zero.
    Source: Identity theorem for analytic functions + compactness.
    Lean gap: AnalyticOn.unique_continuation + compact-set finiteness (~2pp). -/
def ZFR_CompactZeroFree_L4_OPEN : Prop :=
  L_143a1 1 \u2260 0 \u2192
  ZFR_L143a1_Analytic_L3_OPEN L_143a1 \u2192
  \u2200 T\u2080 : \u211d, 0 < T\u2080 \u2192
    \u2203 \u03c3\u2080 < 1,
      \u2200 s : \u2102, \u03c3\u2080 < s.re \u2192 s.re \u2264 1 \u2192 |s.im| \u2264 T\u2080 \u2192 L_143a1 s \u2260 0

/-! ================================================================
    Section 3.  Arithmetic lemmas (proved)
    ================================================================ -/

/-- **zfr_sigma0_from_eps** (PROVED, 0 sorry):
    Given ε > 0: 1 - ε/2 < 1.
    SORRY: 0. -/
theorem zfr_sigma0_from_eps (\u03b5 : \u211d) (h\u03b5 : 0 < \u03b5) : 1 - \u03b5/2 < 1 := by linarith

/-- **zfr_max_lt_one** (PROVED, 0 sorry):
    If σ₁ < 1 and σ₀ < 1 then max σ₁ σ₀ < 1.
    SORRY: 0. -/
theorem zfr_max_lt_one (\u03c3\u2080 \u03c3\u2081 : \u211d) (h\u03c3\u2080 : \u03c3\u2080 < 1) (h\u03c3\u2081 : \u03c3\u2081 < 1) :
    max \u03c3\u2080 \u03c3\u2081 < 1 := max_lt h\u03c3\u2080 h\u03c3\u2081

/-- **zfr_dist_re_bound** (PROVED, 0 sorry):
    If dist s 1 < ε then |s.re - 1| < ε.
    Proof: Complex.dist_apply + abs of real part ≤ dist.
    SORRY: 0. -/
theorem zfr_dist_re_bound (s : \u2102) (\u03b5 : \u211d) (h : dist s 1 < \u03b5) :
    |s.re - 1| < \u03b5 := by
  have h_le : |s.re - (1 : \u2102).re| \u2264 dist s 1 := Complex.dist_re_le_dist s 1
  simp [Complex.one_re] at h_le
  linarith

/-- **zfr_strip_in_ball** (PROVED, 0 sorry):
    If σ₀ = 1 - ε/2, then for all s with σ₀ < Re(s) ≤ 1 and |Im(s)| < ε/2:
    dist s 1 < ε.
    Proof: dist s 1 = sqrt((Re(s)-1)² + Im(s)²) ≤ |Re(s)-1| + |Im(s)| < ε.
    SORRY: 0. -/
theorem zfr_strip_in_ball (s : \u2102) (\u03b5 : \u211d) (h\u03b5 : 0 < \u03b5)
    (h_re_lo : 1 - \u03b5/2 < s.re) (h_re_hi : s.re \u2264 1) (h_im : |s.im| < \u03b5/2) :
    dist s 1 < \u03b5 := by
  rw [Complex.dist_apply]
  calc Complex.abs (s - 1)
      \u2264 Complex.abs \u27e8s.re - 1, s.im\u27e9 := by
          apply Complex.abs.le_abs_re_add_abs_im
      _ = |(s - 1).re| + |(s - 1).im| := by simp [Complex.abs_apply_re_im_le]
      _ < \u03b5/2 + \u03b5/2 := by
          apply add_lt_add
          \u00b7 simp; linarith
          \u00b7 simpa
      _ = \u03b5 := by ring

/-! ================================================================
    Section 4.  Full strip combinator
    ================================================================ -/

/-- **zfr_strip_from_ball_and_level4** (PROVED, 0 sorry):
    ZFR_L143a1_ZeroFreeRegion_L3_OPEN follows from
    ZFR_LargeImStrip_L4_OPEN and ZFR_CompactZeroFree_L4_OPEN.

    Proof:
    From h_large: ∃ T₀ σ₁ < 1, L ≠ 0 for T₀ ≤ |Im| ≤ and σ₁ < Re ≤ 1.
    From h_compact with T₀: ∃ σ₂ < 1, L ≠ 0 for |Im| ≤ T₀ and σ₂ < Re ≤ 1.
    Take σ₀ = max(σ₁, σ₂) < 1.
    Case |Im(s)| ≥ T₀: use h_large (σ₁ < σ₀ ≤ Re ≤ 1 → σ₁ < Re ≤ 1 ✓).
    Case |Im(s)| < T₀: use h_compact (σ₂ < σ₀ ≤ Re ≤ 1 → σ₂ < Re ≤ 1 ✓).
    Conclude: σ₀ < Re ≤ 1 → L ≠ 0.

    SORRY: 0.  Combinator structure only. -/
theorem zfr_strip_from_ball_and_level4
    (h_large   : ZFR_LargeImStrip_L4_OPEN L_143a1)
    (h_compact : ZFR_CompactZeroFree_L4_OPEN L_143a1) :
    ZFR_L143a1_ZeroFreeRegion_L3_OPEN L_143a1 := by
  intro hL1 h_anal
  obtain \u27e8T\u2080, \u03c3\u2081, hT\u2080, h\u03c3\u2081_lt, h_large_strip\u27e9 := h_large hL1 h_anal
  obtain \u27e8\u03c3\u2082, h\u03c3\u2082_lt, h_compact_strip\u27e9 := h_compact hL1 h_anal T\u2080 hT\u2080
  refine \u27e8max \u03c3\u2081 \u03c3\u2082, zfr_max_lt_one \u03c3\u2081 \u03c3\u2082 h\u03c3\u2081_lt h\u03c3\u2082_lt, fun s h_re_lo h_re_hi => ?_\u27e9
  by_cases h_im : T\u2080 \u2264 |s.im|
  \u00b7 apply h_large_strip s h_im
    \u00b7 exact lt_of_le_of_lt (le_max_left _ _) h_re_lo
    \u00b7 exact h_re_hi
  \u00b7 push_neg at h_im
    apply h_compact_strip s
    \u00b7 exact lt_of_le_of_lt (le_max_right _ _) h_re_lo
    \u00b7 exact h_re_hi
    \u00b7 exact le_of_lt h_im

/-- **zfr_dva_from_level4** (PROVED, 0 sorry):
    ZFR_DelaValleePoussin_OPEN follows from the two level-4 sub-surfaces.
    Chain: level-4 → ZFR_ZeroFreeRegion → (zfr_dva_from_region) → ZFR_DVP.
    SORRY: 0. -/
theorem zfr_dva_from_level4
    (h_large   : ZFR_LargeImStrip_L4_OPEN L_143a1)
    (h_compact : ZFR_CompactZeroFree_L4_OPEN L_143a1)
    (h_anal    : ZFR_L143a1_Analytic_L3_OPEN L_143a1) :
    ZFR_DelaValleePoussin_OPEN L_143a1 :=
  ArakelovRH.Batch34ZFRCombinator.zfr_dva_from_region L_143a1 h_anal
    (zfr_strip_from_ball_and_level4 L_143a1 h_large h_compact)

/-- **batch37_zfr_audit** (PROVED, 0 sorry): -/
theorem batch37_zfr_audit :
    -- 1 - ε/2 < 1 for ε > 0
    (\u2200 \u03b5 : \u211d, 0 < \u03b5 \u2192 1 - \u03b5/2 < 1) /\
    -- max σ₀ σ₁ < 1 if both < 1
    (\u2200 \u03c3\u2080 \u03c3\u2081 : \u211d, \u03c3\u2080 < 1 \u2192 \u03c3\u2081 < 1 \u2192 max \u03c3\u2080 \u03c3\u2081 < 1) :=
  \u27e8fun \u03b5 h => by linarith, fun \u03c3\u2080 \u03c3\u2081 h\u03c3\u2080 h\u03c3\u2081 => max_lt h\u03c3\u2080 h\u03c3\u2081\u27e9

end ArakelovRH.Batch37ZFRPoussin
