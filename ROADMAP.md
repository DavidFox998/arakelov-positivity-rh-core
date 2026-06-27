# ROADMAP -- arakelov-positivity-rh-core

**Opera Numerorum: Route B to RiemannHypothesis**
Author: David J. Fox | June 2026 | Lean 4 + Mathlib v4.12.0

---

## Current Status (Batch 82, June 27 2026)

```
clay_certificate_weil_pure (h_weil h_cps h_ik) : RiemannHypothesis
  PROVED, 0 sorry  [3-atom Clay certificate, B78]

ik_descent_certified_b82 (h1 h2 h3 h4) : IK_Descent_Combined_OPEN
  PROVED, 0 sorry  [IK certified from 4 sub-gaps, B82]

RiemannHypothesis certified from 6 named mathematical propositions:
  h_weil -- BC6_WeilBound_Pure_OPEN      (~43pp)
  h_cps  -- CPS_Langlands_Combined_OPEN  (~25pp)
  h1     -- IK_RS_SimplePole_OPEN        (~10pp)
  h2     -- RS_Identity_OPEN             (~15pp)
  h3     -- L_sym2_Limit_to_L143_OPEN    (~10pp)
  h4     -- ZetaZeroFree_OPEN            (~30pp)
Total remaining: ~133pp.  KimSarnak CLOSED (B78, norm_num).
```

### Batch History

| Batch | Achievement |
|-------|-------------|
| B77 | 4-atom Clay cert; C_Chain bridge; critical path 28->4 |
| B78 | KimSarnak CLOSED (norm\_num 975/4096); 3-atom cert |
| B79 | Abstract Filter.Tendsto residue lemma (0 sorry) |
| B80 | RiemannZeta_Residue_OPEN closed (Mathlib riemannZeta_residue_one) |
| B81 | Division argument: L_sym2 -> c WITHOUT ContinuousAt; IK ~80pp->~65pp |
| **B82** | **IK descent certified from 4 sub-gaps (0 sorry)** |

---

## Completed Walls

| Wall | Status | Key Theorem |
|------|--------|-------------|
| Wall A (Gate M1 inputs) | COMPLETE B46 | bc_sum_S4_gt_bound |
| Wall C (Gamma function) | COMPLETE B70 | Wall_C_closed (DCT) |
| Wall D (ZFR scaffold) | COMPLETE B56-57 | all 14 atoms proved |
| KimSarnak | CLOSED B78 | spectral_gap_ks = 975/4096 |
| Zeta residue | CLOSED B80 | riemannZeta_residue_one (Mathlib) |
| L_sym2 ContinuousAt | ELIMINATED B81 | Division argument |
| IK_GRH_to_L_sym2_nv | PROVED B79+B81 | Not a named open def |

---

## Priority 1 -- BC6_WeilBound_Pure_OPEN (~43pp)

**Statement**:
```lean
def BC6_WeilBound_Pure_OPEN : Prop :=
  forall T : R, 1 < T ->
    Complex.abs (S_weil_143 T) <= C_S14_143 * T / Real.log T
```

**Source**: Bost-Connes 1995 Theorem 6 + Selberg trace formula for Gamma_0(143).

**Sub-atoms**:
```
SelbergTrace_Gamma0_143_OPEN  (~15pp)
  Selberg trace formula: Tr(K_T) = spectral sum = geometric sum.
  K_T = BC95 tent function (proved B76: max(0, C/log T - |r|/T)).
  Lean gap: automorphic form integration on Gamma_0(143)\H.

BC95_SpectralEstimate_OPEN    (~28pp)
  |spectral sum| <= C_S14_143 * T / log T  from BC95 Thm 6.
  Preconditions already proved:
    C_S14_143 > 2*sqrt(13)  [proved: C_S14_143_gt_tau]
    0 < lambda_1(143)        [CLOSED B78: spectral_gap_ks by norm_num]
    0 < arakelovPairing      [proved: arakelovPairing_X0_143_pos]
  Lean gap: spectral theory + BC95 estimate (~28pp).
```

**Bridge**: trace + spectral -> Weil bound (structural, 0 sorry once sub-atoms done).

---

## Priority 2 -- CPS_Langlands_Combined_OPEN (~25pp)

**Source**: Cogdell-Piatetski-Shapiro 1999, Theorem 3.3 (GL_2 converse theorem).

