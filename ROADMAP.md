# ROADMAP — arakelov-positivity-rh-core

**Target:** Unconditional Lean 4 proof of `_root_.RiemannHypothesis`.

Author: David J. Fox — Opera Numerorum — June 2026

---

## Current Position (June 26 2026)

```
Conditional proof:  route_b_clay_certificate    0 sorry   DONE
                    rh_from_all_atomic_surfaces  0 sorry   DONE
Proved bricks:      90+                                    DONE
Wall A:             4 log bounds for S4         0 sorry   DONE
Wall C (partial):   sin identity closed         0 sorry   DONE
BC6 prereqs:        genus=13, nu2=nu3=0, C>2*sqrt(13)     DONE
Remaining open:     19 named surfaces           ~200pp Lean
```

---

## The Four Walls

### Wall A — COMPLETE

All four log lower bounds for S₄ = {2,3,19,191}:
- log 2 > 0.69, log 3 > 1.09, log 19 > 2.94, log 191 > 5.25
- File: `ExpLogBoundsSubClosure.lean`
- Discharges `gate_bc6` in `opera-sieve/lean/bost_connes.lean`

### Wall C — Partially closed (~13pp remain)

**Closed:** sin modulus identity (`wall_c_sin_identity_complete`, 0 sorry)
- sin(pi*s) normSq = sin(pi*s.re)^2 + sinh(pi*s.im)^2

**Open (~13pp):**
- `Stirling_Binet_OPEN` (~8pp): Binet's second formula log Gamma(s)
  - Reference: Binet 1838; Whittaker-Watson §12.3
  - Method: contour integral of log(1 + t/s) over [0, infinity)
  - Lean API: Complex.integral_comp, Summable bounds for the Binet series
- `Stirling_Remainder_OPEN` (~5pp): |Gamma(s)| ~ sqrt(2*pi)*|T|^(Re(s)-1/2)*exp(-pi*|T|/2)
  - Depends on Stirling_Binet_OPEN
  - Closes Surface 18+19 of the 19 open surfaces

**Next attack (shortest path to close):** Stirling_Binet_OPEN via Binet integral.

### Wall B — Algebraic half proved (~25pp remain)

**Proved (Batch 30):** `hasse_implies_ramanujan_normSq`
- alpha*beta = p, alpha+beta = a (int), a^2 <= 4p -> normSq(alpha) = p
- This is the algebraic Ramanujan lemma (pure complex arithmetic, 0 sorry)

**Open (~25pp):** `EP_HasseAllPrimes_OPEN`
- Hasse bound |a_p|^2 <= 4p for ALL primes p (not just finite set)
- Source: Hasse 1936, Weil 1948 (RH for curves over finite fields)
- ClassNumber-143 proves it for 168 primes p <= 997 by `rfl`
- Lean gap: Frobenius API for elliptic curves over F_p (Weil theorem)

**Next attack:** Import Weil's theorem for elliptic curves when Mathlib API available.

### Wall D — CPS Converse Theorem (~105pp total, largest wall)

`CU_ConverseHalfPlane_OPEN` (~35pp) is the single largest gap in the project.

**Sub-surfaces (Batch 24 decomposition):**
- `TwistedL_HolomorphicStrip_OPEN` (~8pp): DifferentiableOn L on closed strips
- `TwistedL_PolyGrowth_OPEN` (~5pp): polynomial growth O(|T|^A)
- `PhragmenLindelof_Strip_OPEN` (~3pp): Phragmen-Lindelof API match

**Other CPS surfaces:**
- `FE_CompletedFunctionalEq_OPEN` (~5pp): completed functional equation for L(s,f)
- `CU_ExtendToAllC_OPEN` (~10pp): analytic identity theorem (Batch 24 decomposes to 3 sub-surfs)

---

## Milestone Plan

### Milestone R1 — Wall C Complete (~2 sessions)

**Goal:** Close Stirling_Binet_OPEN and Stirling_Remainder_OPEN (13pp total).

Steps:
1. Write `GammaStirlingBinet.lean`:
   - Binet integral formula: log Gamma(s) = (s-1/2)*log(s) - s + log(2*pi)/2 + J(s)
   - J(s) = int_0^inf (1/2 - 1/t + 1/(exp(t)-1)) * exp(-st)/t dt
   - Method: sum representation of J(s) as a Bernoulli number series
2. Write `GammaStirlingBound.lean`:
   - Derive |Gamma(s)| from log Gamma asymptotics
   - Close Stirling_Remainder_OPEN

**Effect:** Closes 2 of 19 open surfaces. Wall C COMPLETE.

### Milestone R2 — BC6 Spectral Bridge (~3 sessions)

**Goal:** Close BC6_SpectralBC95_OPEN using Batch 31 level-4 sub-surfaces.

**Prereqs all proved (Batch 31):**
- genus(X0(143)) = 13 [norm_num]
- nu2 = 0, nu3 = 0 (no CM points) [decide from Legendre symbols]
- C(S4) > 2*sqrt(13) [from ClassNumber-143 BostBound_143.lean]

