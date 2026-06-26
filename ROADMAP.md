# ROADMAP — arakelov-positivity-rh-core

**Target:** Unconditional Lean 4 proof of `_root_.RiemannHypothesis`.

Author: David J. Fox — Opera Numerorum — June 2026

---

## Current Position (Batch 53, June 26 2026)

```
Grand Conditional:   opera_numerorum_grand_conditional   0 sorry   PROVED (B49)
Route B scaffold:    route_b_from_nine_surfaces           0 sorry   PROVED (B49)
Wall A:              bc_sum_S4_gt_bound + 4 log bounds    0 sorry   COMPLETE (B46)
Wall C closures:     7 atoms closed (SigmaBig B49, ZFR_Iso B50, KernelLarge B51,
                     LaplaceSmall B52, GaussLimit B53, C08' B53, LogDeriv B53);
                     2 INVALIDATED (C08+C09 false); 5 valid atoms open (~1.05pp)
Atomic opens:        47 valid named surfaces               0 sorry   ALL OPEN DEFS
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

### Wall C — 12 Elements, 7 Closed (+2 Invalidated), 5 Valid Open (~1.05pp)

```
C01  Binet_KernelTaylor_L8              0.20pp  W-W §12.31        OPEN
C02  Binet_KernelFirstBernoulli_L8      0.15pp  B₂=1/6            OPEN
C03  Binet_KernelLargeBound_L8          0.15pp  exp decay         CLOSED (B51)
C04  Binet_GaussLimit_L8               0.25pp  GammaSeq_tendsto  CLOSED (B53)
C05  Binet_ProdFromLimit_L8             0.20pp  Weierstrass       OPEN
C06  Binet_LogGammaSeries_L8            0.25pp  W-W §12.16        OPEN
C07  Binet_IntegralFromDigamma_L8       0.25pp  W-W §12.32        OPEN
C08  Gamma_NotBranch_UpperHalf_L8       ——      FALSE (Stirling)  INVALIDATED (B52)
C09  Gamma_NotBranch_LowerHalf_L8       ——      dep. on C08       INVALIDATED (B52)
C08' Gamma_LogGamma_Approach_L8        0.25pp  logDeriv_apply    CLOSED (B53)
C10  Laplace_IntegSigmaSmall_L10        0.15pp  rpow domination   CLOSED (B52)
C11  Laplace_IntegSigmaBig_L10          ——      domination        CLOSED (B49)
C12  ZFR_Isolated_PathA                 ——      Mathlib analytic  CLOSED (B50)
```

**Closure method for C04 (B53):**
  `binet_gauss_limit_proved`: `Complex.GammaSeq_tendsto_Gamma s` matches C04 exactly.
  Proof: `intro s _; exact Complex.GammaSeq_tendsto_Gamma s`. 3 lines.

**Closure method for C08' (B53):**
  `Gamma_LogGamma_C08prime_closed`: `logDeriv_apply Complex.Gamma s` is rfl.
  Key: Complex.logGamma does NOT exist in Mathlib v4.12.0 — use `logDeriv Complex.Gamma`.

**Closure method for binet_log_deriv_direct (B53, supersedes B46):**
  `HasDerivAt.clog` (Complex/LogDeriv.lean L95–97):
  Given `HasDerivAt Complex.Gamma g' s` and `Complex.Gamma s ∈ slitPlane`,
  returns `HasDerivAt (Complex.log ∘ Complex.Gamma) (g' / Complex.Gamma s) s`.
  Note: supersedes B46 combinator (which required false Gamma_LogDiff_OPEN).

**C08 INVALIDATION (B52, CRITICAL):**
  `Gamma_NotBranch_UpperHalf_L8_OPEN` (`|arg Γ(s)| < π/2`) is **FALSE**.
  By Stirling: `arg(Γ(σ+iτ)) ≈ τ log τ − τ + O(log τ)` — unbounded.
  **Also**: `Gamma_NotOnBranchCut_OPEN` (`arg Γ(s) ≠ π`) is SUSPECTED FALSE for
  large Im(s) (Stirling implies arg cycles through all values). Remains as named open.
  **Fix**: B53's `binet_log_deriv_direct` uses `HasDerivAt.clog` directly,
  sidestepping the branch-cut issue entirely.

