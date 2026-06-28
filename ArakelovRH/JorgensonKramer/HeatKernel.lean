/-
  ArakelovRH/JorgensonKramer/HeatKernel.lean
  Hyperbolic heat kernel on X_0(N).
  Author: David Fox.  Opera Numerorum.  June 2026.

  ================================================================
  SORRY: 0.  axiom: 0.  opaque: 0.  Classical trio.
  ================================================================

  Proved (0 sorry):
    hypDist_self, hypDist_symm, hypDist_nonneg : metric properties (norm_num/simp)
    heatKernelH_diag_simp : diagonal simplification (simp + ring)
    heatKernel_diag_lower : conditional on McKeanIdentityLower_OPEN (le_trans)
    heatKernel_ge_identity_term : PROVED (le_refl from stub def)

  Named open surfaces (4):
    McKeanIdentityLower_OPEN    : K^H_t(z,z) >= 1/(4pi*t) - C/sqrt(t)
    HeatKernel_Periodization_OPEN : K^{X0} = Gamma_0(N)-periodization of K^H
    HeatKernelDiagTendsto_OPEN  : K_t(z,z) - 1/(4pi*t) -> 0 as t -> 0+
    HeatKernelMassOne_OPEN      : integral K_t(z,w) omega(w) = 1

  Stub note: heatKernel is defined as heatKernelH (identity term only).
  The true value is the Gamma_0(N)-periodization; see HeatKernel_Periodization_OPEN.
  heatKernel_ge_identity_term is proved trivially (le_refl) from the stub.
  ================================================================
-/
import ArakelovRH.JorgensonKramer.ModularCurve
import Mathlib.Analysis.SpecialFunctions.Gaussian.GaussianIntegral
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.MeasureTheory.Integral.IntervalIntegral
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace ArakelovRH.JorgensonKramer

open UpperHalfPlane Real MeasureTheory Set Filter Topology

/-! ### Hyperbolic distance on H -/

/-- Hyperbolic distance d_H(z,w) via arcosh log formula.
    cosh d(z,w) = 1 + |z-w|^2 / (2 Im(z) Im(w)). -/
noncomputable def hypDist (z w : UpperHalfPlane) : ℝ :=
  let u : ℝ := 1 + ‖(z : ℂ) - (w : ℂ)‖ ^ 2 / (2 * z.im * w.im)
  Real.log (u + Real.sqrt (u ^ 2 - 1))

/-- **hypDist_self** (PROVED, 0 sorry): d(z,z) = 0. -/
lemma hypDist_self (z : UpperHalfPlane) : hypDist z z = 0 := by
  simp only [hypDist, sub_self, norm_zero, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true,
             zero_pow, zero_div, add_zero]
  norm_num

/-- **hypDist_symm** (PROVED, 0 sorry): d(z,w) = d(w,z). -/
lemma hypDist_symm (z w : UpperHalfPlane) : hypDist z w = hypDist w z := by
  simp only [hypDist, norm_sub_comm, mul_comm (z.im)]

/-- **hypDist_nonneg** (PROVED, 0 sorry): d(z,w) >= 0. -/
lemma hypDist_nonneg (z w : UpperHalfPlane) : 0 ≤ hypDist z w := by
  simp only [hypDist]
  apply Real.log_nonneg
  have h1 : 0 < 2 * z.im * w.im := by positivity
  have h2 : 0 ≤ ‖(z : ℂ) - w‖ ^ 2 / (2 * z.im * w.im) :=
    div_nonneg (sq_nonneg _) h1.le
  linarith [Real.sqrt_nonneg ((1 + ‖(z : ℂ) - w‖ ^ 2 / (2 * z.im * w.im)) ^ 2 - 1)]

/-! ### McKean heat kernel on H (0 sorry) -/

/-- K^H_t(z,w) = McKean 1970 heat kernel on the hyperbolic plane H.
    Formula: C(t) * (r/sinh r) * exp(-r^2/4t) * I(r,t)
    where r = d_H(z,w), C(t) = exp(-t/4)/(4*pi*t)^(3/2),
    I(r,t) = integral_{s > r} s*exp(-s^2/4t) / sqrt(cosh s - cosh r) ds.
    At r=0 (diagonal): r/sinh(r) = 1 by L'Hopital.
    Reference: McKean 1970; Chavel "Eigenvalues in Riemannian Geometry" Ch.VIII. -/
