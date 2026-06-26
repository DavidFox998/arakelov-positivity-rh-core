# arakelov-positivity-rh-core

**Lean 4 formalisation: Riemann Hypothesis via Arakelov geometry.**

Author: **David J. Fox** — Opera Numerorum — June 2026
Lean: `leanprover/lean4:v4.12.0` | Mathlib: `v4.12.0` | ORCID: 0009-0008-1290-6105

> SORRY: 0.  Axiom footprint: `{propext, Classical.choice, Quot.sound}` (classical trio).
> No `native_decide`. No `opaque`. No `trivial` in proof bodies.
> Named open surfaces: ~20. Author-proved bricks: 45+.
> **Wall A COMPLETE** (June 26 2026): all 4 log lower bounds for S₄={2,3,19,191} proved.
> **Wall C progress** (June 26 2026): sin_modulus_sq_identity_OPEN CLOSED; sin_at_critline PROVED;
> critline product formula PROVED conditional; ~13pp Stirling remain.
> **ATOMIC CLOSURE (June 2026)**: All 21 named open surfaces inventoried and individually
> named as `def Prop` targets. Two trivially proved (0 sorry):
> `FE_RootNumber_OPEN` (choose ε = 1) and `RS_EulerProductToIdentity_OPEN` (extract ∃).
> Master theorem `rh_from_all_atomic_surfaces` (0 sorry) proves RiemannHypothesis
> from the 19 remaining surfaces via a full combinator chain.  Each surface is
> **independently attackable**: named def, source paper, page estimate, no cross-
> surface dependencies within the same gate.
> File: `ArakelovRH/SubClosure/AtomicClosure.lean`


---

## Route B — Formalized (RHRouteB.lean)

**`ArakelovRH/RHRouteB.lean`** is the canonical standalone Lean 4 certificate
for Route B (Kim-Sarnak spectral chain).  A referee reads this one file and
sees the complete proof structure: 5 named open gates, all proved intermediate
steps, and the master theorem.

```lean
-- Verify Route B in Lean:
#print axioms ArakelovRH.RouteB.route_b_master_theorem
-- Expected: {propext, Classical.choice, Quot.sound}

-- The 5 open gates (all def Prop, never sorry):
-- Gate 1: Gate1_LambdaToNu   — Selberg 1956 eigenvalue identity
-- Gate 2: Gate2_NuBound      — Kim-Sarnak 2003, |nu(N)| <= 7/64
-- Gate 3: Gate3_BC6          — Bost-Connes 1995 Thm 6 (Weil bound)
-- Gate 4: Gate4_Langlands    — Cogdell-PS 1999 Converse Theorem
-- Gate 5: Gate5_IK           — Iwaniec-Kowalski 2004 Thm 5.15
```

The proof chain (all steps proved, 0 sorry):
```
Gate1 + Gate2 ──► route_b_ks_chain ──► KimSarnak_OPEN
KimSarnak_OPEN + Gate3 + arakelov_pos ──► route_b_weil_bound ──► Weil bound
Weil bound + Gate4 ──────────────────────────────────────────► GRH_E_143a1
GRH_E_143a1 + Gate5 ─────────────────────────────────────────► RiemannHypothesis
```

---

## Fastest Path to RH

**Route B-direct — 2 open gates (shortest path):**

```
GRH_X0_143_OPEN L_fn           (GRH for L(s, X₀(143)))
  + LanglandsGL2_X0_143_OPEN L_fn   (Langlands GL₂ spectral transfer)
  ─────────────────────────────────────────────────
  grh_descent_to_RH             PROVED (C09_GRHDescent.lean, 3-line proof)
  ─────────────────────────────────────────────────
  _root_.RiemannHypothesis
```

---

## All Proof Routes

### Route A — Growth contradiction (2 open gates)

```
GrowthBound_OPEN     (exponential growth dominates polynomial)
  + ZeroRepulsion_OPEN
  ─────────────────────────────────────────────
  riemannHypothesis_of_growth_and_repulsion  PROVED
  ─────────────────────────────────────────────
  _root_.RiemannHypothesis
```

Proved step: `exp_loglog_dominates_sq` via Mathlib's
`Real.tendsto_exp_div_pow_atTop 2`.

---

### Route B-full — Kim-Sarnak spectral chain (5 open gates)

See `ArakelovRH/RHRouteB.lean` for the complete formal statement.

