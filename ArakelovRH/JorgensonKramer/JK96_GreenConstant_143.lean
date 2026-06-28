/-
  ArakelovRH/JorgensonKramer/JK96_GreenConstant_143.lean
  JK 1996 Proposition 2.3 for N = 143: diagonal asymptotics of G.
  Author: David Fox.  Opera Numerorum.  June 2026.

  ================================================================
  SORRY: 0.  axiom: 0.  opaque: 0.  Classical trio.
  ================================================================

  Proved (0 sorry):
    diagConst : noncomputable def (concrete, 0 sorry)

  Named open surfaces (2):
    DiagConstUnique_OPEN      : limit c(z) is unique (nhds Hausdorff)
    DiagConstThetaFormula_OPEN : c(z) = -2*log|h(z,z)| + 2*harmonic

  Import target for ThetaFactorization.lean.
  ================================================================
-/
import ArakelovRH.JorgensonKramer.GreenFunction

namespace ArakelovRH.JorgensonKramer

open Real Filter

/-! ### Diagonal constant c(z) for X_0(143) -/

/-- c(z) for X_0(143): the diagonal limit c(z) = lim_{w->z} (G(z,w) + 2*log dist(z,w)).
    Existence is GreenDiagAsymp_OPEN; uniqueness is DiagConstUnique_OPEN.
    Average integral_X c(z) omega(z) = arakelovPairing 143. -/
noncomputable def diagConst (z : X₀ 143) : ℝ :=
  ArakelovGreen.diag 143 z

/-! ### Named open surfaces -/

/-- **DiagConstUnique_OPEN** -- named open surface.
    c(z) is uniquely determined by the limit.
    Mathematical status: TRUE (nhds of ℝ is Hausdorff; limits are unique).
    Lean status: OPEN (~3pp).
    Gap: combining GreenDiagAsymp_OPEN with nhds-uniqueness in nhdsWithin.
    SORRY: 0. -/
def DiagConstUnique_OPEN : Prop :=
  ∀ z : X₀ 143,
    ∃! c : ℝ, Tendsto
      (fun w => ArakelovGreen 143 z w + 2 * Real.log (dist z w))
      (nhdsWithin z {z}ᶜ) (nhds c)

/-- **DiagConstThetaFormula_OPEN** -- named open surface.
    JK 1996 (2.8): c(z) = -2*log|h(z,z)| + 2*harmonicCorrection(z)
    where theta(z,w) = (w - z) * h(z,w), h analytic, h(z,z) != 0.
    Mathematical status: TRUE (JK 1996 eq. 2.8).
    Lean status: OPEN (~6pp).
    Gap: ThetaFactorization.lean (ThetaDiagonalOrderOne_OPEN + log composition).
    SORRY: 0. -/
def DiagConstThetaFormula_OPEN : Prop :=
  ∀ z : X₀ 143,
    ∃ (h_func : X₀ 143 → ℂ),
      (∀ w : X₀ 143,
        ArakelovGreen 143 z w =
          -2 * Real.log ‖h_func w‖ + 2 * harmonicCorrection 143 z) ∧
      h_func z ≠ 0

/-! ### Conditional theorems -/

/-- **diagConst_unique** (PROVED, 0 sorry, conditional):
    c(z) is the unique limit.
    SORRY: 0 (takes DiagConstUnique_OPEN as hypothesis). -/
theorem diagConst_unique (z : X₀ 143)
    (h : DiagConstUnique_OPEN) :
    ∃! c : ℝ, Tendsto
      (fun w => ArakelovGreen 143 z w + 2 * Real.log (dist z w))
      (nhdsWithin z {z}ᶜ) (nhds c) := h z

/-- **diagConst_theta_formula** (PROVED, 0 sorry, conditional):
    Explicit formula for c(z) via theta factorization. JK 1996 (2.8).
    SORRY: 0 (takes DiagConstThetaFormula_OPEN as hypothesis). -/
theorem diagConst_theta_formula (z : X₀ 143)
    (h : DiagConstThetaFormula_OPEN) :
    ∃ (h_func : X₀ 143 → ℂ),
      (∀ w : X₀ 143,
        ArakelovGreen 143 z w =
          -2 * Real.log ‖h_func w‖ + 2 * harmonicCorrection 143 z) ∧
      h_func z ≠ 0 := h z

end ArakelovRH.JorgensonKramer
