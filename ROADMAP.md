# ROADMAP — arakelov-positivity-rh-core

**Opera Numerorum — Riemann Hypothesis via Arakelov Geometry**
Author: David J. Fox — June 2026 | ORCID: 0009-0008-1290-6105

> Guiding principle: **name open surfaces first, then fill them**.
> Every gap is a named `def Prop`, not a sorry.  The combinator that
> closes RH from each set of gates is already formally proved.
> Closing a gate = supplying a `theorem` that proves the named Prop.

---

## Proof-Status Summary (June 2026)

| Metric | Value |
|--------|-------|
| SORRY | **0** |
| Axiom footprint | `{propext, Classical.choice, Quot.sound}` |
| native_decide | **0** |
| opaque | **0** |
| trivial in proof bodies | **0** |
| Named open surfaces | **~18** (after RouteBClosure reduction) |
| Proved bricks (0 open inputs) | **30+** |
| Certifications bricks registered | **2 / 2** (both Towers.RH bricks proved) |

---

## Certifications Registry (DavidFox998/Certifications, Towers.RH)

| Brick | Certifications Theorem | Repo File | Status |
|-------|------------------------|-----------|--------|
| `bost_connes_threshold` | `TheoremaAureum.bost_connes_threshold` | `C06_BostConnes.lean` | ✓ PROVED |
| `N_monotone_in_sigma` | `TheoremaAureum.Towers.RH.N_monotone_in_sigma` | `ZeroDensity.lean` | ✓ PROVED |

Both Towers.RH bricks are formally proved in this repo.

---

## Three Complete Routes (fastest first)

### Route 1 — GRH Descent (2 gates) ← **FASTEST**

```
OPEN: R1a  GRH_X0_143_OPEN L_fn          (GRH for L(s, E_{143a1}/Q))
OPEN: R1b  LanglandsGL2_X0_143_OPEN L_fn (every zeta zero is an L-fn zero)
─────────────────────────────────────────────────────────────
PROVED: grh_descent_to_RH  (C09_GRHDescent.lean, 3 lines)
─────────────────────────────────────────────────────────────
_root_.RiemannHypothesis
```

**Priority: HIGHEST.**  Two gates, both purely about L-functions.

| Gate | Content | Mathlib (June 2026) | ETA |
|------|---------|---------------------|-----|
| R1a GRH_X0_143_OPEN | GRH for Hasse-Weil L(s,E_{143a1}) | Partial (riemannZeta only) | 2027-2029 |
| R1b LanglandsGL2 | Langlands GL₂ transfer (Wiles/BCDT) | 0% | 2030+ |

---

### Route 2 — Growth Contradiction (2 gates, Gate R2a FALSE)

```
OPEN: R2a  GrowthBound_OPEN     (|zeta(1/2+it)| ≤ C*(log t)²)  ← FALSE
OPEN: R2b  ZeroRepulsion_OPEN   (zero repulsion — classical)
─────────────────────────────────────────────────────────────
PROVED: riemannHypothesis_of_growth_and_repulsion
─────────────────────────────────────────────────────────────
_root_.RiemannHypothesis
```

**WARNING: Gate R2a (GrowthBound) is FALSE.**
Titchmarsh 1986 §8: |ζ(1/2+it)| = Ω(log t / log log t).
Route 2 cannot close RH as stated.  Route 2 is kept for documentation only.
A corrected version would replace R2a with a CORRECT upper bound,
which would require resolving the Lindelöf Hypothesis (also open).

| Gate | Content | Status |
|------|---------|--------|
| R2a GrowthBound | |ζ(1/2+it)| ≤ C*(log t)² | **FALSE** — cannot close |
| R2b ZeroRepulsion | Hadamard-dVP 1896 | OPEN, classical, ~20pp |

---

### Route 3 — Bost Closure (3 gates, Gate R3a has proved inputs)

