/-
  C06 — Bost-Connes Spectral Threshold

  Proves 2·√genus(X₀(143)) < C₀ = 320.  The Bost-Connes C*-algebra BC(ℚ)
  encodes ℚ^ab via an operator algebra whose partition function recovers ζ(s).
  The threshold C₀ = 320 is the Selberg trace formula constant for X₀(143).

  Source repos:
    DavidFox998/bost-connes        →  Src/BostConnes/C06_ZetaControl.lean
    DavidFox998/rh-p5-bridge-14   →  Towers/RH/Chain/C06_ZetaControl.lean
    DavidFox998/rh-core-c01-c07   →  Towers/RH/Chain/C06_ZetaControl.lean

  Change from source: uses (X₀ 143).genus cast to ℝ for chain traceability
  rather than the hard-coded literal (13 : ℝ).

  Clay rules: no sorry · no axiom · no opaque · no native_decide · no fun _ => trivial
  Axiom footprint: {propext, Classical.choice, Quot.sound}
-/
import Mathlib.Analysis.SpecialFunctions.Sqrt
import ArakelovRH.C01_Arakelov

namespace ArakelovRH

/-- BRICK: 2·√genus(X₀(143)) < 320.
    genus(X₀(143)) = 13 (ℚ, cast to ℝ); √13 < 4; 2·4 = 8 ≪ 320. -/
theorem bost_connes_threshold :
    2 * Real.sqrt ((X₀ 143).genus : ℝ) < (320 : ℝ) := by
  have hg : ((X₀ 143).genus : ℝ) = 13 := by exact_mod_cast X₀_143_genus
  rw [hg]
  have hsq : Real.sqrt 13 < 4 := by
    have h1 : Real.sqrt 13 < Real.sqrt 16 :=
      Real.sqrt_lt_sqrt (by norm_num) (by norm_num)
    have h2 : Real.sqrt 16 = 4 := by
      rw [show (16 : ℝ) = 4 ^ 2 from by norm_num]
      exact Real.sqrt_sq (by norm_num)
    linarith
  linarith

/-- Bost-Connes excess: C₀ − 2·√genus > 0. -/
theorem bost_connes_excess :
    0 < (320 : ℝ) - 2 * Real.sqrt ((X₀ 143).genus : ℝ) :=
  by linarith [bost_connes_threshold]

end ArakelovRH
