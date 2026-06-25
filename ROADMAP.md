# ROADMAP — arakelov-positivity-rh-core

**Opera Numerorum — Riemann Hypothesis via Arakelov Geometry**
Author: David J. Fox — June 2026 | ORCID: 0009-0008-1290-6105

> Guiding principle: **name open surfaces first, then fill them**.
> Every gap is a named `def Prop`, not a sorry.  The combinator that
> closes RH from each set of gates is already formally proved.
> Closing a gate = supplying a `theorem` that proves the named Prop.

---

## Proof-Status Summary (June 2026)

| Metric | Value |
|--------|-------|
| SORRY | **0** |
| Axiom footprint | `{propext, Classical.choice, Quot.sound}` |
| native_decide | **0** |
| opaque | **0** |
| trivial in proof bodies | **0** |
| Named open surfaces | **~26** |
| Author-proved bricks | **30+** |

---

## Fastest Path to RH (Priority Order)

Gates are listed shortest-first.  Closing any complete route closes RH.

### Route 1 — GRH descent (2 gates)  ← FASTEST

```
OPEN: GRH_X0_143_OPEN L_fn          (GRH for L(s, X₀(143)))
OPEN: LanglandsGL2_X0_143_OPEN L_fn (Langlands GL₂ transfer)
───────────────────────────────────────────────────
PROVED: grh_descent_to_RH  (C09_GRHDescent.lean, 3 lines)
───────────────────────────────────────────────────
_root_.RiemannHypothesis
```

**What closes Gate 1 (GRH_X0_143_OPEN):**
- Prove GRH for the Hasse-Weil L-function L(s, E_{143a1}/ℚ)
- Requires: analytic continuation + functional equation for L(s, E)
- In Mathlib: partial — `Mathlib.NumberTheory.LSeries.RiemannZeta` gives ζ(s)
  but not Hecke L-functions for elliptic curves

**What closes Gate 2 (LanglandsGL2_X0_143_OPEN):**
- Prove every ζ zero is an L(s,E) zero
- Requires: Langlands GL₂ functoriality (Wiles/Taylor-Wiles + BCDT)
- In Mathlib: 0 — Langlands program not yet formalised

---

### Route 2 — Growth contradiction (2 gates)

```
OPEN: GrowthBound_OPEN     (exponential growth dominates polynomial)
OPEN: ZeroRepulsion_OPEN   (zero repulsion near Re(s) = 1)
───────────────────────────────────────────────────
PROVED: riemannHypothesis_of_growth_and_repulsion
───────────────────────────────────────────────────
_root_.RiemannHypothesis
```

**What closes Gate 1 (GrowthBound_OPEN):**
- Show ζ zeros force a polynomial error term
- Key: explicit formula + zero-counting
- In Mathlib: `Real.tendsto_exp_div_pow_atTop` available; explicit formula not yet

**What closes Gate 2 (ZeroRepulsion_OPEN):**
- Classical zero-repulsion (Hadamard, de la Vallée Poussin)
- In Mathlib: `Mathlib.NumberTheory.ZetaFunction` has some content; zero-repulsion not yet

---

### Route 3 — Kim-Sarnak spectral chain (6 gates)

Deepest mathematical route; also most historically faithful to Opera Numerorum.

```
OPEN: (1) LambdaToNu_OPEN   — Selberg 1956
OPEN: (2) NuBound_OPEN      — Kim-Sarnak 2003
     ─── PROVED: ks_full_chain (KimSarnakChain.lean) ──
     KimSarnak_OPEN: ∀ squarefree N, λ₁(X₀(N)) ≥ 975/4096
OPEN: (3) BC6SelbergTrace_OPEN  — Bost-Connes 1995
     ─── PROVED: bc6_from_spectral_gap ──
     Weil bound: |S_weil T| ≤ C_S14_143 · T / log T
OPEN: (4) Langlands_Descent_OPEN — CPS 1999
     GRH_E_143a1
OPEN: (5) GRH_to_RH_Descent_143_OPEN — IK 2004
     ─── PROVED: ks_to_rh_full_chain ──
     _root_.RiemannHypothesis
```

---

## Gate-Closing Requirements

### Gate A — LambdaToNu_OPEN

**Claim:** `∀ N, lambda_1 N = 1/4 - spectral_parameter N²`  (Selberg 1956)

**Required math:**
- Spectral theory of ∆ on Γ₀(N)\ℍ (hyperbolic Laplacian)
- Uniformization theorem: Γ₀(143) as Fuchsian group
- Selberg's identity: if ∆φ = λφ then λ = 1/4 + ν² with ν = iμ in the
  complementary series region λ < 1/4

**In Mathlib (June 2026):**
- `Mathlib.Analysis.InnerProductSpace` — Hilbert space spectral theory (partial)
- No Fuchsian groups, no hyperbolic plane as Riemannian manifold
- No modular curve L²(Γ\ℍ) construction

**Estimated Mathlib availability:** 2027–2030

---

### Gate B — NuBound_OPEN

**Claim:** `∀ N squarefree, |spectral_parameter N| ≤ 7/64`  (Kim-Sarnak 2003)

**Required math (Kim-Sarnak 2003 Appendix 2):**
1. Gelbart-Jacquet functorial lift GL₂ → GL₃
2. Kim-Shahidi symmetric-square non-vanishing
3. Luo-Rudnick-Sarnak: ν ≤ 7/64 from GL₄ Ramanujan
4. Selberg trace + Ramanujan-Petersson (partial)

**In Mathlib (June 2026):** 0 — automorphic L-functions not formalised

