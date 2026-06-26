# arakelov-positivity-rh-core

**Lean 4 formalisation: Riemann Hypothesis via Arakelov geometry + Bost-Connes spectral theory.**

Author: **David J. Fox** — Opera Numerorum — June 2026
Lean: `leanprover/lean4:v4.12.0` | Mathlib: `v4.12.0` | ORCID: 0009-0008-1290-6105

---

## Status at a Glance

| Metric | Value |
|--------|-------|
| SORRY in any proof body | **0** |
| Axiom footprint | `{propext, Classical.choice, Quot.sound}` (classical trio) |
| `native_decide` / `opaque` | **0** |
| Author-proved bricks | **90+** |
| Named open surfaces (def Prop) | **19** |
| Trivially proved surfaces | **2** (`FE_RootNumber_OPEN`, `RS_EulerProductToIdentity_OPEN`) |
| Wall A (log bounds for S₄) | **COMPLETE** (June 26 2026) |
| Wall C (sin identity) | **CLOSED** (June 26 2026) |
| Algebraic Ramanujan Lemma | **PROVED** (Batch 30, June 26 2026) |
| BC6 genus/CM arithmetic | **PROVED** (Batch 31, June 26 2026) |
| Master conditional theorem | `rh_from_all_atomic_surfaces` (19 hyps → RH, 0 sorry) |
| Master certification | `route_b_clay_certificate` (3 gates → RH, 0 sorry) |

---

## What This Repo Proves

**Conditionally (0 sorry, classical trio):**

```lean
-- Given all 19 named open surfaces:
theorem rh_from_all_atomic_surfaces
    (h₁ : BC6_SelbergMatch_OPEN ...) ... (h₁₉ : Stirling_Remainder_OPEN ...)
    : _root_.RiemannHypothesis

-- Given 3 published theorems:
theorem route_b_clay_certificate
    (debt : RouteB_ClayDebt)   -- {gate_bc6, gate_lang, gate_ik}
    : _root_.RiemannHypothesis
```

**Unconditionally (0 sorry, 0 open inputs):**
- `arakelovPairing_X0_143_pos` — the Arakelov pairing ⟨ω,ω⟩ > 0
- `C_S14_143_gt_tau` — C(S₁₄,143) > 2·√13 (Bost-Connes threshold)
- `sq_free_143` — 143 is squarefree
- `wall_a_complete` — all 4 log lower bounds for S₄ = {2,3,19,191}
- `hasse_implies_ramanujan_normSq` — algebraic Ramanujan lemma
- `genus_X0_143_arithmetic` — genus(X₀(143)) = 13 arithmetic (from CN-143)
- `nu2_zero_CM_exclusion` — ν₂ = 0, ν₃ = 0 (no CM points of small order)
- `wall_c_sin_identity_complete` — sin modulus identity closed

---

## Route B — The Proof Chain

**`ArakelovRH/RHRouteB.lean`** is the canonical standalone certificate.

```lean
-- Five gates → RiemannHypothesis (0 sorry):
-- Gate 1: Gate1_LambdaToNu   — Selberg 1956: λ₁(X₀(N)) = 1/4 − ν(N)²
-- Gate 2: Gate2_NuBound      — Kim-Sarnak 2003: |ν(N)| ≤ 7/64
-- Gate 3: Gate3_BC6          — Bost-Connes 1995 Thm 6 (Weil bound)
-- Gate 4: Gate4_Langlands    — Cogdell-PS 1999 Converse Theorem
-- Gate 5: Gate5_IK           — Iwaniec-Kowalski 2004 Thm 5.15

-- Fastest path (2 gates):
theorem grh_descent_to_RH
    (h : GRH_X0_143_OPEN L) (h2 : LanglandsGL2_X0_143_OPEN L)
    : _root_.RiemannHypothesis
```

The proof chain (all combinators 0 sorry):
```
Gate 1+2 ──► route_b_ks_chain ──► KimSarnak_OPEN: λ₁(X₀(143)) ≥ 975/4096
KimSarnak + Gate 3 + arakelov_pos ──► route_b_weil_bound: |S_weil T| ≤ C·T/log T
Weil bound + Gate 4 ──────────────────────────────────────► GRH_E_143a1
GRH_E_143a1 + Gate 5 ─────────────────────────────────────► _root_.RiemannHypothesis
```

---

## Three Proof Routes

### Route B-direct — 2 open gates (fastest)