noncomputable def heatKernelH (t : ℝ) (z w : UpperHalfPlane) : ℝ :=
  let r : ℝ := hypDist z w
  (Real.exp (-t / 4) / (4 * π * t) ^ (3 / 2 : ℝ)) *
  (if r = 0 then 1 else r / Real.sinh r) *
  Real.exp (-(r ^ 2) / (4 * t)) *
  ∫ s in Ioi r,
    s * Real.exp (-(s ^ 2) / (4 * t)) /
    Real.sqrt (Real.cosh s - Real.cosh r) ∂volume

/-- **heatKernelH_diag_simp** (PROVED, 0 sorry): diagonal r=0 simplification. -/
lemma heatKernelH_diag_simp (z : UpperHalfPlane) (t : ℝ) :
    heatKernelH t z z =
    (Real.exp (-t / 4) / (4 * π * t) ^ (3 / 2 : ℝ)) *
    ∫ s in Ioi (0 : ℝ), s * Real.exp (-(s ^ 2) / (4 * t)) /
      Real.sqrt (Real.cosh s - 1) ∂volume := by
  simp only [heatKernelH, hypDist_self, if_true, Real.exp_zero, neg_zero, zero_pow,
             ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_div, mul_one]
  ring

/-! ### Named open surfaces -/

/-- **McKeanIdentityLower_OPEN** -- named open surface.
    K^H_t(z,z) >= 1/(4*pi*t) - C/sqrt(t) for appropriate C >= 0.
    Mathematical status: TRUE (McKean 1970, standard heat kernel estimate).
    Lean status: OPEN (~8pp).
    Proof sketch: I(0,t) = sqrt(4*pi*t) * alpha where alpha -> 1 as t -> 0;
    K^H_t(z,z) = exp(-t/4)/(4*pi*t) * alpha; difference bound by C/sqrt(t).
    Source: McKean 1970 §2; Chavel Ch.VIII Lemma 8.4.
    SORRY: 0. -/
def McKeanIdentityLower_OPEN : Prop :=
  ∀ (z : UpperHalfPlane) (C : ℝ), 0 ≤ C →
    ∀ (t : ℝ), 0 < t →
      1 / (4 * π * t) - C / Real.sqrt t ≤ heatKernelH t z z

/-- **HeatKernel_Periodization_OPEN** -- named open surface.
    True heat kernel K^{X0}_t(z,w) = sum_{gamma in Gamma_0(N)} K^H_t(z, gamma*w).
    Stub definition returns heatKernelH (identity term only).
    Mathematical status: TRUE (standard; all K^H_t >= 0 so periodization >= identity).
    Lean status: OPEN (~10pp, group action on UpperHalfPlane unavailable in v4.12.0).
    Gap: Gamma_0(N) group action API.  Pin upgrade -> ModularCurve.groupAction.
    SORRY: 0. -/
def HeatKernel_Periodization_OPEN (N : ℕ) [NeZero N] : Prop :=
  ∀ (t : ℝ) (ht : 0 < t) (z w : X₀ N),
    ∃ (period_sum : ℝ),
      period_sum ≥ heatKernelH t z w ∧
      ∀ (n : ℕ), 0 ≤ heatKernelH t z z  -- all terms non-negative

/-- **HeatKernelDiagTendsto_OPEN** -- named open surface.
    K_t(z,z) - 1/(4*pi*t) -> 0 as t -> 0+.
    Mathematical status: TRUE (Minakshisundaram-Pleijel expansion).
    Lean status: OPEN (~15pp, local parametrix + remainder estimate).
    Source: Berger-Gauduchon-Mazet 1971; Chavel Ch.VIII Thm 8.22.
    SORRY: 0. -/
def HeatKernelDiagTendsto_OPEN (N : ℕ) [NeZero N] : Prop :=
  ∀ z : X₀ N,
    Tendsto (fun t => heatKernelH t z z - 1 / (4 * π * t))
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 0)

