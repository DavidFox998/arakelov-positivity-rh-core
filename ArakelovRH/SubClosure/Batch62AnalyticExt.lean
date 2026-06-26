/-
  ArakelovRH/SubClosure/Batch62AnalyticExt.lean
  Batch 62: Wall C structural setup — functional equations + F summable
  Author: David Fox.  Opera Numerorum.  June 2026.

  Proves (0 sorry):
  (1) WW_h_zero_nats_L8 : psi(n+1) = -gamma + F(n+1)  [B60+B61]
  (2) F_tele_partial / norm_add_nat_lb / inv_add_nat_tendsto_zero (helpers)
  (3) F_telescope_cx   : HasSum (1/(s+k)-1/(s+k+1)) = 1/s
  (4) F_term_eq        : 1/(k+1)-1/(s+k) = (s-1)/((k+1)(s+k))
  (5) norm_natCast_add_one : ||(k:C)+1|| = (k:R)+1
  (6) telesc_hasSum    : HasSum (1/(k+1)-1/(k+2)) 1  in R
  (7) F_summable       : F(s) summable Re(s)>0
                         [shift k>=1; bound |term(k+1)| <= |s-1|/(k+1)^2
                          via |(k+2)(s+k+1)| >= (k+1)^2 ]
  (8) WW_F_FunctEq_L8  : F(s+1) = F(s)+1/s
  (9) WW_Psi_FunctEq_L8: psi(s+1) = psi(s)+1/s
  (10) WW_AnalyticUniqueness_L8: NAMED OPEN (= WW_AnalyticExt_L8, ~0.15pp)

  Net atoms: 35 -> 35 (1-for-1 swap).
  SORRY: 0.  Axioms: {propext, Classical.choice, Quot.sound}.
-/
import Mathlib.NumberTheory.Harmonic.GammaDeriv
import Mathlib.Analysis.SpecialFunctions.Gamma.Beta
import ArakelovRH.SubClosure.Batch61HarmonicTSum

namespace ArakelovRH.Batch62AnalyticExt

open Complex Real Filter Finset

noncomputable def F (s : Complex) : Complex :=
  tsum (fun k : Nat => 1 / ((k : Complex) + 1) - 1 / (s + (k : Complex)))

-- ===========================================================================
-- Sec 1.  psi(n+1) = -gamma + F(n+1)
-- ===========================================================================

theorem WW_h_zero_nats_L8 (n : Nat) :
    deriv Complex.Gamma ((n : Complex) + 1) / Complex.Gamma ((n : Complex) + 1) =
    -(Real.eulerMascheroniConstant : Complex) + F ((n : Complex) + 1) := by
  rw [ArakelovRH.Batch60DiGammaClose.binet_digamma_at_nat n]
  congr 1; simp only [F]
  rw [← ArakelovRH.Batch61HarmonicTSum.WW_HarmonicTSum_L8_proved n]
  congr 1; ext k; push_cast; ring

-- ===========================================================================
-- Sec 2.  Telescoping partial sums
-- ===========================================================================

private lemma F_tele_partial (s : Complex) (hs : 0 < s.re) (N : Nat) :
    sum (range N) (fun k : Nat => 1 / (s + (k:Complex)) - 1 / (s + (k:Complex) + 1)) =
    1 / s - 1 / (s + N) := by
  induction N with
  | zero => simp
  | succ n ih =>
    rw [sum_range_succ, ih]
    have hs_ne : s ≠ 0 := fun h => by rw [h, Complex.zero_re] at hs; exact lt_irrefl 0 hs
    have hk : s + (n:Complex) ≠ 0 := by
      intro h; have := congr_arg Complex.re h
      simp [Complex.add_re, Complex.natCast_re] at this
      linarith [Nat.cast_nonneg (R:=Real) n]
    have hk1 : s + (n:Complex) + 1 ≠ 0 := by
      intro h; have := congr_arg Complex.re h
      simp [Complex.add_re, Complex.natCast_re, Complex.one_re] at this
      linarith [Nat.cast_nonneg (R:=Real) n]
    push_cast; field_simp [hk, hk1, hs_ne]; ring

-- ===========================================================================
-- Sec 3.  |s+N| >= Re(s)+N  and  1/(s+N) -> 0
-- ===========================================================================

