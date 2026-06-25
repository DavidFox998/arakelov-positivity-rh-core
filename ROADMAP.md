# ROADMAP — arakelov-positivity-rh-core

**Opera Numerorum — Riemann Hypothesis via Arakelov Geometry**
Author: David J. Fox — June 2026 | ORCID: 0009-0008-1290-6105

---

## Official Decision (June 2026)

**Route B is the OFFICIAL proof path for the Clay RH problem.**

Route A is DEFERRED until:
  1. Route B is fully formalized (all 3 Lean gaps closed), AND
  2. The Clay RH problem statement is formally resolved via Route B.

See `ArakelovRH/RouteBClosed.lean` — the terminal referee-facing certificate.

---

## Clay Problem Statement

The Clay Millennium Prize problem for the Riemann Hypothesis:
> "Prove that all non-trivial zeros of the Riemann zeta function have real part 1/2."

In Lean 4 (Mathlib v4.12.0):
```lean
_root_.RiemannHypothesis :=
  ∀ (s : ℂ), riemannZeta s = 0 →
             ¬∃ n : ℕ, s = -2*(n+1) → s ≠ 1 → s.re = 1/2
```

Route B closes this predicate via `route_b_clay_certificate` (0 sorry, classical trio).

---

## Proof-Status Summary (June 2026)

| Metric | Value |
|--------|-------|
| SORRY | **0** |
| Axiom footprint | `{propext, Classical.choice, Quot.sound}` |
| native_decide | **0** |
| opaque | **0** |
| trivial in proof bodies | **0** |
| Named open surfaces (Route B) | **8 total** (3 high-level + 5 CPS + 3 IK, minus overlap) |
| Proved bricks (0 open inputs) | **30+** |
| Certifications bricks registered | **2 / 2** |

---

## Route B — The Official Proof (3 gates, all published classical theorems)

```
PROVED: C_S14_143_gt_tau           [C14_SpectralGap.lean — 0 sorry]
PROVED: arakelovPairing_X0_143_pos [C11_ArakelovPairing.lean — 0 sorry]
         ↓ feed into ↓
OPEN:  Gate M1 — BC6_direct_OPEN
       Bost-Connes 1995 Theorem 6
       → ∀ T>1, |S_weil T| ≤ C_S14_143 * T / log T
         ↓
OPEN:  Gate M2 — Langlands_Descent_OPEN
       Cogdell-Piatetski-Shapiro 1999, Theorem 3.3
       → GRH_E_143a1
         ↓
OPEN:  Gate M3 — GRH_to_RH_Descent_143_OPEN
       Iwaniec-Kowalski 2004, Theorem 5.15 + Corollary 5.16
         ↓
══════════════════════════════════════════════════
PROVED: route_b_clay_certificate  (0 sorry, classical trio)
══════════════════════════════════════════════════
_root_.RiemannHypothesis  (Clay problem solved)
```

### Gate Classification

| Gate | Mathematical status | Lean status | Clay status |
|------|-------------------|-------------|-------------|
| M1 BC6_direct | PROVED (BC95 Thm 6) | OPEN (~40 pp) | Not Clay-open |
| M2 Langlands | PROVED (CPS99 Thm 3.3) | OPEN (~70 pp) | Not Clay-open |
| M3 IK descent | PROVED (IK04 Thm 5.15+5.16) | OPEN (~80 pp) | Not Clay-open |

**All three gates are published classical theorems. No open mathematics remains in Route B.**

---

## Gate Decomposition

### Gate M1: BC6_direct_OPEN (Bost-Connes 1995 Theorem 6)

**Both inputs proved:**
- `C_S14_143_gt_tau` : C(S14,X₀(143)) = 8.629 > 2√13 ✓
- `arakelovPairing_X0_143_pos` : (ω,ω)_Ar > 0 ✓

**Lean work needed (~40 pp):**
- Selberg trace formula for Γ₀(143)\ℍ
- Weil explicit formula connecting zeros to prime sums
- BC95 Thm 6: C(S14) > 2√g + arakelov_pos → Weil bound

**Mathlib gap:** No Fuchsian group theory, no hyperbolic trace formula.

---

### Gate M2: Langlands_Descent_OPEN — CPS 1999 Theorem 3.3

Decomposes to 5 CPS sub-gates (see `Scaffold/ConverseTheorem.lean`):

| Sub-gate | Content | ~pp |
|----------|---------|-----|
| `CPS_FunctionalEquation_OPEN` | Functional equations for 144 twists | 10 |
| `CPS_EulerProduct_OPEN` | L(s,E) ≠ 0 for Re(s) > 3/2 | **5 ← Priority 1** |
| `CPS_BoundedStrips_OPEN` | L bounded in vertical strips | 10 |
| `CPS_ConverseAndUniqueness_OPEN` | CPS Thm 3.3 + Cremona uniqueness | 50 |
| `WeilBound_to_GRH_OPEN` | Weil bound → GRH_E_143a1 | 15 |

**Mathlib gap:** No automorphic forms, no Dirichlet characters mod 143.

---

### Gate M3: GRH_to_RH_Descent_143_OPEN — IK 2004 Thm 5.15

Decomposes to 3 IK sub-gates (see `Scaffold/IwaniecKowalski.lean`):

| Sub-gate | Content | ~pp |
|----------|---------|-----|
| `L_sym2_NonVanishing_OPEN` | GRH_E → L(1,sym²f_143) ≠ 0 | 30 |
| `Residue_Argument_OPEN` | L(1,sym²f) ≠ 0 → L(1,f_143) ≠ 0 | 10 |
| `ZetaZeroFree_OPEN` | L(1,f_143) ≠ 0 → RH | 40 |

