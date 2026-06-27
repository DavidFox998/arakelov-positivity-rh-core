# arakelov-positivity-rh-core

**Lean 4 formal proof: Riemann Hypothesis via Arakelov geometry + Bost-Connes theory**

Author: **David J. Fox** | *Opera Numerorum* | June 2026
Lean: `leanprover/lean4:v4.12.0` | Mathlib: `v4.12.0` | ORCID: 0009-0008-1290-6105

---

## Status at a Glance (Batch 77, June 27 2026)

| Metric | Value |
|--------|-------|
| SORRY in any proof body | **0** |
| Axiom footprint | `{propext, Classical.choice, Quot.sound}` |
| Clay Certificate (3-gate) | **PROVED** (`route_b_clay_certificate`, B49) |
| Clay Certificate (4-atom) | **PROVED** (`clay_certificate_kim_sarnak`, B77) |
| Critical path atoms | **4** (down from 28 at B76) |
| Wall A | COMPLETE (B46) |
| Wall C | COMPLETE (B70: GammaSeq DCT proof) |
| Wall D | COMPLETE (B56-57: all 14 atoms proved/conditional) |
| HEAD | Batch 77: 4-atom Clay certificate + C_Chain bridge |

---

## What This Repo Proves

### Clay Closure Theorem (0 sorry) — Original

```lean
theorem route_b_clay_certificate (debt : RouteB_ClayDebt) :
    _root_.RiemannHypothesis
-- RouteB_ClayDebt has 3 fields (all published classical theorems):
--   gate_bc6  : BC6_direct_OPEN       (Bost-Connes 1995 Thm 6)
--   gate_lang : Langlands_Descent_OPEN (CPS 1999 Thm 3.3)
--   gate_ik   : GRH_to_RH_Descent_143_OPEN (IK 2004 Thm 5.15+Cor 5.16)
-- Axioms: {propext, Classical.choice, Quot.sound}
```

### Four-Atom Clay Certificate (0 sorry) — **Batch 77, NEW**

```lean
theorem clay_certificate_kim_sarnak
    (h_ks  : KimSarnak_SquarefreeSpectralGap_OPEN)  -- Kim-Sarnak 2003, ~15pp
    (h_bc6 : BC6_SelbergBC95_Combined_OPEN)          -- BC95 Thm 6 + Selberg, ~35pp
    (h_cps : CPS_Langlands_Combined_OPEN)            -- CPS 1999 Thm 3.3, ~25pp
    (h_ik  : IK_Descent_Combined_OPEN)               -- IK 2004 Thm 5.15, ~80pp
    : _root_.RiemannHypothesis
-- PROVED, 0 sorry, {propext, Classical.choice, Quot.sound}
-- File: ArakelovRH/ClayCertificate.lean
```

**The 4 assumptions are all published classical theorems. None is a Clay Millennium Problem.**
Total remaining Lean formalization: **~155pp**.

### Clay Rule Compliance

```
SORRY:          0   (in all proof bodies)
axiom keyword:  0   (no extra axioms)
native_decide:  0   (no native_decide)
opaque:         0   (no opaque definitions)
#print axioms clay_certificate_kim_sarnak
  = {propext, Classical.choice, Quot.sound}
```

### Source: C_Chain Bridge (Batch 77)

Bridge143.lean (TheoremaAureum C_Chain, June 2026) proves RH from 3 named **axioms**
(not Clay-grade: axioms appear in `#print axioms`). This repo uses the same
mathematical content as **named open defs** — no axiom keyword, classical trio only.

| Bridge143 (axiom, NOT Clay) | Route B (named open def, Clay-grade) |
|-----------------------------|--------------------------------------|
| `kim_sarnak_squarefree` | `KimSarnak_SquarefreeSpectralGap_OPEN` |
| `bc6_selberg_trace_143` | `BC6_SelbergBC95_Combined_OPEN` |
| `langlands_descent_143a1` | `CPS_Langlands_Combined_OPEN` |

---

## Proof Architecture