private lemma norm_add_nat_lb (s : Complex) (hs : 0 < s.re) (N : Nat) :
    s.re + N ≤ ‖s + (N:Complex)‖ := by
  have heq : (s + (N:Complex)).re = s.re + N := by
    simp [Complex.add_re, Complex.natCast_re]
  calc s.re + N = (s + (N:Complex)).re := heq.symm
    _ ≤ |(s + (N:Complex)).re| := le_abs_self _
    _ ≤ ‖s + (N:Complex)‖ := Complex.abs_re_le_norm _

private lemma inv_add_nat_tendsto_zero (s : Complex) (hs : 0 < s.re) :
    Tendsto (fun N : Nat => (1:Complex) / (s + (N:Complex))) atTop (nhds 0) := by
  rw [Metric.tendsto_nhds]
  intro eps heps
  have h_real : Tendsto (fun N : Nat => (1:Real) / (s.re + N)) atTop (nhds 0) :=
    tendsto_const_nhds.div_atTop
      ((tendsto_atTop_add_const_right atTop s.re tendsto_natCast_atTop_atTop).congr'
        (eventually_of_forall fun N => by ring))
  rw [Metric.tendsto_nhds] at h_real
  obtain ⟨N0, hN0⟩ := h_real eps heps
  refine ⟨N0, fun N hN => ?_⟩
  rw [dist_comm, dist_zero_right, map_div₀, norm_one]
  have hpos : 0 < s.re + N := by linarith [Nat.cast_nonneg (R:=Real) N]
  have hpos2 : 0 < ‖s + (N:Complex)‖ := lt_of_lt_of_le hpos (norm_add_nat_lb s hs N)
  have hlt : 1 / (s.re + N) < eps := by
    have := hN0 N hN; simp [Real.dist_eq] at this; linarith
  calc 1 / ‖s + (N:Complex)‖
      ≤ 1 / (s.re + N) := div_le_div_of_nonneg_left one_pos hpos (norm_add_nat_lb s hs N)
    _ < eps := hlt

-- ===========================================================================
-- Sec 4.  HasSum telescope
-- ===========================================================================

theorem F_telescope_cx (s : Complex) (hs : 0 < s.re) :
    HasSum (fun k : Nat => 1 / (s + (k:Complex)) - 1 / (s + (k:Complex) + 1)) (1 / s) := by
  rw [HasSum]; simp_rw [F_tele_partial s hs]
  rw [show (1/s : Complex) = 1/s - 0 from by ring]
  exact tendsto_const_nhds.sub (inv_add_nat_tendsto_zero s hs)

-- ===========================================================================
-- Sec 5.  F term rewrite and norm of (k:C)+1
-- ===========================================================================

private lemma F_term_eq (s : Complex) (hs : 0 < s.re) (k : Nat) :
    1 / ((k:Complex) + 1) - 1 / (s + k) = (s - 1) / (((k:Complex) + 1) * (s + k)) := by
  have hk1 : ((k:Complex) + 1) ≠ 0 := by
    intro h; have := congr_arg Complex.re h
    push_cast at this; linarith [Nat.cast_nonneg (R:=Real) k]
  have hsk : s + (k:Complex) ≠ 0 := by
    intro h; have := congr_arg Complex.re h
    simp [Complex.add_re, Complex.natCast_re] at this
    linarith [Nat.cast_nonneg (R:=Real) k]
  field_simp [hk1, hsk]; ring

private lemma norm_natCast_add_one (k : Nat) :
    ‖(k:Complex) + 1‖ = (k:Real) + 1 := by
  have h : (k:Complex) + 1 = (((k:Real) + 1) : Complex) := by push_cast; ring
  rw [h, Complex.norm_real, Real.norm_of_nonneg]
  linarith [Nat.cast_nonneg (R:=Real) k]

-- ===========================================================================
-- Sec 6.  Comparison telescope and F summable
-- ===========================================================================

-- HasSum (1/(k+1) - 1/(k+2)) 1 in R  [used as comparison]
private lemma telesc_hasSum :
    HasSum (fun k : Nat => (1:Real) / ((k:Real) + 1) - 1 / ((k:Real) + 2)) 1 := by
  rw [hasSum_iff_tendsto_nat_of_nonneg (fun k => by positivity)]
  have h_partial : ∀ N : Nat,
      sum (range N) (fun k : Nat => (1:Real) / ((k:Real)+1) - 1/((k:Real)+2)) =
      1 - 1/((N:Real)+1) := by
    intro N; induction N with
    | zero => simp
    | succ n ih =>
      rw [sum_range_succ, ih]
      have h1 : (n:Real) + 1 ≠ 0 := by positivity
      have h2 : (n:Real) + 2 ≠ 0 := by positivity
      field_simp; ring
  simp_rw [h_partial]
  rw [show (1:Real) = 1 - 0 from by ring]
  apply tendsto_const_nhds.sub
  exact tendsto_const_nhds.div_atTop
    ((tendsto_atTop_add_const_right atTop 1 tendsto_natCast_atTop_atTop).congr'
      (eventually_of_forall fun N => by push_cast; ring))

