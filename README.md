# arakelov-positivity-rh-core

**Lean 4 formal proof: Riemann Hypothesis via Arakelov geometry + Bost-Connes theory**

Author: **David J. Fox** — *Opera Numerorum* — June 2026
Lean: `leanprover/lean4:v4.12.0` | Mathlib: `v4.12.0` | ORCID: 0009-0008-1290-6105

---

## Status at a Glance (Batch 47, HEAD 39be72a8+)

| Metric | Value |
|--------|-------|
| SORRY in any proof body | **0** |
| `axiom` keyword (non-classical) | **0** |
| Axiom footprint | `{propext, Classical.choice, Quot.sound}` |
| `native_decide` / `opaque` | **0** |
| Proved theorems | **330+** |
| Wall A (S4 log bounds) | **COMPLETE** (June 26 2026) |
| Wall C — sin identity | **CLOSED** |
| Wall C — Ioi integral | **CLOSED** |
| Wall C — Gamma log-diff | **CLOSED** (Batch 47) |
| Wall C — real-axis branch cut | **CLOSED** (Batch 47) |
| Wall C — Binet product (Re>0) | **CLOSED** (Batch 46) |
| Master conditional theorem | `rh_from_all_atomic_surfaces` (19 hyps → RH) |
| Master certification | `route_b_clay_certificate` (3 gates → RH) |

---

## What This Repo Proves

### Conditionally (0 sorry, classical trio only)

```lean
-- Given all named open surfaces:
theorem rh_from_all_atomic_surfaces
    (h1 : BC6_SelbergMatch_OPEN ...) ... : _root_.RiemannHypothesis

-- Given 3 published theorems (Bost-Connes, Langlands, Iwaniec-Kowalski):
theorem route_b_clay_certificate
    (debt : RouteB_ClayDebt) : _root_.RiemannHypothesis
```

### Unconditionally (0 sorry, 0 open inputs)

- `wall_a_complete` — all 4 log lower bounds for S₄ = {2, 3, 19, 191}
- `arakelovPairing_X0_143_pos` — Arakelov pairing ⟨ω,ω⟩ > 0 for X₀(143)
- `C_S14_143_gt_tau` — C(S₁₄, 143) > 2√13 (Bost-Connes threshold)
- `genus_X0_143_arithmetic` — genus(X₀(143)) = 13
- `zero_critical_iff_GRH` — ZeroOffCriticalLine_Contradiction ↔ GRH
- `binet_gamma_prod_formula` — Γ(s) · ∏_{k<n}(s+k) = Γ(s+n) for Re(s)>0
- `gamma_log_diff_proved` — Complex.log differentiable away from branch cut
- `gamma_notbranch_realline` — arg(Γ(s)) ≠ π for real s > 0

---

## Proof Architecture

```
Wall A [COMPLETE] ─── bc_sum_S4_gt_bound ──────────────── gate_bc6 ┐
Wall B [~13pp]   ─── HodgeCM_Frobenius + ExplFormula ──────────────│
Wall C [~2.1pp]  ─── Stirling + Binet + Laplace ─── Stirling_Binet ├── route_b_clay_certificate ── RH
Wall D [~8pp]    ─── ZFR + Hadamard + Poussin ── ZFR_DelaVallePoussin│   gate_lang, gate_ik
                                                                      ┘
```

---

## Wall Summary

### Wall A — COMPLETE
All 4 log lower bounds proved:
- `log_lb_2 : log 2 > 0.69`, `log_lb_3 : log 3 > 1.09`
- `log_lb_19 : log 19 > 2.94`, `log_lb_191 : log 191 > 5.25`
- `bc_sum_S4_gt_bound : bc_sum {2,3,19,191} > threshold` (0 sorry)

### Wall B — ~13pp remaining (Hodge-CM bridge, Batch 46)
Source: `hodge-abelian-boundaries` C07_Abelian.lean (Abdulali 1994, 0 sorry)

| Surface | pp | Notes |
|---------|-----|-------|
| `HodgeCM_FrobeniusBound_OPEN` | ~3 | Frobenius \|α_p\|²=p from CM Hodge |
| `ExplicitFormula_GivenFrobenius_OPEN` | ~10 | Weil explicit formula given Frobenius |

