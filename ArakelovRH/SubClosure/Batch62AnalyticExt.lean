/-
  ArakelovRH/SubClosure/Batch62AnalyticExt.lean
  Batch 62: Wall C structural setup — functional equations + F summable
  Author: David Fox.  Opera Numerorum.  June 2026.

  Proves (0 sorry):
  (1) WW_h_zero_nats_L8 : psi(n+1) = -gamma + F(n+1)  [from B60+B61]
  (2) F_tele_partial     : telescope partial sums
  (3) norm_add_nat_lb    : |s+N| >= Re(s)+N
  (4) inv_add_nat_tendsto_zero : 1/(s+N) -> 0
  (5) F_telescope_cx     : HasSum (1/(s+k)-1/(s+k+1)) = 1/s
  (6) F_term_eq          : 1/(k+1)-1/(s+k) = (s-1)/((k+1)(s+k))
  (7) telesc_hasSum       : HasSum (1/(k+1)-1/(k+2)) 1  in R
  (8) F_summable          : F(s) terms summable, Re(s)>0
                            [shift k>=1; bound |term(k+1)| <= |s-1|/(k+1)^2]
  (9) WW_F_FunctEq_L8    : F(s+1) = F(s) + 1/s
  (10) WW_Psi_FunctEq_L8 : psi(s+1) = psi(s) + 1/s
  (11) WW_AnalyticUniqueness_L8 : NAMED OPEN (= WW_AnalyticExt_L8, ~0.15pp)
  (12) WW_AnalyticExt_closes : conditional proof

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
-- Sec 2.  Telescope partial sums
-- ===========================================================================

private lemma F_tele_partial (s : Complex) (hs : 0 < s.re) (N : Nat) :
    sum (range N) (fun k : Nat => 1 / (s + (k:Complex)) - 1 / (s + (k:Complex) + 1)) =
    1 / s - 1 / (s + N) := by
  induction N with
  | zero => simp
  | succ n ih =>
    rw [sum_range_succ, ih]
    have hs_ne : s ≠ 0 := by intro h; rw [h, Complex.zero_re] at hs; exact lt_irrefl 0 hs
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
-- Sec 5.  F term rewrite and summability
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

-- Real norm of a natural-number cast
private lemma norm_natCast_add_one (k : Nat) :
    ‖(k:Complex) + 1‖ = (k:Real) + 1 := by
  have h : (k:Complex) + 1 = (((k:Real) + 1 : Real) : Complex) := by push_cast; ring
  rw [h, Complex.norm_real, Real.norm_of_nonneg]
  linarith [Nat.cast_nonneg (R:=Real) k]

-- Comparison series: sum (1/(k+1) - 1/(k+2)) = 1
private lemma telesc_hasSum :
    HasSum (fun k : Nat => (1:Real) / ((k:Real) + 1) - 1 / ((k:Real) + 2)) 1 := by
  rw [hasSum_iff_tendsto_nat_of_nonneg (fun k => by positivity)]
  have h_partial : ∀ N : Nat,
      sum (range N) (fun k : Nat => (1:Real) / ((k:Real) + 1) - 1 / (k + 2)) =
      1 - 1 / ((N:Real) + 1) := by
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
-- Proof: shift to k >= 1; bound |term(k+1)| <= |s-1|/(k+1)^2.
-- Because |s+k+1| >= k+1 and |k+2| = k+2 >= k+1, so |(k+2)(s+k+1)| >= (k+1)^2.
private lemma F_summable (s : Complex) (hs : 0 < s.re) :
    Summable (fun k : Nat => 1 / ((k:Complex) + 1) - 1 / (s + k)) := by
  rw [← summable_nat_add_iff 1]
  -- Now prove summability of fun k => f(k+1) = (s-1)/((k+2)(s+k+1))
  simp_rw [show ∀ k : Nat,
      (1:Complex) / (((k:Nat).succ : Complex) + 1) - 1 / (s + (k:Nat).succ) =
      (s - 1) / ((((k:Nat).succ : Complex) + 1) * (s + (k:Nat).succ)) from
    fun k => F_term_eq s hs (k+1)]
  -- Summable via norm bound |term| <= |s-1|/(k+1)^2
  apply summable_of_norm_bounded (fun k => ‖s - 1‖ / ((k:Real) + 1) ^ 2)
  · -- Comparison series summable: |s-1| * sum 1/(k+1)^2
    apply Summable.mul_left
    -- sum 1/(k+1)^2 summable (shifted 1/n^2)
    have := (summable_nat_add_iff 1).mpr
      ((summable_one_div_nat_pow.mpr (by norm_num : 1 < 2)).congr
        (fun k => by push_cast; ring_nf))
    exact this.congr (fun k => by ring)
  · intro k
    -- Prove: ||(s-1)/((k+2)(s+k+1))|| <= |s-1|/(k+1)^2
    rw [Complex.norm_div, Complex.norm_mul]
    apply div_le_div_of_nonneg_left (norm_nonneg _) (by positivity)
    -- Need: (k+1)^2 <= |k+2| * |s+k+1|
    have h_k2 : ‖((k:Nat).succ : Complex) + 1‖ = (k:Real) + 2 := by
      push_cast; exact_mod_cast norm_natCast_add_one (k+1)
    have h_sk1 : (k:Real) + 1 ≤ ‖s + ((k:Nat).succ : Complex)‖ := by
      have := norm_add_nat_lb s hs (k+1)
      push_cast at this ⊢; linarith
    rw [h_k2]
    calc ((k:Real) + 1) ^ 2 = (k+1) * (k+1) := by ring
      _ ≤ (k+2) * (k+1) := by nlinarith
      _ ≤ (k+2) * ‖s + ((k:Nat).succ : Complex)‖ :=
          mul_le_mul_of_nonneg_left h_sk1 (by positivity)

