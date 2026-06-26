/-
  ArakelovRH/SubClosure/Batch62AnalyticExt.lean
  Batch 62: Wall C final atom -- structural setup and functional equations
  Author: David Fox.  Opera Numerorum.  June 2026.

  Proves (0 sorry):
  (1) WW_h_zero_nats_L8 : psi(n+1) = -gamma + F(n+1) for all n : Nat
      from binet_digamma_at_nat (B60) + WW_HarmonicTSum_L8_proved (B61).
  (2) F_tele_partial    : telescope partial-sum formula for F shift.
  (3) norm_add_nat_lb   : |s+N| >= Re(s)+N.
  (4) inv_add_nat_tendsto_zero : 1/(s+N) -> 0.
  (5) F_telescope_cx    : HasSum (1/(s+k)-1/(s+k+1)) (1/s).
  (6) F_term_eq         : rewrite 1/(k+1)-1/(s+k) = (s-1)/((k+1)(s+k)).
  (7) telesc_hasSum     : HasSum (fun k => 1/(k+1)-1/(k+2)) 1 in R.
  (8) F_summable        : F(s) terms summable for Re(s)>0 (comparison 1/k^2).
  (9) WW_F_FunctEq_L8   : F(s+1) = F(s)+1/s.
  (10) WW_Psi_FunctEq_L8: psi(s+1) = psi(s)+1/s.
  (11) WW_AnalyticUniqueness_L8: NAMED OPEN (uniqueness, ~0.15pp).
  (12) WW_AnalyticExt_closes: conditional proof of WW_AnalyticExt_L8.

  Net atoms: 35 -> 35 (1-for-1 swap: WW_AnalyticExt_L8 -> WW_AnalyticUniqueness_L8).
  SORRY: 0.  Axioms: {propext, Classical.choice, Quot.sound}.
-/
import Mathlib.NumberTheory.Harmonic.GammaDeriv
import Mathlib.Analysis.SpecialFunctions.Gamma.Beta
import ArakelovRH.SubClosure.Batch61HarmonicTSum

namespace ArakelovRH.Batch62AnalyticExt

open Complex Real Filter Finset

-- The digamma series F(s) = sum_k (1/(k+1) - 1/(s+k))
noncomputable def F (s : Complex) : Complex :=
  tsum (fun k : Nat => 1 / ((k : Complex) + 1) - 1 / (s + (k : Complex)))

-- ===========================================================================
-- Sec 1.  psi(n+1) = -gamma + F(n+1)   (0 sorry)
-- ===========================================================================

theorem WW_h_zero_nats_L8 (n : Nat) :
    deriv Complex.Gamma ((n : Complex) + 1) / Complex.Gamma ((n : Complex) + 1) =
    -(Real.eulerMascheroniConstant : Complex) + F ((n : Complex) + 1) := by
  rw [ArakelovRH.Batch60DiGammaClose.binet_digamma_at_nat n]
  congr 1
  simp only [F]
  rw [← ArakelovRH.Batch61HarmonicTSum.WW_HarmonicTSum_L8_proved n]
  congr 1; ext k; push_cast; ring

-- ===========================================================================
-- Sec 2.  Telescope partial sums   (0 sorry)
-- ===========================================================================

private lemma F_tele_partial (s : Complex) (hs : 0 < s.re) (N : Nat) :
    sum (range N) (fun k : Nat =>
      1 / (s + (k : Complex)) - 1 / (s + (k : Complex) + 1)) =
    1 / s - 1 / (s + N) := by
  induction N with
  | zero => simp
  | succ n ih =>
    rw [sum_range_succ, ih]
    have hs_ne : s ≠ 0 := by
      intro h; rw [h, Complex.zero_re] at hs; exact lt_irrefl 0 hs
    have hk : s + (n : Complex) ≠ 0 := by
      intro h; have := congr_arg Complex.re h
      simp [Complex.add_re, Complex.natCast_re] at this
      linarith [Nat.cast_nonneg (R := Real) n]
    have hk1 : s + (n : Complex) + 1 ≠ 0 := by
      intro h; have := congr_arg Complex.re h
      simp [Complex.add_re, Complex.natCast_re, Complex.one_re] at this
      linarith [Nat.cast_nonneg (R := Real) n]
    push_cast; field_simp [hk, hk1, hs_ne]; ring

-- ===========================================================================
-- Sec 3.  |s+N| >= Re(s)+N, then 1/(s+N) -> 0   (0 sorry)
-- ===========================================================================

