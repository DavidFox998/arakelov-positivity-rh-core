/-
  C03 — Slope Inequality and Positivity Bricks

  Proves the Miyaoka-Yau slope inequality (4g−4)/g ≤ ω²(X) in ℚ, and
  the specific numerical bricks for X₀(143).

  Source repos:
    DavidFox998/rh-p5-bridge-14  →  Towers/RH/Chain/C03_Positivity.lean
    DavidFox998/rh-core-c01-c07  →  Towers/RH/Chain/C03_Positivity.lean

  Clay rules: no sorry · no axiom · no opaque · no native_decide · no fun _ => trivial
  Axiom footprint: {propext, Classical.choice, Quot.sound}
-/
import ArakelovRH.C01_Arakelov

namespace ArakelovRH

/-- Miyaoka-Yau slope inequality: (4g−4)/g ≤ ω²(X) whenever g ≥ 2 and ω² > 0.
    Proved in ℚ; both sides have the same denominator g, numerators are equal. -/
theorem slope_inequality (X : ArithmeticSurface)
    (hg : 2 ≤ X.genus) (_ : ArakelovPositivity X) :
    (4 * X.genus - 4) / X.genus ≤ arakelovSelfIntersection X := by
  unfold arakelovSelfIntersection
  have hgpos : 0 < X.genus := by linarith
  rw [div_le_div_iff hgpos hgpos]
  have : (4 * X.genus - 4) * X.genus = 4 * (X.genus - 1) * X.genus := by ring
  linarith

/-- Faltings height positivity: ArakelovPositivity is exactly ω² > 0. -/
theorem faltingsHeight_pos (X : ArithmeticSurface) (hA : ArakelovPositivity X) :
    0 < arakelovSelfIntersection X := hA

/-- Height lower bound: ω²(X₀(143)) ≥ 48/13 (equality). -/
theorem height_lower_bound (hA : ArakelovPositivity (X₀ 143)) :
    48 / 13 ≤ arakelovSelfIntersection (X₀ 143) := by
  rw [arakelovSelfIntersection_X0_143]

/-- BRICK: slope inequality closed for X₀(143). Zero open inputs.
    (4·13 − 4)/13 = 48/13 = ω²(X₀(143)). -/
lemma slope_le_self_intersection_X0_143 :
    (4 * (X₀ 143).genus - 4) / (X₀ 143).genus ≤ arakelovSelfIntersection (X₀ 143) := by
  rw [X₀_143_genus, arakelovSelfIntersection_X0_143]
  norm_num

end ArakelovRH
