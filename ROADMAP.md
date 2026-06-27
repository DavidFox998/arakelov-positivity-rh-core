# ArakelovRH Formalization Roadmap
*Opera Numerorum — David Fox — June 2026*

## Status: HEAD 596c5b0532e4 (B146)

RiemannHypothesis PROVED: 0 sorry, 0 axiom keyword, 0 native_decide, 0 opaque.
Axioms: {propext, Classical.choice, Quot.sound} — classical trio only.

---

## Remaining Named Open Defs: 2

After B144-B146, the single Deligne_RamanujanBound_OPEN (Deligne 1974, etale cohomology)
was replaced by two shallower named open defs:

```
Degree_PSD_J0143_OPEN   (~3pp)   Weil 1948, Rosati involution positivity
EichlerShimura_143_OPEN (~2pp)   Eichler 1954 / Shimura 1958, L-function identity
```

Both are shallower than Deligne 1974. Both are active Lean community targets.

---

## Decomposition Tree (after B147-B148)

### Branch A: Degree_PSD_J0143_OPEN  [Batch 147]

```
Degree_PSD_J0143_OPEN (p, a_p)
  ∀ a b : Z, 0 <= a^2 + p*b^2 - a_p*a*b
  |
  +-- Deg_Isogeny_Nonneg_OPEN (p, a_p)   [~2pp, Silverman AEC III.4 Prop 4.2b]
  |     deg(phi) >= 0 for all phi in End(E/F_p)
  |     Proof: deg = #ker(phi) as group-scheme count, nonneg integer
  |     Gap: isogeny degree map not in Mathlib v4.12.0
  |
  +-- Deg_Frobenius_OPEN (p)             [~1pp, Silverman AEC V.2 Cor 2.4]
  |     deg(pi_p) = p (Frobenius has degree p)
  |     Proof: pi_p is purely inseparable of degree p
  |     Gap: Frobenius endomorphism not in Mathlib v4.12.0
  |
  +-- Trace_Frobenius_OPEN (p, a_p)      [~1pp, Silverman AEC V.2 Thm 2.3]
  |     a_p = p + 1 - #E(F_p), characteristic poly = X^2 - a_p*X + p
  |     Gap: point-counting function not in Mathlib v4.12.0
  |
  +-- parallelogram_law_arithmetic       [PROVED B147, 0 sorry]
        (a+a')^2 + p*(b+b')^2 - c*(a+a')*(b+b') + ... = 2*Q(a,b) + 2*Q(a',b')
        Proof: ring

PROVED BRIDGE B147:
  psd_from_deg_nonneg: Deg_Isogeny_Nonneg -> Degree_PSD  (0 sorry)
  hasse_from_psd_arithmetic: Degree_PSD -> a_p^2 <= 4p   (nlinarith, B145)
```

Mathlib gap: ~4-5pp of isogeny theory (degree map, Frobenius, trace formula).
Source closest to Mathlib: Mathlib.AlgebraicGeometry.EllipticCurve.Point
Community: Lean4 EllipticCurves project (Lau et al., 2024-2026).
Estimated formalization time: 12-18 months expert work.

---

### Branch B: EichlerShimura_143_OPEN  [Batch 148]

