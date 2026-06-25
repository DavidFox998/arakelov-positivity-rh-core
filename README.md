# arakelov-positivity-rh-core

**Canonical standalone Lean 4 package: Riemann Hypothesis via Arakelov geometry.**

Author: **David J. Fox** — Opera Numerorum — June 2026
Lean toolchain: `leanprover/lean4:v4.12.0` | Mathlib: `v4.12.0`
ORCID: 0009-0008-1290-6105

> Lean 4 formalisation of the Opera Numerorum RH proof strategy.
> SORRY: 0. Axiom footprint: `{propext, Classical.choice, Quot.sound}`.
> No `native_decide`. No `opaque`. No `trivial` in proof bodies.

---

## Proof Status

### Unconditionally proved bricks (0 open inputs, classical trio)

| Brick | File | Method |
|-------|------|--------|
| `arakelovSelfIntersection (X₀ 143) = 48/13` | C01 | norm_num |
| `ArakelovPositivity (X₀ 143)` | C08 | norm_num |
| `P5_conductor_times_genus : 143 * 13 = 1859` | C08 | norm_num |
| `C_S4_143_gt_tau : C_S4_143 > 2·√13` | C01 | nlinarith |
| `bost_connes_threshold : 2·√13 < 320` | C06 | norm_num |
| `K_bad_lt_threshold` | C01 | log monotonicity |
| `sq_free_143 : Squarefree 143` | C14 | interval_cases |
| `C_S14_143_gt_tau : C_S14_143 > 2·√13` | C14 | nlinarith |
| `arakelovPairing_X0_143_pos` | C11 | exp_one_lt_d9 + log(11) > 1 |
| `log_11_gt_one` | C11 | exp_one_lt_d9 |
| `kim_sarnak_arithmetic : 1/4 - (7/64)² = 975/4096` | KimSarnakMainTheorem | norm_num |
| `ks_arithmetic_chain : \|ν\| ≤ 7/64 → 975/4096 ≤ 1/4 - ν²` | KimSarnakChain | linarith |
| `hasSpectralGap_zero` | SpectralAbstract | simp |
| `spectral_bound : ‖T‖ ≤ 1 → spectralRadius ℂ T ≤ 1` | SpectralAbstract | Gelfand |
| `gap_reduction : coercivity m → bounded below by m` | SpectralAbstract | Cauchy-Schwarz |

---

## Proof Routes to RH

### Route A — Growth contradiction (2 open gates)

```
GrowthBound_OPEN (false: exponential growth dominates)
  + ZeroRepulsion_OPEN
  ──────────────────────────────────────────────────
  riemannHypothesis_of_growth_and_repulsion   PROVED
  ──────────────────────────────────────────────────
  _root_.RiemannHypothesis
```

Proved step: `exp_loglog_dominates_sq` via `Real.tendsto_exp_div_pow_atTop 2`.

---

### Route B — Kim-Sarnak spectral chain (6 open gates)

```
LambdaToNu_OPEN        (Selberg 1956: λ₁ N = 1/4 - ν(N)²)
  + NuBound_OPEN       (Kim-Sarnak 2003: |ν(N)| ≤ 7/64)
  ────────────────────────────────────────────
  ks_full_chain        PROVED (kim_sarnak_discharge)
  → KimSarnak_OPEN: ∀ squarefree N, λ₁(X₀(N)) ≥ 975/4096
  ────────────────────────────────────────────
  + BC6SelbergTrace_OPEN  (Bost-Connes 1995 Thm 6)
  + arakelovPairing_X0_143_pos  ← PROVED unconditionally
  ────────────────────────────────────────────
  bc6_from_spectral_gap    PROVED
  → ∀ T>1, |S_weil T| ≤ C_S14_143 · T / log T
  ────────────────────────────────────────────
  + Langlands_Descent_OPEN  (CPS 1999 Converse Theorem)
  → GRH_E_143a1
  ────────────────────────────────────────────
  + GRH_to_RH_Descent_143_OPEN  (IK 2004 Thm 5.15)
  ────────────────────────────────────────────
  ks_to_rh_full_chain  PROVED (6-gate combinator)
  ────────────────────────────────────────────
  _root_.RiemannHypothesis
```

---

### Route B direct — GRH descent (2 open gates)

```
GRH_X0_143_OPEN L_fn + LanglandsGL2_X0_143_OPEN L_fn
  ──────────────────────────────────────────────────
  grh_descent_to_RH_genuine   PROVED
  ──────────────────────────────────────────────────
  _root_.RiemannHypothesis
```

Shortest path: 2 gates, 3-line formal proof in C09_GRHDescent.lean.

---

## Named Open Surfaces