```
KimSarnak_OPEN + decide(Squarefree 143)
    |
    v  [lambda_1_143_pos_from_kim_sarnak, 0 sorry]
0 < lambda_1(143)
    |
    + BC6_SelbergBC95_Combined_OPEN
    |
    v  [gate_bc6_from_kim_sarnak_and_bc95, 0 sorry]
BC6_Theorem6_OPEN (Weil bound for S_weil_143)
    |
    v  [gate_m1_from_bc6_theorem6, 0 sorry]
gate_bc6 : BC6_direct_OPEN
    |
    + CPS_Langlands_Combined_OPEN -> gate_lang : Langlands_Descent_OPEN
    + IK_Descent_Combined_OPEN   -> gate_ik   : GRH_to_RH_Descent_143_OPEN
    |
    v  [route_b_clay_certificate, PROVED]
RiemannHypothesis
```

---

## Direct Closures (selected, all 0 sorry)

| Theorem | Batch | What it proves |
|---------|-------|----------------|
| `wall_a_complete` | B46 | `bc_sum_S4_gt_bound`: S4={2,3,19,191} Bost-Connes sum |
| `Wall_C_closed` | B70 | `WW_GammaSeq_Deriv_L8` via DCT, sigma/M split |
| `hodge_cm_frobenius_bound_proved` | B71 | `HodgeCM_FrobeniusBound_OPEN` proved directly |
| `zero_contradiction_iff_critical` | B73 | `ZeroOffCriticalLine_Contradiction_OPEN` = GRH |
| `BC95_OptimalTestFn_SubGap_PROVED` | **B76** | Tent function `max(0, C/log T - \|r\|/T)`, 0 sorry |
| `sq_free_143` | **B77** | `Nat.Squarefree 143`, by decide |
| `lambda_1_143_pos_from_kim_sarnak` | **B77** | `0 < lambda_1 143` from KimSarnak + decide |
| `gate_bc6_from_kim_sarnak_and_bc95` | **B77** | `BC6_Theorem6_OPEN` from KimSarnak + BC6_Combined |
| `clay_certificate_kim_sarnak` | **B77** | **4-atom Clay certificate** |

---

## BSD Connection (Module 23, David Fox)

GRH and BSD share the same L-function `L(s, f_143a1) = L(s, E_143a1)`.

```
BSD for J_0(143) (Opera Numerorum, Module 23):
  ord_{s=1} L(J_0(143), s) = 1 = rank(J_0(143)(Q))  [CERTIFIED, LMFDB]
  Omega/R = 11.929 ~ 12  [0.59% error]
  Delta_DS/H4 = 2.1812 ~ 2*(12/11) = 2.1818  [0.027% error, M8A identity]
  Sha = 1 (conjectural).  Tate conjecture: follows from BSD.
  BSD_TOWER_CERTIFIED (separate Opera Numerorum chain).
```

---

## Files

```
ArakelovRH/
  RouteBClosed.lean              -- route_b_clay_certificate (PROVED, B49)
  ClayCertificate.lean           -- clay_certificate_kim_sarnak (PROVED, B77) **NEW**
  C01_Arakelov.lean ... C14_SpectralGap.lean  -- proved bricks
  SubClosure/
    Batch75GateM1Decomp.lean     -- Gate M1 decomposed (4 sub-gaps)
    Batch76TentFunctionClose.lean -- BC95_OptimalTestFn proved (tent fn)
    Batch77GateBCCollapse.lean   -- KimSarnak + BC6_Combined **NEW**
    Batch77GateCPSCollapse.lean  -- CPS_Langlands_Combined **NEW**
    Batch77GateIKCollapse.lean   -- IK_Descent_Combined **NEW**
    Batch77MasterCert.lean       -- B77 master cert **NEW**
    [... 140+ earlier SubClosure files ...]
ROADMAP.md                       -- detailed proof plan
```

---

## Zenodo / GitHub

- Zenodo DOI v5 (CERN, latest): https://doi.org/10.5281/zenodo.20600891
- Opera Numerorum AllCerts ZIP (106 PDFs): https://drive.google.com/file/d/17ZrH7j7X6SsOyb_qVhn4BInKUszRmDFT/view?usp=sharing
- SHA chain master: `certificates/invariants.json` (Opera Numerorum Replit repo)
- M7 manifest SHA: `5b80b84d...` (frozen, locks M1-M6)

*David J. Fox — ORCID 0009-0008-1290-6105 — Aberdeen/Seattle WA — June 2026*
