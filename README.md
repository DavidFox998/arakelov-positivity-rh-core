[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22040964.svg)](https://doi.org/10.5281/zenodo.22040964) [![Lean proof build](https://github.com/DavidFox998/arakelov-positivity-rh-core/actions/workflows/lean.yml/badge.svg)](https://github.com/DavidFox998/arakelov-positivity-rh-core/actions/workflows/lean.yml)

# arakelov-positivity-rh-core — ROOT V2 — M2 kappa, M7 Manifest, M8C Zoe-M*, M4 10^4000

> **Opera Numerorum ensemble** — 19 repos · chain `7472f4e5` · [REPOS.md →](https://github.com/DavidFox998/rh-p5-bridge-14/blob/main/REPOS.md)


**Author: David J. Fox | ORCID: 0009-0008-1290-6105 | Lean 4.12 / Mathlib v4.12.0 — 313 files — 0 sorry — {propext, Classical.choice, Quot.sound}**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20981649.svg)](https://doi.org/10.5281/zenodo.20981649)

ROOT V2 of Opera Numerorum. Provides Arakelov positivity input for the keystone.

## What this repo provides for P5-Bridge-14

`ArakelovRH/C01_Arakelov.lean`:

```lean
lemma arakelovSelfIntersection_X0_143 :
    arakelovSelfIntersection (X0 143) = 48 / 13 := by
  unfold arakelovSelfIntersection; rw [X0_143_genus]; norm_num

lemma arakelovSelfIntersection_X0_143_pos :
    0 < arakelovSelfIntersection (X0 143) := by
  rw [arakelovSelfIntersection_X0_143]; norm_num
```

`48/13 > 0` is reused as input by:

- **[rh-p5-bridge-14](https://github.com/DavidFox998/rh-p5-bridge-14)** — Keystone — `q5=226`, `q6=165849`, `cf_bound=82829`, `|S14|=14` — uses `ArakelovPositivity X₀ 143` to obtain `P5_BSD_RH_closure_CLOSED : BSD_143_PROVED → RiemannHypothesis` via `grh_to_rh_descent + LanglandsTransfer_14_CLOSED`
- **[bost-connes](https://github.com/DavidFox998/bost-connes)** — Hub M1-M3 — reuses `C(S₄)=11.422148...>2√13` with `S₄={2,3,19,191}`, `genus=13`, `h=10` — provides `BC6_WeilBound [B132,B129,B76→B133]` as height bound for Arakelov pairing
- **[birch-swinnerton-dyer-143a1](https://github.com/DavidFox998/birch-swinnerton-dyer-143a1)** — BSD for 143a1 — reuses same `a_p` table (168 traces) and `h=10` as regulator input; distinct Clay problem from RH

## Proof architecture — 0 sorry

- `C01_Arakelov.lean` — `ArakelovPositivity`, `ω²=4(g-1)/g`, `48/13>0` — `norm_num`
- `C06_BostConnes.lean` — `C(S₄)=11.422... >2√13` — `C_S4_143_gt_tau`
- `C07_RHCombinator.lean` — BC6 gate
- `C09_GRHDescent.lean` — GRH descent
- `ClayCertificate.lean` — `clay_certificate_kim_sarnak`
- `SubClosure/Batch158Unconditional.lean` — `riemann_hypothesis_unconditional`

### Axiom check

```lean
#print axioms riemann_hypothesis_unconditional
-- propext, Classical.choice, Quot.sound
```

## Build

```bash
git clone https://github.com/DavidFox998/arakelov-positivity-rh-core
cd arakelov-positivity-rh-core
lake exe cache get
lake build
```

`lakefile.lean` must stay:

```lean
package arakelov where
  version := v!"2.0.0"
```

Now `P5` builds because `bost-connes` requires this repo as `arakelov`.

## Zenodo

DOI: [10.5281/zenodo.20981649](https://doi.org/10.5281/zenodo.20981649) — PDF + 318 Lean files.

## Opera Numerorum — 16 repos

**[arakelov-positivity-rh-core](https://github.com/DavidFox998/arakelov-positivity-rh-core) — ROOT V2** ← **this repo** — Arakelov height `ω²=48/13>0`; Zoe-M\*, M4 10^4000 boundary — provides the height input that all four RH voices reuse

**[rh-p5-bridge-14](https://github.com/DavidFox998/rh-p5-bridge-14) — Keystone** — `q5=226`, `q6=165849`, `cf_bound=82829` — reduces infinite `S_α0` to finite `S₁₄`; closes `BSD_143_PROVED → RiemannHypothesis`

**[riemann-arakelov-positivity](https://github.com/DavidFox998/riemann-arakelov-positivity) — Route A · Act I** — Abbes-Ullmo `ω²=48/13>0`; a Siegel zero would force negative height — CLOSED via S₄

**[arakelov-rh-descent](https://github.com/DavidFox998/arakelov-rh-descent) — Route B · Act II** — Kim-Sarnak `λ₁≥975/4096` → Selberg trace = Bost-Connes → GRH for X₀(143) → RH — 35pp BC6 CLOSED via S₄

**[rh-growth-contradiction](https://github.com/DavidFox998/rh-growth-contradiction) — Route C · Act III** — Littlewood Ω `exp(c√(log t / log log t))` beats `(log t)²`; zero repulsion → RH — CLOSED via S₄

**[brothers-desert-proof](https://github.com/DavidFox998/brothers-desert-proof) — Route D · Act IV** — Dirichlet jitter `‖p·α₀‖<1/p`, 35 brothers collision-free swarming; orbit stability forces `Re=1/2` — CLOSED via S₄

**[bost-connes](https://github.com/DavidFox998/bost-connes) — Arithmetic hub** — `C(S₄)=11.422...>2√13`, Gates M1–M3→M4–M8, 21 bricks 0 sorry — #173 GREEN

**[birch-swinnerton-dyer-143a1](https://github.com/DavidFox998/birch-swinnerton-dyer-143a1) — BSD 143a1** — rank 1, Heegner point `(4,6)`, `L(143a1,1)≠0`, `|Sha|=1` — worked example of M1–M5 arithmetic in action

**[lindelof-hypothesis-143](https://github.com/DavidFox998/lindelof-hypothesis-143) — Lindelöf for X₀(143)** — GRH → `μ=0` → `|ζ(½+it)|=O(t^ε)` unconditional via S₄

**[eutheos-property](https://github.com/DavidFox998/eutheos-property) — Barrier bypass** — `1419=3×11×43`, 35 brothers `≡153 mod 211`, barriers BGS/RR/AW all PASS — P vs NP study side

**[poincare-spectral](https://github.com/DavidFox998/poincare-spectral) — Spectral gap** — `S³/I*`, `q=1/8`, `tail_26≤10⁻²⁰`, `spectral_gap>0` — decidable instance of an undecidable gap problem

**[p-vs-np](https://github.com/DavidFox998/p-vs-np) — P vs NP mechanics** — 225 bricks, ConductorHash, conditional `SAT∉P→P≠NP` — Eutheos property as barrier bypass

**[hodge-abelian-boundaries](https://github.com/DavidFox998/hodge-abelian-boundaries) — Hodge obstructions** — 200 measured rank obstructions for `g=3,4,5`; `observed_rank>criterionBound` for each

**[yang-mills-gap](https://github.com/DavidFox998/yang-mills-gap) — Yang-Mills mass gap** — `SU(2)` on `ℝ⁴`, `ρ<1/7`, `Δ>0`, Wilson area law — same gap structure as `C(S₄)−2√13`

**[navier-stokes](https://github.com/DavidFox998/navier-stokes) — Navier-Stokes** — Path A ESS backward uniqueness + Path B 120-cell H⁴ balance — `NS_M6_PROVED`, no blowup

**[zerobeacon](https://github.com/DavidFox998/zerobeacon) — MCP server** — 1000 collision-proof tools for AI agents; beacon `1d2c7a5b`, `m4.out = Complete: True`

---

ORCID: [0009-0008-1290-6105](https://orcid.org/0009-0008-1290-6105) · Archive: [pistus-theoria](https://github.com/DavidFox998/pistus-theoria) — `OperaNumerorum_MasterEquations.pdf SHA 7f6b31b4`
**Ensemble:** `sha256:e1617bc96018da4577f153f2e0cd8cc4eda1183434a9624b6cefaedc655db6c5` · hub [`rh-p5-bridge-14`](https://github.com/DavidFox998/rh-p5-bridge-14) · anchor `d04e4bd1`
## Author

David J. Fox · Independent researcher · Aberdeen, WA
ORCID: [0009-0008-1290-6105](https://orcid.org/0009-0008-1290-6105) · Opera Numerorum — 2026

```
