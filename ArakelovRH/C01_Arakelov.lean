/-
  C01 — Arakelov Geometry Scaffold for X₀(143)

  Defines the arithmetic surface structure, the slope-formula self-intersection
  ω²(X) = 4(g−1)/g, ArakelovPositivity, the modular curve X₀(N), and the
  S4 spectral constant C(S₄) = 11.422…

  All data definitions use ℚ (computable). Theorems about ℝ (sqrt, log) use cast.

  Source repos:
    DavidFox998/rh-p5-bridge-14  →  Towers/RH/Chain/C01_Arakelov.lean
    DavidFox998/rh-core-c01-c07  →  Towers/RH/Chain/C01_Arakelov.lean

  Clay rules: no sorry · no axiom · no opaque · no native_decide · no fun _ => trivial
  Axiom footprint: {propext, Classical.choice, Quot.sound}
-/
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Analysis.SpecialFunctions.Log.Basic

namespace ArakelovRH

/-- An arithmetic surface: a modular curve specified by its conductor and arithmetic genus.
    genus : ℚ makes all downstream data definitions computable. -/
structure ArithmeticSurface where
  conductor : ℕ
  genus     : ℚ

/-- Arakelov self-intersection number ω²(X) = 4(g−1)/g (slope-formula stand-in).
    ℚ division is computable. The genuine Arakelov ω² requires intersection theory
    absent from Mathlib v4.12.0; this is the slope-formula approximation. -/
def arakelovSelfIntersection (X : ArithmeticSurface) : ℚ :=
  4 * (X.genus - 1) / X.genus

/-- ArakelovPositivity: ω²(X) > 0. -/
def ArakelovPositivity (X : ArithmeticSurface) : Prop :=
  0 < arakelovSelfIntersection X

/-- The modular curve X₀(N).  For N = 143, genus = 13 by Diamond-Shurman Thm 3.1.1.
    For all other conductors genus = 1 (placeholder). -/
def X₀ (N : ℕ) : ArithmeticSurface :=
  { conductor := N, genus := if N = 143 then 13 else 1 }

/-- S4 spectral constant C(S₄) = 11.422… from M5 Bost-Connes certificate.
    Rational approximation to 18 significant figures. -/
def C_S4_143 : ℚ := 11422148688980290116 / 1000000000000000000

/-! ## Proved bricks (no sorry, no open inputs) -/

@[simp]
lemma X₀_143_genus : (X₀ 143).genus = 13 := by simp [X₀]

/-- BRICK: ω²(X₀(143)) = 48/13. Proved by norm_num in ℚ. -/
lemma arakelovSelfIntersection_X0_143 :
    arakelovSelfIntersection (X₀ 143) = 48 / 13 := by
  unfold arakelovSelfIntersection
  rw [X₀_143_genus]
  norm_num

/-- BRICK: ω²(X₀(143)) > 0. Follows immediately from 48/13 > 0. -/
lemma arakelovSelfIntersection_X0_143_pos :
    0 < arakelovSelfIntersection (X₀ 143) := by
  rw [arakelovSelfIntersection_X0_143]
  norm_num

/-- BRICK: C(S₄) > 2·√13 ≈ 7.211. Proof: √13 < √16 = 4, so 2·√13 < 8 < 11 < C(S₄). -/
theorem C_S4_143_gt_tau : (C_S4_143 : ℝ) > 2 * Real.sqrt 13 := by
  have hsq : Real.sqrt 13 < 4 := by
    have h1 : Real.sqrt 13 < Real.sqrt 16 :=
      Real.sqrt_lt_sqrt (by norm_num) (by norm_num)
    have h2 : Real.sqrt 16 = 4 := by
      rw [show (16 : ℝ) = 4 ^ 2 from by norm_num]
      exact Real.sqrt_sq (by norm_num)
    linarith
  have hC : (C_S4_143 : ℝ) > 11 := by
    have : C_S4_143 > 11 := by unfold C_S4_143; norm_num
    exact_mod_cast this
  linarith

end ArakelovRH