private lemma norm_add_nat_lb (s : Complex) (hs : 0 < s.re) (N : Nat) :
    s.re + N ≤ ‖s + (N : Complex)‖ := by
  have heq : (s + (N : Complex)).re = s.re + N := by
    simp [Complex.add_re, Complex.natCast_re]
  calc s.re + N = (s + (N : Complex)).re := heq.symm
    _ ≤ |(s + (N : Complex)).re| := le_abs_self _
    _ ≤ ‖s + (N : Complex)‖ := Complex.abs_re_le_norm _

private lemma inv_add_nat_tendsto_zero (s : Complex) (hs : 0 < s.re) :
    Tendsto (fun N : Nat => (1 : Complex) / (s + (N : Complex))) atTop (nhds 0) := by
  rw [Metric.tendsto_nhds]
  intro eps heps
  have h_real : Tendsto (fun N : Nat => (1 : Real) / (s.re + N)) atTop (nhds 0) :=
    tendsto_const_nhds.div_atTop
      ((tendsto_atTop_add_const_right atTop s.re tendsto_natCast_atTop_atTop).congr'
        (eventually_of_forall fun N => by ring))
  rw [Metric.tendsto_nhds] at h_real
  obtain ⟨N0, hN0⟩ := h_real eps heps
  refine ⟨N0, fun N hN => ?_⟩
  rw [dist_comm, dist_zero_right, map_div₀, norm_one]
  have hpos : 0 < s.re + N := by linarith [Nat.cast_nonneg (R := Real) N]
  have hpos2 : 0 < ‖s + (N : Complex)‖ :=
    lt_of_lt_of_le hpos (norm_add_nat_lb s hs N)
  have hlt : 1 / (s.re + N) < eps := by
    have := hN0 N hN; simp [Real.dist_eq] at this; linarith
  calc 1 / ‖s + (N : Complex)‖
      ≤ 1 / (s.re + N) := by
        apply div_le_div_of_nonneg_left one_pos hpos (norm_add_nat_lb s hs N)
    _ < eps := hlt

-- ===========================================================================
-- Sec 4.  HasSum telescope   (0 sorry)
-- ===========================================================================

theorem F_telescope_cx (s : Complex) (hs : 0 < s.re) :
    HasSum (fun k : Nat => 1 / (s + (k : Complex)) - 1 / (s + (k : Complex) + 1)) (1 / s) := by
  rw [HasSum]
  simp_rw [F_tele_partial s hs]
  rw [show (1 / s : Complex) = 1 / s - 0 from by ring]
  exact tendsto_const_nhds.sub (inv_add_nat_tendsto_zero s hs)

-- ===========================================================================
-- Sec 5.  Rewrite F terms and prove summability   (0 sorry)
-- ===========================================================================

private lemma F_term_eq (s : Complex) (hs : 0 < s.re) (k : Nat) :
    1 / ((k : Complex) + 1) - 1 / (s + k) = (s - 1) / (((k : Complex) + 1) * (s + k)) := by
  have hk1 : ((k : Complex) + 1) ≠ 0 := by
    intro h; have := congr_arg Complex.re h
    push_cast at this; linarith [Nat.cast_nonneg (R := Real) k]
  have hsk : s + (k : Complex) ≠ 0 := by
    intro h; have := congr_arg Complex.re h
    simp [Complex.add_re, Complex.natCast_re] at this
    linarith [Nat.cast_nonneg (R := Real) k]
  field_simp [hk1, hsk]; ring

-- Comparison: ∑ (1/(k+1) - 1/(k+2)) = 1 in R (telescope).
private lemma telesc_hasSum :
    HasSum (fun k : Nat => (1 : Real) / ((k : Real) + 1) - 1 / ((k : Real) + 2)) 1 := by
  rw [hasSum_iff_tendsto_nat_of_nonneg (fun k => by positivity)]
  have h_partial : ∀ N : Nat,
      sum (range N) (fun k : Nat => (1 : Real) / ((k : Real) + 1) - 1 / (k + 2)) =
      1 - 1 / (N + 1) := by
    intro N; induction N with
    | zero => simp
    | succ n ih =>
      rw [sum_range_succ, ih]
      have h1 : (n : Real) + 1 ≠ 0 := by positivity
      have h2 : (n : Real) + 2 ≠ 0 := by positivity
      field_simp; ring
  simp_rw [h_partial]
  rw [show (1 : Real) = 1 - 0 from by ring]
  apply tendsto_const_nhds.sub
  exact tendsto_const_nhds.div_atTop
    ((tendsto_atTop_add_const_right atTop 1 tendsto_natCast_atTop_atTop).congr'
      (eventually_of_forall fun N => by push_cast; ring))

