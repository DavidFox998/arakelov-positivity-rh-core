/-
  ArakelovRH/SubClosure/Batch70LocalUnifProof.lean
  Batch 70: Wall C CLOSED -- GammaSeq_TendstoLocalUnif_b69 PROVED (0 sorry)
  Author: David Fox.  Opera Numerorum.  June 2026.

  KEY THEOREM:
    TendstoLocallyUniformlyOn (fun n z => Complex.GammaSeq z n)
      Complex.Gamma atTop {z : ℂ | 0 < z.re}

  PROOF:
    For x0 in {Re>0}: sigma=Re(x0)/2, M=2*Re(x0), V=ball(x0, Re(x0)/4).
    For z in V: sigma <= Re(z) <= M, Re(z) > 0.
    For ALL t>0: t^(Re(z)-1) <= t^(sigma-1)+t^(M-1)   [split at t=1].
    Hence: norm(GammaSeq z n - Gamma z) <= h_n(sigma,M) -> 0 by DCT (z-independent).
    Dominator: 2*exp(-t)*(t^(sigma-1)+t^(M-1)) integrable from GammaIntegral_convergent.

  SORRY: 0.  Axioms: {propext, Classical.choice, Quot.sound}.
-/

import Mathlib.Analysis.SpecialFunctions.Gamma.Beta
import Mathlib.MeasureTheory.Integral.DominatedConvergence
import ArakelovRH.SubClosure.Batch69LocalUnif

namespace ArakelovRH.Batch70LocalUnifProof

open Complex Real Filter MeasureTheory Set Topology

-- =============================================================================
-- S1.  rpow bounds: for ALL t>0, t^(Re(z)-1) <= t^(sigma-1)+t^(M-1)
-- =============================================================================

/-- 0<x<=1, sigma<=Re(z) -> x^(Re(z)-1) <= x^(sigma-1) [t<1: larger exp -> smaller val] -/
private lemma rpow_le_sigma {z : ℂ} {sigma x : ℝ}
    (hsz : sigma <= z.re) (hx0 : 0 < x) (hx1 : x <= 1) :
    x ^ (z.re - 1) <= x ^ (sigma - 1) :=
  Real.rpow_le_rpow_of_exponent_ge hx0 hx1 (sub_le_sub_right hsz 1)

/-- 1<=x, Re(z)<=M -> x^(Re(z)-1) <= x^(M-1) [t>1: larger exp -> larger val] -/
private lemma rpow_le_M {z : ℂ} {M x : ℝ}
    (hzM : z.re <= M) (hx1 : 1 <= x) :
    x ^ (z.re - 1) <= x ^ (M - 1) :=
  Real.rpow_le_rpow_of_exponent_le hx1 (sub_le_sub_right hzM 1)

/-- For sigma<=Re(z)<=M and 0<x: x^(Re(z)-1) <= x^(sigma-1)+x^(M-1) [key uniform bound] -/
private lemma rpow_re_le_sum {z : ℂ} {sigma M x : ℝ}
    (hsz : sigma <= z.re) (hzM : z.re <= M) (hx0 : 0 < x) :
    x ^ (z.re - 1) <= x ^ (sigma - 1) + x ^ (M - 1) := by
  rcases le_or_lt x 1 with h | h
  · linarith [rpow_le_sigma hsz hx0 h, Real.rpow_nonneg hx0.le (M - 1)]
  · linarith [rpow_le_M hzM h.le, Real.rpow_nonneg hx0.le (sigma - 1)]

-- =============================================================================
-- S2.  The approximant phi_n and properties
-- =============================================================================

private noncomputable def phi_n (n : ℕ) (x : ℝ) : ℝ :=
  indicator (Ioc 0 (n : ℝ)) (fun x => (1 - x / n) ^ n) x

private lemma phi_n_nonneg (n : ℕ) (x : ℝ) : 0 <= phi_n n x :=
  indicator_nonneg (fun x hx => pow_nonneg
    (sub_nonneg.mpr (div_le_one_of_le hx.2 (by positivity))) n) x

private lemma phi_n_le_exp (n : ℕ) (x : ℝ) (hx : 0 <= x) : phi_n n x <= Real.exp (-x) := by
  simp only [phi_n, indicator]; split_ifs with h
  · exact one_sub_div_pow_le_exp_neg h.2
  · exact Real.exp_nonneg _

