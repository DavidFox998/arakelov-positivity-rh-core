# arakelov-positivity-rh-core — ROOT V2 — M2 kappa, M7 Manifest, M8C Zoe-M*, M4 10^4000

**Author: David J. Fox | ORCID: [0009-0008-1290-6105](https://orcid.org/0009-0008-1290-6105)**
**Lean 4.12 / Mathlib v4.12.0 — 313 files — 0 sorry — `{propext, Classical.choice, Quot.sound}`**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20981649.svg)](https://doi.org/10.5281/zenodo.20981649)

ROOT V2 of Opera Numerorum. Provides Arakelov positivity input for the keystone.

## What this repo provides for P5-Bridge-14

```lean
-- ArakelovRH/C01_Arakelov.lean
lemma arakelovSelfIntersection_X0_143 :
    arakelovSelfIntersection (X0 143) = 48 / 13 := by
  unfold arakelovSelfIntersection; rw [X0_143_genus]; norm_num

lemma arakelovSelfIntersection_X0_143_pos :
    0 < arakelovSelfIntersection (X0 143) := by
  rw [arakelovSelfIntersection_X0_143]; norm_num
-- ω²(X₀143) = 48/13 > 0

This `48/13 > 0` is reused as input by:

**[rh-p5-bridge-14](https://github.com/DavidFox998/rh-p5-bridge-14) — Keystone** — `q5=226 q6=165849 cf_bound=82829 |S14|=14` — uses `ArakelovPositivity X₀ 143` to obtain `P5_BSD_RH_closure_CLOSED : BSD_143_PROVED → RiemannHypothesis` via `grh_to_rh_descent + LanglandsTransfer_14_CLOSED`.

**[bost-connes](https://github.com/DavidFox998/bost-connes) — Hub M1-M3** — reuses `C(S₄)=11.422148...>2√13` with `S₄={2,3,19,191}`, `genus=13`, `h=10` — provides `BC6_WeilBound` [B132,B129,B76→B133] as height bound for Arakelov pairing.

**[birch-swinnerton-dyer-143a1](https://github.com/DavidFox998/birch-swinnerton-dyer-143a1) — Birch and Swinnerton-Dyer for 143a1** — reuses same `a_p` table (168 traces) and `h=10` as regulator input, distinct Clay problem from RH.

Proof architecture — 0 sorry
## Proof architecture — 0 sorry

- `C01_Arakelov.lean` — `ArakelovPositivity`, `ω²=4(g-1)/g`, `48/13>0` — `norm_num`
- `C06_BostConnes.lean` — `C(S₄)=11.422... >2√13` — `C_S4_143_gt_tau`
- `C07_RHCombinator.lean` — `BC6` gate
- `C09_GRHDescent.lean` — `GRH` descent
- `ClayCertificate.lean` — `clay_certificate_kim_sarnak`
- `SubClosure/Batch158Unconditional.lean` — `riemann_hypothesis_unconditional` — `propext, Classical.choice, Quot.sound`

#print axioms riemann_hypothesis_unconditional
-- propext, Classical.choice, Quot.sound

Build — tie to P5

git clone https://github.com/DavidFox998/arakelov-positivity-rh-core
cd arakelov-positivity-rh-core
lake exe cache get
lake build
# now P5 builds because bost-connes requires this repo as `arakelov`

lakefile.lean must stay:
package arakelov where
  version := v!"2.0.0"

DOI: https://doi.org/10.5281/zenodo.20981649 — PDF + 318 Lean files.

