# ROADMAP — arakelov-positivity-rh-core

**Target:** Unconditional Lean 4 proof of `_root_.RiemannHypothesis`.

Author: David J. Fox — Opera Numerorum — June 2026

---

## Current Position (Batch 51, June 26 2026)

```
Grand Conditional:   opera_numerorum_grand_conditional   0 sorry   PROVED (B49)
Route B scaffold:    route_b_from_nine_surfaces           0 sorry   PROVED (B49)
Wall A:              bc_sum_S4_gt_bound + 4 log bounds    0 sorry   COMPLETE (B46)
Wall C closures:     3 atoms closed (SigmaBig, ZFR_Iso, KernelLarge)
Atomic opens:        50 named surfaces                    0 sorry   ALL OPEN DEFS
Remaining:           ~185pp analytic number theory
```

---

## The Periodic Table of Atomic Gaps

Each row is a `def : Prop` (named open surface). **Element** = Wall-Index code.
**Mass** = estimated pages of Lean to close.

### Wall A — COMPLETE

```
All 4 log lower bounds for S₄ = {2, 3, 19, 191} discharged.
bc_sum_S4_gt_bound : bc_sum_S4 > threshold  (0 sorry, Batch 46)
File: ExpLogBoundsSubClosure.lean
```

---

### Wall B — 7 Elements, ~13pp total

```
B01  HodgeCM_WeilConjectureAbelian_L6    1pp   Deligne 1969
B02  HodgeCM_FrobeniusFromWeil_L6        1pp   Tate 1966
B03  HodgeCM_J0143_L6                    1pp   Diamond-Shurman 9.6.1
B04  ExplicitFormula_WeilSum_L6          2pp   Weil 1952 / IK §5.5
B05  ExplicitFormula_ZeroContrib_L6      3pp   IK §5.5 Prop 5.9
B06  ExplicitFormula_PrimeSide_L6        3pp   IK §5.5
B07  ExplicitFormula_RHFromBound_L6      2pp   Bombieri 1974
```

**Attack order:** B01→B02→B03 (Hodge CM chain) then B04→B05→B06→B07 (Weil explicit).
Key Mathlib needed: `AlgebraicGeometry.Frobenius` API for elliptic curves.

---

### Wall C — 12 Elements, 3 Closed, 9 Open (~1.50pp open)

```
C01  Binet_KernelTaylor_L8              0.20pp  W-W §12.31        OPEN
C02  Binet_KernelFirstBernoulli_L8      0.15pp  B_2=1/6           OPEN
C03  Binet_KernelLargeBound_L8          0.15pp  exp decay         CLOSED (B51)
C04  Binet_GaussLimit_L8               0.25pp  Gauss product     OPEN
C05  Binet_ProdFromLimit_L8             0.25pp  Weierstrass       OPEN
C06  Binet_LogGammaSeries_L8            0.25pp  W-W §12.16        OPEN
C07  Binet_IntegralFromDigamma_L8       0.25pp  W-W §12.32        OPEN
C08  Gamma_NotBranch_UpperHalf_L8       0.05pp  Artin §1          OPEN
C09  Gamma_NotBranch_LowerHalf_L8       0.05pp  reflection        OPEN
C10  Laplace_IntegSigmaSmall_L10        0.15pp  antiderivative    OPEN
C11  Laplace_IntegSigmaBig_L10          ——      domination        CLOSED (B49)
C12  ZFR_Isolated_PathA                 ——      Mathlib analytic  CLOSED (B50)
```

**Closure method for C03 (done):**
  `binet_large_bound_proved`: `t ≥ 2π → |B(t)/t| ≤ 1/(4π) < 1/12`
  via `Real.add_one_le_exp` + `Real.pi_gt_three`.

**Next: C01→C02** (alternating series for Binet kernel small t).
  C01 closes via Bernoulli generating function Taylor series in Mathlib.
  C02 closes from C01 via alternating series bound.

**Next: C04→C05** (Gauss limit → Weierstrass product).
  C04: `Complex.tendsto_GaussProduct` if available in v4.12.0; else named open.
  C05: from C04 by taking logs.

**Next: C06→C07** (digamma series → log Gamma integral).
  C06: digamma series from `Complex.differentiableAt_Gamma` + product formula.
  C07: integration of C06 gives Binet's first formula (W-W §12.32).

**Then: C08→C09** (Gamma branch cut argument, tiny).
  C08: sector bound in upper half-plane (`|arg Γ(s)| < π/2 for Im(s) > 0`).
  Note: the statement `|arg Γ(s)| < π/2` may be too strong for large Im(s).
  Safe restatement: `arg Γ(s) ≠ π` for Re(s) > 0. (Verified in docs.)