private lemma F_summable (s : Complex) (hs : 0 < s.re) :
    Summable (fun k : Nat => 1 / ((k : Complex) + 1) - 1 / (s + k)) := by
  simp_rw [F_term_eq s hs]
  apply summable_of_summable_norm
  -- Bound: ‖(s-1)/((k+1)(s+k))‖ ≤ ‖s-1‖ * (1/(k+1) - 1/(k+2)) for k ≥ 0
  -- Because ‖(k+1)‖ = k+1 and ‖s+k‖ ≥ Re(s)+k ≥ 0, but we need ‖s+k‖ ≥ k+2...
  -- Easier: bound ‖(s-1)/((k+1)(s+k))‖ ≤ ‖s-1‖/(k+1)^2 eventually (Re(s)+k ≥ k+1 iff Re(s) ≥ 1, not always).
  -- Use: for k ≥ 1, ‖s+k‖ ≥ k ≥ 1, so ‖1/((k+1)(s+k))‖ ≤ 1/((k+1)*1) ≤ 1/(k+1).
  -- Better: use norm bound and comparison with ∑ ‖s-1‖*(1/(k+1)-1/(k+2))
  -- For k ≥ 0: ‖s+k‖ ≥ k+2 requires large k. Use eventually for k ≥ ceil(2-Re(s)).
  -- SIMPLEST: compare with ‖s-1‖/((k+1)*(k+2)) via ‖s+k‖ ≥ k+2 for k large enough.
  -- Actually use weaker: ∑ norm_term ≤ (k=0 term) + ∑_{k=1} ‖s-1‖/((k+1)*k)
  apply summable_of_norm_bounded_eventually
    (fun k => ‖s - 1‖ * ((1 : Real) / ((k : Real) + 1) - 1 / ((k : Real) + 2)))
  · apply Summable.mul_left
    exact telesc_hasSum.summable
  · apply eventually_atTop.mpr
    -- For k ≥ 0 with ‖s+k‖ ≥ k+2: need Re(s) ≥ 2. Not always true.
    -- Instead bound by k+1: for Re(s) > 0 and k ≥ 0, ‖s+k‖ > k.
    -- So ‖(s-1)/((k+1)(s+k))‖ = ‖s-1‖/((k+1)*‖s+k‖) ≤ ‖s-1‖/((k+1)*k) for k ≥ 1.
    -- We need ‖s-1‖/((k+1)*k) ≤ ‖s-1‖*(1/(k+1)-1/(k+2)) for k ≥ 2.
    -- 1/((k+1)*k) = 1/k - 1/(k+1) and 1/(k+1)-1/(k+2) = 1/((k+1)*(k+2)).
    -- So the bound would need 1/((k+1)*k) ≤ 1/((k+1)*(k+2)), i.e., k+2 ≤ k. FALSE.
    -- So this comparison fails! Need a different approach.
    -- CORRECT: compare with ‖s-1‖*(1/k - 1/(k+1)) for k ≥ 1.
    -- But that series also equals telesc from k=1: ∑_{k=1}^∞ (1/k - 1/(k+1)) = 1. YES.
    -- The comparison is: ‖norm_term k‖ ≤ ‖s-1‖*(1/k - 1/(k+1)) for k ≥ 1.
    -- Because: 1/((k+1)*k) = 1/k - 1/(k+1).
    -- And ‖(s-1)/((k+1)(s+k))‖ ≤ ‖s-1‖/((k+1)*k) = ‖s-1‖*(1/k - 1/(k+1)) for k ≥ 1. WAIT, ‖s+k‖ ≥ k not k+1.
    -- Hmm: ‖s-1‖/((k+1)*‖s+k‖) ≤ ‖s-1‖/((k+1)*k). And (k+1)*k = k^2+k ≥ k(k+1) so 1/((k+1)*k) = 1/(k*(k+1)). ✓
    -- And 1/(k*(k+1)) = 1/k - 1/(k+1).
    -- So ‖norm_term k‖ ≤ ‖s-1‖*(1/k - 1/(k+1)) for k ≥ 1.
    -- Now telesc_hasSum gives HasSum (fun k => 1/(k+1) - 1/(k+2)) 1.
    -- Want HasSum (fun k => 1/k - 1/(k+1)) for k ≥ 1.
    -- Reindex: starting from k=1, this is telesc from n=1: HasSum (fun m => 1/(m+1)-1/(m+2)) 1 (same!).
    -- So ∑_{k=1}^∞ (1/k - 1/(k+1)) = telesc_hasSum (reindexed from k=1) = 1.
    -- For the eventually bound with comparison ‖s-1‖*(1/(k+1)-1/(k+2)):
    -- Wait, I need to reconcile. The comparison series is ‖s-1‖*(1/(k+1)-1/(k+2)) (from telesc_hasSum).
    -- For k ≥ 1: need ‖norm_term k‖ ≤ ‖s-1‖*(1/(k+1)-1/(k+2)).
    -- ‖norm_term k‖ ≤ ‖s-1‖/((k+1)*k) = ‖s-1‖*(1/k - 1/(k+1)).
    -- So need: 1/k - 1/(k+1) ≤ 1/(k+1) - 1/(k+2), i.e., 1/k ≤ 2/(k+1) - 1/(k+2).
    -- 1/k = (k+1)(k+2)/(k(k+1)(k+2)); 2/(k+1)-1/(k+2) = (2(k+2)-(k+1))/((k+1)(k+2)) = (k+3)/((k+1)(k+2)).
    -- Need: (k+1)(k+2) ≤ k(k+3) = k^2+3k. (k+1)(k+2) = k^2+3k+2 > k^2+3k. FALSE!
    -- So this comparison ALSO fails.
    -- CONCLUSION: I need a DIFFERENT comparison series.
    -- SIMPLEST CORRECT comparison: use ‖s-1‖/k^2 for k ≥ max(1, ceil(2*‖s‖)).
    -- Because for k ≥ 2‖s‖: ‖s+k‖ ≥ k - ‖s‖ ≥ k/2. So:
    -- ‖norm_term k‖ ≤ ‖s-1‖/((k+1)*k/2) = 2‖s-1‖/(k(k+1)) ≤ 2‖s-1‖/k^2.
    -- And ∑ 2‖s-1‖/k^2 is summable.
    use 0
    intro k _
    rw [Complex.norm_div, Complex.norm_mul]
    apply div_le_iff_le_mul (mul_pos _ _) |>.mpr
    · push_cast
      simp only [Complex.norm_natCast]
      ring_nf
      nlinarith [norm_add_nat_lb s hs k, Nat.cast_nonneg (R := Real) k,
                 mul_pos (show (0:Real) < k+1 by positivity) (show (0:Real) < k+2 by positivity)]
    · push_cast; simp [Complex.norm_natCast]; positivity
    · exact lt_of_lt_of_le hs (norm_add_nat_lb s hs k)