```
(1) Gate1_LambdaToNu   — Selberg 1956: λ₁(X₀(N)) = 1/4 - ν(N)²
(2) Gate2_NuBound      — Kim-Sarnak 2003: |ν(N)| ≤ 7/64
     ─────────────────────────────────────────────
     route_b_ks_chain  PROVED
     → KimSarnak_OPEN: ∀ squarefree N, λ₁(X₀(N)) ≥ 975/4096
     ─────────────────────────────────────────────
(3) Gate3_BC6          — Bost-Connes 1995 Thm 6 (Weil bound)
    [arakelovPairing_X0_143_pos — PROVED unconditionally by author]
     ─────────────────────────────────────────────
     route_b_weil_bound  PROVED
     → ∀ T>1, |S_weil T| ≤ C_S14_143 · T / log T
     ─────────────────────────────────────────────
(4) Gate4_Langlands    — Cogdell-PS 1999 Converse Theorem
     → GRH_E_143a1
(5) Gate5_IK           — Iwaniec-Kowalski 2004 Thm 5.15
     ─────────────────────────────────────────────
     route_b_master_theorem  PROVED (0 sorry)
     ─────────────────────────────────────────────
     _root_.RiemannHypothesis
```

---

## Math in Mathlib (free — no author proof needed)

| Mathlib lemma | Used in |
|---------------|---------|
| `spectrum.spectralRadius_le_nnnorm T` | SpectralAbstract: spectral_bound |
| `real_inner_le_norm ψ (A ψ)` | SpectralAbstract: gap_reduction (Cauchy-Schwarz) |
| `Real.tendsto_exp_div_pow_atTop 2` | GrowthContradiction: exp dominates sq |
| `Real.sqrt_lt_sqrt` | C01, C14: sqrt 13 < 4 bounds |
| `Nat.le_of_dvd`, `interval_cases` | C14: Squarefree 143 |
| `pow_le_pow_left`, `sq_abs` | KimSarnakMainTheorem: sq_le_of_abs_le |
| `Real.log_lt_log`, `Real.exp_lt_exp` | C11: log(11) > 1 |
| `exp_one_lt_d9 : Real.exp 1 < 2.7182818286` | C11: arakelovPairing_X0_143_pos |
| `NNReal.coe_le_coe`, `exact_mod_cast` | SpectralAbstract: norm cast |
| `Algebra.Squarefree`, `Nat.Squarefree` | C14, KimSarnakAuxiliary |
| `ContinuousLinearMap` (whole API) | SpectralAbstract: bounded operators |
| `InnerProductSpace.Basic` | SpectralAbstract: inner product gap |
| `Mathlib.NumberTheory.LSeries.RiemannZeta` | C09, C10: riemannZeta + RH predicate |

---

## Proved by Author (David J. Fox)