| Surface | File | Mathematical reference |
|---------|------|------------------------|
| `LambdaToNu_OPEN` | KimSarnakAuxiliary | Selberg 1956 eigenvalue identity |
| `NuBound_OPEN` | KimSarnakAuxiliary | Kim-Sarnak 2003 App 2 Cor 2 |
| `KimSarnak_OPEN` | C14_SpectralGap | Kim-Sarnak 2003 (discharged by LambdaToNu+Nu) |
| `BC6SelbergTrace_OPEN` | C14_SpectralGap | Bost-Connes 1995 Thm 6 |
| `SelbergTrace_X0143_OPEN` | SelbergTrace143 | Selberg 1956, Hejhal 1976 |
| `SelbergWeylLaw_X0143_OPEN` | SelbergTrace143 | Weyl 1912 |
| `SelbergZeroFree_X0143_OPEN` | SelbergTrace143 | Iwaniec-Kowalski 2004 §5 |
| `HasModularSpectralGap_OPEN` | KimSarnakChain | Hecke operator on L²(Γ₀(N)\ℍ) |
| `GRH_X0_143_OPEN` | C09_GRHDescent | GRH for L(s, X₀(143)) |
| `LanglandsGL2_X0_143_OPEN` | C09_GRHDescent | Langlands GL₂ spectral transfer |
| `Langlands_Descent_OPEN` | C09_GRHDescent | CPS 1999 Converse Theorem |
| `GRH_to_RH_Descent_143_OPEN` | C09_GRHDescent | IK 2004 Thm 5.15 + Cor 5.16 |
| `P5_HeckeTransfer_14_OPEN` | C09_GRHDescent | BC95 + Langlands Hecke transfer |
| `GrowthBound_OPEN` | GrowthContradiction | Exponential growth (Route A) |
| `ZeroRepulsion_OPEN` | GrowthContradiction | Zero repulsion (Route A) |
| CPS surfaces (5) | ConverseTheorem | CPS 1999 Converse Theorem chain |
| IK surfaces (6) | IwaniecKowalski | IK 2004 prime counting descent |

**Total named open surfaces: ~26. SORRY: 0.**

---

## File Structure

```
ArakelovRH/
  C01_Arakelov.lean           — X₀, ArithmeticSurface, Arakelov constants
  C02_Modularity.lean         — Modularity scaffold
  C03_Positivity.lean         — Positivity scaffold
  C04_HeightBound.lean        — Height bound scaffold
  C05_Discriminant.lean       — Discriminant scaffold
  C06_BostConnes.lean         — Bost-Connes spectral constants
  C07_RHCombinator.lean       — RH combinator scaffold
  C08_Positivity.lean         — BRICK: ArakelovPositivity + P5_conductor_times_genus
  C09_GRHDescent.lean         — GRH surfaces + Route A/B combinators
  C10_RHMainTheorem.lean      — Main theorem (both routes)
  C11_ArakelovPairing.lean    — BRICK: arakelovPairing > 0
  C14_SpectralGap.lean        — KimSarnak_OPEN, BC6, sq_free_143, lambda_1
  Master.lean                 — Bridge scaffold
  Spectral/
    SpectralAbstract.lean     — HasSpectralGap, spectral_bound, gap_reduction
    SelbergTrace143.lean      — Selberg trace formula surfaces for X₀(143)
    KimSarnakChain.lean       — Full chain: abstract gap → KimSarnak → RH
  Scaffold/
    GrowthContradiction.lean  — Route A: RH_genuine + exp_loglog proof
    IwaniecKowalski.lean      — IK Thm 5.15/5.16 + grh_to_rh_honest_note
    ConverseTheorem.lean      — CPS 1999 Converse Theorem scaffold
    AbbesUllmo.lean           — Abbes-Ullmo 1996 Thm 1.2
    JorgensonKramer.lean      — JK 1996 Table 1 constants
    KimSarnakAuxiliary.lean   — LambdaToNu_OPEN, NuBound_OPEN, discharge
    KimSarnakMainTheorem.lean — kim_sarnak_arithmetic, sq_le_of_abs_le
  ClassNumber/
    GenusFormula.lean         — Genus formula, index of Γ₀(143)
    ReducedForms.lean         — 10 reduced BQFs for discriminant -143
    NormFormBounds.lean       — norm form impossibilities, prime splitting
```

---

## Referee Verification

```lean
-- Unconditional bricks:
#print axioms ArakelovRH.arakelov_positivity_X0_143
#print axioms ArakelovRH.arakelovPairing_X0_143_pos
#print axioms ArakelovRH.sq_free_143

-- Spectral gap machinery (ported from yang-mills-gap):
#print axioms ArakelovRH.Spectral.gap_reduction
#print axioms ArakelovRH.Spectral.spectral_bound
#print axioms ArakelovRH.Spectral.hasSpectralGap_zero

-- Kim-Sarnak arithmetic:
#print axioms ArakelovRH.KimSarnakMainTheorem.kim_sarnak_arithmetic
#print axioms ArakelovRH.Spectral.KimSarnakChain.ks_arithmetic_chain

-- Route B chain (6-gate):
#print axioms ArakelovRH.Spectral.KimSarnakChain.ks_to_rh_full_chain

-- Route B direct (2-gate):
#print axioms ArakelovRH.grh_descent_to_RH

-- Route A:
#print axioms ArakelovRH.GrowthContradiction.riemannHypothesis_of_growth_and_repulsion

-- All expected: {propext, Classical.choice, Quot.sound}
```

---

## Run

```bash
lake build ArakelovRH
# DO NOT run `lake update` — Mathlib pinned to v4.12.0
```

---

## Related repositories (read-only references)

| Repo | Role |
|------|------|
| `DavidFox998/ClassNumber-143` | BSD tower: h(ℚ(√-143)) = 10, proved unconditionally |
| `DavidFox998/yang-mills-gap` | Abstract spectral gap machinery (SpectralAbstract ported from here) |

See `ROADMAP.md` for the full development plan.