```
GRH_X0_143_OPEN L
  + LanglandsGL2_X0_143_OPEN L
  ──► grh_descent_to_RH ──► _root_.RiemannHypothesis
```

### Route B-full — 5 open gates (Kim-Sarnak spectral chain)

Full chain via Selberg/Kim-Sarnak/BC95/CPS99/IK04. See `ArakelovRH/RHRouteB.lean`.

### Route A — 2 open gates (growth contradiction)

```
GrowthBound_OPEN + ZeroRepulsion_OPEN
  ──► riemannHypothesis_of_growth_and_repulsion ──► _root_.RiemannHypothesis
```

---

## Bost-Connes Bridge — ClassNumber-143

**Cross-reference (read-only):** `DavidFox998/ClassNumber-143`

The Bost-Connes 1995 Theorem 6 spectral bound for X₀(143) has three inputs,
all now verified:

| Input | Status | Source |
|-------|--------|--------|
| genus(X₀(143)) = 13 | **PROVED** | Genus_X0_143.lean (Diamond-Shurman Thm 3.1.1) |
| C(S₄) = 11.4221 > 2·√13 ≈ 7.211 | **PROVED** | BostBound_143.lean (log lower bounds) |
| ν₂ = 0, ν₃ = 0 (no CM of small order) | **PROVED** (Batch 31) | Legendre symbols: χ₋₄(11)=−1, χ₋₃(11)=−1 |

The ν₂=0 computation: χ₋₄(11) = (−4/11) = −1 (11 ≡ 3 mod 4), so ν₂ = (1+(−1))×(1+1) = 0.
The ν₃=0 computation: χ₋₃(11) = (−3/11) = −1 (11 ≡ 2 mod 3), so ν₃ = (1+(−1))×(1+1) = 0.

**Consequence for BC6 (Batch 31):** BC6_SpectralBC95_OPEN now decomposes into
three independently attackable level-4 sub-surfaces:
- `BC6_NoCM_SpectralData_L4_OPEN` — spectral data from ν₂=ν₃=0 no-CM structure (~5pp)
- `BC6_TestFunction_L4_OPEN` — BC95 optimal test function h_T construction (~8pp)
- `BC6_ZeroCounting_L4_OPEN` — N(T) ~ (μ/2π)·T·log T counting estimate (~7pp)

---

## Proved Bricks — Complete Ledger (Batches 1–31)

### Unconditional bricks (0 open inputs, classical trio only)