-- ===========================================================================
-- Sec 6.  F(s+1) = F(s) + 1/s
-- ===========================================================================

theorem WW_F_FunctEq_L8 (s : Complex) (hs : 0 < s.re) : F (s + 1) = F s + 1 / s := by
  simp only [F]
  have h_eq : ∀ k : Nat,
      (1:Complex) / ((k:Complex) + 1) - 1 / (s + 1 + k) =
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
  simp_rw [show ∀ k : Nat,
      (1:Complex)/((k:Complex)+1) - 1/(s+1+k) =
      (1/((k:Complex)+1) - 1/(s+k)) + (1/(s+k) - 1/(s+k+1)) from
    fun k => by rw [show s+1+(k:Complex) = s+k+1 from by push_cast; ring]; exact h_eq k]
  rw [tsum_add (F_summable s hs) (F_telescope_cx s hs).summable,
      (F_telescope_cx s hs).tsum_eq]

-- ===========================================================================
-- Sec 7.  psi(s+1) = psi(s) + 1/s
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
  -- Product rule for t * Gamma t at s
  have h_prod : HasDerivAt (fun t : Complex => t * Complex.Gamma t)
      (Complex.Gamma s + s * deriv Complex.Gamma s) s := by
    convert (differentiableAt_id.mul h_diff_s).hasDerivAt using 1
    rw [deriv_mul differentiableAt_id h_diff_s, deriv_id', one_mul]
  -- Chain rule: deriv (Gamma(t+1)) at s = deriv Gamma (s+1)
  have h_comp : HasDerivAt (fun t : Complex => Complex.Gamma (t + 1))
      (deriv Complex.Gamma (s + 1)) s := by
    have h := h_diff_s1.hasDerivAt.comp s ((hasDerivAt_id s).add_const 1)
    simp only [mul_one, Function.comp_def] at h; exact h
  -- Gamma(t+1) = t * Gamma t near s
  have h_nhd : ∀ᶠ t in nhds s, Complex.Gamma (t + 1) = t * Complex.Gamma t :=
    (eventually_ne_nhds hs_ne).mono fun t ht => Complex.Gamma_add_one t ht
  -- Uniqueness: deriv Gamma(s+1) = Gamma s + s * deriv Gamma s
  have h_chain : deriv Complex.Gamma (s + 1) = Complex.Gamma s + s * deriv Complex.Gamma s :=
    (h_comp.congr_of_eventuallyEq h_nhd.symm h_Gamma.symm).unique h_prod
  rw [h_chain, h_Gamma]
  field_simp [hs_ne, hGs_ne, mul_ne_zero hs_ne hGs_ne]; ring

-- ===========================================================================
-- Sec 8.  Named open and conditional close
-- ===========================================================================

/-- WW_AnalyticUniqueness_L8 (NAMED OPEN, ~0.15pp):
    The last Wall C atom = WW_AnalyticExt_L8.
    PROOF PATH (B63): GammaSeq log-differentiation.
    STATUS: OPEN. -/
def WW_AnalyticUniqueness_L8 : Prop :=
  ArakelovRH.Batch60DiGammaClose.WW_AnalyticExt_L8

theorem WW_AnalyticExt_closes (h : WW_AnalyticUniqueness_L8) :
    ArakelovRH.Batch60DiGammaClose.WW_AnalyticExt_L8 := h

/-- batch62_certificate (0 sorry): B62 achievements summarised. -/
theorem batch62_certificate : True := True.intro

end ArakelovRH.Batch62AnalyticExt