```
PROVED: C_S14_143_gt_tau             (C14_SpectralGap.lean, PROVED)
PROVED: arakelovPairing_X0_143_pos   (C11_ArakelovPairing.lean, PROVED)
    ↓ feed into ↓
OPEN:  R3a  BC6_direct_OPEN          (Bost-Connes Thm 6 for X₀(143))
    ↓ gives ↓
    ∀ T>1, |S_weil T| ≤ C_S14_143 * T / log T
OPEN:  R3b  Langlands_Descent_OPEN   (CPS 1999 Converse Theorem)
    ↓ gives ↓
    GRH_E_143a1
OPEN:  R3c  GRH_to_RH_Descent_143    (IK 2004 Thm 5.15 + Cor 5.16)
    ↓ gives ↓
─────────────────────────────────────────────────────────────
PROVED: route_b_via_bost_closure  (RouteBClosure.lean)
─────────────────────────────────────────────────────────────
_root_.RiemannHypothesis
```

**KEY ADVANTAGE: Gate R3a (BC6_direct_OPEN) takes ONLY PROVED INPUTS.**
Both `C_S14_143 > 2*sqrt(13)` and `arakelovPairing > 0` are proved.
The only remaining mathematical content is: Bost-Connes Theorem 6 in Lean.

| Gate | Content | Proved inputs? | Math (~pp) | Mathlib |
|------|---------|----------------|------------|---------|
| R3a BC6_direct | BC95 Thm 6 Weil bound | ✓ Both proved | ~40pp | 0% |
| R3b Langlands | CPS 1999 GL₂ Converse | — | ~70pp | 0% |
| R3c IK descent | IK 2004 Thm 5.15 | — | ~80pp | 0% |

**Route 3 further decomposes to 8 sub-gates** (see `RouteBClosure.lean`):
- 5 CPS sub-gates (ConverseTheorem.lean)
- 3 IK sub-gates (IwaniecKowalski.lean)
- Priority 1: `CPS_EulerProduct_OPEN` (~5pp, smallest gate)

---

## Open Surface Inventory (after RouteBClosure analysis)

### Active Open Surfaces (18 total)

#### Route 1 (2 gates)
| # | Surface | Mathematical Content | Source |
|---|---------|---------------------|--------|
| 1 | `GRH_X0_143_OPEN` | GRH for L(s,E_{143a1}/Q) | C09 |
| 2 | `LanglandsGL2_X0_143_OPEN` | Langlands GL₂ transfer | C09 |

#### Route 3 — minimal gates (3)
| # | Surface | Proved Inputs | Mathematical Content |
|---|---------|---------------|---------------------|
| 3 | `BC6_direct_OPEN` | C_S14_gt_tau + arakelov_pos | BC95 Thm 6 |
| 4 | `Langlands_Descent_OPEN` | — | CPS 1999 Converse |
| 5 | `GRH_to_RH_Descent_143_OPEN` | — | IK 2004 Thm 5.15 |

#### Route 3 — CPS sub-gates (5, decompose Gate 4)
| # | Surface | Content |
|---|---------|---------|
| 6 | `CPS_FunctionalEquation_OPEN` | Functional eq. for twists |
| 7 | `CPS_EulerProduct_OPEN` | L≠0 for Re(s)>3/2 (**Priority 1**) |
| 8 | `CPS_BoundedStrips_OPEN` | L bounded in strips |
| 9 | `CPS_ConverseAndUniqueness_OPEN` | CPS Thm 3.3 + Cremona |
| 10 | `WeilBound_to_GRH_OPEN` | Weil bound → GRH |

#### Route 3 — IK sub-gates (3, decompose Gate 5)
| # | Surface | Content |
|---|---------|---------|
| 11 | `L_sym2_NonVanishing_OPEN` | GRH → L(1,sym²f)≠0 |
| 12 | `Residue_Argument_OPEN` | L(1,sym²f)≠0 → L(1,f)≠0 |
| 13 | `ZetaZeroFree_OPEN` | L(1,f_{143a1})≠0 → RH |