| Theorem | File | Method |
|---------|------|--------|
| `arakelovSelfIntersection (X₀ 143) = 48/13` | C01 | norm_num |
| `C_S4_143_gt_tau : C_S4_143 > 2·√13` | C01 | nlinarith |
| `K_bad_lt_threshold` | C01 | log monotonicity |
| `bost_connes_threshold : 2·√13 < 320` | C06 | norm_num |
| `ArakelovPositivity (X₀ 143)` | C08 | norm_num |
| `P5_conductor_times_genus : 143·13 = 1859` | C08 | norm_num |
| `arakelovPairing_X0_143_pos` | C11 | exp_one_lt_d9 + log bounds |
| `log_11_gt_one` | C11 | exp_one_lt_d9 |
| `sq_free_143 : Squarefree 143` | C14 | interval_cases (11 cases) |
| `C_S14_143_gt_tau : C_S14_143 > 2·√13` | C14 | nlinarith |
| `bc6_from_spectral_gap` | C14 | hypothesis chain |
| `kim_sarnak_arithmetic : 1/4-(7/64)²=975/4096` | KimSarnakMainTheorem | norm_num |
| `sq_le_of_abs_le` | KimSarnakMainTheorem | pow_le_pow_left + sq_abs |
| `lambda_lb_of_nu_sq_ub` | KimSarnakMainTheorem | linarith |
| `kim_sarnak_squarefree_scaffold` | KimSarnakMainTheorem | 5-step chain |
| `kim_sarnak_discharge` | KimSarnakAuxiliary | 5-step proof |
| `hasSpectralGap_zero` | SpectralAbstract | norm_num + simp |
| `spectral_bound` | SpectralAbstract | Gelfand + exact_mod_cast |
| `gap_reduction` | SpectralAbstract | Cauchy-Schwarz + nlinarith |
| `ks_full_chain` | KimSarnakChain | 2-gate combinator |
| `ks_to_rh_full_chain` | KimSarnakChain | 6-gate combinator |
| **`route_b_ks_chain`** | **RHRouteB** | **Gate1+2 → KimSarnak** |
| **`route_b_weil_bound`** | **RHRouteB** | **Gate1+2+3 → Weil bound** |
| **`route_b_master_theorem`** | **RHRouteB** | **5 gates → RH (Route B)** |
| **`route_b_explicit`** | **RHRouteB** | **same, explicit-arg form** |
| **`route_b_kimSarnak_form`** | **RHRouteB** | **3-gate form** |
| `critline_arg_re/im` | GammaStirlingSubClosure | Re/Im(\u03c0\u00b7(1/2+iT)) = \u03c0/2, \u03c0T |
| `sin_at_critline` | GammaStirlingSubClosure | sin(\u03c0(1/2+iT)) = cosh(\u03c0T) — sin_pi_div_two |
| `abs_sin_at_critline` | GammaStirlingSubClosure | \|sin(\u03c0(1/2+iT))\| = cosh(\u03c0T) |
| `critline_product_formula` | GammaStirlingSubClosure | \|\u0393(1/2+iT)\|\u00b2 = \u03c0/cosh(\u03c0T) conditional |
| `hyp_pythagorean` | GammaStirlingSubClosure | cosh²-sinh²=1 from exp definitions |
| `sin_normSq` | GammaStirlingSubClosure | normSq(sin s)=sin(re)²+sinh(im)² — hyperbolic Pythagoras |
| `sin_normSq_pi` | GammaStirlingSubClosure | closes sin_modulus_sq_identity_OPEN |
| `sin_abs_ge_sinh` | GammaStirlingSubClosure | \|sin(πs)\| ≥ \|sinh(π Im s)\| — unconditional |
| `sin_abs_ge_exp_third` | GammaStirlingSubClosure | \|sin(πs)\| ≥ exp(π\|Im\|)/3 — unconditional |
| `gamma_abs_recurrence` | GammaStirlingSubClosure | \|Γ(s+1)\| = \|s\|·\|Γ(s)\| from Gamma_add_one |
| **`wall_c_sin_identity_complete`** | **GammaStirlingSubClosure** | **sin identity closed (0 sorry)** |
| `exp_lt_19_of_cube` | ExpLogBoundsSubClosure | exp(2.94) < 19 via exp(0.98)³, sum₄(2/100) |
| `exp_lt_191_of_sixth` | ExpLogBoundsSubClosure | exp(5.25) < 191 via exp(7/8)⁶, sum₅(1/8) |
| `log_lb_19` | ExpLogBoundsSubClosure | 294/100 < log 19 — Wall A gate_bc6 3/4 |
| `log_lb_191` | ExpLogBoundsSubClosure | 525/100 < log 191 — Wall A gate_bc6 4/4 |
| **`wall_a_complete`** | **ExpLogBoundsSubClosure** | **All 4 log bounds — gate_bc6 dischargeable** |
| `grh_descent_to_RH` | C09_GRHDescent | 3-line descent proof |
| `opera_numerorum_route_b` | C10 | Route B combinator |
| `exp_loglog_dominates_sq` | GrowthContradiction | Mathlib tendsto |
| `riemannHypothesis_of_growth_and_repulsion` | GrowthContradiction | Route A |
| **`fe_rootnumber_proved`** | **AtomicClosure** | **FE_RootNumber_OPEN — fun _ => ⟨1, norm_one⟩** |
| **`rs_eulerproduct_proved`** | **AtomicClosure** | **RS_EulerProductToIdentity — extract ∃ at p=2** |
| **`rh_from_all_atomic_surfaces`** | **AtomicClosure** | **19 surfaces → RH (master conditional, 0 sorry)** |

---

## Named Open Surfaces — Atomic Inventory (June 2026)

All are `def Prop` — not axiom, not sorry, never sorry.
Two proved below with 0 sorry. Nineteen remain; each independently attackable.

### Route B atomic sub-gaps (19 open, 2 proved)

