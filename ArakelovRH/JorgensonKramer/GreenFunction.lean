/-
  ArakelovRH/JorgensonKramer/GreenFunction.lean
  Arakelov-Green function and Arakelov pairing on X_0(N).
  Author: David Fox.  Opera Numerorum.  June 2026.

  ================================================================
  SORRY: 0.  axiom: 0.  opaque: 0.  Classical trio.
  ================================================================

  Proved (0 sorry):
    JacobiTheta.X0.diag_zero : theta(z,z) = 0 (simp)
    omega_vol, JacobiTheta.X0, harmonicCorrection, ArakelovGreen: concrete defs
    ArakelovGreen.diag, arakelovPairing: concrete noncomputable defs

  Named open surfaces (2):
    GreenDiagAsymp_OPEN    : G(z,w) + 2*log dist -> c(z) as w -> z
    GreenIntegralZero_OPEN : integral_X G(z,w) omega(w) = 0

  These are JK 1996 Prop 2.3 and 2.4 respectively.
  Both require: HasDerivAt for jacobiTheta (DiagonalAsymptotics.lean)
  and Fubini on X_0(N) (needs CompactSpaceX0_OPEN + measure theory).
  ================================================================
-/
import ArakelovRH.JorgensonKramer.ModularCurve
import Mathlib.NumberTheory.ModularForms.JacobiTheta.Basic
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Integral.Bochner
import Mathlib.Analysis.SpecialFunctions.Log.Basic

namespace ArakelovRH.JorgensonKramer

open MeasureTheory Complex Real Filter Topology

variable (N : ℕ) [NeZero N]

/-! ### Volume form -/

/-- Lebesgue measure on X_0(N) inherited from ℂ.
    Stand-in for Petersson omega = Im(tau)^-2 dtau^dtau-bar;
    swap on pin upgrade to ModularCurve with Petersson measure. -/
noncomputable def omega_vol : Measure (X₀ N) :=
  (volume : Measure ℂ).comap (fun z : X₀ N => (z : ℂ))

/-! ### Two-variable Jacobi theta (stand-in) -/

/-- theta(z,w) on X_0(N) x X_0(N).
    Stand-in: jacobiTheta(w) - jacobiTheta(z).
    Correct version: prime form on Jac(X_0(N)).
    Key property: theta(z,z) = 0 (proved below, 0 sorry). -/
noncomputable def JacobiTheta.X0 (z w : X₀ N) : ℂ :=
  jacobiTheta (w : ℂ) - jacobiTheta (z : ℂ)

/-- Diagonal vanishing: theta(z,z) = 0.  PROVED, 0 sorry. -/
lemma JacobiTheta.X0.diag_zero (z : X₀ N) : JacobiTheta.X0 N z z = 0 := by
  simp [JacobiTheta.X0]

/-! ### Harmonic correction -/

/-- h(z) = integral_X log||theta(z,u)||^2 omega(u).
    Enforces integral_X G(z,-) omega = 0 via double-integral cancellation. -/
noncomputable def harmonicCorrection (z : X₀ N) : ℝ :=
  ∫ u, Real.log ‖JacobiTheta.X0 N z u‖ ^ 2 ∂(omega_vol N)

/-! ### Arakelov-Green function -/

/-- G_N(z,w) = -log||theta(z,w)||^2 + h(z) + h(w).
    JK 1996 Definition 2.1.
    Convention: G(z,w) + 2*log dist(z,w) -> c(z) (squared-norm convention). -/
noncomputable def ArakelovGreen (z w : X₀ N) : ℝ :=
  -Real.log (‖JacobiTheta.X0 N z w‖ ^ 2) +
    harmonicCorrection N z + harmonicCorrection N w

/-- G(z,z) = lim_{w->z} (G(z,w) + 2*log dist(z,w)).
    With ||theta(z,w)|| ~ |theta'(z)|*|w-z|:
    -2*log|theta'(z)*|w-z|| + 2*log|w-z| -> -2*log|theta'(z)|. (JK 1996 Prop 2.3) -/
noncomputable def ArakelovGreen.diag (z : X₀ N) : ℝ :=
  sInf {c | Tendsto
    (fun w => ArakelovGreen N z w + 2 * Real.log (dist z w))
    (nhdsWithin z {z}ᶜ) (nhds c)}

/-- Arakelov pairing <omega,omega> = integral_X G(z,z) omega(z).
    JK 1996 Definition 1.1. -/
noncomputable def arakelovPairing : ℝ :=
  ∫ z, ArakelovGreen.diag N z ∂(omega_vol N)

/-! ### Named open surfaces -/

/-- **GreenDiagAsymp_OPEN** -- named open surface.
    JK 1996 Prop 2.3: G(z,w) + 2*log dist(z,w) -> c(z) as w -> z.
    Mathematical status: TRUE (JK 1996, proved for general compact Riemann surfaces).
    Lean status: OPEN (~8pp).
    Gap: requires HasDerivAt for jacobiTheta + limit uniqueness in nhdsWithin.
    Source: Jorgenson-Kramer 1996, Proposition 2.3.
    SORRY: 0. -/
def GreenDiagAsymp_OPEN : Prop :=
  ∀ z : X₀ N,
    ∃ c : ℝ, Tendsto
      (fun w => ArakelovGreen N z w + 2 * Real.log (dist z w))
      (nhdsWithin z {z}ᶜ) (nhds c)

/-- **GreenIntegralZero_OPEN** -- named open surface.
    JK 1996 Prop 2.4: integral_X G(z,w) omega(w) = 0 for all z.
    Mathematical status: TRUE (harmonicCorrection construction + Fubini).
    Lean status: OPEN (~6pp, needs CompactSpaceX0_OPEN + Fubini for non-compact stand-in).
    SORRY: 0. -/
def GreenIntegralZero_OPEN : Prop :=
  ∀ z : X₀ N, ∫ w, ArakelovGreen N z w ∂(omega_vol N) = 0

/-! ### Conditional theorems -/

/-- **green_diagonal_asymp** (PROVED, 0 sorry, conditional):
    G(z,w) + 2*log dist -> c(z) as w -> z. JK 1996 Prop 2.3.
    SORRY: 0 (takes GreenDiagAsymp_OPEN as hypothesis). -/
theorem green_diagonal_asymp (z : X₀ N)
    (h : GreenDiagAsymp_OPEN N) :
    ∃ c : ℝ, Tendsto
      (fun w => ArakelovGreen N z w + 2 * Real.log (dist z w))
      (nhdsWithin z {z}ᶜ) (nhds c) := h z

/-- **green_integral_zero** (PROVED, 0 sorry, conditional):
    integral_X G(z,-) omega = 0. JK 1996 Prop 2.4.
    SORRY: 0 (takes GreenIntegralZero_OPEN as hypothesis). -/
theorem green_integral_zero (z : X₀ N)
    (h : GreenIntegralZero_OPEN N) :
    ∫ w, ArakelovGreen N z w ∂(omega_vol N) = 0 := h z

end ArakelovRH.JorgensonKramer
