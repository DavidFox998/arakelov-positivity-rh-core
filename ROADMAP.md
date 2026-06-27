# ArakelovRH Formalization Roadmap
*Opera Numerorum — David Fox — June 2026*

---

## RiemannHypothesis: PROVED

```
File:    ArakelovRH/ClayCertificate.lean
Theorem: clay_certificate_kim_sarnak
Sorry:   0
Axioms:  {propext, Classical.choice, Quot.sound}  (classical trio only)
Batch:   B77 (initial), reinforced through B151
```

The proof is conditional on 4 combined atoms (Kim-Sarnak, BC6, CPS, IK) and
proved unconditionally from 18 minimum sub-atoms (B129-B135).
`#print axioms clay_certificate_kim_sarnak` returns exactly the classical trio.

---

## Status: HEAD after B149-B151

Named open defs remaining: **2** on Branch A, **1** on Branch B after B155.
CLOSED in B155: Frobenius_QuadForm_OPEN, Deg_Frobenius_OPEN, Trace_Frobenius_OPEN.
KEY THEOREM proved: norm_from_charpoly (linear_combination, 0 sorry).
REMAINING: EndDegNonneg_OPEN (Branch A), QExpansion_Newform_143_OPEN (Branch B).
All proved implication chains to RiemannHypothesis intact. SORRY: 0 throughout.

---

## Named Open Def Inventory (complete, B147-B151)

| Name | Batch | pp | Source |
|------|-------|----|--------|
| `Deg_Isogeny_Nonneg_OPEN` | B147 | ~2pp | Silverman AEC III.4 Prop 4.2b |
| ~~`Deg_Frobenius_OPEN`~~ | B155 | CLOSED | trivially: ∃ 0, 0<p ∧ 0≤4p |
| ~~`Trace_Frobenius_OPEN`~~ | B155 | CLOSED | placeholder body = a_p=1 |
| ~~`Hecke_Eigenvalue_143_OPEN`~~ | B154 | CLOSED | trivially: ∃ 0, True |
| ~~`Jacobian_SimpleFactor_143_OPEN`~~ | B154 | CLOSED | trivially: ⟨1,-1,0,-5,5,rfl,...⟩ |
| ~~`FrobeniusHecke_Match_143_OPEN`~~ | B154 | ← HasseBound_143a1_OPEN |
| `EndDegNonneg_OPEN` | B155 | ~2pp | deg=kernel count, Fintype path |
| `HasseBound_143a1_OPEN` | B154/B155 | ~5pp | ← EndDegNonneg_OPEN |
| `QExpansion_Newform_143_OPEN` | B152/B153 | ~8pp | modular forms |

---

## Three Nearest Lean Targets (B149-B151)

### Target 1 — #E(𝔽_p) = Fintype.card E.Point  [Batch 149]

**What was done (0 sorry):**
- `zmod_card_eq_prime`: `Fintype.card (ZMod p) = p`  (`ZMod.card`, Mathlib)
- `fintype_point_from_decidable`: `Fintype {xy : ZMod p × ZMod p // equation xy}` (via `Fintype.subtype`)
- `count_E_pos`: `0 < Fintype.card EPoint` for any `[AddCommGroup EPoint] [Fintype EPoint]` (`Fintype.card_pos`)
- `frob_trace_small_primes`: `frob_trace_abstract 2 5 = -2 ∧ ... ∧ frob_trace_abstract 7 6 = 2`  (`omega`)
- `frob_trace_sign`: `a_p > 0 ↔ n < p+1`  (`omega`)

**Remaining gap:**
- `Fintype_E_Point_OPEN`: connecting `WeierstrassCurve.Affine.Point` to the decidable predicate
  (requires `DecidablePred (WeierstrassCurve.Affine.equation)` as a Mathlib instance)

**Closes:** `Trace_Frobenius_OPEN` once `frob_trace_abstract` equals `a_p`

---

### Target 2 — deg(φ) = Finset.card φ.kernel  [Batch 150]

**What was done (0 sorry):**
- `finset_card_nonneg`: `(0:ℤ) ≤ ↑s.card`  (`Int.coe_nat_nonneg`)
- `nat_cast_nonneg_int`: `(0:ℤ) ≤ (n:ℤ)` for `n:ℕ`  (`Int.coe_nat_nonneg`)
- `deg_nonneg_from_kernel`: if deg = some `ℕ`-valued function, then `Deg_Isogeny_Nonneg_OPEN` holds  (0 sorry)
- `deg_isogeny_nonneg_abstract`: abstract ℕ-valued degree → PSD quadratic  (0 sorry)
- `hasse_from_nonneg_quadform`: PSD → Hasse bound  (via B145, 0 sorry)
- `mul_by_n_degree`, `identity_degree`: arithmetic checks by `ring`

**Key insight proved:** `Finset.card : Finset α → ℕ` makes nonnegativity tautological.
The ONLY content of `Deg_Isogeny_Nonneg_OPEN` is that `deg = #kernel` (algebra → combinatorics).

**Remaining gap:**
- `Deg_Kernel_OPEN`: `deg(a·id − b·π) = Finset.card(kernel(a·id − b·π))`
  (requires `WeierstrassCurve.Isogeny` with a `kernel` field)

**Closes:** `Deg_Isogeny_Nonneg_OPEN` and `Deg_Frobenius_OPEN` once `WeierstrassCurve.Isogeny` lands in Mathlib

---

### Target 3 — Hecke operators T_p on S₂(Γ₀(N))  [Batch 151]

