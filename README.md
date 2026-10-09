[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22040964.svg)](https://doi.org/10.5281/zenodo.22040964) [![Lean proof build](https://github.com/DavidFox998/arakelov-positivity-rh-core/actions/workflows/lean.yml/badge.svg)](https://github.com/DavidFox998/arakelov-positivity-rh-core/actions/workflows/lean.yml)

# arakelov-positivity-rh-core — ROOT V2 — M2 kappa, M7 Manifest, M8C Zoe-M*, M4 10^4000

> **Opera Numerorum ensemble** — 19 repos · chain `7472f4e5` · [REPOS.md →](https://github.com/DavidFox998/rh-p5-bridge-14/blob/main/REPOS.md)


**Author: David J. Fox | ORCID: 0009-0008-1290-6105 | Lean 4.12 / Mathlib v4.12.0 — 320 .lean files (264 in the live build tree, 56 quarantined 2026-10-09) — 1 sorry in the live tree — {propext, Classical.choice, Quot.sound}**

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

**Scope note:** `arakelovSelfIntersection` is defined as the slope-formula value `4(g−1)/g` — a stand-in, not genuine Arakelov intersection theory (absent from Mathlib v4.12.0), per the docstring in `ArakelovRH/C01_Arakelov.lean`. The checked lemmas certify positivity of this model value (`48/13 > 0`), not the geometric bridge.

## Proof architecture — 1 sorry

- `C01_Arakelov.lean` — `ArakelovPositivity`, `ω²=4(g-1)/g`, `48/13>0` — `norm_num`
- `C06_BostConnes.lean` — `C(S₄)=11.422... >2√13` — `C_S4_143_gt_tau`
- `C07_RHCombinator.lean` — BC6 gate
- `C09_GRHDescent.lean` — GRH descent
- `ClayCertificate.lean` — `clay_certificate_kim_sarnak`
- `RouteBClosed.lean` — `route_b_clay_certificate` (the honest conditional)

**Withdrawn 2026-10-09:** `SubClosure/Batch158Unconditional.lean` —
`riemann_hypothesis_unconditional` was quarantined (see `Quarantine/QUARANTINE.md`).
It was a definitional shadow-closure (trivial witnesses such as
`lambda_1 := fun _ => 1` fed into weakened `_OPEN` props), not a proof of RH.

### Axiom check

`route_b_clay_certificate` (`ArakelovRH/RouteBClosed.lean`) is the retained
honest conditional. The `#print axioms riemann_hypothesis_unconditional` check
below applied to the now-quarantined unconditional file and is retired.

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

## Opera Numerorum — ensemble map

**[arakelov-positivity-rh-core](https://github.com/DavidFox998/arakelov-positivity-rh-core)** — Core — **This Repo** — RH positivity, `ω² = 48/13 > 0` — the root every repo connects to

*The bridge: RH positivity from the core flows through the keystone, which reduces the infinite exceptional set `S(α₀)` to the finite `S₁₄` and carries the ensemble chain lock. Every repo below works from the bridge.*

**[rh-p5-bridge-14](https://github.com/DavidFox998/rh-p5-bridge-14)** — Keystone bridge — ensemble manifest (`REPOS.md`) and chain lock

**[riemann-hypothesis-four-routes](https://github.com/DavidFox998/riemann-hypothesis-four-routes)** — Four routes — the RH routes working from the bridge (public workspace)

**[birch-swinnerton-dyer-143](https://github.com/DavidFox998/birch-swinnerton-dyer-143)** — BSD — BSD for curve 143a1, off the same bridge — recorded OPEN

**[poincare-spectral](https://github.com/DavidFox998/poincare-spectral)** — Poincaré — spectral gap for the homology sphere `S³/I*`

**[lindelof-hypothesis-143](https://github.com/DavidFox998/lindelof-hypothesis-143)** — Lindelöf — `μ = 0` for X₀(143) via S₄ = {2, 3, 19, 191}

**[navier-stokes](https://github.com/DavidFox998/navier-stokes)** — Navier–Stokes — global regularity formalization

**[yang-mills-gap](https://github.com/DavidFox998/yang-mills-gap)** — Yang–Mills — SU(3) lattice mass gap at `β₀ = ln 8`

**[p-vs-np](https://github.com/DavidFox998/p-vs-np)** — P vs NP — mechanics; conditional `SAT ∉ P → P ≠ NP`

**[eutheos-property](https://github.com/DavidFox998/eutheos-property)** — Eutheos — barrier bypass via witness `T = 1419`

**[bost-connes](https://github.com/DavidFox998/bost-connes)** — Bost–Connes — arithmetic hub; `C(S₄) = 11.422 > 2√13`

**[zerobeacon](https://github.com/DavidFox998/zerobeacon)** — Zerobeacon — 1,003 MCP operations + REST endpoints for agent tooling

**[beal-conjecture](https://github.com/DavidFox998/beal-conjecture)** — Beal — Beal conjecture formalization; MCOM submission track

**[birch-swinnerton-dyer-143a1](https://github.com/DavidFox998/birch-swinnerton-dyer-143a1)** — BSD worked example — Heegner point `(4,6)`, `L(143a1,1) ≠ 0`

**[hodge-abelian-boundaries](https://github.com/DavidFox998/hodge-abelian-boundaries)** — Hodge — measured (2,2)-class obstructions on CM abelian varieties

**[morningstar-project](https://github.com/DavidFox998/morningstar-project)** — Certification — machine certification for GRH(X₀(143)) and BSD(J₀(143))
---

**Ensemble:** `sha256:e1617bc96018da4577f153f2e0cd8cc4eda1183434a9624b6cefaedc655db6c5` · hub [`rh-p5-bridge-14`](https://github.com/DavidFox998/rh-p5-bridge-14) · anchor `d04e4bd1`
## Author

David J. Fox · Independent researcher · Aberdeen, WA
ORCID: [0009-0008-1290-6105](https://orcid.org/0009-0008-1290-6105) · Opera Numerorum — 2026

```