private lemma phi_n_measurable (n : ℕ) : Measurable (phi_n n) :=
  ((continuous_const.sub (continuous_id.div_const n)).pow n).measurable.indicator measurableSet_Ioc

/-- phi_n n x -> exp(-x) pointwise for each fixed x > 0. -/
private lemma phi_n_tendsto (x : ℝ) (hx : 0 < x) :
    Tendsto (fun n : ℕ => phi_n n x) atTop (nhds (Real.exp (-x))) := by
  have hconv : Tendsto (fun n : ℕ => (1 - x / (n : ℝ)) ^ n) atTop (nhds (Real.exp (-x))) := by
    have := tendsto_one_plus_div_pow_exp (-x); simp only [neg_div] at this
    convert this using 2; ext n; ring
  refine hconv.congr' ?_
  filter_upwards [eventually_ge_atTop (Nat.ceil x)] with n hn
  simp [phi_n, indicator_of_mem (mem_Ioc.mpr (And.intro hx (Nat.le_of_ceil_le hn)))]

-- =============================================================================
-- S3.  h_n(sigma,M) and DCT proof that h_n -> 0
-- =============================================================================

private noncomputable def h_n (sigma M : ℝ) (n : ℕ) : ℝ :=
  ∫ x : ℝ in Ioi 0, |phi_n n x - Real.exp (-x)| * (x ^ (sigma - 1) + x ^ (M - 1))

private lemma h_n_nonneg (sigma M : ℝ) (n : ℕ) : 0 <= h_n sigma M n :=
  integral_nonneg (fun _ => mul_nonneg (abs_nonneg _) (by positivity))