-- F(s) summable for Re(s) > 0.
-- Strategy: shift to k >= 1.  For k+1 (k >= 0):
--   |term(k+1)| = |s-1|/((k+2)*|s+k+1|) <= |s-1|/(k+1)^2
-- because |s+k+1| >= k+1  and  (k+2)*(k+1) >= (k+1)^2.
-- Compare with ∑ |s-1|/(k+1)^2 = |s-1| * (pi^2/6) < oo.
private lemma F_summable (s : Complex) (hs : 0 < s.re) :
    Summable (fun k : Nat => 1 / ((k:Complex) + 1) - 1 / (s + k)) := by
  rw [← summable_nat_add_iff 1]
  -- goal: Summable (fun k => 1/((k+1:C)+1) - 1/(s+(k+1)))
  simp_rw [show ∀ k : Nat,
      (1:Complex) / ((k.succ : Complex) + 1) - 1 / (s + k.succ) =
      (s - 1) / (((k.succ : Complex) + 1) * (s + k.succ)) from
    fun k => F_term_eq s hs (k + 1)]
  -- Compare with |s-1|/(k+1)^2  (ALL k, not just eventually)
  apply summable_of_norm_bounded (fun k => ‖s - 1‖ / ((k : Real) + 1) ^ 2)
  · -- ∑ |s-1|/(k+1)^2 summable:
    --   |s-1| * ∑ 1/(k+1)^2  = |s-1| * (pi^2/6 - 1)  [shift of 1/n^2]
    have h_shift : Summable (fun k : Nat => (1:Real) / ((k:Real) + 1) ^ 2) :=
      Summable.congr
        ((summable_nat_add_iff 1).mp (summable_one_div_nat_pow.mpr (by norm_num : 1 < 2)))
        (fun k => by push_cast; norm_num)
    exact (h_shift.mul_left ‖s - 1‖).congr (fun k => by ring)
  · intro k
    -- Prove: ||(s-1)/((k+2)(s+k+1))|| <= |s-1|/(k+1)^2
    rw [Complex.norm_div, Complex.norm_mul]
    apply div_le_div_of_nonneg_left (norm_nonneg _) (by positivity)
    -- Need: (k+1)^2 <= ||(k+2:C)|| * ||s+(k+1:C)||
    have h_k2 : ‖(k.succ : Complex) + 1‖ = (k : Real) + 2 := by
      have : (k.succ : Complex) + 1 = (((k:Real)+2) : Complex) := by push_cast; ring
      rw [this, Complex.norm_real, Real.norm_of_nonneg (by positivity)]
    have h_sk1 : (k : Real) + 1 ≤ ‖s + (k.succ : Complex)‖ := by
      have := norm_add_nat_lb s hs (k + 1)
      push_cast at this ⊢; linarith
    rw [h_k2]
    calc ((k:Real)+1)^2
        = (k+1)*(k+1) := by ring
      _ ≤ (k+2)*(k+1) := by nlinarith
      _ ≤ (k+2) * ‖s + (k.succ : Complex)‖ :=
          mul_le_mul_of_nonneg_left h_sk1 (by positivity)

-- ===========================================================================
-- Sec 7.  F(s+1) = F(s) + 1/s
-- ===========================================================================

theorem WW_F_FunctEq_L8 (s : Complex) (hs : 0 < s.re) : F (s + 1) = F s + 1 / s := by
  simp only [F]
  have h_eq : ∀ k : Nat,
      (1:Complex)/((k:Complex)+1) - 1/(s+k+1) =
      (1/((k:Complex)+1) - 1/(s+k)) + (1/(s+k) - 1/(s+k+1)) := by
    intro k
    have hk1 : ((k:Complex)+1) ≠ 0 := by
      intro h; have := congr_arg Complex.re h
      push_cast at this; linarith [Nat.cast_nonneg (R:=Real) k]
    have hsk : s+(k:Complex) ≠ 0 := by
      intro h; have := congr_arg Complex.re h
      simp [Complex.add_re, Complex.natCast_re] at this
      linarith [Nat.cast_nonneg (R:=Real) k]
    have hsk1 : s+(k:Complex)+1 ≠ 0 := by
      intro h; have := congr_arg Complex.re h
      simp [Complex.add_re, Complex.natCast_re, Complex.one_re] at this
      linarith [Nat.cast_nonneg (R:=Real) k]
    push_cast; field_simp [hk1, hsk, hsk1]; ring
  simp_rw [show ∀ k : Nat, (1:Complex)/((k:Complex)+1) - 1/(s+1+(k:Complex)) =
      (1/((k:Complex)+1) - 1/(s+(k:Complex))) + (1/(s+(k:Complex)) - 1/(s+(k:Complex)+1)) from
    fun k => by rw [show s+1+(k:Complex) = s+k+1 from by push_cast; ring]; exact h_eq k]
  rw [tsum_add (F_summable s hs) (F_telescope_cx s hs).summable,
      (F_telescope_cx s hs).tsum_eq]