**Remaining (~20pp):**
- `BC6_NoCM_SpectralData_L4_OPEN` (~5pp): spectral data for CM-free curves
- `BC6_TestFunction_L4_OPEN` (~8pp): BC95 §4 optimal test function h_T
- `BC6_ZeroCounting_L4_OPEN` (~7pp): N(T) counting via Selberg's lemma

### Milestone R3 — BC6 Selberg Match (~2 sessions)

**Goal:** Close BC6_SelbergMatch_OPEN (S_weil = S_spectral, 15pp).

Mathematical content:
- Selberg trace formula: Tr(h) = spectral sum + geometric sum
- Weil explicit formula: sum over zeros = sum over primes
- Eichler-Shimura: L-zeros correspond to Hecke eigenvalues
- Reference: Hejhal LNM 548, Theorem 9.4; BC95 §3

When R3 complete: Gate M1 closes. Two of three major gates done.

### Milestone R4 — IK Rankin-Selberg (~3 sessions)

**Goal:** Close IK surfaces (Surfaces 15–17 of 19).

Sub-surfaces to close:
- `IK_ZetaSimplePole_L3_OPEN` (~2pp): riemannZeta simple pole at s=1 [Mathlib hookup]
- `IK_Lsym2_NonzeroAt1_L3_OPEN` (~8pp): L(sym^2,1) != 0 [Kim-Shahidi 2002]
- `IK_RS_Split_L3_OPEN` (~5pp): RS = zeta * L_sym2 near s=1 [Shimura-Zagier]
- `IK_GRH_to_L_sym2_nv_OPEN` (~10pp): GRH -> L_sym2 nonzero [IK Thm 5.15]
- `IK_RS_L143_Link_OPEN` (~10pp): RS link for f_{143a1} [IK Thm 5.15]

When R4 complete: Gate M3 (IK) closes.

### Milestone R5 — CPS Converse Theorem (~5-6 sessions, hardest)

**Goal:** Close the CPS 1999 surfaces.

Dominant gaps:
- `CU_ConverseHalfPlane_OPEN` (~35pp): CPS Thm 3.3 — largest single gap
- `ZFR_DelaValleePoussin_OPEN` (~12pp): zero-free region
- `ZFR_RHFromWeilZeroFree_OPEN` (~18pp): descent from zero-free region

When R5 complete: Gate M2 (Langlands/CPS) closes.

### Milestone R6 — Unconditional Proof

When Milestones R1-R5 are complete:
- All 19 named open surfaces are closed
- `rh_from_all_atomic_surfaces` becomes fully unconditional
- `route_b_clay_certificate` becomes fully unconditional
- `_root_.RiemannHypothesis` is proved without any named open inputs

---

## Recommended Attack Order (by effort/impact ratio)

| Priority | Target | Pages | Impact |
|----------|--------|-------|--------|
| 1 | Wall C: Stirling_Binet + Stirling_Remainder | 13pp | Closes 2 surfaces, Wall C done |
| 2 | IK_ZetaSimplePole_L3_OPEN | 2pp | Advances Gate M3, Mathlib hookup |
| 3 | BC6 Level-4 sub-surfaces | 20pp | Advances Gate M1 |
| 4 | BC6_SelbergMatch_OPEN | 15pp | Gate M1 closes when done |
| 5 | Wall B: EP_HasseAllPrimes_OPEN | 25pp | Closes Surface 4 |
| 6 | IK surfaces (RS + sym2) | 35pp | Gate M3 closes |
| 7 | ZFR surfaces | 30pp | Gate M3 approaches |
| 8 | CPS surfaces (CU) | 50pp+ | Gate M2 closes |

---

## Cross-Repository Dependencies (read-only references)

| Repo | Status | What we use |
|------|--------|------------|
| DavidFox998/ClassNumber-143 | READ-ONLY | Genus=13, nu2=nu3=0, C(S4)>2*sqrt(13), h(-143)=10 |
| DavidFox998/yang-mills-gap | READ-ONLY | Spectral gap machinery (reference) |
| DavidFox998/opera-sieve | READ-ONLY | Wall A: gate_bc6 (bc_sum_S4_gt_bound proved) |

---

## CMI Submission Checklist

- [x] Zero sorry, zero native_decide, zero opaque
- [x] Axioms: {propext, Classical.choice, Quot.sound} only
- [x] _root_.RiemannHypothesis (genuine Mathlib predicate, not True)
- [x] Conditional theorem: 19 named open surfaces -> RH
- [x] All open surfaces: def Prop, not axioms
- [x] Route B master theorem: 3 published gates -> RH
- [x] Clay certification: RouteBClosed.lean (formal)
- [x] BC6 arithmetic inputs all proved (genus, no-CM, Bost threshold)
- [ ] Wall C complete (Stirling remain)
- [ ] Wall B complete (Hasse for all primes)
- [ ] All 19 surfaces closed (unconditional proof)