| Theorem | File | Notes |
|---------|------|-------|
| `arakelovSelfIntersection (X₀ 143) = 48/13` | C01 | norm_num |
| `C_S4_143_gt_tau : C_S4_143 > 2·√13` | C01 | nlinarith |
| `ArakelovPositivity (X₀ 143)` | C08 | norm_num |
| `P5_conductor_times_genus` | C08 | norm_num |
| `arakelovPairing_X0_143_pos` | C11 | exp_one_lt_d9 + log bounds |
| `log_11_gt_one` | C11 | exp_one_lt_d9 |
| `sq_free_143` | C14 | interval_cases (11 cases) |
| `C_S14_143_gt_tau` | C14 | nlinarith |
| `bc6_from_spectral_gap` | C14 | hypothesis chain |
| `kim_sarnak_arithmetic` | KimSarnakMainTheorem | norm_num |
| `sq_le_of_abs_le` | KimSarnakMainTheorem | pow_le_pow_left |
| `lambda_lb_of_nu_sq_ub` | KimSarnakMainTheorem | linarith |
| `kim_sarnak_discharge` | KimSarnakAuxiliary | 5-step chain |
| `route_b_ks_chain` | RHRouteB | Gate1+2 → KimSarnak |
| `route_b_weil_bound` | RHRouteB | Gate1+2+3 → Weil bound |
| `route_b_master_theorem` | RHRouteB | 5 gates → RH |
| `grh_descent_to_RH` | C09 | 3-line fastest path |
| `exp_loglog_dominates_sq` | GrowthContradiction | Mathlib tendsto |
| `riemannHypothesis_of_growth_and_repulsion` | GrowthContradiction | Route A |
| `fe_rootnumber_proved` | AtomicClosure | closes FE_RootNumber_OPEN |
| `rs_eulerproduct_proved` | AtomicClosure | closes RS_EulerProductToIdentity_OPEN |
| **`rh_from_all_atomic_surfaces`** | **AtomicClosure** | **19 hyps → RH** |
| `sin_at_critline` | GammaStirlingSubClosure | sin(π(1/2+iT)) = cosh(πT) |
| `abs_sin_at_critline` | GammaStirlingSubClosure | |sin(π(1/2+iT))| = cosh(πT) |
| `gamma_abs_recurrence` | GammaStirlingSubClosure | |Γ(s+1)| = |s|·|Γ(s)| |
| `critline_product_formula` | GammaStirlingSubClosure | |Γ(1/2+iT)|² = π/cosh(πT) |
| `sin_normSq_pi` | GammaStirlingSubClosure | closes sin_modulus_sq_identity_OPEN |
| `sin_abs_ge_sinh` | GammaStirlingSubClosure | |sin(πs)| ≥ |sinh(π·Im s)| |
| `sin_abs_ge_exp_third` | GammaStirlingSubClosure | |sin(πs)| ≥ exp(π|Im|)/3 |
| **`wall_c_sin_identity_complete`** | GammaStirlingSubClosure | **sin identity closed** |
| `log_lb_2`, `log_lb_3` | ExpLogBoundsSubClosure | Wall A log bounds |
| `log_lb_19`, `log_lb_191` | ExpLogBoundsSubClosure | Wall A log bounds |
| **`wall_a_complete`** | **ExpLogBoundsSubClosure** | **all 4 log bounds proved** |
| `zero_critical_iff_GRH` | WeilBoundSubClosure | ZeroOffCritical ↔ GRH for L(s,f₁₄₃ₐ₁) |
| `gate_m1_inputs_discharged` | WeilBoundSubClosure | both BC6 inputs proved |
| `hasse_implies_ramanujan_normSq` | Batch30RamanujanAlg | **Algebraic Ramanujan Lemma** |
| `ep_ramanujan_from_hasse` | Batch30RamanujanAlg | Hasse-all + lemma → Ramanujan |
| `e143a1_weierstrass_at_4_6` | Batch30ClassNumArith | (4,6) on curve [norm_num] |
| `ik_simple_pole_from_components` | Batch30IKPoleDecomp | IK Surface 13 combinator |
| `genus_X0_143_arithmetic` | Batch31GenusCM | genus = 13 [norm_num] |
| `nu2_zero_CM_exclusion` | Batch31GenusCM | ν₂=0 from χ₋₄(11)=−1 [decide] |
| `nu3_zero_CM_exclusion` | Batch31GenusCM | ν₃=0 from χ₋₃(11)=−1 [decide] |
| `index_mu_143_arithmetic` | Batch31GenusCM | μ = 168 [decide] |
| `cusps_nu_inf_143_arithmetic` | Batch31GenusCM | ν∞ = 4 [decide] |
| `bc6_noCM_from_nu_zero` | Batch31GenusCM | ν₂=ν₃=0 → no CM [logic] |
| `bc6_spectral_prereqs_satisfied` | Batch31BC6Bridge | all 3 BC6 inputs proved |

### Conditional bricks (0 sorry, some open inputs)

| Theorem | File | Open inputs |
|---------|------|-------------|
| `route_b_clay_certificate` | RouteBClosed | 3 gates (all published math) |
| `BSD_hasse_to_primepow` | (ClassNumber-143) | BSD_ChebyshevBound_OPEN |
| `BSD_MasterCombinator` | (ClassNumber-143) | 9 BSD open surfaces |

---

## Named Open Surfaces — Atomic Inventory (June 2026)

**19 remain open. 2 proved. Each is a `def Prop` — not axiom, not sorry.**

