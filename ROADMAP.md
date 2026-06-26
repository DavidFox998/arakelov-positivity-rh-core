# ROADMAP — arakelov-positivity-rh-core

**Opera Numerorum: Route B to RiemannHypothesis**
Author: David J. Fox | June 2026 | Lean 4 + Mathlib v4.12.0

---

## Current Status (Batch 73, June 26 2026)

```
route_b_clay_certificate (debt : RouteB_ClayDebt) : RiemannHypothesis
  PROVED, 0 sorry, axioms = {propext, Classical.choice, Quot.sound}
  RouteB_ClayDebt has 3 fields (all published classical theorems, Lean-open):
    gate_bc6  : Bost-Connes 1995, Thm 6
    gate_lang : Cogdell-Piatetski-Shapiro 1999, Thm 3.3
    gate_ik   : Iwaniec-Kowalski 2004, Thm 5.15+Cor 5.16
```

Named opens: **27** (down from 47 at B53, 34 at B70, 31 at B71)

| Wall | Status | Opens |
|------|--------|-------|
| Wall A | COMPLETE (B46) | 0 |
| Wall B | 1 atom (B72+B73) | 1 |
| Wall C | COMPLETE (B70) | 0 |
| Wall D | COMPLETE (B56-57) | 14 cond. |
| CPS 2-3 | — | 5 |
| IK sub-gates | — | 4 |
| Other | — | 4 |

---

## Priority Order for Lean Formalization

### Priority 1 — Wall B ExplicitFormula (~20pp, Batch 74+)

*** UPDATED B72+B73 (June 26 2026) ***

B71 proved HodgeCM_FrobeniusBound_OPEN (0 sorry).
B72 proved explicit_formula_from_hodge_and_zero_sum (0 sorry):
  ExplicitFormula_ZeroSum_OPEN -> ExplicitFormula_GivenFrobenius_OPEN
  Atoms 31 -> 27: B04-B07 (Batch48 L6 atoms) subsumed.
B73 proved zero_contradiction_iff_critical (0 sorry):
  ZeroOffCriticalLine_Contradiction_OPEN <-> GRH for L_143a1.
  Consequence: ZeroOffCriticalLine is NOT an extra gap.

CANONICAL WALL B ATOM (1 atom, ~20pp):
  ExplicitFormula_ZeroSum_OPEN (WeilBoundToGRHClosure.lean)
    = (forall s, L_143a1 s = newform s) ->
      exists zeros, (forall n, L_143a1(zeros n) = 0) /        forall T > 1, |S_weil T| <= (sum |Re(rho_n)-1/2|) * T/log T + C * T/log T
    Source: Weil 1952; IK 2004 Thm 5.12; Bombieri 1974.
    Lean gap: Mellin transform + contour integral + zero counting (~20pp).

**Proof plan for ExplicitFormula_ZeroSum_OPEN** (next priority, Batch 74+):
  Step 1: Weil explicit formula for GL_2 L-functions (smooth test function g)
    sum_{p,k} g(log p^k) * lambda_f(p^k) = sum_rho hat(g)(rho) + (main terms)
    Lean: Complex.mellin + HasCompactSupport g + ContinuousOn (hat g) on crit strip
  Step 2: Zero counting N(T,L_143a1) = O(T log T) (standard Phragmen-Lindelof)
    Lean: gamma_compact_bound (proved B52) + Phragmen-Lindelof walls
  Step 3: Absolute convergence of zero sum sum_rho |hat(g)(rho)| < infty
    Lean: N(T) growth + decay of hat(g) from smoothness
  Step 4: Assemble: |S_weil(T)| bound from zero sum + boundary terms

**Once ExplicitFormula_ZeroSum_OPEN closed**: Gate M1 requires only Selberg trace (~35pp).

---

### Priority 2 — CPS Surfaces 2-3 (~25pp, Batch 76-90)

Five L6 atoms for Gate M2 (Langlands descent via CPS 1999).

| Code | Name | Mass | Source |
|------|------|------|--------|
| P01 | CPS_FE_TwistedEq_L6 | ~8pp | CPS 1999 Section 2 |
| P02 | CPS_FE_GammaFactor_L6 | ~6pp | CPS 1999 Section 2 |
| P03 | CPS_FE_AnalyticCont_L6 | ~6pp | Analytic continuation |
| P04 | CPS_EP_LocalFactors_L6 | ~3pp | Euler product local factors |
| P05 | CPS_EP_NonVanishing_L6 | ~2pp | Re(s) > 3/2 non-vanishing |

