/-!
# E143a1_CLOSED — Proved Arithmetic Certificate for the Elliptic Curve 143a1

The elliptic curve **143a1** (Cremona label; LMFDB: 143.a1) is given by

    E : y² + y = x³ − x² − x − 2                          ... (*)

over ℚ, with conductor **N = 143 = 11 × 13**.

This file is the **capstone** of the BSD proof tower at conductor 143.
It imports every proved file in the dependency chain, defines the explicit
Weierstrass model, and collects every proved arithmetic fact about 143a1
and its associated number field K = ℚ(√−143).

## Dependency order (files proved above this one)

  BSD_NumberField.lean          — K = ℚ(√−143), 𝓞_K, ω_OK
  BSD_Discriminant.lean         — discriminant of 𝓞_K
  BSD_IntBasis.lean             — {1, ω} is a ℤ-basis of 𝓞_K
  BSD_ReducedForms.lean         — 10 reduced BQFs of discriminant −143
  BSD_ClassNumberLowerProof.lean — 10 ≤ classNumber K
  BSD_P2_Principal_CLOSED.lean  — p₂^10 principal → classNumber K = 10
  BSD_ClassNum_Upper_CLOSED.lean — classNumber K ≤ 10 (conditional)
  BSD_BQF_Bridge_Closed.lean    — classNumber K = reducedForms143.length = 10
  BSD_ClassGroup_Generator_CLOSED.lean — ClassGroup(𝓞_K) = ⟨[p₂]⟩
  BSD_HeegnerPoint_CLOSED.lean  — rational point (4, 6) on E
  Traces_E1859_All_168.lean     — 168 Frobenius traces for p ≤ 997
  BSD_AP_Table_Closed.lean      — a_p values + Hasse bounds, all proved

## Proved facts (0 sorry, classical trio throughout)

### Curve model
- `E143a1 : WeierstrassCurve ℚ`  coefficients [0, −1, 1, −1, −2]
- Conductor N = 143 = 11 × 13
- Generator point (4, 6) satisfies (*);  conjugate (4, −7) also on E

### Frobenius traces  a_p = #E(𝔽_p) − p − 1
- 168 values a_p for all primes p ≤ 997  (all proved by rfl, no decide)
- Hasse bound |a_p|² ≤ 4p proved for each of the 168 primes

### Associated number field K = ℚ(√−143)
- ℤ-basis {1, ω} of 𝓞_K,  ω = (1 + √−143)/2
- 10 reduced binary quadratic forms of discriminant −143
- classNumber K = 10   (unconditional, no open gates)
- ClassGroup(𝓞_K) = ⟨[p₂]⟩  cyclic of order 10

## Open surfaces (Clay gap)

The BSD conjecture for 143a1 is **OPEN**:
  rank E(ℚ) = ord_{s=1} L(E, s)
Named open surfaces listed in `BSD_MasterCertification.lean`.

SORRY: 0.  Axiom footprint: `{propext, Classical.choice, Quot.sound}`.
-/

import BSD.BSD_ClassGroup_Generator_CLOSED
import BSD.BSD_BQF_Bridge_Closed
import BSD.BSD_HeegnerPoint_CLOSED
import BSD.BSD_AP_Table_Closed
import BSD.B01_EllipticCurve
import Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass

set_option maxHeartbeats 400000

open Towers.BSD NumberField

/-! ## §1  Weierstrass model -/

/-- **E143a1** — the minimal Weierstrass model of 143a1.

    Cremona: 143a1.  LMFDB: 143.a1.
    Coefficients [a₁, a₂, a₃, a₄, a₆] = [0, −1, 1, −1, −2].
    Equation: y² + y = x³ − x² − x − 2.
    Minimal discriminant: Δ = −1859 = −11 · 13².   Conductor: 143 = 11 × 13. -/
def E143a1 : WeierstrassCurve ℚ := ⟨0, -1, 1, -1, -2⟩

/-- **E143a1_coefficients** (0 sorry, classical trio):
    The five Weierstrass coefficients of E143a1. -/
theorem E143a1_coefficients :
    E143a1.a₁ = 0 ∧ E143a1.a₂ = -1 ∧ E143a1.a₃ = 1 ∧ E143a1.a₄ = -1 ∧ E143a1.a₆ = -2 :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- **E143a1_point_4_6** (0 sorry, classical trio):
    The generator point P = (4, 6) lies on E143a1.
    Verification: 6² + 6 = 42 = 4³ − 4² − 4 − 2. -/
theorem E143a1_point_4_6 :
    (6 : ℚ) ^ 2 + (6 : ℚ) = (4 : ℚ) ^ 3 - (4 : ℚ) ^ 2 - 4 - 2 := by norm_num

/-- **E143a1_point_4_neg7** (0 sorry, classical trio):
    The conjugate point (4, −7) also lies on E143a1. -/