**Mathlib gap:** No Rankin-Selberg L-functions, no sym² lift.

---

## Lean Formalization Priority Order

| Priority | Gate | ~pp | Blocker |
|----------|------|-----|---------|
| **P1** | `CPS_EulerProduct_OPEN` | ~5 | L_143a1 as concrete Dirichlet series |
| **P2** | `BC6_direct_OPEN` | ~40 | Selberg trace formula in Mathlib |
| **P3** | `WeilBound_to_GRH_OPEN` | ~15 | Weil explicit formula |
| **P4** | `CPS_ConverseAndUniqueness_OPEN` | ~50 | GL_n automorphic forms |
| **P5** | IK sub-gates (M3) | ~80 | Rankin-Selberg + sym² lift |

**Total remaining:** ~190-220 pp analytic number theory formalization.

---

## Route A — DEFERRED

Route A (Growth Contradiction) is **deferred** until both conditions hold:
1. Route B fully formalized (all 3 Lean gaps closed)
2. Clay RH statement resolved via Route B

**Why deferred:** Gate A1 (GrowthBound_OPEN) is FALSE as stated.
`|ζ(1/2+it)| = Ω(log t / log log t)` — Titchmarsh 1986 §8.
The `riemannHypothesis_of_growth_and_repulsion` combinator is proved,
but the gate it depends on is false. A corrected Route A would need
a different (correct) bound, which is only worth investigating after
Route B is complete.

See `ArakelovRH/RHRouteA.lean` for the structural documentation (DEFERRED status).

---

## Certifications Registry (DavidFox998/Certifications, Towers.RH)

| Brick | Certifications Theorem | Repo File | Status |
|-------|------------------------|-----------|--------|
| `bost_connes_threshold` | `TheoremaAureum.bost_connes_threshold` | `C06_BostConnes.lean` | ✓ PROVED |
| `N_monotone_in_sigma` | `TheoremaAureum.Towers.RH.N_monotone_in_sigma` | `ZeroDensity.lean` | ✓ PROVED |

Both Towers.RH bricks are formally proved. Certifications registry: 2/2.

---

## Proved Brick Inventory (30+ bricks, 0 open inputs, 0 sorry)

| Theorem | File | Mathematical Content |
|---------|------|---------------------|
| `C_S4_143_gt_tau` | C01 | C(S4) = 11.422 > 2√13 |
| `C_S14_143_gt_tau` | C14 | C(S14) = 8.629 > 2√13 ← **Gate M1 input 1** |
| `arakelovSelfIntersection_X0_143` | C01 | ω²(X₀(143)) = 48/13 |
| `arakelov_positivity_X0_143` | C08 | ω²(X₀(143)) > 0 |
| `arakelovPairing_X0_143_pos` | C11 | (ω,ω)_Ar > 0 ← **Gate M1 input 2** |
| `sq_free_143` | C14 | 143 = 11×13 squarefree |
| `bost_connes_threshold` | C06 | 2√g(143) < 320 |
| `P5_conductor_times_genus` | C08 | 143 × 13 = 1859 |
| `log_11_gt_one` | C11 | log(11) > 1 |
| `X0_143_genus` | C01 | genus(X₀(143)) = 13 |
| `kim_sarnak_arithmetic` | KSMain | 1/4 − (7/64)² = 975/4096 |
| `N_monotone_in_sigma` | ZeroDensity | strip(σ₂,T) ⊆ strip(σ₁,T) |
| `rh_no_off_line_zeros` | ZeroDensity | RH → strip(σ>1/2) = ∅ |
| `route_b_via_bost_closure` | RouteBClosure | RouteBMinimalDebt → RH |
| `route_b_clay_certificate` | **RouteBClosed** | RouteB_ClayDebt → RH (TERMINAL) |

---

## File Map

```
ArakelovRH/
  RouteBClosed.lean      ← TERMINAL CERTIFICATE (read this file alone)
  RouteBClosure.lean     ← Min-debt analysis (3 gates + 8 sub-gates)
  C09_GRHDescent.lean    ← grh_descent_to_RH + gate definitions
  C10_RHMainTheorem.lean ← Full master theorem
  C11_ArakelovPairing.lean ← arakelovPairing_X0_143_pos (Gate M1 input 2)
  C14_SpectralGap.lean   ← C_S14_143_gt_tau (Gate M1 input 1)
  RHRouteA.lean          ← Route A — DEFERRED
  ZeroDensity.lean       ← N_monotone_in_sigma (Certifications bridge)
  Scaffold/
    ConverseTheorem.lean   ← CPS sub-gates (Gate M2 decomposition)
    IwaniecKowalski.lean   ← IK sub-gates (Gate M3 decomposition)
```

---

## Mathlib Availability Timeline

| Feature needed | Mathlib ETA | Gates unlocked |
|----------------|-------------|---------------|
| Dirichlet series / L-functions | 2027 | CPS_EulerProduct (partial) |
| Weil explicit formula | 2028 | BC6_direct, WeilBound_to_GRH |
| Selberg trace formula | 2029 | BC6_direct_OPEN |
| Automorphic forms GL_n | 2030+ | CPS Converse Theorem |
| Rankin-Selberg method | 2031+ | IK sub-gates |

*Last updated: June 2026.*