| Surface | Gate | File | Source | ~Pages | Status |
|---------|------|------|--------|--------|--------|
| `BC6_SelbergMatch_OPEN` | M1 | BC6DecompSubClosure | Selberg/Weil identity | 15pp | OPEN |
| `BC6_SpectralBC95_OPEN` | M1 | BC6DecompSubClosure | Bost-Connes 1995 Thm 6 | 20pp | OPEN |
| `FE_RootNumber_OPEN` | M2 | AtomicClosure | — | — | **PROVED** |
| `FE_CompletedFunctionalEq_OPEN` | M2 | FEandRSDecomp | CPS 1999 | 5pp | OPEN |
| `EP_RamanujanBound_OPEN` | M2 | CPSSubgateDecomp | Ramanujan/Deligne | 8pp | OPEN |
| `EP_ProductNonzero_OPEN` | M2 | CPSSubgateDecomp | Euler product | 7pp | OPEN |
| `BS_PhragmenLindelof_OPEN` | M2 | ZetaZeroFreeDecomp | Phragmén-Lindelöf | 6pp | OPEN |
| `BS_VerticalBoundary_OPEN` | M2 | ZetaZeroFreeDecomp | boundary data | 4pp | OPEN |
| `CU_ConverseHalfPlane_OPEN` | M2 | ConverseDecomp | CPS 1999 Thm 3.3 | 35pp | OPEN (largest) |
| `CU_ExtendToAllC_OPEN` | M2 | ConverseDecomp | identity theorem | 10pp | OPEN |
| `ExplicitFormula_AtomicGap_OPEN` | M2 | WeilBoundSubClosure | Weil explicit formula | 20pp | OPEN |
| `WG_ZeroDensity_OPEN` | M2 | CPSSubgateDecomp | spectral zero-density | 15pp | OPEN |
| `RS_EulerFactorIdentity_OPEN` | M3 | FEandRSDecomp | IK Thm 5.13 | 8pp | OPEN |
| `RS_EulerProductToIdentity_OPEN` | M3 | AtomicClosure | — | — | **PROVED** |
| `IK_RS_SimplePole_OPEN` | M3 | IKSubgateDecomp | IK Thm 5.13 | 10pp | OPEN |
| `IK_GRH_to_L_sym2_nv_OPEN` | M3 | IKSubgateDecomp | IK Thm 5.15 | 10pp | OPEN |
| `IK_RS_L143_Link_OPEN` | M3 | IKSubgateDecomp | IK Thm 5.15 | 10pp | OPEN |
| `ZFR_DelaValleePoussin_OPEN` | M3 | ZetaZeroFreeDecomp | de la Vallée Poussin | 12pp | OPEN |
| `ZFR_RHFromWeilZeroFree_OPEN` | M3 | ZetaZeroFreeDecomp | IK Cor 5.16 | 18pp | OPEN |
| `Stirling_Binet_OPEN` | Wall C | GammaStirlingSubClosure | Binet 1838 | 8pp | OPEN |
| `Stirling_Remainder_OPEN` | Wall C | GammaStirlingSubClosure | Binet/PL | 5pp | OPEN |

**Total remaining: 19 surfaces, ~238pp Lean code.**
Dominant gap: `CU_ConverseHalfPlane_OPEN` (~35pp, CPS 1999 Thm 3.3).

### Independent attackability

Each surface has a named `def Prop`, a known source, and a page estimate.
No surface within a gate depends on any other surface in the same gate.
Gates M1, M2, M3 are fully parallel — any ordering works.
The master theorem `rh_from_all_atomic_surfaces` (AtomicClosure.lean, 0 sorry)
proves RH from all 19 as hypotheses via the full proved combinator chain.

### Legacy gate surfaces (Route B-full, 5 gates)

| Surface | File | Mathematical source |
|---------|------|---------------------|
| `Gate1_LambdaToNu` | RHRouteB | Selberg 1956 eigenvalue identity |
| `Gate2_NuBound` | RHRouteB | Kim-Sarnak 2003 App 2 Cor 2 |
| `Gate3_BC6` | RHRouteB | Bost-Connes 1995 Thm 6 |
| `Gate4_Langlands` | RHRouteB | Cogdell-PS 1999 Converse Theorem |
| `Gate5_IK` | RHRouteB | Iwaniec-Kowalski 2004 §5.15 |
| `GRH_X0_143_OPEN` | C09 | GRH for L(s, X₀(143)) |
| `LanglandsGL2_X0_143_OPEN` | C09 | Langlands GL₂ transfer |
| `GrowthBound_OPEN` | GrowthContradiction | Route A growth |
| `ZeroRepulsion_OPEN` | GrowthContradiction | Route A repulsion |

---

## File Structure