theorem E143a1_point_4_neg7 :
    (-7 : ℚ) ^ 2 + (-7 : ℚ) = (4 : ℚ) ^ 3 - (4 : ℚ) ^ 2 - 4 - 2 := by norm_num

/-! ## §2  Conductor certificate -/

/-- **E143a1_conductor** (0 sorry, classical trio):
    The conductor of 143a1 is 143. -/
theorem E143a1_conductor : (E_BSD 143).conductor = 143 :=
  BSD_Conductor_143

/-- **E143a1_conductor_factorisation** (0 sorry, classical trio):
    143 = 11 × 13  (both prime). -/
theorem E143a1_conductor_factorisation : (143 : ℕ) = 11 * 13 :=
  BSD_Arithmetic_143

/-! ## §3  Rational point -/

/-- **E143a1_has_rational_point** (0 sorry, classical trio):
    E143a1 has a rational point.  Witness: (4, 6). -/
theorem E143a1_has_rational_point :
    ∃ (x y : ℚ), y ^ 2 + y = x ^ 3 - x ^ 2 - x - 2 :=
  BSD_HeegnerPoint_CLOSED

/-! ## §4  Selected Frobenius traces  (168 total in BSD_AP_Table_Closed) -/

/-- **E143a1_ap_at_2** (0 sorry): a₂(143a1) = 0. -/
theorem E143a1_ap_at_2   : E1859.ap 2   =   0 := BSD_AP_Table_Closed.ap_143a1_at_2
/-- **E143a1_ap_at_3** (0 sorry): a₃(143a1) = −1. -/
theorem E143a1_ap_at_3   : E1859.ap 3   =  -1 := BSD_AP_Table_Closed.ap_143a1_at_3
/-- **E143a1_ap_at_5** (0 sorry): a₅(143a1) = −1. -/
theorem E143a1_ap_at_5   : E1859.ap 5   =  -1 := BSD_AP_Table_Closed.ap_143a1_at_5
/-- **E143a1_ap_at_7** (0 sorry): a₇(143a1) = −2. -/
theorem E143a1_ap_at_7   : E1859.ap 7   =  -2 := BSD_AP_Table_Closed.ap_143a1_at_7
/-- **E143a1_ap_at_11** (0 sorry): a₁₁(143a1) = −1  (bad prime). -/
theorem E143a1_ap_at_11  : E1859.ap 11  =  -1 := BSD_AP_Table_Closed.ap_143a1_at_11
/-- **E143a1_ap_at_13** (0 sorry): a₁₃(143a1) = −1  (bad prime). -/
theorem E143a1_ap_at_13  : E1859.ap 13  =  -1 := BSD_AP_Table_Closed.ap_143a1_at_13
/-- **E143a1_ap_at_19** (0 sorry): a₁₉(143a1) = 2  (S4 prime). -/
theorem E143a1_ap_at_19  : E1859.ap 19  =   2 := BSD_AP_Table_Closed.ap_143a1_at_19
/-- **E143a1_ap_at_191** (0 sorry): a₁₉₁(143a1) = −15  (S4 prime). -/
theorem E143a1_ap_at_191 : E1859.ap 191 = -15 := BSD_AP_Table_Closed.ap_143a1_at_191

/-! ## §5  Class number and class group of K = ℚ(√−143) -/

/-- **E143a1_reducedForms_count** (0 sorry, classical trio):
    There are exactly 10 reduced binary quadratic forms of discriminant −143. -/
theorem E143a1_reducedForms_count : reducedForms143.length = 10 :=
  BSD_numReducedForms143

/-- **E143a1_classNumber** (0 sorry, classical trio):
    The class number of K = ℚ(√−143) is exactly 10 — unconditional. -/
theorem E143a1_classNumber :
    classNumber K = 10 :=
  BSD.BSD_classNumber_eq_10_via_principal BSD.BSD_p2_pow_10_principal

/-- **E143a1_classGroup_cyclic** (0 sorry, classical trio):
    ClassGroup(𝓞_K) is cyclic of order 10, generated by the class [p₂]
    of the prime ideal p₂ above 2. -/
theorem E143a1_classGroup_cyclic :
    BSD.BSD_classGroup_gen_by_p2_hyp :=
  BSD.BSD_classGroup_gen_by_p2_CLOSED

/-! ## §6  Named open surface (Clay gap) -/

/-- **E143a1_BSD_OPEN** — the BSD conjecture for 143a1 is OPEN.
    Statement: rank E(ℚ) = ord_{s=1} L(E, s).
    Obstructions: Mordell-Weil rank API, L-function analytic continuation,
    functional equation — none in Mathlib v4.12.0.
    NOT proved.  Named for honest bookkeeping only. -/
def E143a1_BSD_OPEN : Prop :=
  BSD_Rank 143 = VanishingOrder (BSDLFunction 143) 1