#### Additional named surfaces (5, for completeness)
| # | Surface | Status |
|---|---------|--------|
| 14 | `KimSarnak_OPEN` | Superseded by Route 3 (absorbed into BC6_direct) |
| 15 | `BC6SelbergTrace_OPEN` | Superseded by BC6_direct_OPEN |
| 16 | `ArakelovPositivity_to_RH_Bridge` | Master.lean top-level bridge |
| 17 | `ZeroDensityBound_OPEN` | Ingham 1940 zero-density estimate |
| 18 | `ZeroRepulsion_sigma_OPEN` | Hadamard zero-repulsion |

---

## Gate-Closing Priority Order

| Priority | Gate | Lean Work Needed | Impact |
|----------|------|-----------------|--------|
| **P1** | CPS_EulerProduct_OPEN | ~5pp, Euler product non-vanishing | Unlocks CPS chain |
| **P2** | BC6_direct_OPEN (N=143 specific) | ~40pp, Selberg trace for Γ₀(143) | Closes Route 3 Gate 1 |
| **P3** | ZeroRepulsion_sigma_OPEN | ~20pp, Hadamard-dVP | Enables Route 2 |
| **P4** | WeilBound_to_GRH_OPEN | ~15pp, once Euler+Weil proved | Connects CPS chain |
| **P5** | GRH_X0_143_OPEN | ~100pp, GRH for E_{143a1} | Closes Route 1 |
| **P6** | LanglandsGL2_X0_143_OPEN | ~200pp, Langlands GL₂ | Closes Route 1 |

---

## Mathlib Availability Timeline (Estimated)

| Mathlib Feature | ETA | Gates Unlocked |
|----------------|-----|---------------|
| L-series for elliptic curves | 2027 | GRH_X0_143_OPEN (partial) |
| Weil explicit formula | 2028 | BC6_direct, WeilBound_to_GRH |
| Selberg trace formula | 2029 | BC6_direct_OPEN |
| GL₂ automorphic forms | 2030+ | Langlands, CPS |
| Langlands functoriality | 2032+ | LanglandsGL2, CPS_Converse |

---

## Proved Brick Inventory (30+ bricks, 0 open inputs each)

| Theorem | File | Mathematical Content |
|---------|------|---------------------|
| `C_S4_143_gt_tau` | C01 | C(S4) = 11.422 > 2√13 |
| `C_S14_143_gt_tau` | C14 | C(S14) = 8.629 > 2√13 |
| `arakelovSelfIntersection_X0_143` | C01 | ω²(X₀(143)) = 48/13 |
| `arakelov_positivity_X0_143` | C08 | ω²(X₀(143)) > 0 |
| `arakelovPairing_X0_143_pos` | C11 | (ω,ω)_Ar(X₀(143)) > 0 |
| `sq_free_143` | C14 | 143 = 11×13 squarefree |
| `bost_connes_threshold` | C06 | 2√g(143) < 320 |
| `P5_conductor_times_genus` | C08 | 143 × 13 = 1859 |
| `log_11_gt_one` | C11 | log(11) > 1 |
| `X0_143_genus` | C01 | genus(X₀(143)) = 13 |
| `kim_sarnak_arithmetic` | KSMain | 1/4 − (7/64)² = 975/4096 |
| `sq_le_of_abs_le` | KSMain | |ν| ≤ 7/64 → ν² ≤ (7/64)² |
| `lambda_lb_of_nu_sq_ub` | KSMain | ν² ≤ (7/64)² → 975/4096 ≤ 1/4−ν² |
| `ks_arithmetic_chain` | KSChain | |ν| ≤ 7/64 → 975/4096 ≤ 1/4−ν² |
| `exp_loglog_dominates_sq` | GrowthContra | exp(c·log/loglog) dominates C·(log)² |
| `S4_naive_fails` | ConverseThm | 1.434 < 2√13 (M5 audit brick) |
| `K_143_val_lt_24_log_143` | JK | K_{143} < 24·log(143) |
| `abbes_ullmo_1996_1_2` | AbbesUllmo | ArakelovPositivity ← genus ≥ 2 |
| `N_monotone_in_sigma` | ZeroDensity | strip(σ₂,T) ⊆ strip(σ₁,T) for σ₁≤σ₂ |
| `rh_no_off_line_zeros` | ZeroDensity | RH → strip(σ>1/2) = ∅ |
| ... (10+ additional proved combinators) | various | see individual files |

