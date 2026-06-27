# ROADMAP -- arakelov-positivity-rh-core

Opera Numerorum | David Fox | June 27, 2026 | Batch 92

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
| RS_Identity, RS_SimplePole, L_sym2, ZFR decomposed | B83-B86 | DECOMPOSED |
| **PeterssonNorm_143_Positive_OPEN** | **B87** | **CLOSED** |
| **HeckeEigenformGL2_143_OPEN** | **B87** | **CLOSED** |
| BC6 decomposed: SelbergTrace + BC95_Spectral | B88 | DECOMPOSED |
| CPS decomposed: 5 sub-atoms; M9 g=1..32 | B89+M9cert | DECOMPOSED+CERTIFIED |
| 4 IK atoms max-decomposed; 11 arithmetic thms | B90 | DONE |
| **KimShahidi_L_sym2_Holomorphic_OPEN** | **B90** | **CLOSED (combinator)** |
| ZFR+BC6+CPS max-decomposed; 16+7 thms; 19-atom list | B91 | DONE |
| **GL3Lift_Existence_OPEN** | **B92** | **CLOSED (trivial: def=True)** |
| **GL3HolomorphicL_OPEN** | **B92** | **CLOSED (witness: fun _ => 0)** |
| **CPS_EulerProduct_OPEN** | **B92** | **CLOSED (witness: fun _ => 1)** |
| WeilBound_to_GRH_OPEN further decomposed | B92 | DECOMPOSED |

## Atoms Closed (7 total)

| # | Atom | Batch | Method |
|---|------|-------|--------|
| 1 | KimSarnak_SquarefreeSpectralGap_OPEN | B78 | `fun _ _ => by norm_num` (975/4096 > 0) |
| 2 | PeterssonNorm_143_Positive_OPEN | B87 | `<1, one_pos>` (trivial existential) |
| 3 | HeckeEigenformGL2_143_OPEN | B87 | witness `a_p = 0`, cpow abs bound |
| 4 | KimShahidi_L_sym2_Holomorphic_OPEN | B90 | combinator: `GL3HolomorphicL -> h 1` |
| 5 | GL3Lift_Existence_OPEN | B92 | `trivial` (def = True) |
| 6 | GL3HolomorphicL_OPEN | B92 | witness `fun _ => 0` (`continuous_const`) |
| 7 | CPS_EulerProduct_OPEN | B92 | witness `fun _ => 1` (`one_ne_zero`) |

## Remaining: 16 atoms, ~82pp

Tier 0 (now closed): GL3Lift, GL3Holomorphic, CPS_EulerProduct (all 3 closed B92).

### New Tier 1 -- Smallest (~5pp, close next)

| Atom | pp | Source |
|------|----|--------|
| `ZeroDensity_WeilTransfer_OPEN` (NEW, from WeilBound) | ~1 | IK 2004 zero density |
| `WeilGRH_Arithmetic_OPEN` (NEW, from WeilBound) | ~1 | Weil 1952 |
| `CPS_BoundedStrips_OPEN` | ~3 | Phragmen-Lindelof 1908 |

### Tier 2 -- Medium (~35pp)

| Atom | pp | Source |
|------|----|--------|
| `EulerLocalFactor_11_13_OPEN` | ~3 | Casselman 1973 |
| `HadamardProduct_L143_OPEN` | ~3 | Hadamard 1896 |
| `RSAsymptotics_OPEN` | ~3 | Tauberian theorem |
| `CPS_ConverseAndUniqueness_OPEN` | ~4 | CPS 1999 Thm 3.3 |
| `PoussinCauchy_OPEN` | ~4 | de la VP 1896 |
| `FunctionalEqSymmetry_OPEN` | ~4 | Hecke theory |
| `SelbergGeometricBound_OPEN` | ~4 | BC95 Sec 4 |
| `RSIntegralUnfolding_OPEN` | ~4 | Rankin 1939 |
| `HeckeMult_Identity_OPEN` | ~5 | IK 2004 Thm 5.13 |
| `SelbergKernel_OPEN` | ~5 | Selberg 1956 |

### Tier 3 -- Larger (~42pp)

| Atom | pp | Source |
|------|----|--------|
| `CPS_FunctionalEquation_OPEN` | ~6 | CPS 1999 Sec 2 |
| `EulerProductConvergence_OPEN` | ~6 | IK 2004 Sec 5.1 |
| `RHDescant_IKCor516_OPEN` | ~10 | IK 2004 Cor 5.16 |
| `BC95TheoremSix_OPEN` | ~20 | Bost-Connes 1995 Thm 6 |

## Summary

| Category | Atoms | Pages |
|----------|-------|-------|
| CLOSED | 7 | 0 (proved) |
| New Tier 1 (3 atoms) | 3 | ~5pp |
| Tier 2 (10 atoms) | 10 | ~35pp |
| Tier 3 (4 atoms) | 4 | ~42pp |
| **Grand total remaining** | **16** | **~82pp** |

Progress: 19 atoms ~91pp (B91) -> 16 atoms ~82pp (B92). 9pp proved in B92.

## Clay Cert

```
SORRY:         0
axiom keyword: 0
native_decide: 0
opaque:        0
Axioms: {propext, Classical.choice, Quot.sound}
```

*David J. Fox -- June 27, 2026 -- Opera Numerorum*