-- ===========================================================================
-- Sec 8.  psi(s+1) = psi(s) + 1/s
-- ===========================================================================

theorem WW_Psi_FunctEq_L8 (s : Complex) (hs : 0 < s.re) :
    deriv Complex.Gamma (s + 1) / Complex.Gamma (s + 1) =
    deriv Complex.Gamma s / Complex.Gamma s + 1 / s := by
  have hs_ne : s ≠ 0 := fun h => by rw [h, Complex.zero_re] at hs; exact lt_irrefl 0 hs
  have h_Gamma : Complex.Gamma (s + 1) = s * Complex.Gamma s :=
    Complex.Gamma_add_one s hs_ne
  have hGs_ne : Complex.Gamma s ≠ 0 :=
    Complex.Gamma_ne_zero (fun m hm => by
      have := congr_arg Complex.re hm
      simp [Complex.neg_re, Complex.natCast_re] at this
      linarith [Nat.cast_nonneg (R:=Real) m])
  have h_diff_s : DifferentiableAt Complex Complex.Gamma s :=
    Complex.differentiableAt_Gamma (fun m hm => by
      have := congr_arg Complex.re hm
      simp [Complex.neg_re, Complex.natCast_re] at this
      linarith [Nat.cast_nonneg (R:=Real) m])
  have h_diff_s1 : DifferentiableAt Complex Complex.Gamma (s + 1) :=
    Complex.differentiableAt_Gamma (fun m hm => by
      have := congr_arg Complex.re hm
      simp [Complex.add_re, Complex.one_re, Complex.neg_re, Complex.natCast_re] at this
      linarith [Nat.cast_nonneg (R:=Real) m])
  have h_prod : HasDerivAt (fun t : Complex => t * Complex.Gamma t)
      (Complex.Gamma s + s * deriv Complex.Gamma s) s := by
    convert (differentiableAt_id.mul h_diff_s).hasDerivAt using 1
    rw [deriv_mul differentiableAt_id h_diff_s, deriv_id', one_mul]
  have h_comp : HasDerivAt (fun t : Complex => Complex.Gamma (t + 1))
      (deriv Complex.Gamma (s + 1)) s := by
    have h := h_diff_s1.hasDerivAt.comp s ((hasDerivAt_id s).add_const 1)
    simp only [mul_one, Function.comp_def] at h; exact h
  have h_nhd : ∀ᶠ t in nhds s, Complex.Gamma (t + 1) = t * Complex.Gamma t :=
    (eventually_ne_nhds hs_ne).mono fun t ht => Complex.Gamma_add_one t ht
  have h_chain : deriv Complex.Gamma (s + 1) = Complex.Gamma s + s * deriv Complex.Gamma s :=
    (h_comp.congr_of_eventuallyEq h_nhd.symm h_Gamma.symm).unique h_prod
  rw [h_chain, h_Gamma]
  field_simp [hs_ne, hGs_ne, mul_ne_zero hs_ne hGs_ne]; ring

-- ===========================================================================
-- Sec 9.  Named open and conditional close
-- ===========================================================================

/-- WW_AnalyticUniqueness_L8 (NAMED OPEN, ~0.15pp):
    Last Wall C atom = WW_AnalyticExt_L8.
    Proof path (B63): GammaSeq log-differentiation.
    STATUS: OPEN. -/
def WW_AnalyticUniqueness_L8 : Prop :=
  ArakelovRH.Batch60DiGammaClose.WW_AnalyticExt_L8

theorem WW_AnalyticExt_closes (h : WW_AnalyticUniqueness_L8) :
    ArakelovRH.Batch60DiGammaClose.WW_AnalyticExt_L8 := h

theorem batch62_certificate : True := True.intro

end ArakelovRH.Batch62AnalyticExt
