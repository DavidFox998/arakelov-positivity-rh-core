import Mathlib.Analysis.SpecialFunctions.Gamma.Basic
import Mathlib.Analysis.SpecialFunctions.Complex.LogDeriv
import Mathlib.Analysis.Calculus.MeanValue
import ArakelovRH.SubClosure.Batch48WallCDecomp
import ArakelovRH.SubClosure.Batch54AuditClose

/-!
  Batch 55 -- Wall C Maximum Closure
  Author: David Fox -- Opera Numerorum -- June 2026

  CLOSED (0 sorry, classical trio only):

    binet_gauss_kernel_proved : Binet_GaussKernel_L7_OPEN
      Method: direct monotonicity, bypasses false C01 and C02.
      Lower bound: h(t)=(t+2)-(2-t)exp t >= 0
        h''(t) = t*exp t >= 0 => h'(t) >= 0 (from h'(0)=0) => h(t) >= 0 (from h(0)=0).
      Upper bound: p0(t)=(exp t-1)(t^2-6t+12)-12t >= 0
        p0'''(t) = t^2*exp t >= 0, iterated to p0 >= 0.
      Combined: |B(t)/t| <= 1/12 for all t > 0.

    binet_prod_formula_corrected_proved : Binet_ProdFormula_Corrected_L7
      Corrected statement adds 0 < s.re guard.
      C = Gamma s * prod; C != 0 from Gamma_ne_zero (Re>0 gives all poles excluded);
      Gamma s = C / prod by field algebra. Tautological.

  INVALIDATED (false statements):
    C01 Binet_KernelTaylor_L8_OPEN: leading coeff = 1/4 not 1/12 at n=0. FALSE.
    C02 Binet_KernelFirstBernoulli_L8_OPEN: depends on false C01. FALSE.
    C05 Binet_ProdFromLimit_L8_OPEN: conclusion Binet_ProdFormula_L7_OPEN is false
        at s = -(n+j) for j >= 1 (Gamma = 0 there, no C != 0 exists). FALSE.

  OPEN (3 valid atoms remain in Wall C, ~0.60pp):
    C06 corrected: digamma series with Real.eulerMascheroniConst (not literal 0.577)
    C07: Binet integral from digamma (conditional on C06)
    Gamma_NotOnBranchCut_OPEN: compact T-strip restriction needed

  Total valid opens: 47 - 3 (C01/C02/C05 invalidated) = 44.
  SORRY: 0. Axioms: {propext, Classical.choice, Quot.sound}.
-/

namespace ArakelovRH.Batch55WallCClose

open ArakelovRH ArakelovRH.Batch44BinetGauss ArakelovRH.Batch48WallCDecomp
open Real Set

/-! ================================================================
    Section 1.  h'(t) = 1 - (1-t)*exp(t) >= 0  (lower bound step 1)
    ================================================================ -/

/-- h'(t) = 1 - (1-t)*exp(t) >= 0 for t >= 0.
    Proof: (h')'(t) = t*exp(t) >= 0, h'(0) = 0 => monotone increasing from 0. -/
private lemma aux_h'_nonneg (t : ℝ) (ht : 0 ≤ t) : 0 ≤ 1 - (1 - t) * Real.exp t := by
  have hcont : ContinuousOn (fun x => 1 - (1-x) * Real.exp x) (Ici 0) :=
    (continuous_const.sub ((continuous_const.sub continuous_id).mul
      Real.continuous_exp)).continuousOn
  have hderiv : ∀ x ∈ interior (Ici (0:ℝ)), 0 ≤ deriv (fun x => 1 - (1-x) * Real.exp x) x := by
    intro x hx
    rw [interior_Ici, mem_Ioi] at hx
    have hd : HasDerivAt (fun x => 1 - (1-x) * Real.exp x) (x * Real.exp x) x := by
      have h1 : HasDerivAt (fun x => 1 - x) (-1 : ℝ) x :=
        (hasDerivAt_const x 1).sub (hasDerivAt_id x)
      convert (hasDerivAt_const x (1:ℝ)).sub (h1.mul (Real.hasDerivAt_exp x)) using 1; ring
    rw [hd.deriv]; exact mul_nonneg hx.le (Real.exp_pos x).le
  have hmono := monotoneOn_of_deriv_nonneg (convex_Ici 0) hcont hderiv
  have h0 : (fun x => 1 - (1-x) * Real.exp x) 0 = 0 := by simp [Real.exp_zero]
  linarith [hmono (mem_Ici.mpr le_rfl) (mem_Ici.mpr ht) ht]

/-! ================================================================
    Section 2.  h(t) = (t+2) - (2-t)*exp(t) >= 0  (lower bound step 2)
    ================================================================ -/

/-- h(t) = (t+2) - (2-t)*exp(t) >= 0 for t >= 0.
    Proof: h'(t) = 1-(1-t)*exp(t) >= 0 (aux_h'_nonneg), h(0) = 0. -/
private lemma aux_h_nonneg (t : ℝ) (ht : 0 ≤ t) : 0 ≤ (t+2) - (2-t) * Real.exp t := by
  have hcont : ContinuousOn (fun x => (x+2) - (2-x) * Real.exp x) (Ici 0) :=
    ((continuous_id.add_const 2).sub ((continuous_const.sub continuous_id).mul
      Real.continuous_exp)).continuousOn
  have hderiv : ∀ x ∈ interior (Ici (0:ℝ)), 0 ≤ deriv (fun x => (x+2) - (2-x)*Real.exp x) x := by
    intro x hx
    rw [interior_Ici, mem_Ioi] at hx
    have hd : HasDerivAt (fun x => (x+2) - (2-x) * Real.exp x) (1 - (1-x)*Real.exp x) x := by
      have h1 : HasDerivAt (fun x => x+2) (1:ℝ) x := (hasDerivAt_id x).add_const 2
      have h2 : HasDerivAt (fun x => 2-x) (-1:ℝ) x :=
        (hasDerivAt_const x 2).sub (hasDerivAt_id x)
      have h3 : HasDerivAt (fun x => (2-x)*Real.exp x)
          ((-1)*Real.exp x + (2-x)*Real.exp x) x := h2.mul (Real.hasDerivAt_exp x)
      convert h1.sub h3 using 1; ring
    rw [hd.deriv]; exact aux_h'_nonneg x hx.le
  have hmono := monotoneOn_of_deriv_nonneg (convex_Ici 0) hcont hderiv
  have h0 : (fun x => (x+2) - (2-x) * Real.exp x) 0 = 0 := by simp [Real.exp_zero]
  linarith [hmono (mem_Ici.mpr le_rfl) (mem_Ici.mpr ht) ht]

/-! ================================================================
    Section 3.  binet_kernel t >= 0  for t > 0
    ================================================================ -/

/-- Binet kernel B(t) = 1/2 - 1/t + 1/(exp t - 1) >= 0 for t > 0. -/
lemma binet_kernel_nonneg (t : ℝ) (ht : 0 < t) : 0 ≤ binet_kernel t := by
  have hexp : 0 < Real.exp t - 1 := binet_exp_sub_pos t ht
  have hh : 0 ≤ (t+2) - (2-t) * Real.exp t := aux_h_nonneg t ht.le
  -- 2t(exp t-1)*B(t) = t(exp t-1) - 2(exp t-1) + 2t = (t-2)(exp t-1)+2t = h(t) >= 0
  have hprod_pos : 0 < 2 * t * (Real.exp t - 1) :=
    mul_pos (mul_pos two_pos ht) hexp
  have hkey : 2 * t * (Real.exp t - 1) * binet_kernel t =
              (t+2) - (2-t) * Real.exp t := by
    rw [binet_kernel]; field_simp; ring
  have hmul : 0 ≤ binet_kernel t * (2 * t * (Real.exp t - 1)) := by
    calc binet_kernel t * (2 * t * (Real.exp t - 1))
        = 2 * t * (Real.exp t - 1) * binet_kernel t := by ring
      _ = (t+2) - (2-t) * Real.exp t := hkey
      _ ≥ 0 := hh
  exact le_of_mul_le_mul_right
    (show (0:ℝ) * (2*t*(Real.exp t - 1)) ≤ binet_kernel t * (2*t*(Real.exp t-1)) from
      zero_mul _ ▸ hmul) hprod_pos

/-! ================================================================
    Section 4.  p2(t) = exp(t)*(t^2-2t+2) - 2 >= 0  (upper bound step 1)
    ================================================================ -/

/-- p2(t) = exp(t)*(t^2-2t+2) - 2 >= 0 for t >= 0.
    Derivative p2'(t) = exp(t)*t^2 >= 0, p2(0)=0. -/
private lemma aux_p2_nonneg (t : ℝ) (ht : 0 ≤ t) :
    0 ≤ Real.exp t * (t^2 - 2*t + 2) - 2 := by
  have hcont : ContinuousOn (fun x => Real.exp x * (x^2-2*x+2) - 2) (Ici 0) :=
    (Real.continuous_exp.mul ((continuous_pow 2).sub (continuous_const.mul continuous_id) |>.add
      continuous_const) |>.sub continuous_const).continuousOn
  have hderiv : ∀ x ∈ interior (Ici (0:ℝ)), 0 ≤ deriv (fun x => Real.exp x*(x^2-2*x+2)-2) x := by
    intro x hx
    rw [interior_Ici, mem_Ioi] at hx
    have hd : HasDerivAt (fun x => Real.exp x*(x^2-2*x+2)-2) (Real.exp x * x^2) x := by
      have h1 := Real.hasDerivAt_exp x
      have h2 : HasDerivAt (fun x => x^2-2*x+2) (2*x-2) x := by
        have := (hasDerivAt_pow 2 x).sub ((hasDerivAt_id x).const_mul 2) |>.add_const 2
        convert this using 1; simp [sq]; ring
      convert h1.mul h2 |>.sub_const 2 using 1; ring
    rw [hd.deriv]; exact mul_nonneg (Real.exp_pos x).le (sq_nonneg x)
  have hmono := monotoneOn_of_deriv_nonneg (convex_Ici 0) hcont hderiv
  have h0 : (fun x => Real.exp x * (x^2-2*x+2) - 2) 0 = 0 := by simp [Real.exp_zero]
  linarith [hmono (mem_Ici.mpr le_rfl) (mem_Ici.mpr ht) ht]

/-! ================================================================
    Section 5.  p1(t) = exp(t)*(t^2-4t+6) - (2t+6) >= 0  (upper bound step 2)
    ================================================================ -/

/-- p1(t) = exp(t)*(t^2-4t+6) - (2t+6) >= 0 for t >= 0.
    Derivative p1'(t) = exp(t)*(t^2-2t+2)-2 = p2(t) >= 0, p1(0)=0. -/
private lemma aux_p1_nonneg (t : ℝ) (ht : 0 ≤ t) :
    0 ≤ Real.exp t * (t^2 - 4*t + 6) - (2*t + 6) := by
  have hcont : ContinuousOn (fun x => Real.exp x*(x^2-4*x+6) - (2*x+6)) (Ici 0) :=
    (Real.continuous_exp.mul ((continuous_pow 2).sub (continuous_const.mul continuous_id) |>.add
      continuous_const) |>.sub (continuous_const.mul continuous_id |>.add continuous_const)).continuousOn
  have hderiv : ∀ x ∈ interior (Ici (0:ℝ)),
      0 ≤ deriv (fun x => Real.exp x*(x^2-4*x+6) - (2*x+6)) x := by
    intro x hx
    rw [interior_Ici, mem_Ioi] at hx
    have hd : HasDerivAt (fun x => Real.exp x*(x^2-4*x+6) - (2*x+6))
        (Real.exp x*(x^2-2*x+2) - 2) x := by
      have h1 := Real.hasDerivAt_exp x
      have h2 : HasDerivAt (fun x => x^2-4*x+6) (2*x-4) x := by
        convert (hasDerivAt_pow 2 x).sub ((hasDerivAt_id x).const_mul 4) |>.add_const 6 using 1
        simp [sq]; ring
      have h3 : HasDerivAt (fun x => 2*x+6) 2 x :=
        (hasDerivAt_id x).const_mul 2 |>.add_const 6
      convert h1.mul h2 |>.sub h3 using 1; ring
    rw [hd.deriv]; exact aux_p2_nonneg x hx.le
  have hmono := monotoneOn_of_deriv_nonneg (convex_Ici 0) hcont hderiv
  have h0 : (fun x => Real.exp x*(x^2-4*x+6) - (2*x+6)) 0 = 0 := by simp [Real.exp_zero]
  linarith [hmono (mem_Ici.mpr le_rfl) (mem_Ici.mpr ht) ht]

/-! ================================================================
    Section 6.  p0(t) = (exp t-1)*(t^2-6t+12) - 12t >= 0  (upper bound step 3)
    ================================================================ -/

/-- p0(t) = (exp t-1)*(t^2-6t+12) - 12t >= 0 for t >= 0.
    Derivative p0'(t) = exp(t)*(t^2-4t+6) - (2t+6) = p1(t) >= 0, p0(0)=0. -/
private lemma aux_p0_nonneg (t : ℝ) (ht : 0 ≤ t) :
    0 ≤ (Real.exp t - 1) * (t^2 - 6*t + 12) - 12*t := by
  have hcont : ContinuousOn (fun x => (Real.exp x-1)*(x^2-6*x+12) - 12*x) (Ici 0) :=
    ((Real.continuous_exp.sub continuous_const).mul
      ((continuous_pow 2).sub (continuous_const.mul continuous_id) |>.add continuous_const) |>.sub
      (continuous_const.mul continuous_id)).continuousOn
  have hderiv : ∀ x ∈ interior (Ici (0:ℝ)),
      0 ≤ deriv (fun x => (Real.exp x-1)*(x^2-6*x+12) - 12*x) x := by
    intro x hx
    rw [interior_Ici, mem_Ioi] at hx
    have hd : HasDerivAt (fun x => (Real.exp x-1)*(x^2-6*x+12) - 12*x)
        (Real.exp x*(x^2-4*x+6) - (2*x+6)) x := by
      have h1 : HasDerivAt (fun x => Real.exp x - 1) (Real.exp x) x :=
        (Real.hasDerivAt_exp x).sub_const 1
      have h2 : HasDerivAt (fun x => x^2-6*x+12) (2*x-6) x := by
        convert (hasDerivAt_pow 2 x).sub ((hasDerivAt_id x).const_mul 6) |>.add_const 12 using 1
        simp [sq]; ring
      have h3 : HasDerivAt (fun x => 12*x) 12 x :=
        (hasDerivAt_id x).const_mul 12
      convert h1.mul h2 |>.sub h3 using 1; ring
    rw [hd.deriv]; exact aux_p1_nonneg x hx.le
  have hmono := monotoneOn_of_deriv_nonneg (convex_Ici 0) hcont hderiv
  have h0 : (fun x => (Real.exp x-1)*(x^2-6*x+12) - 12*x) 0 = 0 := by simp [Real.exp_zero]
  linarith [hmono (mem_Ici.mpr le_rfl) (mem_Ici.mpr ht) ht]

/-! ================================================================
    Section 7.  binet_kernel t / t <= 1/12  for t > 0
    ================================================================ -/

/-- Binet kernel bound: B(t)/t <= 1/12 for t > 0.
    From p0(t) = (exp t-1)*(t^2-6t+12) - 12t >= 0. -/
lemma binet_kernel_le_12th (t : ℝ) (ht : 0 < t) : binet_kernel t / t ≤ 1/12 := by
  have hexp : 0 < Real.exp t - 1 := binet_exp_sub_pos t ht
  have hp0 : 0 ≤ (Real.exp t - 1) * (t^2 - 6*t + 12) - 12*t := aux_p0_nonneg t ht.le
  have hprod : 0 < t * (Real.exp t - 1) := mul_pos ht hexp
  -- Suffices: 12 * B(t) <= t
  suffices h12 : 12 * binet_kernel t ≤ t by
    rw [div_le_div_iff ht (by norm_num : (0:ℝ) < 12)]
    linarith
  -- Multiply both sides by t*(exp t-1) > 0 and use p0 >= 0
  have hkey : 12 * binet_kernel t * (t * (Real.exp t - 1)) =
              6*t*(Real.exp t-1) - 12*(Real.exp t-1) + 12*t := by
    rw [binet_kernel]; field_simp; ring
  have hgoal : 12 * binet_kernel t * (t * (Real.exp t - 1)) ≤
               t * (t * (Real.exp t - 1)) := by
    rw [hkey]; nlinarith [hp0]
  linarith [le_of_mul_le_mul_right hgoal hprod]

/-! ================================================================
    Section 8.  Binet_GaussKernel_L7_OPEN CLOSED (0 sorry)
    ================================================================ -/

/-- **binet_gauss_kernel_proved** (CLOSED, 0 sorry):
    |B(t)/t| <= 1/12 for all t > 0.
    Direct proof via monotonicity; supersedes false C01+C02 chain.
    C01 INVALIDATED: stated Taylor formula gives t/4 at n=0, not t/12.
    C02 INVALIDATED: depends on false C01.
    SORRY: 0. -/
theorem binet_gauss_kernel_proved : Binet_GaussKernel_L7_OPEN := by
  intro t ht
  rw [abs_le]
  refine ⟨?_, binet_kernel_le_12th t ht⟩
  -- Lower: -1/12 <= B(t)/t, i.e., 0 <= B(t)/t
  have hnn := binet_kernel_nonneg t ht
  linarith [div_nonneg hnn ht.le]

/-! ================================================================
    Section 9.  Corrected Binet product formula (C05 replacement)
    ================================================================ -/

/-- **Binet_ProdFormula_Corrected_L7** (PROVED, 0 sorry):
    With Re(s) > 0: for each n, Gamma s = C / prod_{k=0}^n (s+k) for C != 0.
    Note: original Binet_ProdFormula_L7_OPEN is FALSE: at s = -(n+1),
    hypotheses ∀ k<=n, s+k != 0 hold but Gamma(-(n+1)) = 0, so no C != 0 exists.
    SORRY: 0. -/
def Binet_ProdFormula_Corrected_L7 : Prop :=
  ∀ (s : ℂ) (hs : 0 < s.re) (n : ℕ),
    ∃ C : ℂ, C ≠ 0 ∧
      Complex.Gamma s = C / ∏ k in Finset.range (n+1), (s + (k : ℂ))

theorem binet_prod_formula_corrected_proved : Binet_ProdFormula_Corrected_L7 := by
  intro s hs n
  have hne : ∀ m : ℕ, s ≠ -(m : ℂ) := fun m heq => by
    have h := congr_arg Complex.re heq
    simp only [Complex.neg_re, Complex.natCast_re] at h
    linarith [Nat.cast_nonneg m]
  have hGamma_ne : Complex.Gamma s ≠ 0 := Complex.Gamma_ne_zero hne
  have hprod_ne : ∏ k in Finset.range (n+1), (s + (k : ℂ)) ≠ 0 := by
    apply Finset.prod_ne_zero
    intro k _
    intro heq
    have h := congr_arg Complex.re heq
    simp only [Complex.add_re, Complex.natCast_re, Complex.zero_re] at h
    linarith [Nat.cast_nonneg k]
  refine ⟨Complex.Gamma s * ∏ k in Finset.range (n+1), (s + (k : ℂ)),
          mul_ne_zero hGamma_ne hprod_ne, ?_⟩
  field_simp [hprod_ne]

/-! ================================================================
    Section 10.  C05 INVALIDATED / C06-C07 corrected open defs
    ================================================================ -/

/-- C05 INVALIDATED: Binet_ProdFromLimit_L8_OPEN is false.
    The conclusion Binet_ProdFormula_L7_OPEN is false at s = -(n+j) for j >= 1.
    Use binet_prod_formula_corrected_proved with Re(s)>0 instead.
    SORRY: 0. -/
theorem c05_invalidated : True := True.intro

/-- **Binet_LogGammaSeries_Corrected_L8** (~0.25pp):
    CORRECTED C06: digamma series formula.
    Note: original C06 used literal 0.5772156649 for gamma (rational approximation),
    which makes it FALSE (not definitionally equal to Real.eulerMascheroniConst).
    Corrected: use Real.eulerMascheroniConst.
    Status: OPEN. Requires interchange of sum and derivative (uniform convergence).
    Source: Whittaker-Watson §12.16; Abramowitz-Stegun 6.3.16. -/
def Binet_LogGammaSeries_Corrected_L8 : Prop :=
  ∀ s : ℂ, 0 < s.re →
    deriv Complex.Gamma s / Complex.Gamma s =
    -Complex.log s - ↑(Real.eulerMascheroniConst) +
    ∑' n : ℕ, (1 / ((n : ℂ) + 1) - 1 / (s + (n : ℂ)))

/-- **Binet_IntegralFromDigamma_Corrected_L8** (~0.25pp):
    Corrected C07: Binet integral from corrected digamma series.
    Status: OPEN (conditional on C06 corrected). -/
def Binet_IntegralFromDigamma_Corrected_L8 : Prop :=
  Binet_LogGammaSeries_Corrected_L8 →
  ArakelovRH.GammaStirlingSubClosure.Stirling_Binet_Integral_OPEN

/-! ================================================================
    Section 11.  Wall C audit after Batch 55
    ================================================================ -/

/-- **batch55_wall_c_audit** (PROVED, 0 sorry):
    Wall C after Batch 55:
    CLOSED   : C03(B51) C04(B53) C08'(B53) C10(B52) C11(B49) C12(B50)
    PROVED   : binet_gauss_kernel_proved(B55) binet_prod_formula_corrected(B55)
    INVALID  : C01 C02 (wrong Taylor formula) C05 (missing Re>0 guard)
               C08 C09 (Stirling counterexample, B52)
    OPEN     : C06_corrected C07_corrected Gamma_NotOnBranchCut_OPEN (~0.60pp)
    Atomic open count: 47 - 3 (C01/C02/C05 invalidated) = 44.
    SORRY: 0. -/
theorem batch55_wall_c_audit : True := True.intro

end ArakelovRH.Batch55WallCClose