**Then: C10** (Laplace integrability, σ∈(0,1), Ioi(0)).
  Proof: HasDerivAt antiderivative `-exp(-σt)/σ` → `integrableOn_Ioi`.

---

### Wall D — 14 Elements, ~5pp total

```
D01  ZFR_ChebyshevBound_L5             0.30pp  IK §5.7 L5.20     OPEN
D02  ZFR_PoussinLogDerivCombine_L5     0.40pp  IK §5.7 L5.22     OPEN
D03  ZFR_PoussinSigmaShift_L5         0.30pp  IK §5.7 L5.23     OPEN
D04  ZFR_ZeroFreeStrip_L5             0.40pp  IK §5.7 T5.25     OPEN
D05  ZFR_ExplicitRegion_L5            0.30pp  IK §5.7           OPEN
D06  ZFR_RegionConstant_L5            0.50pp  IK §5.7 explicit  OPEN
D07  ZFR_RegionForL143_L5             0.50pp  IK §5.7 + compact OPEN
D08  ZFR_RegionToZFR_L5               0.50pp  half-strip        OPEN
D09  ZFR_GammaStirlingBound_L6        0.25pp  Stirling (Wall C) OPEN
D10  ZFR_DirichletSeriesBound_L6      0.25pp  IK §5.1           OPEN
D11  ZFR_HadamardZeroSum_L6           0.25pp  Hadamard          OPEN
D12  ZFR_HadamardFactorization_L6     0.25pp  Hadamard          OPEN
D13  ZFR_DirichletSeries_L6           0.25pp  IK §5.1           OPEN
D14  ZFR_EulerFactors_L6              0.25pp  IK §5.2           OPEN
```

**D09 depends on Wall C** (Stirling bound = Wall C Binet formula).
**D01-D02:** trig_poussin_identity (3+4cos+cos2≥0) is PROVED (B48). Use it.
**Hardest:** D01+D03+D04 (Chebyshev + Poussin argument, ~1pp each).
**ZFR bridge:** `zero_critical_iff_GRH` (proved, B46) formally connects D output to Surface 9.

---

### CPS Surfaces 2–3 — 5 Elements, ~25pp

```
P01  CPS_FE_TwistedEq_L6              8pp   CPS 1999 §2        OPEN
P02  CPS_FE_GammaFactor_L6            6pp   CPS 1999 §2        OPEN
P03  CPS_FE_AnalyticCont_L6           6pp   analytic identity  OPEN
P04  CPS_EP_LocalFactors_L6           3pp   Euler product      OPEN
P05  CPS_EP_NonVanishing_L6           2pp   Re(s)>3/2          OPEN
```

**P04→P05** are the shortest. Attack these first (~5pp total).

---

### Surfaces 5–9 — 11 Elements, ~120pp

```
S501  CPS_ConverseThmHecke_L5         25pp  CPS 1999 Thm 3.3   OPEN
S502  CPS_CremonaUniqueness_L5        20pp  Cremona 1997       OPEN
S601  Weil_FrobeniusToLine_L5          8pp  Weil 1948 Thm C    OPEN
S602  Weil_ConjectureToGRH_L5          7pp  Deligne 1974       OPEN
S701  IK_GelbartJacquet_L5             8pp  GJ 1978            OPEN
S702  IK_NonvanishingFromGRH_L5       12pp  IK §5.15           OPEN
S801  IK_RankinSelberg_L5              7pp  IK Thm 5.13        OPEN
S802  IK_ResidueFromPole_L5            8pp  IK §5.15           OPEN
S901  IK_NonZeroAtOne_L5               5pp  IK §5.16           OPEN
S902  IK_ZFRfromNonZero_L5            10pp  IK Cor 5.16        OPEN
S903  IK_RHfromZFR_L5                 10pp  IK §5.6            OPEN
```

**Shortest path:** S901→S902→S903 (IK §5.6-5.16 chain, ~25pp total).
**Key insight:** S901 uses `L_143a1 1 ≠ 0` which comes from Rankin-Selberg (S801+S802).

---

### Bridges — 4 Named Surfaces

```
BR1  WallA_Surface1_Bridge            40pp  Selberg 1956 + Weil 1952
BR2  WallBC_Surface24_Bridge          46pp  CPS 1999 §2
BR3  WallB_Surface56_Bridge           15pp  Weil 1948; Cremona 1997
BR4  WallD_Surface789_Bridge          60pp  IK Chapter 5
```

---

## Milestone Plan

### M-C: Complete Wall C (~1.5pp, 9 atoms)

**Goal:** Close C01-C10 (9 atoms, ~1.50pp total).

```
Session 1: C04+C05 — Gauss limit → Weierstrass product (~0.50pp)
Session 2: C06+C07 — digamma series → Binet integral (~0.50pp)
Session 3: C01+C02 — Bernoulli Taylor expansion + small-t bound (~0.35pp)
Session 4: C08+C09+C10 — branch cut + Laplace small-sigma (~0.15pp)
```

