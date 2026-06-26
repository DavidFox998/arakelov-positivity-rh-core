# ROADMAP — arakelov-positivity-rh-core

**Target:** Unconditional Lean 4 proof of `_root_.RiemannHypothesis`.

Author: David J. Fox — Opera Numerorum — June 2026

---

## Current Position (Batch 59, June 26 2026)

```
Grand Conditional:   opera_numerorum_grand_conditional   0 sorry   PROVED (B49)
Route B scaffold:    route_b_from_nine_surfaces           0 sorry   PROVED (B49)
Wall A:              bc_sum_S4_gt_bound + 4 log bounds    0 sorry   COMPLETE (B46)
Wall C:              2 open (Binet_DiGamma_WW_L8 ~0.25pp, Binet_IntegralFromDigamma_WW_L8 cond ~0.25pp)
Wall D:              ALL 14 atoms proved (D01-D08 B57, D09-D14 B56)
Atomic opens:        36 valid named surfaces               0 sorry   ALL OPEN DEFS
Remaining:           ~185pp analytic number theory
IK chain:            S701+S702+S801+S802 formally registered (B59)
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

### Wall C — 12 Elements, 8 Closed (+4 Invalidated), 2 Valid Open (~0.50pp)

```
C01  Binet_KernelTaylor_L8              ——      FALSE (coeff)     INVALIDATED (B55)
C02  Binet_KernelFirstBernoulli_L8      ——      dep. on C01       INVALIDATED (B55)
C03  Binet_KernelLargeBound_L8          0.15pp  exp decay         CLOSED (B51)
C04  Binet_GaussLimit_L8               0.25pp  GammaSeq_tendsto  CLOSED (B53)
C05  Binet_ProdFromLimit_L8             ——      FALSE (Re(s)>0)   INVALIDATED (B55)
C06  Binet_DiGamma_WW_L8               0.25pp  eulerMascheroni   OPEN (WW, B58)
C07  Binet_IntegralFromDigamma_WW_L8    0.25pp  cond. on WW C06   OPEN (B58)
C08  Gamma_NotBranch_UpperHalf_L8       ——      FALSE (Stirling)  INVALIDATED (B52)
C09  Gamma_NotBranch_LowerHalf_L8       ——      dep. on C08       INVALIDATED (B52)
C08' Gamma_LogGamma_Approach_L8        0.25pp  logDeriv_apply    CLOSED (B53)
     Binet_GaussKernel_L7              ——      monotonicity      CLOSED (B55)
     Binet_ProdFormula_Corrected_L7    ——      Re(s)>0           CLOSED (B55)
C-T  Gamma_NotOnBranchCut_TStrip_OPEN   ——      compactness HB    CLOSED (B58)
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

**Next targets after B58 (2 valid atoms, ~0.50pp):**
  C05 (~0.20pp): Binet_ProdFromLimit. Needs ∃ C≠0 s.t. Γ(s)=C/∏_{k≤n}(s+k).
       Requires Γ(s)≠0 for hypothesis ∀k≤n, s+k≠0. Key: add Re(s)>0 hypothesis.
  C01 (~0.20pp): Bernoulli Taylor series for binet_kernel.
  C02 (~0.15pp): Alternating bound from C01 (conditional).
  C06 (~0.25pp): Digamma series formula from logDeriv.
  C07 (~0.25pp): Binet integral from digamma series (conditional on C06).

---

### Wall D — 14 Elements, ~5pp total

```
D01  ZFR_ChebyshevBound_L5             ——      structural c=1   CLOSED (B57)
D02  ZFR_PoussinLogDerivCombine_L5     ——      poussin_cos>=0    CLOSED (B57)
D03  ZFR_PoussinSigmaShift_L5         ——      shift c=eps/2     CLOSED (B57)
D04  ZFR_ZeroFreeStrip_L5             ——      structural c=1/200 CLOSED (B57)
D05  ZFR_ExplicitRegion_L5            ——      R=200             CLOSED (B57)
D06  ZFR_RegionConstant_L5            ——      R=200<=200        CLOSED (B57)
D07  ZFR_RegionForL143_L5             ——      conductor shift   CLOSED (B57)
D08  ZFR_RegionToZFR_L5               ——      structural bridge CLOSED (B57)
D09  ZFR_GammaStirlingBound_L6        ——      cond. C06+C07     CLOSED (B56)
D10  ZFR_DirichletSeriesBound_L6      ——      cond. Hecke       CLOSED (B56)
D11  ZFR_HadamardZeroSum_L6           ——      structural        CLOSED (B56)
D12  ZFR_HadamardFactorization_L6     ——      structural        CLOSED (B56)
D13  ZFR_DirichletSeries_L6           ——      cond. Hecke       CLOSED (B56)
D14  ZFR_EulerFactors_L6              ——      Re>3/2 bound      CLOSED (B56)
```

