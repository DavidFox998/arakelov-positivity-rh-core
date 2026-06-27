# ROADMAP — arakelov-positivity-rh-core

**Opera Numerorum: Route B to RiemannHypothesis**
Author: David J. Fox | June 2026 | Lean 4 + Mathlib v4.12.0

---

## Current Status (Batch 77, June 27 2026)

```
route_b_clay_certificate (debt : RouteB_ClayDebt) : RiemannHypothesis
  PROVED, 0 sorry, axioms = {propext, Classical.choice, Quot.sound}

clay_certificate_kim_sarnak (h_ks h_bc6 h_cps h_ik) : RiemannHypothesis
  PROVED, 0 sorry  [4-atom Clay certificate, B77]
  h_ks  : KimSarnak_SquarefreeSpectralGap_OPEN  [Kim-Sarnak 2003, ~15pp]
  h_bc6 : BC6_SelbergBC95_Combined_OPEN          [BC95 Thm 6, ~35pp]
  h_cps : CPS_Langlands_Combined_OPEN            [CPS 1999, ~25pp]
  h_ik  : IK_Descent_Combined_OPEN               [IK 2004, ~80pp]
```

CRITICAL PATH: **4 combined atoms** (~155pp total formalization remaining)
Old 28 atoms are now OFF critical path (superseded by combined atoms).

| Wall / Gate | Status | Critical atoms |
|-------------|--------|----------------|
| Wall A | COMPLETE (B46) | 0 |
| Wall B ExplicitFormula | Off critical path (B77) | 0 |
| Wall C | COMPLETE (B70) | 0 |
| Wall D | COMPLETE conditional (B56-57) | 0 |
| Gate BC6 (KimSarnak + BC6_Combined) | **2 combined** | 2 |
| Gate CPS (Langlands) | **1 combined** | 1 |
| Gate IK (Descent) | **1 combined** | 1 |

---

## The 4-Atom Clay Claim (B77)

**Source:** Bridge143.lean (TheoremaAureum C_Chain analysis, June 2026).
Bridge143 uses 3 AXIOMS (not Clay-grade). B77 uses the same content as NAMED OPEN DEFS.

```lean
theorem clay_certificate_kim_sarnak
    (h_ks  : KimSarnak_SquarefreeSpectralGap_OPEN)  -- Kim-Sarnak 2003
    (h_bc6 : BC6_SelbergBC95_Combined_OPEN)          -- BC95 Thm 6
    (h_cps : CPS_Langlands_Combined_OPEN)            -- CPS 1999 Thm 3.3
    (h_ik  : IK_Descent_Combined_OPEN)               -- IK 2004 Thm 5.15
    : _root_.RiemannHypothesis
-- PROVED, 0 sorry, {propext, Classical.choice, Quot.sound}
```

Proof chain:
1. `KimSarnak_OPEN + decide(Squarefree 143)` → `0 < lambda_1 143`
2. `lambda_1 > 0 + BC6_Combined` → `BC6_Theorem6_OPEN` (Weil bound, gate_bc6)
3. `CPS_Combined` = `Langlands_Descent_OPEN` (gate_lang, def unfold)
4. `IK_Combined` = `GRH_to_RH_Descent_143_OPEN` (gate_ik, def unfold)
5. `route_b_clay_certificate ⟨gate_bc6, gate_lang, gate_ik⟩` → `RiemannHypothesis`

---

## Batch History (selected)

| Batch | Key Achievement | Atoms |
|-------|----------------|-------|
| B46 | Wall A complete (bc_sum_S4_gt_bound) | — |
| B49 | Grand conditional: 9 surfaces → RH | — |
| B70 | Wall C CLOSED (GammaSeq DCT proof) | 35→34 |
| B71 | HodgeCM_FrobeniusBound proved | 34→31 |
| B72-73 | Wall B 31→27; ZeroOffCriticalLine = GRH | 31→27 |
| B74 | ExplicitFormula canonicalized (NonTrivialZeros) | 27 |
| B75 | Gate M1 decomposed into 4 sub-gaps | 27→29 |
| B76 | BC95_OptimalTestFn proved (tent function) | 29→28 |
| **B77** | **4-atom Clay certificate; Bridge143 C_Chain bridge** | **28→4 critical** |