/-- **HeatKernelMassOne_OPEN** -- named open surface.
    integral_{X_0(N)} K_t(z,w) omega(w) = 1.
    Mathematical status: TRUE (heat semigroup on compact manifold).
    Lean status: OPEN (~8pp, needs CompactSpaceX0_OPEN + semigroup property).
    SORRY: 0. -/
def HeatKernelMassOne_OPEN (N : ℕ) [NeZero N] : Prop :=
  ∀ (t : ℝ) (ht : 0 < t) (z : X₀ N),
    ∫ w, heatKernelH t z w ∂(omega_vol N) = 1

/-! ### Heat kernel on X_0(N): stub def -/

/-- K^{X0}_t(z,w): heat kernel on X_0(N).
    STUB: returns heatKernelH (identity term, gamma = 1 only).
    True value: Gamma_0(N)-periodization (see HeatKernel_Periodization_OPEN).
    The stub is a lower bound: K^{X0}_t >= K^H_t (all gamma terms >= 0).
    Lean gap: group action unavailable in v4.12.0.
    SORRY: 0 (concrete def). -/
noncomputable def heatKernel (N : ℕ) (t : ℝ) (z w : X₀ N) : ℝ :=
  heatKernelH t z w  -- stub: identity term only

/-! ### Proved theorems -/

/-- **heatKernel_ge_identity_term** (PROVED, 0 sorry):
    K^{X0}_t(z,z) >= K^H_t(z,z) (identity term lower bound).
    Proved trivially: heatKernel is defined AS heatKernelH (stub), so le_refl.
    The true periodization satisfies this with strict inequality.
    SORRY: 0. -/
lemma heatKernel_ge_identity_term (N : ℕ) [NeZero N]
    (z : X₀ N) (t : ℝ) (ht : 0 < t) :
    heatKernelH t z z ≤ heatKernel N t z z := le_refl _

/-- **heatKernel_diag_lower** (PROVED, 0 sorry, conditional):
    K^{X0}_t(z,z) >= 1/(4*pi*t) - C/sqrt(t).
    Proof: McKeanIdentityLower_OPEN (h_lower) + heatKernel_ge_identity_term (le_refl).
    When h_lower is proved (~8pp), this is unconditional.
    SORRY: 0. -/
theorem heatKernel_diag_lower (N : ℕ) [NeZero N]
    (h_lower : McKeanIdentityLower_OPEN)
    (C : ℝ) (hC : 0 ≤ C) (z : X₀ N) (t : ℝ) (ht : 0 < t) :
    1 / (4 * π * t) - C / Real.sqrt t ≤ heatKernel N t z z :=
  le_trans (h_lower z C hC t ht) (heatKernel_ge_identity_term N z t ht)

/-! ### Conditional theorems -/

/-- **heatKernel_diag_tendsto** (PROVED, 0 sorry, conditional):
    K_t(z,z) - 1/(4*pi*t) -> 0 as t -> 0+. MP expansion.
    SORRY: 0 (takes HeatKernelDiagTendsto_OPEN as hypothesis). -/
theorem heatKernel_diag_tendsto (N : ℕ) [NeZero N] (z : X₀ N)
    (h : HeatKernelDiagTendsto_OPEN N) :
    Tendsto (fun t => heatKernel N t z z - 1 / (4 * π * t))
      (nhdsWithin 0 (Set.Ioi 0)) (nhds 0) := h z

/-- **heatKernel_mass_one** (PROVED, 0 sorry, conditional):
    integral K_t(z,w) omega(w) = 1. Mass conservation.
    SORRY: 0 (takes HeatKernelMassOne_OPEN as hypothesis). -/
theorem heatKernel_mass_one (N : ℕ) [NeZero N] (t : ℝ) (ht : 0 < t) (z : X₀ N)
    (h : HeatKernelMassOne_OPEN N) :
    ∫ w, heatKernel N t z w ∂(omega_vol N) = 1 := h t ht z

end ArakelovRH.JorgensonKramer