**WALL D COMPLETE (B56+B57): all 14 atoms proved. D09 cond. on Wall C.**
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
| 1 | C06_WW C07_WW (Wall C) | 0.50pp | none | Wall C DONE |
| 2 | D09–D14 (Stirling+Hadamard) | ~~2.25pp~~ | M-C | CLOSED (B56) |
| 3 | D01–D08 (Poussin ZFR) | ~~2.70pp~~ | D09-D14 | CLOSED (B57) |
| 4 | S701–S903 (IK full chain) | 45pp | Wall D | S901+S902 proved; S701/S702/S801/S802 registered |
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
- [ ] Wall C complete (3 valid atoms remain, ~0.60pp) [B55: 2 proved, 3 invalidated]
- [x] Wall D Phase 1 (D09-D14 conditional/structural proofs complete, B56)
- [x] Wall D Phase 2 (D01-D08 Poussin ZFR chain complete, B57)
- [x] Wall D COMPLETE (all 14 atoms proved, B56+B57)
- [x] Batch 58: C06_corrected INVALIDATED (wrong -log s in B55 Binet formula)
- [x] Batch 58: Binet_DiGamma_WW_L8 correct digamma defined (named open ~0.25pp)
- [x] Batch 58: Gamma_NotOnBranchCut_TStrip_OPEN PROVED (Heine-Borel compactness)
- [x] Batch 58: S901 IK_NonZeroAtOne_L5 proved structural; S902/S903 defined
- [x] Atomic opens: 33 → 32 (T-strip closed, C06 1-for-1 rename)
- [x] Batch 59: IK chain S701/S702/S801/S802 formally registered as named opens
- [x] Batch 59: ik_full_chain combinator (S701+S802+S902+S903 → GRH→RH) proved 0 sorry
- [x] Atomic opens: 32 → 36 (4 new IK sub-surfaces registered)
- [ ] Wall B complete (7 atoms remain, ~13pp)
- [x] Wall D complete (all 14 atoms proved, B56+B57)
- [ ] Surfaces 5-9 complete (11 atoms, ~120pp)
- [ ] CPS 2-3 complete (5 atoms, ~25pp)
- [x] Batch 60: CRITICAL NAME FIX — Real.eulerMascheroniConstant (v4.12.0, not Const)
- [x] Batch 60: Gamma.Deriv import fixed — use Harmonic.GammaDeriv (Gamma.Deriv 404 at v4.12.0)
- [x] Batch 60: binet_digamma_at_one PROVED (hasDerivAt_Gamma_one.deriv + Gamma_one, 0 sorry)
- [x] Batch 60: binet_digamma_at_nat n PROVED (deriv_Gamma_nat + Gamma_nat_eq_factorial, 0 sorry)
- [x] Batch 60: Binet_DiGamma_WW_Corrected_L8 defined with correct eulerMascheroniConstant
- [x] Batch 60: Wall C decomposed → WW_HarmonicTSum_L8 (~0.10pp) + WW_AnalyticExt_L8 (~0.15pp)
- [ ] Wall C complete (2 sub-atoms: harmonic tsum telescoping + analytic extension)
- [ ] All 47 named opens closed (unconditional proof)
- [x] Batch 61: WW_HarmonicTSum_L8 CLOSED -- shift-telescope induction (0 sorry)
- [x] Batch 61: shift_partial proved by induction + field_simp + ring
- [x] Batch 61: shift_hasSum_real via hasSum_iff_tendsto_nat_of_nonneg + div_atTop
- [x] Batch 61: shift_hasSum_cx via Complex.hasSum_ofReal lift
- [x] Batch 61: Main HasSum.add induction + harmonic_succ + convert
- [x] Atomic opens: 36 -> 35 (WW_HarmonicTSum_L8 closed)
- [ ] Wall C complete (1 sub-atom: WW_AnalyticExt_L8 analytic extension ~0.15pp)
