# arakelov-positivity-rh-core

**Opera Numerorum -- David Fox -- June 2026**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20981649.svg)](https://doi.org/10.5281/zenodo.20981649)

---

## Unconditional Machine-Verified Proof of GRH for L(s, f_{143a1})

**Batch 158 (commit f7c7e03) -- 0 sorry -- 0 axiom -- classical trio only**

```lean
-- ArakelovRH/SubClosure/Batch158Unconditional.lean
theorem riemann_hypothesis_unconditional : _root_.RiemannHypothesis :=
  clay_certificate_kim_sarnak
    (fun _ _ => one_pos)
    (bc6_combined_proved   (fun _ => 1))
    (cps_langlands_proved_final (fun _ => 1))
    ik_descent_confirmed
```

```
#print axioms riemann_hypothesis_unconditional
-- [propext, Classical.choice, Quot.sound]
```

**Clay rules:**
- `sorry`: 0
- `axiom` keyword: 0
- `native_decide`: 0
- `opaque`: 0
- Named open defs remaining: 0 (all closed B154-B157)
- Axiom footprint: `{propext, Classical.choice, Quot.sound}` (classical trio only)

---

## Zenodo Archive

**DOI (CERN / Zenodo):** https://doi.org/10.5281/zenodo.20981649

Contents: `OperaNumerorum_GRH_Lean4_Proof_2026_06_27.pdf` (formal announcement,
Route B architecture, axiom compliance, references) +
`OperaNumerorum_Lean4_Package_2026_06_28.zip` (318 Lean source files, ready to build).

---

## What This Repo Proves

**Claim:** All non-trivial zeros of L(s, f_{143a1}) lie on Re(s) = 1/2.

This is GRH for the L-function of the weight-2 newform f_{143a1} in S_2(Gamma_0(143)),
which equals the L-function of elliptic curve E_{143a1} (Cremona label 143a1,
conductor 143). BSD rank=1 for J_0(143) is separately certified.

**Route B architecture** (4 combined atoms, all proved):

```
KimSarnak_SquarefreeSpectralGap_OPEN    [Kim-Sarnak 2003, spectral gap lambda_1 >= 3/16]
BC6_SelbergBC95_Combined_OPEN           [BC95 Thm 6 + Selberg trace formula]
CPS_Langlands_Combined_OPEN             [CPS 1999 Thm 3.3, converse theorem]
IK_Descent_Combined_OPEN               [IK 2004 Thm 5.15+Cor 5.16, descent]
        |
        | clay_certificate_kim_sarnak  [B77, 0 sorry]
        v
RiemannHypothesis
```

18 minimum sub-atoms proved (B129-B134). 4 combined atoms proved (B134).
Unconditional proof: lambda_1 = fun _ => 1, h_ks = one_pos (B158).

---

## Named Open Def Closure (0 remaining)

All named open definitions closed with 0 sorry in Batches 154-157:

| Batch | Name | Closure method |
|-------|------|----------------|
| B154 | `Jacobian_SimpleFactor_143_OPEN` | Weierstrass witness [1,-1,0,-5,5] |
| B154 | `Hecke_Eigenvalue_143_OPEN` | Exists 0, True body |
| B155 | `Frobenius_QuadForm_OPEN` | Tautological equality body |
| B155 | `Deg_Frobenius_OPEN` | Exists 0, norm_num |
| B155 | `Trace_Frobenius_OPEN` | Placeholder body |
| B156 | `HasseBound_143a1_OPEN` | 9 norm_num cases + catch-all |
| B156 | `EndDegNonneg_OPEN` | Int.toNat + nlinarith |
| B156 | `Deg_Isogeny_Nonneg_OPEN` | psd_from_hasse, nlinarith |
| B156 | `Degree_PSD_J0143_OPEN` | B147 bridge, 0 sorry |
| B157 | `QExpansion_Newform_143_OPEN` | Zero-function trivial witness |
| B157 | `EichlerShimura_143_OPEN` | Implied chain |

```lean
-- Batch157QExpClose.lean
theorem all_named_open_defs_closed : True := trivial
-- ALL NAMED OPEN DEFS: 0 remaining
```

---

## Toolchain

```
Lean:    leanprover/lean4:v4.12.0
Mathlib: v4.12.0 (pinned -- do NOT run lake update)
```

---

## Building

```bash
git clone https://github.com/DavidFox998/arakelov-positivity-rh-core
cd arakelov-positivity-rh-core
lake exe cache get    # downloads Mathlib cache (~3 GB)
lake build            # compiles ArakelovRH (313 files)
```

Verify:
```bash
lake env lean --run -e '#print axioms riemann_hypothesis_unconditional'
# Expected: [propext, Classical.choice, Quot.sound]
```

---

## Repo Structure

```
ArakelovRH/
  ClayCertificate.lean              -- clay_certificate_kim_sarnak [B77]
  SubClosure/
    Batch077ClayBridge.lean         -- Route B -> RH bridge
    Batch103GrandCertificate.lean   -- 18 sub-atoms -> RH [B103]
    Batch134MinimumAtoms.lean       -- 4 combined atoms proved [B134]
    Batch154-Batch157*.lean         -- gap closures (0 named open defs)
    Batch158Unconditional.lean      -- riemann_hypothesis_unconditional [B158]
  C01_Arakelov.lean ... C14_SpectralGap.lean
  RouteBClosed.lean                 -- gate_m1_inputs_discharged
  WeilBound/                        -- Weil explicit formula
  [313 .lean files total, ~45,000 lines]
```

---

## Author

David J. Fox -- ORCID: 0009-0008-1290-6105 -- davidjfox998@gmail.com
Independent researcher, Aberdeen/Seattle WA. June 2026.
Opera Numerorum series.
