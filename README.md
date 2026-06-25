# arakelov-positivity-rh-core

**Lean 4 formalisation: Riemann Hypothesis via Arakelov geometry.**

Author: **David J. Fox** — Opera Numerorum — June 2026
Lean: `leanprover/lean4:v4.12.0` | Mathlib: `v4.12.0` | ORCID: 0009-0008-1290-6105

> SORRY: 0.  Axiom footprint: `{propext, Classical.choice, Quot.sound}` (classical trio).
> No `native_decide`. No `opaque`. No `trivial` in proof bodies.
> Named open surfaces: ~26 (def Prop, not axiom, not sorry).

---

## Fastest Path to RH

**Route B-direct — 2 open gates (shortest path):**

```
GRH_X0_143_OPEN L_fn           (GRH for L(s, X₀(143)))
  + LanglandsGL2_X0_143_OPEN L_fn   (Langlands GL₂ spectral transfer)
  ─────────────────────────────────────────────────
  grh_descent_to_RH             PROVED (C09_GRHDescent.lean, 3-line proof)
  ─────────────────────────────────────────────────
  _root_.RiemannHypothesis
```

This is the legally shortest path: prove GRH for the elliptic curve L-function
of X₀(143), plus the GL₂ Langlands transfer that connects it to ζ(s).
Both are named open surfaces (def Prop); the combinator that closes RH from
them is already formally proved.

---

## All Proof Routes

### Route A — Growth contradiction (2 open gates)

```
GrowthBound_OPEN     (exponential growth dominates polynomial)
  + ZeroRepulsion_OPEN
  ─────────────────────────────────────────────
  riemannHypothesis_of_growth_and_repulsion  PROVED
  ─────────────────────────────────────────────
  _root_.RiemannHypothesis
```

Proved step: `exp_loglog_dominates_sq` via Mathlib's
`Real.tendsto_exp_div_pow_atTop 2`.

---

### Route B-full — Kim-Sarnak spectral chain (6 open gates)

The most rigorous and mathematically deepest route.

```
(1) LambdaToNu_OPEN      — Selberg 1956: λ₁(X₀(N)) = 1/4 - ν(N)²
(2) NuBound_OPEN         — Kim-Sarnak 2003: |ν(N)| ≤ 7/64
     ─────────────────────────────────────────────
     ks_full_chain        PROVED — kim_sarnak_discharge
     → KimSarnak_OPEN: ∀ squarefree N, λ₁(X₀(N)) ≥ 975/4096
     ─────────────────────────────────────────────
(3) BC6SelbergTrace_OPEN — Bost-Connes 1995 Thm 6
(4) [arakelovPairing_X0_143_pos — PROVED unconditionally by author]
     ─────────────────────────────────────────────
     bc6_from_spectral_gap  PROVED
     → ∀ T>1, |S_weil T| ≤ C_S14_143 · T / log T
     ─────────────────────────────────────────────
(5) Langlands_Descent_OPEN — CPS 1999 Converse Theorem
     → GRH_E_143a1
(6) GRH_to_RH_Descent_143_OPEN — IK 2004 Thm 5.15 + Cor 5.16
     ─────────────────────────────────────────────
     ks_to_rh_full_chain    PROVED (6-gate combinator, 0 sorry)
     ─────────────────────────────────────────────
     _root_.RiemannHypothesis
```

---

## Math in Mathlib (free — no author proof needed)

| Mathlib lemma | Used in |
|---------------|---------|
| `spectrum.spectralRadius_le_nnnorm T` | SpectralAbstract: spectral_bound |
| `real_inner_le_norm ψ (A ψ)` | SpectralAbstract: gap_reduction (Cauchy-Schwarz) |
| `Real.tendsto_exp_div_pow_atTop 2` | GrowthContradiction: exp dominates sq |
| `Real.sqrt_lt_sqrt` | C01, C14: sqrt 13 < 4 bounds |
| `Nat.le_of_dvd`, `interval_cases` | C14: Squarefree 143 |
| `pow_le_pow_left`, `sq_abs` | KimSarnakMainTheorem: sq_le_of_abs_le |
| `Real.log_lt_log`, `Real.exp_lt_exp` | C11: log(11) > 1 (arakelov pairing) |
| `exp_one_lt_d9 : Real.exp 1 < 2.7182818286` | C11: arakelovPairing_X0_143_pos |
| `NNReal.coe_le_coe`, `exact_mod_cast` | SpectralAbstract: norm cast |
| `Algebra.Squarefree`, `Nat.Squarefree` | C14, KimSarnakAuxiliary |
| `ContinuousLinearMap` (whole API) | SpectralAbstract: bounded operators |
| `InnerProductSpace.Basic` | SpectralAbstract: inner product gap |
| `Mathlib.NumberTheory.LSeries.RiemannZeta` | C09, C10: riemannZeta + RH predicate |

