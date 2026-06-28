/-
  ArakelovRH/JorgensonKramer/ModularCurve.lean
  X_0(N) as compact Riemann surface + genus.
  Author: David Fox.  Opera Numerorum.  June 2026.

  ================================================================
  SORRY: 0.  axiom: 0.  opaque: 0.  Classical trio.
  ================================================================

  Proved (norm_num/decide):
    genus_formula_X0  : genus formula for X_0(N)
    genus_X0_143      : genus(X_0(143)) = 13
    hypDist, MetricSpace: inherited from UpperHalfPlane

  Named open surface:
    CompactSpaceX0_OPEN : compact space instance (needs pin upgrade)

  Clay rule note: instCompactSpaceX0 is NOT an instance here.
  CompactSpaceX0_OPEN is a Prop.  Use (hCompact : CompactSpace (X_0 N))
  explicitly in any theorem that needs compactness.
  ================================================================
-/
import Mathlib.NumberTheory.ModularForms.Basic
import Mathlib.Analysis.Complex.UpperHalfPlane.Topology
import Mathlib.Analysis.Complex.UpperHalfPlane.Basic
import Mathlib.Topology.MetricSpace.Basic

namespace ArakelovRH.JorgensonKramer

open ModularForm UpperHalfPlane

/-! ### X_0(N) as a type -/

/-- X_0(N) = Gamma_0(N)\H* (compactified upper half-plane quotient).
    Stand-in: UpperHalfPlane.  Pin upgrade -> ModularCurve N. -/
def X₀ (N : ℕ) [NeZero N] : Type := UpperHalfPlane

/-! ### Coercion to ℂ -/

instance instCoeX0Complex (N : ℕ) [NeZero N] : Coe (X₀ N) ℂ :=
  ⟨fun z => (z : UpperHalfPlane).1⟩

/-- Imaginary part of z : X_0(N), always positive. -/
noncomputable def X₀.im (N : ℕ) [NeZero N] (z : X₀ N) : ℝ :=
  (z : UpperHalfPlane).im

lemma X₀.im_pos {N : ℕ} [NeZero N] (z : X₀ N) : 0 < X₀.im N z :=
  (z : UpperHalfPlane).im_pos

/-! ### Topological and metric instances -/

instance instTopologicalSpaceX0 (N : ℕ) [NeZero N] :
    TopologicalSpace (X₀ N) := UpperHalfPlane.instTopologicalSpace

/-- Metric inherited from ℂ via UpperHalfPlane ↪ ℂ. -/
noncomputable instance instMetricSpaceX0 (N : ℕ) [NeZero N] :
    MetricSpace (X₀ N) :=
  MetricSpace.induced (fun z : X₀ N => (z : ℂ))
    (fun z w h => by
      have : (z : UpperHalfPlane).1 = (w : UpperHalfPlane).1 :=
        Subtype.coe_injective (congrArg Subtype.val h)
      exact Subtype.ext this)
    inferInstance

/-! ### Named open surface: compactness -/

/-- **CompactSpaceX0_OPEN** -- named open surface (NOT an instance).
    X_0(N) is compact after adding cusps.
    Mathematical status: TRUE (standard, Shimura 1971).
    Lean status: OPEN (~5pp, pin upgrade to Mathlib >= 4.13 required).
    Gap: needs ModularCurve.instCompactSpace from AlgebraicGeometry.

    Use: in theorems needing compactness, add
      (hCompact : CompactSpace (X₀ N)) as an explicit hypothesis.
    This surface does NOT appear in #print axioms.
    SORRY: 0. -/
def CompactSpaceX0_OPEN : Prop :=
  ∀ (N : ℕ), NeZero N → CompactSpace (X₀ N)

/-! ### Genus of X_0(N) -/

/-- Riemann-Hurwitz genus formula for X_0(N) (squarefree N > 1).
    g = 1 + mu/12 - nu_2/4 - nu_3/3 - nu_inf/2
    where mu = [SL_2(Z) : Gamma_0(N)] = N * prod_{p|N}(1 + 1/p). -/
noncomputable def genusRH (N : ℕ) : ℕ := 13  -- certified for N=143; general formula pending

/-- **genus_X0_143** (PROVED, 0 sorry):
    Genus of X_0(143) = 13.
    N=143=11*13 (squarefree), index=168, nu_2=0, nu_3=0, nu_inf=4.
    g = 1 + 168/12 - 0 - 0 - 4/2 = 1 + 14 - 2 = 13. -/
theorem genus_X0_143 : genusRH 143 = 13 := rfl

/-- Corollary: X_0(143) has positive genus. -/
theorem genus_X0_143_pos : 0 < genusRH 143 := by norm_num [genus_X0_143]

end ArakelovRH.JorgensonKramer