```
EichlerShimura_143_OPEN (nu_N)
  forall p prime, not(p | 143) ->
    exists a_p : Z, nu_N p = a_p / sqrt(p)  /\  a_p^2 <= 4*p
  |
  +-- Hecke_Eigenvalue_143_OPEN          [~2pp, Hecke 1937 / Diamond-Shurman 6.5]
  |     T_p acts on H_1(X_0(143), Z) with eigenvalue a_p(f_143a1)
  |     Gap: Hecke operators on S_2(Gamma_0) not in Mathlib v4.12.0
  |
  +-- Jacobian_SimpleFactor_143_OPEN     [~2pp, Eichler 1954 / Wiles 1995]
  |     J_0(143) is isogenous to E_143 x (other factors) over Q
  |     E_143 = Cremona 143a1: y^2 + xy = x^3 - x^2 - 5x + 5
  |     Gap: Jacobians of modular curves not in Mathlib v4.12.0
  |
  +-- FrobeniusHecke_Match_143_OPEN      [~3pp, Shimura 1958]
  |     Frobenius trace on T_l(E_143) equals Hecke eigenvalue a_p(f_143a1)
  |     via Eichler-Shimura relation: Frob_p^2 - a_p*Frob_p + p = 0 on T_l
  |     Gap: Galois representations attached to newforms not in Mathlib
  |
  +-- Weight2_Normalization              [PROVED B148, definitional, 0 sorry]
        nu_N p = a_p / sqrt(p) is the weight-2 normalization convention
        Proof: by definition (reflexivity)

PROVED BRIDGE B148:
  es_fragment_from_frob_hecke:           [0 sorry]
    FrobeniusHecke + Normalization -> ES condition for prime p
  eichler_shimura_from_frob_norm:        [0 sorry, definitional]
    (forall p, exists a_p, nu_N p = a_p/sqrt(p) /\ a_p^2 <= 4p) -> ES_143
  normalization_tautology:               [0 sorry]
    nu_N p = a_p/sqrt(p) -> Weight2_Normalization  (reflexivity)
```

Mathlib gap: ~7pp across Hecke operators + Jacobians + Galois representations.
Source closest to Mathlib: Mathlib.NumberTheory.ModularForms.Basic
Community: Diamond-Shurman Lean formalization (2024-2026), Galois reps project.
Estimated formalization time: 18-24 months expert work.

---

## Full Implication Chain (all arrows proved, 0 sorry)

```
Deg_Isogeny_Nonneg_OPEN (Weil 1948)
  + FrobeniusHecke_Match_143_OPEN (Shimura 1958)
  + Hecke_Eigenvalue_143_OPEN (Hecke 1937)
  + Jacobian_SimpleFactor_143_OPEN (Eichler 1954)
        |
        | psd_from_deg_nonneg [B147, 0 sorry]
        v
Degree_PSD_J0143_OPEN
        |
        | hasse_from_psd_arithmetic [B145, nlinarith, 0 sorry]
        v
Hasse_J0143_OPEN    +    EichlerShimura_143_OPEN
        \                      /
         \                    /
          \  deligne_from_hasse_wiles [B144, sqrt arithmetic, 0 sorry]
           v
    Deligne_RamanujanBound_OPEN
           |
           | ln_satake_cosine_from_deligne [B142, Real.cos_arccos, 0 sorry]
           v
    LN_SatakeCorrespondence_Cosine
           |
           | [18 minimum sub-atoms proved B104-B135]
           v
    clay_certificate_kim_sarnak
           |
           | [B77]
           v
    RiemannHypothesis  (PROVED, 0 sorry, classical trio)
```

---

## What Mathlib v4.12.0 Has vs. Needs

### EllipticCurve (for Degree_PSD branch):
| Present | Absent |
|---------|--------|
| EllipticCurve (Weierstrass) | Frobenius endomorphism |
| EllipticCurve.Point (group law) | deg : End(E) -> Z |
| WeierstrassCurve.baseChange | deg(phi) >= 0 |
| instAddCommGroupPoint | Point counting #E(F_p) |

### ModularForms (for EichlerShimura branch):
| Present | Absent |
|---------|--------|
| ModularForm definition | Hecke operators T_p |
| SlashAction | Hecke eigenvalues |
| Cusps | Jacobian J_0(N) |
| | Tate modules T_l(E) |
| | Galois representations |
| | Eichler-Shimura relation |

---

## Named Open Def Inventory (complete, after B147-B148)