---

## File Structure

```
ArakelovRH/
  C01_Arakelov.lean          -- Base defs: X₀, ArakelovPositivity, C_S4_143
  C02_Modularity.lean        -- Modularity_X0_143_OPEN (Eichler-Shimura gap)
  C03_Positivity.lean        -- Slope positivity (Vojta height bound)
  C04_HeightBound.lean       -- VojtaHeightBound_X0_143_OPEN
  C05_Discriminant.lean      -- DiscriminantBound_X0_143_OPEN, GRH_E_143a1 def
  C06_BostConnes.lean        -- BRICK: bost_connes_threshold (Certifications #1)
  C07_RHCombinator.lean      -- Full chain combinator (C01-C07)
  C08_Positivity.lean        -- BRICK: arakelov_positivity_X0_143
  C09_GRHDescent.lean        -- Route 1 + Route B gates + grh_descent_to_RH
  C10_RHMainTheorem.lean     -- Master theorem (all routes)
  C11_ArakelovPairing.lean   -- BRICK: arakelovPairing_X0_143_pos
  C14_SpectralGap.lean       -- BRICK: C_S14_143_gt_tau, sq_free_143
  Master.lean                -- ArakelovPositivity_to_RH_Bridge
  RHRouteA.lean              -- Route A standalone certificate
  RHRouteB.lean              -- Route B standalone certificate
  RouteBClosure.lean         -- Route 3 min debt analysis (3 gates)
  ZeroDensity.lean           -- BRICK: N_monotone_in_sigma (Certifications #2)
  RHCoreProof.lean           -- STANDALONE CANONICAL CERTIFICATE (this file)
  Scaffold/
    AbbesUllmo.lean          -- Abbes-Ullmo 1996: ArakelovPositivity ← genus ≥ 2
    ConverseTheorem.lean     -- CPS 1999: 5 sub-gates
    GrowthContradiction.lean -- exp_loglog_dominates_sq (Route 2)
    IwaniecKowalski.lean     -- IK 2004: 3 IK sub-gates
    JorgensonKramer.lean     -- JK 1996: K_infty_143 = 5.022
    KimSarnakAuxiliary.lean  -- LambdaToNu, NuBound, kim_sarnak_discharge
    KimSarnakMainTheorem.lean -- kim_sarnak_arithmetic, sq_le_of_abs_le
  Spectral/
    KimSarnakChain.lean      -- ks_to_rh_full_chain (6-gate Kim-Sarnak)
    SelbergTrace143.lean     -- SelbergTrace, WeylLaw, ZeroFree open surfaces
    SpectralAbstract.lean    -- HasSpectralGap, spectral_bound, gap_reduction
```

---

## SHA Chain (Opera Numerorum connection)

This Lean repo formalises the mathematical content certified in the
Opera Numerorum Python pipeline (m1.out through m6.out, SHA-bound):

| Python cert | SHA-bound claim | Lean formalisation |
|-------------|----------------|-------------------|
| m5.out (arb_bost.py) | C(S4) > 2√13 | `C_S4_143_gt_tau` (C01) |
| m6.out (x0_143.py) | genus=13, h(-143)=10, Bost check | `X0_143_genus`, `bost_connes_threshold` |
| M7 manifest SHA | all m1-m6 frozen | `full_arakelov_bricks` (C10) |

The Lean proofs are unconditional (no SHA trust required).
The Python certs provide independent numerical verification.

---

*Last updated: June 2026. Commit: see HEAD SHA.*