private lemma h_n_tendsto_zero {sigma M : ℝ} (hsigma : 0 < sigma) (hM : 0 < M) :
    Tendsto (h_n sigma M) atTop (nhds 0) := by
  simp only [h_n]
  rw [show (0 : ℝ) = ∫ _ : ℝ in Ioi 0, (0 : ℝ) from (integral_zero _ _).symm]
  apply tendsto_integral_of_dominated_convergence
      (fun x => 2 * Real.exp (-x) * (x ^ (sigma - 1) + x ^ (M - 1)))
  · intro n; apply AEMeasurable.restrict
    exact ((phi_n_measurable n).sub (Real.measurable_exp.comp measurable_neg) |>.abs).mul
      (Real.measurable_rpow_const.add Real.measurable_rpow_const) |>.aemeasurable
  · convert ((Real.GammaIntegral_convergent hsigma).add
        (Real.GammaIntegral_convergent hM)).const_mul 2 using 1; ext x; ring
  · intro n
    apply (ae_restrict_iff' measurableSet_Ioi).mpr; apply ae_of_all; intro x hx
    apply mul_le_mul_of_nonneg_right _ (by positivity)
    have hx0 := (mem_Ioi.mp hx).le
    have hphi := phi_n_nonneg n x; have hle := phi_n_le_exp n x hx0
    rw [abs_le]; constructor <;> linarith [Real.exp_nonneg (-x)]
  · apply (ae_restrict_iff' measurableSet_Ioi).mpr; apply ae_of_all; intro x hx
    simpa using ((phi_n_tendsto x (mem_Ioi.mp hx)).sub_const _).abs.mul_const _

-- =============================================================================
-- S4.  Integrability lemmas
-- =============================================================================

private lemma approx_integrand_ible {z : ℂ} (hz : 0 < z.re) {n : ℕ} (hn : n ≠ 0) :
    IntegrableOn
      (fun x : ℝ => indicator (Ioc 0 (n : ℝ))
        (fun x => ((1 - x / n) ^ n : ℝ) * (x : ℂ) ^ (z - 1)) x) (Ioi 0) := by
  rw [integrable_indicator_iff measurableSet_Ioc, IntegrableOn,
      Measure.restrict_restrict_of_subset Ioc_subset_Ioi_self, ← IntegrableOn,
      ← intervalIntegrable_iff_integrableOn_Ioc_of_le (Nat.cast_nonneg n)]
  apply IntervalIntegrable.continuousOn_mul
  · exact intervalIntegral.intervalIntegrable_cpow'
        (by rwa [sub_re, one_re, ← zero_sub, sub_lt_sub_iff_right])
  · exact (RCLike.continuous_ofReal.comp
        ((continuous_const.sub (continuous_id'.div_const (↑n : ℝ))).pow n)).continuousOn

private lemma gamma_integrand_ible {z : ℂ} (hz : 0 < z.re) :
    IntegrableOn (fun x : ℝ => (-(x : ℂ)).exp * (x : ℂ) ^ (z - 1)) (Ioi 0) :=
  Complex.GammaIntegral_convergent hz

private lemma h_n_integrand_ible {sigma M : ℝ} (hsigma : 0 < sigma) (hM : 0 < M) (n : ℕ) :
    IntegrableOn (fun x : ℝ => |phi_n n x - Real.exp (-x)| * (x ^ (sigma - 1) + x ^ (M - 1)))
      (Ioi 0) := by
  have hdom : IntegrableOn (fun x : ℝ => 2 * Real.exp (-x) * (x ^ (sigma - 1) + x ^ (M - 1)))
      (Ioi 0) := by
    convert ((Real.GammaIntegral_convergent hsigma).add
        (Real.GammaIntegral_convergent hM)).const_mul 2 using 1; ext x; ring
  apply hdom.mono_norm
  · exact ((phi_n_measurable n).sub (Real.measurable_exp.comp measurable_neg) |>.abs.mul
        (Real.measurable_rpow_const.add Real.measurable_rpow_const)).aestronglyMeasurable.restrict
  · apply (ae_restrict_iff' measurableSet_Ioi).mpr; apply ae_of_all; intro x hx
    have hx0 := (mem_Ioi.mp hx).le
    simp only [Real.norm_of_nonneg (mul_nonneg (abs_nonneg _) (by positivity)),
               Real.norm_of_nonneg (mul_nonneg (by positivity) (by positivity))]
    apply mul_le_mul_of_nonneg_right _ (by positivity)
    rw [abs_le]
    exact And.intro (by linarith [phi_n_nonneg n x, Real.exp_nonneg (-x)])
                    (by linarith [phi_n_le_exp n x hx0])

-- =============================================================================
-- S5.  GammaSeq z n = int_{Ioi 0} indicator(Ioc 0 n)(approx) x
--       (Beta.lean:316-319 chain, reversed)
-- =============================================================================

private lemma GammaSeq_as_Ioi_integral {z : ℂ} (hz : 0 < z.re) {n : ℕ} (hn : n ≠ 0) :
    Complex.GammaSeq z n =
      ∫ x : ℝ in Ioi 0,
        indicator (Ioc 0 (n : ℝ))
          (fun x => ((1 - x / n) ^ n : ℝ) * (x : ℂ) ^ (z - 1)) x := by
  rw [Complex.GammaSeq_eq_approx_Gamma_integral hz hn]
  symm
  rw [MeasureTheory.integral_indicator measurableSet_Ioc,
      intervalIntegral.integral_of_le (Nat.cast_nonneg n),
      Measure.restrict_restrict_of_subset Ioc_subset_Ioi_self]

-- =============================================================================
-- S6.  Norm bound on integrand difference
-- =============================================================================

private lemma norm_integrand_le {z : ℂ} {sigma M : ℝ} (hsz : sigma <= z.re) (hzM : z.re <= M)
    {n : ℕ} (x : ℝ) (hx : 0 < x) :
    ‖indicator (Ioc 0 (n : ℝ)) (fun x => ((1 - x / n) ^ n : ℝ) * (x : ℂ) ^ (z - 1)) x
      - (-(x : ℂ)).exp * (x : ℂ) ^ (z - 1)‖
      <= |phi_n n x - Real.exp (-x)| * (x ^ (sigma - 1) + x ^ (M - 1)) := by
  have heq :
      indicator (Ioc 0 (n : ℝ)) (fun x => ((1 - x / n) ^ n : ℝ) * (x : ℂ) ^ (z - 1)) x
        - (-(x : ℂ)).exp * (x : ℂ) ^ (z - 1) =
      (phi_n n x - Real.exp (-x) : ℝ) * (x : ℂ) ^ (z - 1) := by
    simp only [phi_n, indicator, Complex.ofReal_sub, Complex.ofReal_exp, Complex.ofReal_neg,
               Complex.ofReal_pow, Complex.ofReal_div, Complex.ofReal_one]
    split_ifs <;> push_cast <;> ring
  rw [heq, norm_mul, Complex.norm_real, Real.norm_eq_abs,
      Complex.norm_eq_abs, Complex.abs_cpow_eq_rpow_re_of_pos hx, sub_re, one_re]
  exact mul_le_mul_of_nonneg_left (rpow_re_le_sum hsz hzM hx) (abs_nonneg _)

-- =============================================================================
-- S7.  norm(GammaSeq z n - Gamma z) <= h_n(sigma,M)
-- =============================================================================

private lemma GammaSeq_norm_le_h_n {z : ℂ} (hz : 0 < z.re) {sigma M : ℝ}
    (hsigma : 0 < sigma) (hsz : sigma <= z.re) (hzM : z.re <= M) {n : ℕ} (hn : n ≠ 0) :
    ‖Complex.GammaSeq z n - Complex.Gamma z‖ <= h_n sigma M n := by
  rw [Complex.Gamma_eq_integral hz, GammaSeq_as_Ioi_integral hz hn, h_n,
      ← integral_sub (approx_integrand_ible hz hn) (gamma_integrand_ible hz)]
  refine (norm_integral_le_integral_norm _).trans ?_
  apply MeasureTheory.integral_mono_on measurableSet_Ioi
  · exact ((approx_integrand_ible hz hn).sub (gamma_integrand_ible hz)).norm
  · exact h_n_integrand_ible hsigma (by linarith [hsz, hzM]) n
  · intro x hx; exact norm_integrand_le hsz hzM x (mem_Ioi.mp hx)

-- =============================================================================
-- S8.  Wall C CLOSED: GammaSeq_TendstoLocalUnif_b69 proved
-- =============================================================================

/-- Batch 70.  Wall C CLOSED.
    GammaSeq(z, n) -> Gamma(z) locally uniformly on {Re > 0}.
    Proves the B69 named open atom, net atoms: 35 -> 34. -/
theorem GammaSeq_TendstoLocalUnif_b70 :
    Batch69LocalUnif.GammaSeq_TendstoLocalUnif_b69 := by
  rw [Batch69LocalUnif.GammaSeq_TendstoLocalUnif_b69]
  rw [Batch69LocalUnif.GammaSeq_strip_isOpen.tendstoLocallyUniformlyOn_iff_forall_tendsto]
  intro x hx
  rw [Filter.tendsto_def]
  intro U hU
  obtain (eps_pos : ∃ ε, 0 < ε ∧ ∀ a b : ℂ, dist a b < ε → (a, b) ∈ U) :=
    Metric.mem_uniformity_dist.mp hU
  obtain ⟨ε, hε, hεU⟩ := eps_pos
  set sigma := x.re / 2; set M := 2 * x.re
  obtain ⟨N, hN⟩ := Metric.tendsto_atTop.mp
    (h_n_tendsto_zero (by positivity : 0 < sigma) (by positivity : 0 < M)) ε hε
  apply Filter.mem_of_superset
    (Filter.prod_mem_prod (Ici_mem_atTop (N + 1)) (Metric.ball_mem_nhds x (by positivity)))
  intro ⟨n, y⟩ ⟨hn_ge, hy_ball⟩
  apply hεU
  have hn_ne : n ≠ 0 := by omega
  have hy_dist : dist y x < x.re / 4 := Metric.mem_ball.mp hy_ball
  have habs : |y.re - x.re| < x.re / 4 := (Complex.dist_re_le y x).trans_lt hy_dist
  have hy_re_ge : sigma <= y.re := by linarith [(abs_lt.mp habs).1]
  have hy_re_le : y.re <= M := by linarith [(abs_lt.mp habs).2]
  have hy_pos : 0 < y.re := by linarith [show 0 < sigma from by positivity]
  rw [dist_comm, dist_eq_norm]
  exact (GammaSeq_norm_le_h_n hy_pos (by positivity) hy_re_ge hy_re_le hn_ne).trans_lt
    (by have := hN n (by omega)
        rwa [Real.dist_eq, abs_of_nonneg (h_n_nonneg sigma M n), sub_zero] at this)

end ArakelovRH.Batch70LocalUnifProof