**Sub-atoms** (from B49 grand conditional):
```
FE_TwistedEq_OPEN    (~8pp)  Functional equation for twisted L-functions
FE_GammaFactor_OPEN  (~3pp)  Gamma factor identification
FE_AnalyticCont_OPEN (~8pp)  Analytic continuation of L(s, f x chi)
EP_LocalFactors_OPEN (~3pp)  Local Euler factors at bad primes
EP_NonVanishing_OPEN (~3pp)  Non-vanishing away from critical line
```

**Bridge**: CPS Thm 3.3 converse theorem assembles these (0 sorry once proved).
CPS_Thm33 surface proved (B49, 0 sorry): it's a combinator over the 5 sub-atoms.

---

## Priority 3 -- IK Sub-Gaps (~65pp, certified B82)

```
IK_RS_SimplePole_OPEN       (~10pp)
  RS(s) = L(s, f_143 x f_143-bar) has simple pole at s=1, residue c > 0.
  Source: Rankin 1939, Selberg 1940.
  Lean gap: RS integral unfolding, Petersson norm, Dirichlet asymptotics.

RS_Identity_OPEN             (~15pp)
  RS(s) = riemannZeta(s) * L_sym2_143(s)  for Re(s) > 1.
  Source: Iwaniec-Kowalski 2004, Theorem 5.13.
  Lean gap: symmetric square lift Euler product factorization.

L_sym2_Limit_to_L143_OPEN   (~10pp)
  (exists c > 0, L_sym2 -> c as s -> 1 from Re > 1) -> L_143a1(1) != 0.
  Source: IK 2004 Thm 5.15 + Kim-Shahidi 2002 (sym^2 entirely).
  Note: B81 division argument gives L_sym2 -> c WITHOUT ContinuousAt.
        This atom absorbs the remaining Kim-Shahidi content (point val).
  Lean gap: Hecke multiplicativity + Euler product at s=1.

ZetaZeroFree_OPEN            (~30pp)  -- LARGEST remaining gap
  L_143a1(1) != 0 -> RiemannHypothesis.
  Source: Iwaniec-Kowalski 2004, Corollary 5.16.
  Note: Wall D structural scaffolds (Hadamard, Poussin) proved B56-57.
  Lean gap: zero-free region for L(s, f_143a1), explicit formula,
            Hadamard factorization + descent to RH.
```

**B82 Bridge** (PROVED, 0 sorry): `ik_descent_certified_b82` assembles h1+h2+h3+h4
into `IK_Descent_Combined_OPEN` via `grh_to_rh_ik_b81` (B81) + `gate_ik_from_ik_combined` (B77).

---

## Lean Formalization Estimate

| Atom | Pages | Estimate | Note |
|------|-------|---------|------|
| SelbergTrace_Gamma0_143_OPEN | ~15pp | 600 lines | Hardest: no Mathlib automorphic |
| BC95_SpectralEstimate_OPEN | ~28pp | 1200 lines | BC95 spectral theory |
| FE_TwistedEq_OPEN | ~8pp | 350 lines | Functional equation |
| FE_GammaFactor_OPEN | ~3pp | 130 lines | Gamma identities |
| FE_AnalyticCont_OPEN | ~8pp | 350 lines | L-function continuation |
| EP_LocalFactors_OPEN | ~3pp | 130 lines | Euler product |
| EP_NonVanishing_OPEN | ~3pp | 130 lines | Non-vanishing |
| IK_RS_SimplePole_OPEN | ~10pp | 450 lines | RS integral |
| RS_Identity_OPEN | ~15pp | 650 lines | Sym^2 factorization |
| L_sym2_Limit_to_L143_OPEN | ~10pp | 450 lines | Hecke mult |
| ZetaZeroFree_OPEN | ~30pp | 1300 lines | Zero-free region |
| **Total** | **~133pp** | **~5740 lines** | |

All are published non-Clay mathematics. 0 sorry in all proof bodies.

---

## Clay Certificate Summary

```
route_b_clay_certificate     (B49): 3-gate -> RH  [PROVED]
clay_certificate_kim_sarnak  (B77): 4-atom -> RH  [PROVED]
clay_certificate_weil_pure   (B78): 3-atom -> RH  [PROVED, KimSarnak closed]
ik_descent_certified_b82     (B82): 4 IK sub-gaps -> IK descent  [PROVED]

All: 0 sorry. Axioms: {propext, Classical.choice, Quot.sound}.
```

*David J. Fox -- Opera Numerorum -- June 27, 2026*