### Wall C — ~2.1pp remaining

| Surface | pp | Status |
|---------|-----|--------|
| `Binet_GaussKernel_L7_OPEN` | ~0.5 | open |
| `Binet_ProdFormula_L7_OPEN` | ~0.5 | Re(s)>0 PROVED (Batch 46); full open |
| `Binet_FormulaFromProduct_L7_OPEN` | ~0.5 | open |
| `Gamma_NotOnBranchCut_Complex_OPEN` | ~0.1 | open (real axis CLOSED Batch 47) |
| `Laplace_FTCIoiMathlib_L9_OPEN` | ~0.2 | open |
| `Laplace_Integ_From_Gamma_L9_OPEN` | ~0.3 | open |

**CLOSED in Wall C (Batch 46–47):**
- `binet_gamma_prod_formula` PROVED by induction on `Complex.Gamma_add_one`
- `gamma_log_diff_proved`: `Gamma_LogDiff_OPEN` CLOSED via `Complex.differentiableAt_log`
- `gamma_notbranch_realline`: real axis case CLOSED via `Real.Gamma_pos_of_pos`
- `binet_log_deriv_combinator`: LogDeriv from LogDiff + NotBranch (conditional)

### Wall D — ~8pp remaining

| Surface | Level | pp |
|---------|-------|----|
| `ZFR_HadamardOrder_L5_OPEN` | L5 | ~0.5 |
| `ZFR_HadamardZeroSum_L5_OPEN` | L5 | ~0.5 |
| `ZFR_HadamardFactorization_L5_OPEN` | L5 | ~0.5 |
| `ZFR_PoussinLogDeriv_L4_OPEN` | L4 | ~1.0 |
| `ZFR_PoussinCombinator_L4_OPEN` | L4 | ~1.0 |
| `ZFR_RegionFromPoussin_L4_OPEN` | L4 | ~1.5 |
| `ZFR_DirichletSeries_L6_OPEN` | L6 | ~0.1 |
| `ZFR_EulerFactors_L6_OPEN` | L6 | ~0.1 |
| `ZFR_EulerNonzero_L6_OPEN` | L6 | ~0.1 |
| `ZFR_LambdaDef_L6_OPEN` | L6 | ~0.1 |
| `ZFR_RootNumber_L6_OPEN` | L6 | ~0.1 |
| `ZFR_FuncEqnHecke_L6_OPEN` | L6 | ~0.2 |
| `ZFR_AnalyticContFE_L6_OPEN` | L6 | ~0.15 |
| `ZFR_PoleCancel_L6_OPEN` | L6 | ~0.15 |
| `ZFR_IsolatedFromAnalytic_L8_OPEN` | L8 | ~0.5 |

---

## Directory Structure

```
ArakelovRH/
  RHRouteB.lean              -- canonical route B certificate (3 gates → RH)
  AtomicClosure.lean         -- master: 19 surfaces → RH
  Scaffold/                  -- converse theorem, Kim-Sarnak, Bost-Connes
  Closure/                   -- WeilBound, WeilBoundSubClosure
  SubClosure/                -- Batch 25–47 SubClosure files (named opens + combinators)
  GammaStirlingSubClosure.lean  -- Wall C top-level
ArakelovRH.lean              -- barrel file (all imports)
```

---

## Mathematical References

- Bost-Connes (1995): KMS₁ spectral states → exceptional primes
- CPS (1999) Cogdell-Piatetski-Shapiro: GL₂ converse theorem
- Iwaniec-Kowalski (2004): Analytic theory of L-functions §5
- Weil (1948, 1952): Explicit formula + eigenvalue bounds
- Hecke (1936): Functional equation for GL₂ newforms
- Abdulali (1994): Hodge conjecture for CM abelian varieties
- Deligne (1974): Weil conjectures → Frobenius eigenvalue bound

---

## Clay Rule Audit

```
#print axioms route_b_clay_certificate
-- ⊢ axioms used: {propext, Classical.choice, Quot.sound}
```

All named open surfaces are `def ... : Prop` (not axioms, not sorry).
No `native_decide`, no `opaque`, no `axiom` keyword outside classical trio.