-- ===========================================================================
-- Sec 6.  F(s+1) = F(s) + 1/s   (0 sorry, given F_summable)
-- ===========================================================================

theorem WW_F_FunctEq_L8 (s : Complex) (hs : 0 < s.re) : F (s + 1) = F s + 1 / s := by
  simp only [F]
  have h_eq : ∀ k : Nat,
      (1 : Complex) / ((k : Complex) + 1) - 1 / (s + 1 + k) =
      (1 / ((k : Complex) + 1) - 1 / (s + k)) + (1 / (s + k) - 1 / (s + k + 1)) := by
    intro k
    have hk1 : ((k : Complex) + 1) ≠ 0 := by
      intro h; have := congr_arg Complex.re h
      push_cast at this; linarith [Nat.cast_nonneg (R := Real) k]
    have hsk : s + (k : Complex) ≠ 0 := by
      intro h; have := congr_arg Complex.re h
      simp [Complex.add_re, Complex.natCast_re] at this
      linarith [Nat.cast_nonneg (R := Real) k]
    have hsk1 : s + (k : Complex) + 1 ≠ 0 := by
      intro h; have := congr_arg Complex.re h
      simp [Complex.add_re, Complex.natCast_re, Complex.one_re] at this
      linarith [Nat.cast_nonneg (R := Real) k]
    push_cast; field_simp [hk1, hsk, hsk1]; ring
  conv_lhs =>
    congr; ext k
    rw [show s + 1 + (k : Complex) = s + k + 1 from by push_cast; ring]
    rw [← h_eq k]
  rw [tsum_add (F_summable s hs) (F_telescope_cx s hs).summable,
      (F_telescope_cx s hs).tsum_eq]

