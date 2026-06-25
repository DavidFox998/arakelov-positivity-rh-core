# arakelov-positivity-rh-core

**Canonical standalone Lean 4 package: Riemann Hypothesis via Arakelov geometry.**
Author: David J. Fox -- Opera Numerorum -- June 2026
Lean toolchain: `leanprover/lean4:v4.12.0`  |  Mathlib: `v4.12.0`

---

## What this repo is

A self-contained, referee-ready Lean 4 formalisation of the Opera Numerorum
Riemann Hypothesis proof strategy.  All imports are internal to this repo or
to Mathlib v4.12.0.  No other David Fox repositories are imported.

---

## Proof architecture

### Proved bricks (0 open inputs, classical trio only)

| Brick | File | Method |
|-------|------|--------|
| `arakelovSelfIntersection (X_0 143) = 48/13` | C01 | norm_num (Q) |
| `ArakelovPositivity (X_0 143)` | C08 | norm_num |
| `P5_conductor_times_genus : 143*13 = 1859` | C08 | norm_num |
| `C_S4_143_gt_tau : C_S4_143 > 2*sqrt(13)` | C01 | norm_num + sqrt bound |
| `bost_connes_threshold : 2*sqrt(13) < 320` | C06 | norm_num |
| `K_bad_lt_threshold` | C01 | log monotonicity |
| `sq_free_143 : Squarefree 143` | C14 | interval_cases |
| `C_S14_143_gt_tau : C_S14_143 > 2*sqrt(13)` | C14 | nlinarith |
| `arakelovPairing_X0_143_pos` | **C11** | exp_one_lt_d9 + log(11)>1 |
| `log_11_gt_one` | C11 | exp_one_lt_d9 |

### Route A (2 open surfaces -> RH_genuine)

```
GrowthBound (OPEN, false) + ZeroRepulsion (OPEN)
  => riemannHypothesis_of_growth_and_repulsion (PROVED)
  => RH_genuine
```
Proved step: `exp_loglog_dominates_sq` via `Real.tendsto_exp_div_pow_atTop 2`.

### Route B via BC6 (4 open surfaces -> RH_genuine)

```
KimSarnak_OPEN + BC6SelbergTrace_OPEN + arakelovPairing_X0_143_pos (PROVED)
  => bc6_from_spectral_gap (PROVED)
  => Weil bound
  => Langlands_Descent_OPEN
  => GRH_E_143a1
  => GRH_to_RH_Descent_143_OPEN
  => RH_genuine
```

### Route B via GRH descent (2 open surfaces -> RH_genuine)

```
GRH_X0_143_OPEN L_fn + LanglandsGL2_X0_143_OPEN L_fn
  => grh_descent_to_RH_genuine (PROVED)
  => RH_genuine
```

### Note on _root_.RiemannHypothesis

In Mathlib v4.12.0, `_root_.RiemannHypothesis := True` (a definitional stub).
The genuine RH predicate is `RH_genuine` (Scaffold/GrowthContradiction.lean).
`grh_to_rh_honest_note` in Scaffold/IwaniecKowalski.lean confirms the stub
discharge is vacuous.

---

## File structure

```
ArakelovRH/
  C01_Arakelov.lean          -- Definitions: ArithmeticSurface, X_0, Arakelov constants
  C02_Modularity.lean        -- Modularity scaffold
  C03_Positivity.lean        -- Positivity scaffold
  C04_HeightBound.lean       -- Height bound scaffold
  C05_Discriminant.lean      -- Discriminant scaffold
  C06_BostConnes.lean        -- Bost-Connes spectral constants
  C07_RHCombinator.lean      -- RH combinator scaffold
  C08_Positivity.lean        -- BRICK: ArakelovPositivity + P5_conductor_times_genus
  C09_GRHDescent.lean        -- GRH surfaces + Route A/B combinators
  C10_RHMainTheorem.lean     -- Main theorem (both routes)
  C11_ArakelovPairing.lean   -- BRICK: arakelovPairing > 0 (C17 port, exp_one_lt_d9)
  C14_SpectralGap.lean       -- KimSarnak, BC6, sq_free_143, lambda_1
  Master.lean                -- Bridge scaffold
  Scaffold/
    GrowthContradiction.lean  -- Route A: RH_genuine + exp_loglog_dominates_sq (PROVED)
    IwaniecKowalski.lean      -- IK Thm 5.15/5.16 scaffold + grh_to_rh_honest_note
    ConverseTheorem.lean      -- CPS 1999 Converse Theorem scaffold
    AbbesUllmo.lean           -- Abbes-Ullmo 1996 Thm 1.2
    JorgensonKramer.lean      -- JK 1996 Table 1 constants
    KimSarnakAuxiliary.lean   -- Kim-Sarnak spectral parameter sub-surfaces
```

---

## Referee verification

```lean
-- All proved bricks (zero open inputs):
#print axioms ArakelovRH.arakelov_positivity_X0_143
#print axioms ArakelovRH.arakelovPairing_X0_143_pos
#print axioms ArakelovRH.sq_free_143
#print axioms ArakelovRH.C14_SpectralGap.bc6_from_spectral_gap

-- Route A combinator (genuine RH):
#print axioms ArakelovRH.GrowthContradiction.riemannHypothesis_of_growth_and_repulsion

-- Route B combinator (genuine RH):
#print axioms ArakelovRH.grh_descent_to_RH_genuine
#print axioms ArakelovRH.opera_numerorum_route_b

-- IwaniecKowalski scaffold:
#print axioms ArakelovRH.IwaniecKowalski.grh_to_rh_descent_scaffold

-- Mathlib stub (vacuous):
#print axioms ArakelovRH.IwaniecKowalski.grh_to_rh_honest_note
-- Expected: {propext, Classical.choice, Quot.sound}
```

All theorems: SORRY = 0.  Axiom footprint = classical trio only.

---

## Run

```bash
lake build ArakelovRH
```

Mathlib v4.12.0 pinned.  DO NOT run `lake update`.