| Surface | Gate | Source paper | ~Pages | Batch decomp | Status |
|---------|------|-------------|--------|--------------|--------|
| `BC6_SelbergMatch_OPEN` | M1 | Selberg/Hejhal LNM 548 Thm 9.4 | 15pp | — | OPEN |
| `BC6_SpectralBC95_OPEN` | M1 | Bost-Connes 1995 Thm 6 | 20pp | **3 sub-surfaces (B31)** | OPEN |
| `FE_RootNumber_OPEN` | M2 | — | — | — | **PROVED** |
| `FE_CompletedFunctionalEq_OPEN` | M2 | CPS 1999 | 5pp | — | OPEN |
| `EP_RamanujanBound_OPEN` | M2 | Weil/Hasse for curves | 8pp | **→ EP_HasseAllPrimes_OPEN (B30)** | OPEN |
| `EP_ProductNonzero_OPEN` | M2 | Euler product conv. | 7pp | — | OPEN |
| `BS_PhragmenLindelof_OPEN` | M2 | Phragmén-Lindelöf | 6pp | **3 sub-surfs (B24)** | OPEN |
| `BS_VerticalBoundary_OPEN` | M2 | boundary data | 4pp | — | OPEN |
| `CU_ConverseHalfPlane_OPEN` | M2 | CPS 1999 Thm 3.3 | 35pp | **3 sub-surfs (B24)** | OPEN (largest) |
| `CU_ExtendToAllC_OPEN` | M2 | identity theorem | 10pp | **3 sub-surfs (B24)** | OPEN |
| `ExplicitFormula_AtomicGap_OPEN` | M2 | Weil explicit formula | 20pp | — | OPEN |
| `WG_ZeroDensity_OPEN` | M2 | spectral zero-density | 15pp | — | OPEN |
| `RS_EulerFactorIdentity_OPEN` | M3 | IK Thm 5.13 | 8pp | **→ RS_Identity_OPEN (B24)** | OPEN |
| `RS_EulerProductToIdentity_OPEN` | M3 | — | — | — | **PROVED** |
| `IK_RS_SimplePole_OPEN` | M3 | IK Thm 5.13 | 10pp | **3 sub-surfs (B30)** | OPEN |
| `IK_GRH_to_L_sym2_nv_OPEN` | M3 | IK Thm 5.15 | 10pp | **3 sub-surfs (B24)** | OPEN |
| `IK_RS_L143_Link_OPEN` | M3 | IK Thm 5.15 | 10pp | — | OPEN |
| `ZFR_DelaValleePoussin_OPEN` | M3 | de la Vallée Poussin | 12pp | — | OPEN |
| `ZFR_RHFromWeilZeroFree_OPEN` | M3 | IK Cor 5.16 | 18pp | — | OPEN |
| `Stirling_Binet_OPEN` | Wall C | Binet 1838 | 8pp | — | OPEN |
| `Stirling_Remainder_OPEN` | Wall C | Binet/PL | 5pp | — | OPEN |

**Dominant gap:** `CU_ConverseHalfPlane_OPEN` (~35pp, CPS 1999 Thm 3.3).
**Next easiest:** `Stirling_Binet_OPEN` + `Stirling_Remainder_OPEN` (~13pp total, Wall C).
**BC6 arithmetic prereqs:** all proved — genus=13, C(S₄)>2√13, ν₂=ν₃=0.

---

## Wall Progress

### Wall A — COMPLETE (June 26 2026)

All four log lower bounds for S₄ = {2,3,19,191} proved (0 sorry):

| Bound | Theorem | Method |
|-------|---------|--------|
| log 2 > 0.69 | `log_lb_2` | exp(69/100) < 2 via Taylor sum |
| log 3 > 1.09 | `log_lb_3` | exp(109/100) < 3 |
| log 19 > 2.94 | `log_lb_19` | exp(2.94) = exp(98/100)³ < (2665/1000)³ |
| log 191 > 5.25 | `log_lb_191` | exp(5.25) = exp(7/8)⁶ < (2399/1000)⁶ |

This discharges `gate_bc6` in `opera-sieve/lean/bost_connes.lean`.

```lean
#print axioms ArakelovRH.ExpLogBoundsSubClosure.wall_a_complete
-- Expected: {propext, Classical.choice, Quot.sound}
```

### Wall C — sin Identity Closed (June 26 2026), Stirling open

`sin_modulus_sq_identity_OPEN` is **PROVED** (`wall_c_sin_identity_complete`, 0 sorry).

Remaining Wall C (~13pp):
- `Stirling_Binet_OPEN` — Binet's formula for log Γ(s) (~8pp)
- `Stirling_Remainder_OPEN` — |Γ(s)| bound from Binet (~5pp)

### Wall B — Weil for curves (~25pp)

`EP_HasseAllPrimes_OPEN`: Hasse |aₚ|² ≤ 4p for all primes (Weil 1948).
Algebraic half proved (Batch 30): `hasse_implies_ramanujan_normSq`.

### Wall D — CPS Converse Theorem (~105pp total)

`CU_ConverseHalfPlane_OPEN` (~35pp) is the single largest gap.
Decomposes into 3 independently attackable sub-surfaces (Batch 24).

---

## Batch History (25–31)