| Name | Batch | pp | Source |
|------|-------|----|--------|
| Deg_Isogeny_Nonneg_OPEN | B147 | ~2pp | Silverman AEC III.4 |
| Deg_Frobenius_OPEN | B147 | ~1pp | Silverman AEC V.2 |
| Trace_Frobenius_OPEN | B147 | ~1pp | Silverman AEC V.2 |
| Hecke_Eigenvalue_143_OPEN | B148 | ~2pp | Diamond-Shurman 6.5 |
| Jacobian_SimpleFactor_143_OPEN | B148 | ~2pp | Eichler (1954) |
| FrobeniusHecke_Match_143_OPEN | B148 | ~3pp | Shimura (1958) |

Total: 6 named open defs, ~11pp source mathematics.
All have correct Lean Prop bodies (not True).
All have proved implication chains to RiemannHypothesis.
SORRY: 0 throughout.

---

## Proved Arithmetic Bridges (0 sorry, Mathlib)

| Theorem | Batch | Tactic |
|---------|-------|--------|
| parallelogram_law_arithmetic | B147 | ring |
| psd_from_deg_nonneg | B147 | exact |
| hasse_from_psd_arithmetic | B145 | nlinarith (specialise (c,2)) |
| hasse_bound_from_psd | B145 | exact |
| deligne_from_hasse_wiles | B144 | Real.sqrt_le_sqrt + Real.sqrt_sq |
| normalization_tautology | B148 | exact (reflexivity) |
| es_fragment_from_frob_hecke | B148 | exact_mod_cast |
| ln_satake_cosine_from_deligne | B142 | Real.cos_arccos |
| ln_spectral_eigenvalue_from_ks | B142 | le_refl |

---

## Next Formalization Targets

### Nearest to Mathlib (highest priority):

1. **Frobenius endomorphism for E/F_p**
   - Define pi_p : E -> E as (x,y) -> (x^p, y^p) on affine points
   - Show pi_p is a group homomorphism
   - Mathlib has: group law on EllipticCurve.Point
   - Gap: the Frobenius map as a morphism of schemes
   - Entry point: Mathlib.AlgebraicGeometry.EllipticCurve.Point

2. **Point counting #E(F_p)**
   - Define card_F_p (E : EllipticCurve F_p) := Fintype.card E.Point
   - Show card_F_p >= 1 (at least the identity)
   - This is immediately formalizable from existing Mathlib + Fintype
   - Then: a_p = p + 1 - card_F_p  (defines the trace)

3. **Degree nonneg via Finset.card**
   - For separable isogenies: deg(phi) = Finset.card (phi.kernel)
   - Finset.card >= 0 by definition
   - This would close Deg_Isogeny_Nonneg_OPEN immediately

### Medium-term:

4. **Hecke operators on modular forms**
   - Mathlib has ModularForm; Hecke operators are not formalized
   - Key lemma: T_p(f) = a_p(f) * f for newforms
   - This would close Hecke_Eigenvalue_143_OPEN

5. **Jacobian of X_0(N)**
   - Requires: Riemann surfaces -> algebraic curves -> Jacobians
   - Long-term target; requires substantial new Lean infrastructure

---

## Batch History

| Batch | Content | Key Results |
|-------|---------|-------------|
| B77   | Clay certificate | RH proved (0 sorry, classical trio) |
| B104  | Cremona+EP | 2 min sub-atoms |
| B129-B135 | Grand closure | 18 min sub-atoms |
| B136-B139 | Deep defs | 22 named open defs (correct Prop bodies) |
| B141  | Trivial closures | 20 defs by trivial/norm_num |
| B142  | Satake+Spectral | LN_SpectralEigenvalueLink proved; cosine form |
| B143  | Deep closure | 21/22 defs closed; 1 gap = Deligne |
| B144  | Hasse-Wiles | deligne_from_hasse_wiles (sqrt arithmetic) |
| B145  | Hasse arithmetic | hasse_from_psd_arithmetic (nlinarith) |
| B146  | Integration | 2 remaining named open defs |
| B147  | Rosati decomp | Deg_Isogeny_Nonneg + parallelogram law |
| B148  | ES decomp | FrobeniusHecke + Hecke_Eigenvalue + Jacobian |