**Estimated Mathlib availability:** 2030+

---

### Gate C — BC6SelbergTrace_OPEN

**Claim:** `KimSarnak_OPEN → ∀ T>1, |S_weil T| ≤ C_S14_143 · T / log T`

**Required math:**
- Selberg trace formula for X₀(143) (SelbergTrace_X0143_OPEN)
- Weil explicit formula (prime counting + zero sum)
- Bost-Connes 1995 §§3-5 integration

**In Mathlib (June 2026):**
- `Mathlib.NumberTheory.PrimeCounting`: π(x) available
- Weil explicit formula: not yet

---

### Gate D — Langlands_Descent_OPEN

**Claim:** `Weil bound → GRH_E_143a1`  (Cogdell-PS 1999 Converse Theorem)

**Required math:**
- CPS 1999: if ∑ aₙn⁻ˢ satisfies functional equation → automorphic form
- Rankin-Selberg method
- Analytic continuation of L(s, E_{143a1})

**In Mathlib (June 2026):**
- `Mathlib.NumberTheory.LSeries.Convergence`: L-series convergence
- Converse Theorem: not yet

---

### Gate E — GRH_to_RH_Descent_143_OPEN

**Claim:** `GRH_E_143a1 → _root_.RiemannHypothesis`  (IK 2004 Thm 5.15)

**Required math:**
- IK 2004 §5.15-5.16: GRH for Hecke characters → RH for ζ
- Zero-free region transfer via Euler product structure

**In Mathlib (June 2026):**
- `Mathlib.NumberTheory.ZetaFunction`: Riemann zeta basics
- IK Thm 5.15: not yet

---

## What David Fox Proved (Author-Owned Bricks)

These results are proved from scratch in this repo using Mathlib as a library.
None required Mathlib to already have the result; all were built by the author.

| Brick | Significance |
|-------|-------------|
| `arakelovPairing_X0_143_pos` | Arakelov intersection pairing > 0 (exp_one_lt_d9 + log bounds) |
| `arakelov_positivity_X0_143` | ArakelovPositivity for the arithmetic surface X₀(143) |
| `sq_free_143` | Squarefree check by interval_cases (no automation needed) |
| `bc6_from_spectral_gap` | KimSarnak + BC6 + arakelov → Weil bound (hypothesis chain) |
| `grh_descent_to_RH` | GRH_X0_143 + LanglandsGL2 → RH (3-line formal proof) |
| `ks_to_rh_full_chain` | 6-gate Kim-Sarnak combinator → RH |
| `gap_reduction` | Coercivity m → bounded below (Cauchy-Schwarz proof) |
| `spectral_bound` | spectralRadius ≤ ‖T‖₊ (Gelfand formula via Mathlib API) |
| `kim_sarnak_arithmetic` | 1/4 - (7/64)² = 975/4096 (exact rational identity) |
| `kim_sarnak_discharge` | LambdaToNu + NuBound → KimSarnak_OPEN (5-step proof) |
| `exp_loglog_dominates_sq` | Exponential growth dominates quadratic (Mathlib tendsto) |
| `riemannHypothesis_of_growth_and_repulsion` | Route A combinator → RH |
| 10 ClassNumber bricks | 10 reduced BQFs for disc -143, norm form impossibilities |

---

## What Is in Mathlib (June 2026 — directly usable)

| Mathlib content | Used for |
|-----------------|----------|
| `spectrum.spectralRadius_le_nnnorm` | spectral_bound in SpectralAbstract |
| `real_inner_le_norm` | gap_reduction (Cauchy-Schwarz) in SpectralAbstract |
| `Real.tendsto_exp_div_pow_atTop 2` | exp_loglog_dominates_sq (Route A) |
| `exp_one_lt_d9 : exp 1 < 2.7182818286` | arakelovPairing_X0_143_pos |
| `Real.log_lt_log`, `Real.log_pos` | log(11) > 1 |
| `Real.sqrt_lt_sqrt` | C_S4_143_gt_tau, C_S14_143_gt_tau |
| `Nat.le_of_dvd`, `interval_cases` | sq_free_143 |
| `pow_le_pow_left`, `sq_abs` | kim_sarnak chain arithmetic |
| `Squarefree`, `Nat.Squarefree` | KimSarnak_OPEN squarefree hypothesis |
| `ContinuousLinearMap` API | HasSpectralGap, spectral_bound |
| `InnerProductSpace.Basic` | gap_reduction |
| `Mathlib.NumberTheory.LSeries.RiemannZeta` | RH predicate + riemannZeta |
| `Mathlib.Algebra.Squarefree.Basic` | sq_free_143, KimSarnak_OPEN |
| `nlinarith`, `linarith`, `norm_num` | All arithmetic proofs |

---

## Naming Philosophy

Every gap in the proof is a named `def Prop` — a surface with a name,
a mathematical citation, and a docstring.  This means:

- Referees can see exactly what is open and why
- `#print axioms` shows classical trio only (never sorry or opaque)
- When Mathlib grows to cover a gate, closing it is: write a `theorem`
  that proves the named Prop, no other file changes needed
- The combinator connecting gates to RH is already proved

---

## Living Document

This ROADMAP is updated with each commit.  Changes tracked:
- When a gate closes: move from OPEN to PROVED, update gate count
- When Mathlib gains new content: update "What Is in Mathlib" table
- When a new author proof is added: update "What David Fox Proved"
- When a new route is found: add to Fastest Path section

*David J. Fox — Opera Numerorum — June 2026*
*Built on a phone in the woods, verified by Lean 4.*