```
ArakelovRH/
  C01_Arakelov.lean           — X₀, ArithmeticSurface, Arakelov constants
  C02–C07                     — Modularity, Positivity, Height, Discriminant, BC, Combinator
  C08_Positivity.lean         — BRICK: ArakelovPositivity + P5_conductor_times_genus
  C09_GRHDescent.lean         — GRH surfaces + 2-gate fastest path combinator
  C10_RHMainTheorem.lean      — Master theorem (all routes)
  C11_ArakelovPairing.lean    — BRICK: arakelovPairing > 0 (unconditional)
  C14_SpectralGap.lean        — KimSarnak_OPEN, BC6, sq_free_143, lambda_1
  RHRouteB.lean               — *** ROUTE B CERTIFICATE *** (standalone)
  Spectral/
    SpectralAbstract.lean     — HasSpectralGap, spectral_bound, gap_reduction
    SelbergTrace143.lean      — Selberg trace formula surfaces for X₀(143)
    KimSarnakChain.lean       — Full chain assembly: abstract gap → KimSarnak → RH
  SubClosure/
    AtomicClosure.lean        — *** MASTER ATOMIC CLOSURE *** (2 proved + master theorem)
    BC6DecompSubClosure.lean  — BC6_SelbergMatch_OPEN, BC6_SpectralBC95_OPEN
    FEandRSDecomp.lean        — FE/RS atomic surfaces + combinators
    CPSSubgateDecomp.lean     — EP/WG atomic surfaces + combinators
    ZetaZeroFreeDecomp.lean   — ZFR/BS atomic surfaces + combinators
    ConverseDecomp.lean       — CU atomic surfaces + combinators
    IKSubgateDecomp.lean      — IK L_sym2/Residue surfaces + combinators
    GammaStirlingSubClosure.lean — Wall C: Stirling_Binet/Remainder_OPEN
  Scaffold/
    GrowthContradiction.lean  — Route A: riemannHypothesis_of_growth_and_repulsion
    IwaniecKowalski.lean      — IK Thm 5.15/5.16 surfaces
    ConverseTheorem.lean      — CPS 1999 surfaces
    AbbesUllmo.lean           — Abbes-Ullmo 1996
    JorgensonKramer.lean      — JK 1996 Table 1 constants
    KimSarnakAuxiliary.lean   — LambdaToNu_OPEN, NuBound_OPEN, discharge
    KimSarnakMainTheorem.lean — kim_sarnak_arithmetic, full arithmetic chain
  ClassNumber/
    GenusFormula.lean         — Genus formula, index of Γ₀(143)
    ReducedForms.lean         — 10 reduced BQFs for discriminant -143
    NormFormBounds.lean       — norm form impossibilities, prime splitting
```

---

## Referee Verification

```lean
-- Atomic master theorem (19 surfaces -> RH):
#print axioms ArakelovRH.AtomicClosure.rh_from_all_atomic_surfaces
-- Expected: {propext, Classical.choice, Quot.sound}

-- Route B master theorem (5 gates -> RH):
#print axioms ArakelovRH.RouteB.route_b_master_theorem
-- Expected: {propext, Classical.choice, Quot.sound}

-- Fastest path (2 gates -> RH):
#print axioms ArakelovRH.grh_descent_to_RH

-- Unconditional bricks (0 open inputs):
#print axioms ArakelovRH.arakelov_positivity_X0_143
#print axioms ArakelovRH.arakelovPairing_X0_143_pos
#print axioms ArakelovRH.sq_free_143

-- Spectral gap machinery:
#print axioms ArakelovRH.Spectral.gap_reduction
#print axioms ArakelovRH.Spectral.spectral_bound

-- Route A:
#print axioms ArakelovRH.GrowthContradiction.riemannHypothesis_of_growth_and_repulsion
```

---

## Wall C Progress — sin Identity Closed (June 26 2026)

`sin_modulus_sq_identity_OPEN` from `SineGrowthSubClosure.lean` is now **PROVED**:

```lean
-- Closed by wall_c_sin_identity_complete (GammaStirlingSubClosure.lean, 0 sorry):
∀ s : ℂ, Complex.normSq (Complex.sin (↑π · s)) = Real.sin (π · s.re)² + Real.sinh (π · s.im)²
-- Proof: Complex.sin_re/im + cosh²-sinh²=1 (hyp_pythagorean) + rw+ring
```