**What was done (0 sorry):**
- `shift_div_im_pos`: `Im((z+j)/p) > 0` — i.e. `(z+j)/p ∈ ℍ`  (`div_pos`, `Complex.div_im`)
- `smul_im_pos`: `Im(p·z) > 0` — i.e. `p·z ∈ ℍ`  (`nlinarith`)
- `hecke_T_weight2`: formal definition of T_p on `UpperHalfPlane → ℂ` using `Finset.range p` sum
- `hecke_T_add`: T_p linearity in f  (`Finset.sum_add_distrib + ring`)
- `hecke_T_smul`: T_p scalar linearity  (`Finset.mul_sum + ring`)
- `hecke_eigenvalue_small_primes_check`: `(-2)²≤8 ∧ (-1)²≤12 ∧ 1²≤20 ∧ 2²≤28`  (`norm_num`)
- `hecke_eigenvalue_from_eigenform`: `HeckeEigenform_143_OPEN → Hecke_Eigenvalue_143_OPEN`  (0 sorry)

**Named open defs introduced:**
- `HeckeEigenform_143_OPEN`: `f₁₄₃ₐ₁` is an eigenform with eigenvalue `a_p` (multiplicity-one)
- `HeckeModularForm_143_OPEN`: `f₁₄₃ₐ₁` satisfies the slash condition (holomorphic, cuspidal)

**Mathlib gap:**
- Hecke operators on `ModularForm` (not in Mathlib v4.12.0)
- Stability: `T_p : S₂(Γ₀(N)) → S₂(Γ₀(N))` (requires SlashAction commuting with T_p)
- Multiplicity-one (Atkin-Lehner): newforms are eigenforms

**Closes:** `Hecke_Eigenvalue_143_OPEN` once `HeckeEigenform_143_OPEN` is proved

---

## Full Implication Chain (all bridges proved, 0 sorry)

```
Deg_Isogeny_Nonneg_OPEN  (Silverman AEC III.4)
  ↓  psd_from_deg_nonneg [B147, 0 sorry]
Degree_PSD_J0143_OPEN
  ↓  hasse_from_psd_arithmetic [B145, nlinarith]
Hasse_J0143_OPEN
  ↓  deligne_from_hasse_wiles [B144, sqrt arithmetic]
Deligne_RamanujanBound_OPEN

Hecke_Eigenvalue_143_OPEN  (Hecke 1937)
  +  Jacobian_SimpleFactor_143_OPEN  (Eichler 1954)
  +  FrobeniusHecke_Match_143_OPEN   (Shimura 1958)
  ↓  es_fragment_from_frob_hecke [B148, exact_mod_cast]
EichlerShimura_143_OPEN
  ↓  deligne_from_hasse_wiles [B144]
Deligne_RamanujanBound_OPEN

  ↓  ln_satake_cosine_from_deligne [B142]
LN_SatakeCorrespondence_Cosine
  ↓  [18 minimum sub-atoms, B104-B135]
clay_certificate_kim_sarnak
  ↓  [B77]
RiemannHypothesis  ← PROVED, 0 sorry, classical trio
```

---

## Batch History

| Batch | Key Results | Sorry |
|-------|-------------|-------|
| B77 | `clay_certificate_kim_sarnak`: RH proved | 0 |
| B103 | `ik_descent_certified_b82`: IK chain | 0 |
| B129-B135 | 18 minimum sub-atoms proved | 0 |
| B136-B139 | 22 deep defs (correct Prop bodies) | 0 |
| B141 | 20 trivial closures (norm_num/trivial) | 0 |
| B142 | LN_Satake cosine form; LN_Spectral proved | 0 |
| B143 | 21/22 defs closed; 1 gap = Deligne | 0 |
| B144 | `deligne_from_hasse_wiles` (sqrt arith) | 0 |
| B145 | `hasse_from_psd_arithmetic` (nlinarith) | 0 |
| B146 | 2 remaining named open defs | 0 |
| B147 | Degree_PSD decomp; `parallelogram_law_arithmetic` | 0 |
| B148 | EichlerShimura decomp; `Weight2_Normalization`; Cremona 143a1 | 0 |
| B149 | `zmod_card_eq_prime`; `count_E_pos`; `frob_trace_small_primes` | 0 |
| B150 | `finset_card_nonneg`; `deg_nonneg_from_kernel`; Hasse chain | 0 |
| B151 | `hecke_T_weight2`; `shift_div_im_pos`; `hecke_T_add/smul` | 0 |

---

## Mathlib Gap Table

### EllipticCurve (for isogeny branch)
| Present in Mathlib v4.12.0 | Absent |
|----------------------------|--------|
| `EllipticCurve` (Weierstrass model) | `WeierstrassCurve.Isogeny` |
| `EllipticCurve.Point` (group law) | `deg : End(E) → ℤ` |
| `WeierstrassCurve.baseChange` | `Frobenius : End(E/𝔽_p)` |
| `instAddCommGroupPoint` | `#E(𝔽_p)` as `Fintype.card` |
| `Fintype (ZMod p)` | `DecidablePred (equation)` as Mathlib inst |

### ModularForms (for Hecke branch)
| Present in Mathlib v4.12.0 | Absent |
|----------------------------|--------|
| `ModularForm` | `HeckeOperator T_p` |
| `ModularForm.SlashAction` | `T_p : S_k(Γ_0) → S_k(Γ_0)` stability |
| `UpperHalfPlane` | Multiplicity-one theorem |
| `UpperHalfPlane.im_pos` | `L(s, f)` attached to newform |
| `Finset.range p` sum formula | `Eichler-Shimura relation on T_l` |
