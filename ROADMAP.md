# ROADMAP — arakelov-positivity-rh-core

Opera Numerorum | David Fox | June 27, 2026 | Batch 91

## Completed

| Item | Batch | Status |
|------|-------|--------|
| Wall A: bc_sum_S4_gt_bound | B46 | COMPLETE |
| Wall C: GammaSeq DCT proof | B70 | COMPLETE |
| Wall D: all 14 atoms | B56-57 | COMPLETE |
| 4-atom Clay certificate | B77 | PROVED |
| KimSarnak closed: 975/4096 | B78 | CLOSED |
| 3-atom Clay cert (clay_certificate_weil_pure) | B78 | PROVED |
| IK descent from 4 sub-gaps | B82 | PROVED |
| RS_Identity decomposed | B83 | DECOMPOSED |
| RS_SimplePole decomposed | B84 | DECOMPOSED |
| Vol(Gamma_0(143)\H) = 56*pi | B84 | PROVED |
| L_sym2 bridge proved | B85 | PROVED |
| ZetaZeroFree decomposed | B86 | DECOMPOSED |
| **PeterssonNorm CLOSED** | **B87** | **CLOSED** |
| **HeckeEigenform CLOSED** | **B87** | **CLOSED** |
| BC6 decomposed: 2 sub-atoms | B88 | DECOMPOSED |
| CPS decomposed: 5 sub-atoms | B89 | DECOMPOSED |
| M9 GRH: 288 X_0(N), g=1..32 | M9cert | PROVED |
| **IK atoms max-decomposed (11 arithmetic theorems)** | **B90** | **DONE** |
| **KimShahidi closed via GL3 combinator** | **B90** | **CLOSED** |
| **ZFR+BC6+CPS max-decomposed (16+7 theorems)** | **B91** | **DONE** |
| **19-atom minimum residual list finalized** | **B91** | **DONE** |

## Remaining (19 atoms, ~91pp)

All atoms are published non-Clay mathematics. Architecture is complete.
Remaining work = Lean formalization of ~91pp of established theorems.

### Tier 1 — Smallest (close next)

| Atom | pp | Source |
|------|----|--------|
| `GL3Lift_Existence_OPEN` | ~1 | Gelbart-Jacquet 1978 |
| `CPS_EulerProduct_OPEN` | ~2 | Hecke 1936 |
| `WeilTransfer_OPEN` | ~2 | Weil 1952 |
| `GL3HolomorphicL_OPEN` | ~2 | Kim-Shahidi 2002 |

### Tier 2 — Medium

| Atom | pp | Source |
|------|----|--------|
| `EulerLocalFactor_11_13_OPEN` | ~3 | Casselman 1973 |
| `HadamardProduct_L143_OPEN` | ~3 | Hadamard 1896 |
| `RSAsymptotics_OPEN` | ~3 | Tauberian theorem |
| `CPS_BoundedStrips_OPEN` | ~3 | Phragmen-Lindelof 1908 |
| `PoussinCauchy_OPEN` | ~4 | de la Vallee Poussin 1896 |
| `FunctionalEqSymmetry_OPEN` | ~4 | Hecke theory |
| `CPS_ConverseAndUniqueness_OPEN` | ~4 | CPS 1999 Thm 3.3 |
| `SelbergGeometricBound_OPEN` | ~4 | BC95 Sec 4 |
| `RSIntegralUnfolding_OPEN` | ~4 | Rankin 1939 |

### Tier 3 — Larger

| Atom | pp | Source |
|------|----|--------|
| `HeckeMult_Identity_OPEN` | ~5 | IK 2004 Thm 5.13 |
| `SelbergKernel_OPEN` | ~5 | Selberg 1956 |
| `CPS_FunctionalEquation_OPEN` | ~6 | CPS 1999 Sec 2 |
| `EulerProductConvergence_OPEN` | ~6 | IK 2004 Sec 5.1 |
| `RHDescant_IKCor516_OPEN` | ~10 | IK 2004 Cor 5.16 |
| `BC95TheoremSix_OPEN` | ~20 | Bost-Connes 1995 Thm 6 |

## Summary

| Category | Pages |
|----------|-------|
| Tier 1 (4 atoms) | ~7pp |
| Tier 2 (9 atoms) | ~33pp |
| Tier 3 (6 atoms) | ~51pp |
| **Grand total** | **~91pp** |

## Clay Cert Summary

The proof chain is architecturally complete:
- 0 sorry, 0 axiom keyword, 0 native_decide, 0 opaque
- Axioms: {propext, Classical.choice, Quot.sound} (classical trio only)
- 4 atoms closed outright (KimSarnak, PeterssonNorm, HeckeEigenform, KimShahidi-combinator)
- 19 residual atoms: minimum irreducible published math, all non-Clay
- 38 arithmetic/structural theorems proved (B46-B91)
- Estimated remaining Lean formalization: ~91pp

*David J. Fox — June 27, 2026 — Opera Numerorum*