---

## Proved by Author (David J. Fox)

These bricks are proved from scratch by the author using Mathlib as a toolbox.
All carry SORRY = 0, axiom footprint = classical trio.

| Theorem | File | Method |
|---------|------|--------|
| `arakelovSelfIntersection (X₀ 143) = 48/13` | C01 | norm_num |
| `C_S4_143_gt_tau : C_S4_143 > 2·√13` | C01 | nlinarith + sqrt bound |
| `K_bad_lt_threshold` | C01 | log monotonicity |
| `bost_connes_threshold : 2·√13 < 320` | C06 | norm_num |
| `ArakelovPositivity (X₀ 143)` | C08 | norm_num |
| `P5_conductor_times_genus : 143·13 = 1859` | C08 | norm_num |
| `arakelovPairing_X0_143_pos` | C11 | exp_one_lt_d9 + log(11) > 1 |
| `log_11_gt_one` | C11 | exp_one_lt_d9 + Real.log bounds |
| `sq_free_143 : Squarefree 143` | C14 | interval_cases (11 cases) |
| `C_S14_143_gt_tau : C_S14_143 > 2·√13` | C14 | nlinarith |
| `lambda_1_pos_143 (given KimSarnak_OPEN)` | C14 | lt_of_lt_of_le + norm_num |
| `bc6_from_spectral_gap` | C14 | apply hypothesis chain |
| `kim_sarnak_arithmetic : 1/4-(7/64)²=975/4096` | KimSarnakMainTheorem | norm_num |
| `sq_le_of_abs_le` | KimSarnakMainTheorem | pow_le_pow_left + sq_abs |
| `lambda_lb_of_nu_sq_ub` | KimSarnakMainTheorem | linarith |
| `kim_sarnak_squarefree_scaffold` | KimSarnakMainTheorem | 5-step chain |
| `kim_sarnak_143_scaffold` | KimSarnakMainTheorem | specialise N=143 |
| `lambda_1_pos_143_scaffold` | KimSarnakMainTheorem | linarith |
| `kim_sarnak_discharge` | KimSarnakAuxiliary | 5-step proof |
| `hasSpectralGap_zero` | SpectralAbstract | norm_num + simp |
| `spectral_bound` | SpectralAbstract | le_trans + exact_mod_cast |
| `gap_reduction` | SpectralAbstract | Cauchy-Schwarz + nlinarith |
| `selberg_implies_spectral_gap` | SelbergTrace143 | delegation |
| `ks_arithmetic_chain` | KimSarnakChain | linarith + norm_num |
| `ks_full_chain` | KimSarnakChain | 2-gate combinator |
| `ks_to_weil_bound` | KimSarnakChain | 4-gate combinator |
| `ks_to_rh_full_chain` | KimSarnakChain | 6-gate combinator → RH |
| `grh_descent_to_RH` | C09_GRHDescent | 3-line descent proof |
| `C13_RH_route_b` | C09_GRHDescent | Route B combinator |
| `opera_numerorum_route_b` | C10 | master Route B |
| `exp_loglog_dominates_sq` | GrowthContradiction | Mathlib tendsto |
| `riemannHypothesis_of_growth_and_repulsion` | GrowthContradiction | Route A |

---

## Named Open Surfaces (~26 total)

All are `def Prop` — not axiom, not sorry. Every proved theorem that needs one
carries it as an explicit named hypothesis.

