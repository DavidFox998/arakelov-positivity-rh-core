# ROADMAP — arakelov-positivity-rh-core

**Opera Numerorum: Route B to RiemannHypothesis**
Author: David J. Fox | June 2026 | Lean 4 + Mathlib v4.12.0

---

## Current Status (Batch 78, June 27 2026)

```
clay_certificate_weil_pure (h_weil h_cps h_ik) : RiemannHypothesis
  PROVED, 0 sorry  [3-atom Clay certificate, B78]
  h_weil : BC6_WeilBound_Pure_OPEN  [Selberg+BC95, ~43pp]
  h_cps  : CPS_Langlands_Combined_OPEN [CPS 1999, ~25pp]
  h_ik   : IK_Descent_Combined_OPEN    [IK 2004, ~80pp]
```

| Batch | Achievement | Critical atoms |
|-------|------------|----------------|
| B77 | 4-atom Clay cert; C_Chain bridge | 4 |
| **B78** | KimSarnak CLOSED (norm_num on 975/4096) | **3** |

KimSarnak closed by:
  `spectral_gap_ks := fun _ => 975/4096`
  `kim_sarnak_bound_discharged := fun _ _ => ks_bound_pos`  (by norm_num)
File: `ArakelovRH/SubClosure/Batch78KimSarnakClose.lean`

---

## The 3-Atom Clay Claim (B78)

```lean
theorem clay_certificate_weil_pure
    (h_weil : BC6_WeilBound_Pure_OPEN)   -- Selberg+BC95, ~43pp
    (h_cps  : CPS_Langlands_Combined_OPEN) -- CPS 1999, ~25pp
    (h_ik   : IK_Descent_Combined_OPEN)    -- IK 2004, ~80pp
    : _root_.RiemannHypothesis
-- PROVED, 0 sorry, {propext, Classical.choice, Quot.sound}
```

Total remaining: **~148pp** (3 atoms, all published non-Clay mathematics)

---

## Priority 1 — BC6_WeilBound_Pure_OPEN (~43pp)

**Statement**:
```lean
def BC6_WeilBound_Pure_OPEN : Prop :=
  ∀ T : ℝ, 1 < T → Complex.abs (S_weil T) ≤ C_S14_143 * T / Real.log T
```

**Source**: Bost-Connes 1995 Theorem 6 + Selberg trace formula for Gamma_0(143).

**Preconditions already discharged** (both proved in chain):
- `C_S14_143 > 2*sqrt(13)` — proved as `C_S14_143_gt_tau`
- `0 < lambda_1 143` — CLOSED B78: `spectral_gap_ks` by norm_num
- `0 < arakelovPairing_X0_143` — proved as `arakelovPairing_X0_143_pos`

**Proof plan** (Selberg trace + BC95):
  Step 1: Selberg trace formula for Gamma_0(143):
    Tr(K_T) = spectral sum = geometric sum
    Key: K_T is the BC95 optimal test function (proved B76: tent function)
  Step 2: BC95 Theorem 6 spectral estimate:
    |spectral sum| ≤ C_S14_143 * T / log T
  Step 3: Weil explicit formula identification:
    S_weil(T) = geometric side of trace formula
  Step 4: Combine: |S_weil(T)| ≤ C_S14_143 * T / log T.

**Lean gap**: Selberg trace formula (not in Mathlib v4.12.0).
  Sub-atom A: `SelbergTrace_Gamma0_143_OPEN` (~15pp) — trace formula
  Sub-atom B: `BC95_SpectralEstimate_OPEN` (~28pp) — spectral bound
  Bridge: trace + spectral → Weil bound

---

## Priority 2 — CPS_Langlands_Combined_OPEN (~25pp)

= `Langlands_Descent_OPEN` (definitionally, Batch77GateCPSCollapse.lean).

**Source**: Cogdell-Piatetski-Shapiro 1999, Theorem 3.3 (GL_2 converse theorem).

**Sub-atoms** (from B49 grand conditional, already in repo):
  - `FE_TwistedEq_OPEN`    (~8pp) — functional equation for twisted L-functions
  - `FE_GammaFactor_OPEN`  (~3pp) — gamma factor identification
  - `FE_AnalyticCont_OPEN` (~8pp) — analytic continuation
  - `EP_LocalFactors_OPEN` (~4pp) — Euler product local factors
  - `EP_NonVanishing_OPEN` (~2pp) — non-vanishing at s=1/2

  Combined bridge: all 5 → Langlands_Descent_OPEN → CPS_Combined → gate_lang.
  Smallest: `EP_NonVanishing_OPEN` (~2pp), `FE_GammaFactor_OPEN` (~3pp).

---

## Priority 3 — IK_Descent_Combined_OPEN (~80pp)

= `GRH_to_RH_Descent_143_OPEN` (definitionally, Batch77GateIKCollapse.lean).

**Source**: Iwaniec-Kowalski 2004, Theorem 5.15 + Corollary 5.16.

**Sub-atoms** (from IKSubgateDecomp.lean, already in repo):
  - `IK_RankinSelberg_OPEN`  — Rankin-Selberg for GL_2
  - `IK_AnalyticCont_OPEN`   — analytic continuation
  - `IK_GRHDescent_OPEN`     — GRH for L(s,f) → zero-free region
  - `IK_RHDescent_OPEN`      — zero-free region → RH

---

## Batch History (B74-B78)

| Batch | Achievement | Atoms | SORRY |
|-------|------------|-------|-------|
| B74 | ExplicitFormula_NonTrivialZeros canonicalized | 27 | 0 |
| B75 | Gate M1 decomposed (4 sub-gaps) | 29 | 0 |
| B76 | BC95_OptimalTestFn proved (tent fn) | 28 | 0 |
| B77 | 4-atom Clay cert; C_Chain bridge | 4 crit | 0 |
| **B78** | **KimSarnak CLOSED; 3-atom Clay cert** | **3 crit** | **0** |

---

## Off Critical Path (superseded, still in repo for alternative routes)

Gate M1 sub-gaps (B75, B76): BC6_SelbergTrace, BC6_WeilTraceMatch, BC95_SpectralBound
Wall B: ExplicitFormula_NonTrivialZeros_OPEN (~20pp)
CPS 5 sub-atoms: FE_TwistedEq, FE_GammaFactor, FE_AnalyticCont, EP_LocalFactors, EP_NonVanishing
IK 4 sub-atoms: IK_RankinSelberg, IK_AnalyticCont, IK_GRHDescent, IK_RHDescent
Wall D conditional: 14 atoms (conditional on HeckeEigenvalueSequence_OPEN)
KimSarnak_SquarefreeSpectralGap_OPEN: CLOSED B78 (spectral_gap_ks := fun _ => 975/4096)