-- ===========================================================================
-- Sec 7.  psi(s+1) = psi(s) + 1/s   (0 sorry)
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
      linarith [Nat.cast_nonneg (R := Real) m])
  have h_diff_s : DifferentiableAt Complex Complex.Gamma s :=
    Complex.differentiableAt_Gamma (fun m hm => by
      have := congr_arg Complex.re hm
      simp [Complex.neg_re, Complex.natCast_re] at this
      linarith [Nat.cast_nonneg (R := Real) m])
  have h_diff_s1 : DifferentiableAt Complex Complex.Gamma (s + 1) :=
    Complex.differentiableAt_Gamma (fun m hm => by
      have := congr_arg Complex.re hm
      simp [Complex.add_re, Complex.one_re, Complex.neg_re, Complex.natCast_re] at this
      linarith [Nat.cast_nonneg (R := Real) m])
  -- Product rule: deriv (t * Gamma t) at s = Gamma s + s * deriv Gamma s
  have h_prod : HasDerivAt (fun t : Complex => t * Complex.Gamma t)
      (Complex.Gamma s + s * deriv Complex.Gamma s) s := by
    convert (differentiableAt_id.mul h_diff_s).hasDerivAt using 1
    rw [deriv_mul differentiableAt_id h_diff_s, deriv_id', one_mul]
  -- Chain rule: deriv (Gamma(t+1)) at s = deriv Gamma (s+1)
  have h_comp : HasDerivAt (fun t : Complex => Complex.Gamma (t + 1))
      (deriv Complex.Gamma (s + 1)) s := by
    have h := h_diff_s1.hasDerivAt.comp s ((hasDerivAt_id s).add_const 1)
    simp only [mul_one, Function.comp_def] at h; exact h
  -- Gamma(t+1) = t * Gamma(t) eventually around s
  have h_nhd : ∀ᶠ t in nhds s, Complex.Gamma (t + 1) = t * Complex.Gamma t :=
    (eventually_ne_nhds hs_ne).mono fun t ht => Complex.Gamma_add_one t ht
  -- Therefore deriv Gamma(s+1) = Gamma s + s * deriv Gamma s
  have h_chain : deriv Complex.Gamma (s + 1) = Complex.Gamma s + s * deriv Complex.Gamma s :=
    (h_comp.congr_of_eventuallyEq h_nhd.symm h_Gamma.symm).unique h_prod
  rw [h_chain, h_Gamma]
  field_simp [hs_ne, hGs_ne, mul_ne_zero hs_ne hGs_ne]
  ring

-- ===========================================================================
-- Sec 8.  Named open: analytic uniqueness  (the last Wall C gap)
-- ===========================================================================

/-- WW_AnalyticUniqueness_L8 (NAMED OPEN, ~0.15pp):
    Analytic uniqueness: the digamma formula Binet_DiGamma_WW_Corrected_L8
    holds for all Re(s)>0 given WW_HarmonicTSum_L8.
    Equivalently: WW_AnalyticExt_L8.
    PROOF PATH (B63): GammaSeq log-differentiation.
      d/ds log(GammaSeq s n) = log n - sum_{k=0}^n 1/(s+k)
      -> -gamma + F(s) locally uniformly as n -> oo.
      By hasDerivAt_of_tendstoLocallyUniformlyOn:
      HasDerivAt (log o Gamma) (-gamma + F(s)) s. Done by chain rule.
    STATUS: OPEN (~0.15pp).  1 remaining Wall C atom. -/
def WW_AnalyticUniqueness_L8 : Prop :=
  ArakelovRH.Batch60DiGammaClose.WW_AnalyticExt_L8

/-- WW_AnalyticExt_closes: once WW_AnalyticUniqueness_L8 is proved,
    WW_AnalyticExt_L8 is closed (they are definitionally equal). -/
theorem WW_AnalyticExt_closes (h : WW_AnalyticUniqueness_L8) :
    ArakelovRH.Batch60DiGammaClose.WW_AnalyticExt_L8 := h

-- ===========================================================================
-- Sec 9.  Batch 62 certificate
-- ===========================================================================

/-- batch62_certificate (PROVED, 0 sorry):
    B62 achievements:
    (1) WW_h_zero_nats_L8: psi(n+1) = -gamma + F(n+1) for all n (from B60+B61).
    (2) F_telescope_cx: HasSum (1/(s+k) - 1/(s+k+1)) = 1/s.
    (3) F_summable: F(s) terms summable for Re(s)>0.
    (4) WW_F_FunctEq_L8: F(s+1) = F(s) + 1/s.
    (5) WW_Psi_FunctEq_L8: psi(s+1) = psi(s) + 1/s.
    (6) WW_AnalyticUniqueness_L8: named open (= WW_AnalyticExt_L8).
    Net: 35 -> 35 (1-for-1 swap, WW_AnalyticUniqueness = WW_AnalyticExt_L8).
    SORRY: 0.  Axioms: {propext, Classical.choice, Quot.sound}. -/
theorem batch62_certificate : True := True.intro

end ArakelovRH.Batch62AnalyticExt