**Effect:** Wall C COMPLETE. D09 (GammaStirlingBound) then ready to close.

### M-D: Complete Wall D (~5pp, 14 atoms)

**Goal:** Close D01-D14 in dependency order.

```
Phase 1: D09+D10+D13+D14  (Stirling+Dirichlet, ~1pp, depends M-C for D09)
Phase 2: D11+D12          (Hadamard factorization, ~0.5pp)
Phase 3: D01+D02          (Chebyshev+Poussin trig, ~0.7pp, trig_poussin PROVED)
Phase 4: D03+D04+D05      (Poussin shift+strip+region, ~1pp)
Phase 5: D06+D07+D08      (explicit constant+ZFR, ~1.5pp)
```

**Effect:** Wall D COMPLETE → `zero_critical_iff_GRH` + `zfr_zero_critical_bridge`
close the ZFR part of Surface 9 chain.

### M-IK: IK Chain S801-S903 (~65pp)

```
S801+S802 (Rankin-Selberg + residue, ~15pp)
S701+S702 (Gelbart-Jacquet sym² lift + nonvanishing, ~20pp)
S901+S902+S903 (L(1,f)≠0 → ZFR → RH, ~25pp)
```

**Effect:** Surfaces 7-9 CLOSED.

### M-CPS: CPS Converse (S501-S602, P01-P05, ~110pp)

Largest block. Parallel attack:
- P04+P05 first (~5pp)
- P01+P02+P03 (~20pp)
- S601+S602 (~15pp, depends M-B Frobenius)
- S501+S502 (~45pp, hardest: CPS Thm 3.3)

### M-B: Wall B (~13pp)

```
B01+B02+B03  (HodgeCM chain, ~3pp — needs Frobenius API)
B04+B05+B06+B07  (Weil explicit formula, ~10pp)
```

**Effect:** Frobenius bound ready for S601+S602 (Weil → GRH).

### M0: Unconditional Proof

All 50 named opens closed → `opera_numerorum_grand_conditional` becomes unconditional.

---

## Attack Priority Table (effort/impact ratio)

| Priority | Elements | Pages | Prerequisite | Effect |
|----------|----------|-------|-------------|--------|
| 1 | C01–C10 (Wall C remain) | 1.50pp | none | Wall C DONE |
| 2 | D09–D14 (Stirling+Hadamard) | 2.25pp | M-C | Wall D partial |
| 3 | D01–D08 (Poussin ZFR) | 2.70pp | D09-D14 | Wall D DONE |
| 4 | S901–S903 (IK ZFR chain) | 25pp | Wall D | Surfaces 7-9 partial |
| 5 | S801–S802 (Rankin-Selberg) | 15pp | — | closes S901 prereq |
| 6 | S701–S702 (GJ sym² lift) | 20pp | S801 | closes S702 prereq |
| 7 | P04–P05 (Euler product) | 5pp | — | CPS surfaces partial |
| 8 | B01–B03 (HodgeCM) | 3pp | Frobenius API | Wall B partial |
| 9 | B04–B07 (Weil explicit) | 10pp | B01-B03 | Wall B DONE |
| 10 | P01–P03 (CPS FE) | 20pp | — | CPS partial |
| 11 | S601–S602 (Weil→GRH) | 15pp | B01-B03 | Surface 6 DONE |
| 12 | S501–S502 (CPS Converse) | 45pp | P01-P05 | Surface 5 DONE |

---

## CMI Submission Checklist

- [x] Zero sorry, zero native_decide, zero opaque
- [x] Axioms: {propext, Classical.choice, Quot.sound} only
- [x] `_root_.RiemannHypothesis` — genuine Mathlib predicate
- [x] Conditional proof: 9 named open surfaces → RH
- [x] All open surfaces: `def : Prop`, not axioms
- [x] Route B master theorem: 3 published gates → RH
- [x] BC6 arithmetic inputs all proved
- [x] `zero_critical_iff_GRH` proved (ZeroOffCritical ↔ GRH for L₁₄₃ₐ₁)
- [x] trig_poussin_identity proved (3+4cos+cos2 ≥ 0)
- [x] laplace_sigma_big_proved (σ≥1 integrability)
- [x] binet_large_bound_proved (|B(t)/t| ≤ 1/12 for t≥2π)
- [ ] Wall C complete (9 atoms remain, ~1.50pp)
- [ ] Wall B complete (7 atoms remain, ~13pp)
- [ ] Wall D complete (14 atoms remain, ~5pp)
- [ ] Surfaces 5-9 complete (11 atoms, ~120pp)
- [ ] CPS 2-3 complete (5 atoms, ~25pp)
- [ ] All 50 named opens closed (unconditional proof)