**Batch 53 API key facts:**
  - `Complex.logGamma` does NOT exist in Mathlib v4.12.0.
  - `Complex.GammaSeq_tendsto_Gamma`: holds for ALL s : ℂ (not just Re>0).
  - `logDeriv_apply f x : logDeriv f x = deriv f x / f x` is rfl.
  - `HasDerivAt.clog` eliminates need for `DifferentiableAt Complex.log` separately.

**Next targets (5 valid atoms, ~1.05pp):**
  C05 (~0.20pp): Binet_ProdFromLimit. Needs ∃ C≠0 s.t. Γ(s)=C/∏_{k≤n}(s+k).
       Requires Γ(s)≠0 for hypothesis ∀k≤n, s+k≠0. Key: add Re(s)>0 hypothesis.
  C01 (~0.20pp): Bernoulli Taylor series for binet_kernel.
  C02 (~0.15pp): Alternating bound from C01 (conditional).
  C06 (~0.25pp): Digamma series formula from logDeriv.
  C07 (~0.25pp): Binet integral from digamma series (conditional on C06).

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
**D01–D02:** trig_poussin_identity (3+4cos+cos2≥0) is PROVED (B48). Use it.
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

**Shortest path:** S901→S902→S903 (IK §5.6–5.16 chain, ~25pp total).
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

### M-C: Complete Wall C (~1.05pp, 5 atoms remaining)

```
Session 1: C05 — Binet_ProdFromLimit from C04 Gauss limit (~0.20pp)
Session 2: C06+C07 — digamma series → Binet integral (~0.50pp)
Session 3: C01+C02 — Bernoulli Taylor + alternating bound (~0.35pp)
```

**Effect:** Wall C COMPLETE. D09 (GammaStirlingBound) then ready to close.

### M-D: Complete Wall D (~5pp, 14 atoms)

```
Phase 1: D09+D10+D13+D14  (Stirling+Dirichlet, ~1pp, depends M-C for D09)
Phase 2: D11+D12          (Hadamard factorization, ~0.5pp)
Phase 3: D01+D02          (Chebyshev+Poussin trig, ~0.7pp, trig_poussin PROVED)
Phase 4: D03+D04+D05      (Poussin shift+strip+region, ~1pp)
Phase 5: D06+D07+D08      (explicit constant+ZFR, ~1.5pp)
```

**Effect:** Wall D COMPLETE → `zero_critical_iff_GRH` closes ZFR part of Surface 9.

### M-IK: IK Chain S801–S903 (~65pp)

```
S801+S802 (Rankin-Selberg + residue, ~15pp)
S701+S702 (Gelbart-Jacquet sym² lift + nonvanishing, ~20pp)
S901+S902+S903 (L(1,f)≠0 → ZFR → RH, ~25pp)
```

### M-CPS: CPS Converse (S501–S602, P01–P05, ~110pp)

- P04+P05 first (~5pp)
- P01+P02+P03 (~20pp)
- S601+S602 (~15pp, depends M-B Frobenius)
- S501+S502 (~45pp, hardest: CPS Thm 3.3)

### M-B: Wall B (~13pp)

```
B01+B02+B03  (HodgeCM chain, ~3pp — needs Frobenius API)
B04+B05+B06+B07  (Weil explicit formula, ~10pp)
```

### M0: Unconditional Proof

All 47 named opens closed → `opera_numerorum_grand_conditional` becomes unconditional.

---

## Attack Priority Table (effort/impact ratio)

| Priority | Elements | Pages | Prerequisite | Effect |
|----------|----------|-------|-------------|--------|
| 1 | C01 C02 C05 C06 C07 (Wall C) | 1.05pp | none | Wall C DONE |
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
- [x] laplace_sigma_small_proved (exp(-σt) integrable on Ioi(0), 0<σ<1)
- [x] binet_gauss_limit_proved (C04 CLOSED via GammaSeq_tendsto_Gamma)
- [x] Gamma_LogGamma_C08prime_closed (C08' CLOSED via logDeriv_apply)
- [x] binet_log_deriv_direct (PROVED via HasDerivAt.clog; B46 combinator superseded)
- [x] C08+C09 invalidated (false statements); C08' logDeriv approach CLOSED
- [ ] Wall C complete (5 valid atoms remain, ~1.05pp)
- [ ] Wall B complete (7 atoms remain, ~13pp)
- [ ] Wall D complete (14 atoms remain, ~5pp)
- [ ] Surfaces 5-9 complete (11 atoms, ~120pp)
- [ ] CPS 2-3 complete (5 atoms, ~25pp)
- [ ] All 47 named opens closed (unconditional proof)