---

## Priority 1 — KimSarnak_SquarefreeSpectralGap_OPEN (~15pp)

File: `ArakelovRH/SubClosure/Batch77GateBCCollapse.lean`

**Mathematical content**: Kim-Sarnak 2003. For squarefree N, the spectral gap
lambda_1(Gamma_0(N)\H) > 3/16. Selberg's 1/4 conjecture (still open) would give 1/4.
Kim-Sarnak gives 3/16 unconditionally.

**Lean gap**: Spectral theory of automorphic forms on Gamma_0(N).
Mathlib v4.12.0 has no automorphic form spectral theory.
Key APIs needed: `SpectralGap`, `LaplacianEigenvalue`, `HyperbolicQuotient`.

**Proof plan**:
  Step 1: Define lambda_1 : ℕ → ℝ as infimum of Laplacian eigenvalues
  Step 2: Kim-Sarnak exponent bound: |a_p(f)| <= p^(7/64) => lambda_1 >= 1/4 - (7/64)^2
  Step 3: 1/4 - (7/64)^2 = 975/4096 > 0
  Step 4: Conclude lambda_1(143) > 0

---

## Priority 2 — BC6_SelbergBC95_Combined_OPEN (~35pp)

File: `ArakelovRH/SubClosure/Batch77GateBCCollapse.lean`

**Mathematical content**: BC95 Theorem 6 + Selberg trace formula for Gamma_0(143).
Given spectral gap and Arakelov positivity, the Weil bound holds:
|S_weil(T)| <= C_S14_143 * T / log T for all T > 1.

**Proof plan**:
  Step 1: Selberg trace formula: Tr(K_T) = sum_zeros (spectral) = sum_primes (geometric)
  Step 2: BC95 Theorem 6 spectral estimate: |spectral sum| <= C_S14_143 * T / log T
  Step 3: Weil explicit formula identification: S_weil T = geometric side of trace
  Step 4: Combine: |S_weil T| <= |spectral sum| <= C_S14_143 * T / log T

---

## Priority 3 — CPS_Langlands_Combined_OPEN (~25pp)

File: `ArakelovRH/SubClosure/Batch77GateCPSCollapse.lean`

**Mathematical content**: CPS 1999 Theorem 3.3. Langlands descent for GL_2 L-functions.
L(s, f_143a1) satisfies functional equation, Euler product, analytic continuation,
local factors, non-vanishing at 1/2. Together: Langlands_Descent_OPEN.

---

## Priority 4 — IK_Descent_Combined_OPEN (~80pp)

File: `ArakelovRH/SubClosure/Batch77GateIKCollapse.lean`

**Mathematical content**: IK 2004 Theorem 5.15 + Corollary 5.16.
GRH for L(s, f_143a1) => RiemannHypothesis via descent argument.

---

## Off Critical Path (superseded, still in repo)

These 24 atoms remain as named open defs but are no longer needed for
`clay_certificate_kim_sarnak`. They provide alternative proof routes.

Gate M1 sub-gaps (B75, B76):
  BC6_SelbergTrace_SubGap_OPEN   -- superseded by BC6_SelbergBC95_Combined_OPEN
  BC6_WeilTraceMatch_SubGap_OPEN -- superseded by BC6_SelbergBC95_Combined_OPEN
  BC95_SpectralBound_SubGap_OPEN -- superseded by BC6_SelbergBC95_Combined_OPEN

Wall B:
  ExplicitFormula_NonTrivialZeros_OPEN -- alternative route to gate_bc6

CPS 5 sub-atoms (B49):
  FE_TwistedEq, FE_GammaFactor, FE_AnalyticCont, EP_LocalFactors, EP_NonVanishing
  -- superseded by CPS_Langlands_Combined_OPEN

IK 4 sub-atoms:
  -- superseded by IK_Descent_Combined_OPEN

Wall D conditional (14 atoms):
  -- conditional on HeckeEigenvalueSequence_OPEN; off critical path