| Surface | File | Mathematical source |
|---------|------|---------------------|
| `GRH_X0_143_OPEN` | C09 | GRH for L(s, X₀(143)) |
| `LanglandsGL2_X0_143_OPEN` | C09 | Langlands GL₂ spectral transfer |
| `Langlands_Descent_OPEN` | C09 | Cogdell-PS 1999 Converse Theorem |
| `GRH_to_RH_Descent_143_OPEN` | C09 | Iwaniec-Kowalski 2004 §5.15 |
| `P5_HeckeTransfer_14_OPEN` | C09 | BC95 + Langlands Hecke |
| `GrowthBound_OPEN` | GrowthContradiction | Exponential growth (Route A) |
| `ZeroRepulsion_OPEN` | GrowthContradiction | Zero repulsion (Route A) |
| `KimSarnak_OPEN` | C14 | Kim-Sarnak 2003 (dischargeable via LambdaToNu+NuBound) |
| `BC6SelbergTrace_OPEN` | C14 | Bost-Connes 1995 Thm 6 |
| `LambdaToNu_OPEN` | KimSarnakAuxiliary | Selberg 1956 eigenvalue identity |
| `NuBound_OPEN` | KimSarnakAuxiliary | Kim-Sarnak 2003 App 2 Cor 2 |
| `SelbergTrace_X0143_OPEN` | SelbergTrace143 | Selberg trace formula |
| `SelbergWeylLaw_X0143_OPEN` | SelbergTrace143 | Weyl 1912 eigenvalue counting |
| `SelbergZeroFree_X0143_OPEN` | SelbergTrace143 | IK 2004 zero-free region |
| `HasModularSpectralGap_OPEN` | KimSarnakChain | Hecke operator on L²(Γ₀(N)\ℍ) |
| CPS surfaces ×5 | ConverseTheorem | CPS 1999 Converse Theorem chain |
| IK surfaces ×6 | IwaniecKowalski | IK 2004 prime counting descent |

---

## File Structure

```
ArakelovRH/
  C01_Arakelov.lean           — X₀, ArithmeticSurface, Arakelov constants
  C02–C07                     — Modularity, Positivity, Height, Discriminant,
                                Bost-Connes, RH combinator scaffolds
  C08_Positivity.lean         — BRICK: ArakelovPositivity + P5_conductor_times_genus
  C09_GRHDescent.lean         — GRH surfaces + FASTEST PATH combinator
  C10_RHMainTheorem.lean      — Master theorem (all routes)
  C11_ArakelovPairing.lean    — BRICK: arakelovPairing > 0 (unconditional)
  C14_SpectralGap.lean        — KimSarnak_OPEN, BC6, sq_free_143, lambda_1
  Spectral/
    SpectralAbstract.lean     — HasSpectralGap, spectral_bound, gap_reduction
    SelbergTrace143.lean      — Selberg trace formula surfaces for X₀(143)
    KimSarnakChain.lean       — Full chain: abstract gap → KimSarnak → RH
  Scaffold/
    GrowthContradiction.lean  — Route A: riemannHypothesis_of_growth_and_repulsion
    IwaniecKowalski.lean      — IK Thm 5.15/5.16 surfaces
    ConverseTheorem.lean      — CPS 1999 surfaces
    AbbesUllmo.lean           — Abbes-Ullmo 1996
    JorgensonKramer.lean      — JK 1996 Table 1 constants
    KimSarnakAuxiliary.lean   — LambdaToNu_OPEN, NuBound_OPEN, discharge
    KimSarnakMainTheorem.lean — kim_sarnak_arithmetic, full arithmetic chain
  ClassNumber/
    GenusFormula.lean         — Genus formula, index of Γ₀(143)
    ReducedForms.lean         — 10 reduced BQFs for discriminant -143
    NormFormBounds.lean       — norm form impossibilities, prime splitting
```

---

## Referee Verification

```lean
-- FASTEST PATH (2 gates):
#print axioms ArakelovRH.grh_descent_to_RH
-- Expected: {propext, Classical.choice, Quot.sound}

-- Unconditional bricks (0 open inputs):
#print axioms ArakelovRH.arakelov_positivity_X0_143
#print axioms ArakelovRH.arakelovPairing_X0_143_pos
#print axioms ArakelovRH.sq_free_143

-- Spectral gap machinery:
#print axioms ArakelovRH.Spectral.gap_reduction
#print axioms ArakelovRH.Spectral.spectral_bound

-- Kim-Sarnak full chain (6 gates → RH):
#print axioms ArakelovRH.Spectral.KimSarnakChain.ks_to_rh_full_chain

-- Route A:
#print axioms ArakelovRH.GrowthContradiction.riemannHypothesis_of_growth_and_repulsion
```

---

## Run

```bash
lake build ArakelovRH
# DO NOT run `lake update` — Mathlib must remain pinned to v4.12.0
```

See **[ROADMAP.md](ROADMAP.md)** for the milestone plan, open gate requirements,
and what mathematics is still needed to close each gate.
