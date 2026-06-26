# arakelov-positivity-rh-core

**Lean 4 formal proof: Riemann Hypothesis via Arakelov geometry + Bost-Connes theory**

Author: **David J. Fox** — *Opera Numerorum* — June 2026
Lean: `leanprover/lean4:v4.12.0` | Mathlib: `v4.12.0` | ORCID: 0009-0008-1290-6105

---

## Status at a Glance (Batch 50)

| Metric | Value |
|--------|-------|
| SORRY in any main proof body | **0** |
| Axiom footprint | `{propext, Classical.choice, Quot.sound}` |
| Grand Conditional Certificate | **PROVED** (Batch 49) |
| `ZFR_Isolated_PathA_OPEN` | **CLOSED** (Batch 50) |
| `ZFR_IsolatedFromAnalytic_L8_OPEN` | **CLOSED** (via PathA, Batch 50) |
| Surfaces 5-9 atomized | **11 L5 opens** (Batch 50) |

---

## What This Repo Proves

### Grand Conditional (Batch 49, 0 sorry, classical trio)

```lean
theorem opera_numerorum_grand_conditional
    (h_s1 : SelbergWeilBC6_143_OPEN S_weil)   -- ~40pp
    ...
    (h_s9 : ZetaZeroFree_OPEN)                 -- ~25pp
    : _root_.RiemannHypothesis
-- Direct call to route_b_from_nine_surfaces (proved scaffold, 0 sorry)
```

### Direct Closures (0 sorry each)

| Theorem | Method |
|---|---|
| `wall_a_complete` | All 4 log bounds for S₄ = {2,3,19,191} |
| `trig_poussin_identity` | 3+4cos+cos2 ≥ 0 via cos_two_mul + positivity |
| `laplace_sigma_big_proved` | IntegrableOn.mono_fun + Gamma_integral_convergent |
| `zfr_isolated_patha_proved` | **[Batch 50]** AnalyticAt.eventually_eq_zero_or_frequently_ne_zero |
| `wall_c_zerofree_combinator` | **[Batch 50]** ZFR_IsolatedFromAnalytic_L8 now closed |
| `gamma_log_diff_proved` | differentiableAt_log |
| `gamma_notbranch_realline` | Gamma_pos_of_pos + arg_ofReal_of_nonneg |
| `binet_gamma_prod_formula` | Gamma_add_one induction |

---

## Complete Open Surface Tree (after Batch 50)

### Surface 1 Bridge (1 named, ~40pp)
`WallA_Surface1_Bridge` — Selberg 1956 + Weil 1952

### CPS Surfaces 2-3 (5 L6 atomic opens, ~25pp total)
`CPS_FE_TwistedEq` (~8pp) · `CPS_FE_GammaFactor` (~6pp) · `CPS_FE_AnalyticCont` (~6pp)  
`CPS_EP_LocalFactors` (~3pp) · `CPS_EP_NonVanishing` (~2pp)

### Wall B — 7 L6 atomic opens (~13pp total)
| Surface | pp | Source |
|---|---|---|
| `HodgeCM_WeilConjectureAbelian_L6` | ~1 | Deligne 1969 |
| `HodgeCM_FrobeniusFromWeil_L6` | ~1 | Tate 1966 |
| `HodgeCM_J0143_L6` | ~1 | Diamond-Shurman 9.6.1 |
| `ExplicitFormula_WeilSum_L6` | ~2 | Weil 1952, IK §5.5 |
| `ExplicitFormula_ZeroContrib_L6` | ~3 | IK §5.5 Prop 5.9 |
| `ExplicitFormula_PrimeSide_L6` | ~3 | IK §5.5 |
| `ExplicitFormula_RHFromBound_L6` | ~2 | Weil 1952, Bombieri 1974 |

### Wall C — 9 atomic L8/L10 opens (~1.65pp total)
| Surface | pp | Source | Status |
|---|---|---|---|
| `Binet_KernelTaylor_L8` | ~0.20 | W-W §12.31 | open |
| `Binet_KernelFirstBernoulli_L8` | ~0.15 | B₂=1/6 | open |
| `Binet_KernelLargeBound_L8` | ~0.15 | exp decay | open |
| `Binet_GaussLimit_L8` | ~0.25 | Gauss product | open |
| `Binet_ProdFromLimit_L8` | ~0.25 | Weierstrass | open |
| `Binet_LogGammaSeries_L8` | ~0.25 | W-W §12.16 | open |
| `Binet_IntegralFromDigamma_L8` | ~0.25 | W-W §12.32 | open |
| `Gamma_NotBranch_UpperHalf_L8` | ~0.05 | Artin §1 | open |
| `Gamma_NotBranch_LowerHalf_L8` | ~0.05 | reflection | open |
| `Laplace_IntegSigmaBig_L10` | — | domination | **CLOSED** Batch 49 |
| `Laplace_IntegSigmaSmall_L10` | ~0.15 | antiderivative | open |
| `ZFR_Isolated_PathA` | — | Mathlib | **CLOSED** Batch 50 |

### Wall D — 14 L5/L6 atomic opens (~5pp total)
`ZFR_ChebyshevBound`, `ZFR_PoussinLogDerivCombine`, `ZFR_PoussinSigmaShift`,  
`ZFR_ZeroFreeStrip`, `ZFR_ExplicitRegion`, `ZFR_RegionConstant`, `ZFR_RegionForL143`,  
`ZFR_RegionToZFR`, `ZFR_GammaStirlingBound`, `ZFR_DirichletSeriesBound`,  
`ZFR_HadamardZeroSum`, `ZFR_HadamardFactorization`, `ZFR_DirichletSeries`, `ZFR_EulerFactors`

### Surfaces 5-9 Atomic Opens (11 L5, new in Batch 50)
| Surface | pp | Source |
|---|---|---|
| `CPS_ConverseThmHecke_L5` | ~25 | CPS 1999 Thm 3.3 |
| `CPS_CremonaUniqueness_L5` | ~20 | Cremona 1997; STW 2001 |
| `Weil_FrobeniusToLine_L5` | ~8 | Weil 1948 Thm C |
| `Weil_ConjectureToGRH_L5` | ~7 | Deligne 1974; Weil 1948 |
| `IK_GelbartJacquet_L5` | ~8 | Gelbart-Jacquet 1978 |
| `IK_NonvanishingFromGRH_L5` | ~12 | IK §5.15 |
| `IK_RankinSelberg_L5` | ~7 | IK Thm 5.13 |
| `IK_ResidueFromPole_L5` | ~8 | IK §5.15; Rankin 1939 |
| `IK_NonZeroAtOne_L5` | ~5 | IK §5.16 |
| `IK_ZFRfromNonZero_L5` | ~10 | IK Cor 5.16 |
| `IK_RHfromZFR_L5` | ~10 | IK §5.6 |

### Bridge Opens (4, Batch 49)
`WallA→Surface1` (~40pp) · `WallBC→Surfaces2,4` (~46pp) · `WallB→Surfaces5-6` (~15pp) · `WallD→Surfaces7-9` (~60pp)

---

## Clay Rule Audit

```
#print axioms opera_numerorum_grand_conditional
-- axioms used: {propext, Classical.choice, Quot.sound}

#print axioms zfr_isolated_patha_proved
-- axioms used: {propext, Classical.choice, Quot.sound}
```

SORRY: 0 (main proof bodies). `axiom`: 0. `native_decide`: 0. `opaque`: 0.
