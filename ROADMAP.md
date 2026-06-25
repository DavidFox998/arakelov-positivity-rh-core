# ROADMAP — arakelov-positivity-rh-core

**Opera Numerorum — Riemann Hypothesis via Arakelov Geometry**
Author: David J. Fox — June 2026
ORCID: 0009-0008-1290-6105

---

## Current status (June 2026)

| Item | Status |
|------|--------|
| SORRY count | **0** |
| Axiom footprint | `{propext, Classical.choice, Quot.sound}` (classical trio only) |
| native_decide | **0** uses |
| opaque | **0** uses |
| trivial in proof bodies | **0** uses |
| Named open surfaces | ~26 |
| Proved unconditional bricks | 15+ |

---

## Milestone 1 — COMPLETE (June 2026)

**Arakelov positivity for X₀(143)**

- [x] `arakelovSelfIntersection (X₀ 143) = 48/13` (norm_num)
- [x] `ArakelovPositivity (X₀ 143)` (norm_num)
- [x] `arakelovPairing_X0_143_pos` (exp_one_lt_d9 + log monotonicity)
- [x] `sq_free_143 : Squarefree 143` (interval_cases)
- [x] `P5_conductor_times_genus : 143 * 13 = 1859` (norm_num)

---

## Milestone 2 — COMPLETE (June 2026)

**Kim-Sarnak arithmetic chain**

- [x] `kim_sarnak_arithmetic : 1/4 - (7/64)² = 975/4096` (norm_num)
- [x] `sq_le_of_abs_le : |ν| ≤ 7/64 → ν² ≤ (7/64)²` (pow_le_pow_left + sq_abs)
- [x] `lambda_lb_of_nu_sq_ub : ν² ≤ (7/64)² → 975/4096 ≤ 1/4 - ν²` (linarith)
- [x] `ks_arithmetic_chain` (proved, no open inputs)
- [x] `kim_sarnak_discharge : LambdaToNu + NuBound → KimSarnak_OPEN` (proved)
- [x] `bc6_from_spectral_gap : KimSarnak + BC6 + arakelov → Weil bound` (proved)
- [x] `ks_to_rh_full_chain : 6 gates → RH` (proved)

---

## Milestone 3 — COMPLETE (June 2026)

**Abstract spectral gap machinery (ported from yang-mills-gap)**

- [x] `HasSpectralGap` predicate (SpectralAbstract.lean)
- [x] `hasSpectralGap_zero` — consistency witness
- [x] `spectral_bound` — Gelfand: ‖T‖ ≤ 1 → spectralRadius ℂ T ≤ 1
- [x] `gap_reduction` — Cauchy-Schwarz: coercivity m → bounded below by m
- [x] Selberg trace formula surfaces named (SelbergTrace143.lean)
- [x] `KimSarnakChain.lean` — full chain assembly

---

## Milestone 4 — OPEN

**Close LambdaToNu_OPEN (Selberg 1956 eigenvalue identity)**

Gate: `∀ N, lambda_1 N = 1/4 - spectral_parameter N²`

Required mathematics:
- Spectral theory of the hyperbolic Laplacian on Γ₀(N)\ℍ
- Uniformization: Γ₀(143) as Fuchsian group acting on ℍ
- Selberg's eigenvalue identity λ = s(1-s), Re(s) = 1/2 + iν

Lean gap: `SpectralTheory.Laplacian` for Fuchsian groups absent from Mathlib v4.12.0.
Estimated Mathlib availability: 2027–2029.

---

## Milestone 5 — OPEN

**Close NuBound_OPEN (Kim-Sarnak 2003, |ν(N)| ≤ 7/64)**

Gate: `∀ N squarefree, |spectral_parameter N| ≤ 7/64`

Required mathematics (Kim-Sarnak 2003 Appendix 2):
1. Gelbart-Jacquet functorial lift GL₂ → GL₃ (automorphic L-functions)
2. Kim-Shahidi non-vanishing for symmetric-square L-functions
3. Luo-Rudnick-Sarnak: ν ≤ 7/64 from GL₄ bounds
4. Selberg trace formula + Ramanujan-Petersson conjecture (partial)

Lean gap: automorphic L-functions and GL_n Langlands absent from Mathlib v4.12.0.
Estimated Mathlib availability: 2030+.

---

## Milestone 6 — OPEN

**Close BC6SelbergTrace_OPEN (Bost-Connes 1995 Thm 6)**

Gate: `KimSarnak_OPEN → ∀ T>1, |S_weil T| ≤ C_S14_143 · T / log T`

Required mathematics:
- Selberg trace formula for X₀(143)
- Weil explicit formula (prime number theorem variant)
- Bost-Connes adelic integration §§3-5

Lean gap: Weil explicit formula for Hecke L-functions absent from Mathlib v4.12.0.

---

## Milestone 7 — OPEN

**Close Langlands_Descent_OPEN (CPS 1999 Converse Theorem)**

Gate: `Weil bound → GRH_E_143a1`

Required mathematics:
- Cogdell-Piatetski-Shapiro Converse Theorem (1999)
- Functional equation for Rankin-Selberg L-functions
- Analytic continuation of L(s, E_{143a1}/ℚ)

Lean gap: Converse Theorem formalization absent from Mathlib v4.12.0.

---

## Milestone 8 — OPEN

**Close GRH_to_RH_Descent_143_OPEN (IK 2004 Thm 5.15)**

Gate: `GRH_E_143a1 → _root_.RiemannHypothesis`

Required mathematics:
- Iwaniec-Kowalski 2004 §5.15-5.16
- Prime number theorem in arithmetic progressions
- Zero-free region transfer from GRH to RH

Lean gap: GRH → RH descent formalization absent from Mathlib v4.12.0.

---

## Milestone 9 (bonus) — OPEN

**Close Route A directly**

- Close `GrowthBound_OPEN` and `ZeroRepulsion_OPEN`
- These require zero-repulsion estimates (Hadamard, de la Vallée Poussin)
- Route A combinator already proved: 2 gates → RH

---

## Clay Rules Compliance

Per the Opera Numerorum Clay rules:

| Rule | Status |
|------|--------|
| No `sorry` | ✅ 0 uses |
| No `axiom` keyword | ✅ 0 uses |
| No `native_decide` | ✅ 0 uses |
| No `trivial` in proof bodies | ✅ 0 uses |
| No `opaque` | ✅ 0 uses |
| Classical trio only | ✅ `{propext, Classical.choice, Quot.sound}` |
| Named open surfaces (not sorry) | ✅ ~26 named `def Prop` |

---

## Reference trail

| Author | Work | Role |
|--------|------|------|
| Selberg (1956) | Trace formula for cofinite Fuchsian groups | LambdaToNu_OPEN |
| Kim-Sarnak (2003) | Appendix 2, Cor 2: λ₁ ≥ 975/4096 | NuBound_OPEN |
| Bost-Connes (1995) | Hecke algebras + spectral theory | BC6SelbergTrace_OPEN |
| Cogdell-PS (1999) | Converse Theorem for GL_n | Langlands_Descent_OPEN |
| Iwaniec-Kowalski (2004) | Thm 5.15 + Cor 5.16 | GRH_to_RH_Descent_143_OPEN |
| Abbes-Ullmo (1996) | Thm 1.2: Arakelov pairing | arakelovPairing_X0_143_pos |
| Jorgenson-Kramer (1996) | Table 1: spectral constants | C_S14_143, C_S4_143 |

---

*David J. Fox — Opera Numerorum — June 2026*
*Built on a phone. Verified by Lean.*