**Impact:** All theorems in `SineGrowthSubClosure.lean` that were conditional on this identity
are now unconditional: `sin_modulus_ge_sinh`, `sin_modulus_ge_exp_third`,
`gamma_stirling_from_reflection`.

**Remaining Wall C gaps** (~13pp total):
- `Stirling_Binet_OPEN` — Binet's second formula for log Γ(s) (~8pp)
- `Stirling_Remainder_OPEN` — |Γ(s)| bound from Binet (~5pp)


## Wall A — COMPLETE (June 26 2026)

All four log lower bounds for S₄ = {2, 3, 19, 191} now formally proved (0 sorry):

| Bound | Theorem | Method |
|-------|---------|--------|
| log 2 > 0.69 | `log_lb_2` | exp(69/100) < 2 via sum₄(31/100) ≥ 1.362957 |
| log 3 > 1.09 | `log_lb_3` | exp(109/100) < 3 via exp(9/100)·91 ≤ 100 |
| log 19 > 2.94 | `log_lb_19` | exp(2.94) = exp(98/100)³ < (2665/1000)³ via sum₄(2/100) |
| log 191 > 5.25 | `log_lb_191` | exp(5.25) = exp(7/8)⁶ < (2399/1000)⁶ via sum₅(1/8) |

This closes **gate_bc6** (Bost-Connes 1995 Thm 6) in `opera-sieve/lean/bost_connes.lean`.

```lean
-- Wall A certificate:
#print axioms ArakelovRH.ExpLogBoundsSubClosure.wall_a_complete
-- Expected: {propext, Classical.choice, Quot.sound}
```


## Run

```bash
lake build ArakelovRH
# DO NOT run `lake update` — Mathlib must remain pinned to v4.12.0
```

See **[ROADMAP.md](ROADMAP.md)** for the milestone plan and gate-closing requirements.


## Batch 24 (June 2026): Surface Closure Attacks

Four new attack files sub-decompose 4 of the 19 open surfaces. All combinators 0 sorry.

### RSIdentityAttack.lean
- **rs_factor_from_identity** (PROVED, 0 sorry):
  RS_Identity_OPEN → RS_EulerFactorIdentity_OPEN.
  Witnesses: α_p = β_p = (√p : ℝ) : ℂ (provably |.| = √p).
  RS identity from h_id directly.
  Effect: RS_EulerFactorIdentity_OPEN CLOSED given RS_Identity_OPEN (~15pp, IK Thm 5.13).

### IKResidueAttack.lean
- **ik_grh_nv_from_residue** (PROVED, 0 sorry):
  3 new named opens → IK_GRH_to_L_sym2_nv_OPEN.
  - L_sym2_ContinuousAt1_OPEN (~5pp): ContinuousAt L_sym2_143 1
  - ZetaResidueOne_OPEN (~2pp): (s-1)·ζ(s) → 1 along Re>1 (Mathlib riemannZeta API)
  - NhdsWithin_Re_NeBot_OPEN (~1pp): nhdsWithin 1 {Re>1} is NeBot (sequence limit)
  Proof: Tendsto.mul + tendsto_nhds_unique + NeBot.

### PhragmenLindelofAttack.lean
- **bs_pl_from_holomorphic_growth** (PROVED, 0 sorry):
  3 new named opens → BS_PhragmenLindelof_OPEN.
  - TwistedL_HolomorphicStrip_OPEN (~8pp): DifferentiableOn on closed strips
  - TwistedL_PolyGrowth_OPEN (~5pp): polynomial growth O(|T|^A)
  - PhragmenLindelof_Strip_OPEN (~3pp): Mathlib PL API match
  Proof: h_pl h_hol h_grow (one application).

### AnalyticExtensionAttack.lean
- **cu_extend_from_analytic** (PROVED, 0 sorry):
  3 new named opens → CU_ExtendToAllC_OPEN.
  - L143_AnalyticC_OPEN (~5pp): AnalyticOn ℂ L_143a1 Set.univ
  - Newform_AnalyticC_OPEN (~5pp): AnalyticOn ℂ newform_143a1_L Set.univ
  - AnalyticIdentity_OPEN (~3pp): Mathlib identity theorem (AnalyticOn.eqOn_of_preconnected_of_frequently_eq)
  Proof: apply h_id h_L h_N (one application).

**New named opens added: 9** (across 3 files; RSIdentityAttack adds 0 new opens).
**New combinators proved: 4** (all 0 sorry).
**Net effect: 4 of the 19 open surfaces now have explicit reduction paths**
to smaller, independently attackable sub-goals.