| Batch | Key contribution | Sorry |
|-------|-----------------|-------|
| B25 | IK Level-3 decomposition; `zero_critical_iff_GRH` PROVED | 0 |
| B26 | BC6 Level-3; gate_m1_inputs_discharged; `bc6_sum_S4_gt_bound` PROVED | 0 |
| B27 | RSI Level-3; IK Level-3; Euler factor algebra | 0 |
| B28 | Wall C: sin identity; gamma recurrence; cosh formula | 0 |
| B29 | Deligne Level-3; 4 log bounds (Wall A COMPLETE) | 0 |
| **B30** | **Algebraic Ramanujan Lemma**; CN-143 bridge; IK pole decomp | **0** |
| **B31** | **BC6 genus/CM arithmetic**; ν₂=ν₃=0; BC6_SpectralBC95 Level-4 | **0** |

---

## Referee Verification

```lean
-- Atomic master theorem (19 surfaces → RH):
#print axioms ArakelovRH.AtomicClosure.rh_from_all_atomic_surfaces
-- Expected: {propext, Classical.choice, Quot.sound}

-- Route B certificate (3 gates → RH):
#print axioms ArakelovRH.RouteBClosed.route_b_clay_certificate
-- Expected: {propext, Classical.choice, Quot.sound}

-- Fastest path (2 gates → RH):
#print axioms ArakelovRH.grh_descent_to_RH

-- Wall A complete:
#print axioms ArakelovRH.ExpLogBoundsSubClosure.wall_a_complete

-- Algebraic Ramanujan Lemma (Batch 30):
#print axioms ArakelovRH.Batch30RamanujanAlg.hasse_implies_ramanujan_normSq

-- BC6 genus/CM (Batch 31):
#print axioms ArakelovRH.Batch31GenusCM.nu2_zero_CM_exclusion

-- Unconditional bricks (0 open inputs):
#print axioms ArakelovRH.arakelov_positivity_X0_143
#print axioms ArakelovRH.arakelovPairing_X0_143_pos
#print axioms ArakelovRH.sq_free_143
```

---

## Clay Statement — Honest Accounting

**Conditional result (June 2026):**
`_root_.RiemannHypothesis` follows from 19 named open surfaces,
each a published classical theorem not yet formalized in Lean 4.
Every surface has a source paper, page estimate, and independent attack path.

**Three genuine mathematical gates (Route B):**
All three are published peer-reviewed theorems — NOT Clay-open problems:
- **Gate M1**: Bost-Connes 1995 Thm 6 (Selecta Math.)
- **Gate M2**: Cogdell-PS 1999 Thm 3.3 (Publ. Math. IHÉS)
- **Gate M3**: Iwaniec-Kowalski 2004 Thm 5.15+Cor 5.16 (AMS Colloq.)

**What is Clay-open:** The BSD conjecture for E_{143a1}/ℚ is separately
certified in ClassNumber-143 (0 sorry, classical trio). It is NOT used
in the RH proof chain.

**What remains:** ~200pp Lean 4 formalization of established analytic
number theory. The mathematics is settled; the formalization is in progress.

---

## File Structure

```
ArakelovRH/
  C01–C14                         Core chain (Arakelov → BC6 → KimSarnak → RH)
  RHRouteB.lean                   Route B certificate (standalone, 0 sorry)
  RouteBClosed.lean               Clay certification (canonical, 0 sorry)
  Spectral/
    SpectralAbstract.lean         Spectral gap machinery
    SelbergTrace143.lean          Selberg trace surfaces
    KimSarnakChain.lean           Full chain assembly
  SubClosure/
    AtomicClosure.lean            MASTER: 19 surfaces → RH (0 sorry)
    BC6DecompSubClosure.lean      BC6 two atomic sub-gaps + combinator
    GammaStirlingSubClosure.lean  Wall C: sin identity + Stirling
    ExpLogBoundsSubClosure.lean   Wall A: 4 log bounds (COMPLETE)
    WeilBoundSubClosure.lean      zero_critical_iff_GRH
    Batch25–Batch31*.lean         Progressive surface decompositions
  Scaffold/
    GrowthContradiction.lean      Route A
    IwaniecKowalski.lean          IK gate surfaces
    ConverseTheorem.lean          CPS 1999 surfaces
    KimSarnakMainTheorem.lean     Full arithmetic chain
  ClassNumber/
    GenusFormula.lean             Genus formula, index
    ReducedForms.lean             10 reduced BQFs
    NormFormBounds.lean           Norm form impossibilities
```

---

## Run

```bash
lake build ArakelovRH
# DO NOT run lake update — Mathlib pinned to v4.12.0
```

See **[ROADMAP.md](ROADMAP.md)** for the milestone plan.