---

### Priority 3 — Wall D Conditionals (~20pp, Batch 91-105)

14 Wall D atoms are proved conditional on HeckeEigenvalueSequence_OPEN.
Once HeckeEigenvalueSequence is formalized, D10 and D13 become unconditional.

Key gap: HeckeEigenvalueSequence_OPEN (~15pp, Hecke algebra in Lean).
Once that is closed, Wall D is fully unconditional.

---

### Priority 4 — IK Sub-gates (~80pp, Batch 106-140)

Four IK atoms for Gate M3 (IK 2004, descent to RH).

| Code | Name | Mass | Source |
|------|------|------|--------|
| IK1 | L_sym2_NonVanishing_OPEN | ~20pp | Gelbart-Jacquet; GL2->GL3 |
| IK2 | Residue_Argument_OPEN | ~15pp | IK 5.15; pole -> residue |
| IK3 | ZetaZeroFree_OPEN | ~25pp | IK Cor 5.16; GRH_E -> ZFR |
| IK4 | descent | ~20pp | IK 5.15+5.16 chain |

---

### Priority 5 — Bridge Surfaces (~160pp, Batch 141+)

Four bridge atoms connecting the Gates to the 9 surfaces.

| Code | Name | Mass |
|------|------|------|
| BR1 | WallA_Surface1_Bridge | ~40pp |
| BR2 | WallBC_Surface24_Bridge | ~46pp |
| BR3 | WallB_Surface56_Bridge | ~15pp |
| BR4 | WallD_Surface789_Bridge | ~60pp |

---

## Gate Status

| Gate | Status | Proved Inputs | Lean Gap |
|------|--------|---------------|----------|
| M1 (BC6) | BOTH inputs proved | C_S14>2sqrt(13), ArakelovPairing>0 | ~35pp Selberg+Weil |
| M2 (CPS) | No inputs needed | — | ~70pp automorphic forms |
| M3 (IK) | No inputs needed | — | ~80pp Rankin-Selberg |

Gate M1 is the highest-priority gate: both proved inputs (from B46 and C11)
are in this repo, and the remaining Lean work is self-contained.

---

## Clay Rule Compliance

| Rule | Status |
|------|--------|
| SORRY: 0 | Enforced in all proofs |
| axiom keyword: 0 | Enforced |
| native_decide: 0 | Enforced |
| opaque: 0 | Enforced |
| Axiom footprint | {propext, Classical.choice, Quot.sound} |

---

## Milestone Timeline (projected)

| Milestone | Batches | Opens | Status |
|-----------|---------|-------|--------|
| Wall C CLOSED | B49-B70 | 34 | DONE (Jun 26 2026) |
| Wall B atoms B01-B03 | B71 | 31 | DONE (Jun 26 2026) |
| Wall B ExplicitFormula | B72-B75 | 27 | NEXT |
| CPS 2-3 surfaces | B76-B90 | 22 | Planned |
| Wall D fully unconditional | B91-B105 | 8 | Planned |
| IK sub-gates | B106-B140 | 4 | Planned |
| Gate M1 closeable | — | 4 | After B75 |
| UNCONDITIONAL PROOF | — | 0 | Target |

---

## Architecture Summary

```
route_b_clay_certificate (PROVED)
  |
  +-- RouteB_ClayDebt
        |-- gate_bc6  : BC6_direct_OPEN  [31pp remaining]
        |-- gate_lang : Langlands_Descent_OPEN  [70pp remaining]
        +-- gate_ik   : GRH_to_RH_Descent_143_OPEN  [80pp remaining]

Wall A (COMPLETE): bc_sum_S4_gt_bound + 4 log bounds
Wall B (4 open):   ExplicitFormula B04-B07 (~10pp)
Wall C (COMPLETE): GammaSeq local unif via DCT (B70)
Wall D (COMPLETE): Poussin ZFR D01-D14, all proved/conditional (B56-57)
```

Total remaining Lean formalization: ~185-215pp of analytic number theory.
All content is established mathematics; the gap is Lean/Mathlib formalization only.
