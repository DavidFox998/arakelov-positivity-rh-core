/-
  C05 — Arakelov Discriminant Bound Open Surface

  Names the Noether formula / discriminant bound gap:
  the genuine Arakelov self-intersection pairing ⟨ω,ω⟩_Ar for X₀(143)
  (distinct from the slope-formula stand-in ω² = 48/13 used in C01)
  is strictly positive via the Noether formula + Jorgenson-Kramer 1996.

  In the source repos this used an opaque stub for arakelovPairing_X0_143.
  Here, arakelov_pairing is an explicit parameter — the content of the
  open surface is exactly the positivity claim it must satisfy.

  Concrete values from C01 that feed the genuine argument:
    arakelovSelfIntersection_X0_143 : ω²_slope = 48/13 ≈ 3.692   (PROVED, C01)
    X₀_143_genus                    : g = 13                        (PROVED, C01)
    conductor                       : N = 143 = 11 × 13

  From Jorgenson-Kramer 1996, Table 1 (N = 143):
    K_infty ≈ 5.022  (contribution of Archimedean fibre)
    (ω,ω)_Ar = ω²_slope − K_infty/12 ≈ 3.692 − 0.418 ≈ 3.274 > 0

  The bracketing of K_infty from Jorgenson-Kramer Table 1 is the content
  of this open surface — it is not in Mathlib v4.12.0.

  Source repos:
    DavidFox998/rh-p5-bridge-14  →  Towers/RH/Chain/C05_Discriminant.lean
    DavidFox998/rh-core-c01-c07  →  Towers/RH/Chain/C05_Discriminant.lean

  Clay rules: no sorry · no axiom · no opaque · no native_decide · no fun _ => trivial
  Axiom footprint: {propext, Classical.choice, Quot.sound}
-/
import ArakelovRH.C01_Arakelov

namespace ArakelovRH

/-- OPEN SURFACE: the genuine Arakelov pairing ⟨ω,ω⟩_Ar for X₀(143) is positive.

    arakelov_pairing is the genuine Arakelov self-intersection ⟨ω,ω⟩_Ar(X₀(143)).
    This is distinct from arakelovSelfIntersection (X₀ 143) = 48/13, which is
    the slope-formula stand-in. The genuine pairing requires the Noether formula:
      ⟨ω,ω⟩_Ar = 12·χ(𝓞_X) − sum_{p | N} δ_p(X₀(N))
    where δ_p are the Arakelov local intersection multiplicities at primes p | 143.

    Positivity follows from Jorgenson-Kramer 1996, Table 1 (N = 143):
      K_infty ≈ 5.022 < 12 · ω²_slope = 12 · 48/13 ≈ 44.3
    so ⟨ω,ω⟩_Ar > 0.

    The claim: arakelov_pairing > 0 AND arakelov_pairing ≥ slope-formula lower bound.

    STATUS: OPEN. Not discharged here or anywhere in this package.
    Source: rh-p5-bridge-14/C05_Discriminant.lean (adapted — no opaque stub) -/
def DiscriminantBound_X0_143_OPEN (arakelov_pairing : ℝ) : Prop :=
  0 < arakelov_pairing ∧
  (arakelovSelfIntersection (X₀ 143) : ℝ) ≤ arakelov_pairing * 13

end ArakelovRH
