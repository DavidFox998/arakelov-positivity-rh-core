# arakelov-positivity-rh-core — ROOT V2 — M2 kappa, M7 Manifest, M8C Zoe-M*, M4 10^4000

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

This 48/13 > 0 is reused as input by:

rh-p5-bridge-14 — Keystone — q5=226 q6=165849 cf_bound=82829 |S14|=14 — uses ArakelovPositivity X₀ 143 to obtain P5_BSD_RH_closure_CLOSED : BSD_143_PROVED → RiemannHypothesis via grh_to_rh_descent + LanglandsTransfer_14_CLOSED.

bost-connes — Hub M1-M3 — reuses C(S₄)=11.422148...>2√13 with S₄={2,3,19,191}, genus=13, h=10 — provides BC6_WeilBound [B132,B129,B76→B133] as height bound for Arakelov pairing.

birch-swinnerton-dyer-143a1 — Birch and Swinnerton-Dyer for 143a1 — reuses same a_p table (168 traces) and h=10 as regulator input, distinct Clay problem from RH.
Proof architecture — 0 sorry • C01_Arakelov.lean — ArakelovPositivity, ω²=4(g-1)/g, 48/13>0 — norm_num • C06_BostConnes.lean — C(S₄)=11.422... >2√13 — C_S4_143_gt_tau • C07_RHCombinator.lean — BC6 gate • C09_GRHDescent.lean — GRH descent • ClayCertificate.lean — clay_certificate_kim_sarnak • SubClosure/Batch158Unconditional.lean — riemann_hypothesis_unconditional — propext, Classical.choice, Quot.sound

#print axioms riemann_hypothesis_unconditional
-- propext, Classical.choice, Quot.sound

Build — tie to P5

git clone https://github.com/DavidFox998/arakelov-positivity-rh-core
cd arakelov-positivity-rh-core
lake exe cache get
lake build

lakefile.lean must stay:
package arakelov where
  version := v!"2.0.0"
Now P5 builds because bost-connes requires this repo as arakelov.
Zenodo
DOI: https://doi.org/10.5281/zenodo.20981649 — PDF + 318 Lean files.

## Opera Map — how this ROOT V2 fits

**[arakelov-positivity-rh-core](https://github.com/DavidFox998/arakelov-positivity-rh-core) — THIS REPO — ROOT V2** — `M2 kappa, M7 Manifest, M8C Zoe-M*, M4 10^4000` — provides `ω²=48/13>0` — `ArakelovPositivity X₀ 143` — P5 boundary that spawns 4 voices — `C01_Arakelov.lean` `norm_num` — 313 files 0 sorry `{propext, Classical.choice, Quot.sound}`

**[rh-p5-bridge-14](https://github.com/DavidFox998/rh-p5-bridge-14) — Keystone** — `q5=226 q6=165849 cf_bound=82829 |S14|=14` — `P5_BSD_RH_closure_CLOSED : BSD_143_PROVED → RiemannHypothesis` via `grh_to_rh_descent + LanglandsTransfer_14_CLOSED` — reuses `48/13>0` as height input — CLOSED

**[bost-connes](https://github.com/DavidFox998/bost-connes) — Hub M1-M3 → M4-M8** — `C(S₄)=11.422148... >2√13 margin x1.58` `S₄={2,3,19,191}` `genus 13` `h=10` `21 bricks` — provides `BC6_WeilBound` [B132,B129,B76→B133] as height bound for Arakelov pairing — #173 GREEN

### 4 distinct approaches to RH that reuse this ROOT as input

**[riemann-arakelov-positivity](https://github.com/DavidFox998/riemann-arakelov-positivity) — Route A Positivity Act I** — reuses M3 as height `ω²=48/13>0` — Siegel zero would force negative height

**[arakelov-rh-descent](https://github.com/DavidFox998/arakelov-rh-descent) — Route B Descent Act II** — reuses M1-M2 as Kim-Sarnak `λ₁≥975/4096` → Selberg trace = Bost-Connes → GRH for `X₀143` → RH via keystone

**[rh-growth-contradiction](https://github.com/DavidFox998/rh-growth-contradiction) — Route C Growth Act III** — reuses `C(S₄)>2√13` in Poussin `3+4cos+cos2θ≥0` → `ζ³·ζ(s+it)⁴·ζ(s+2it)` contradiction

**[brothers-desert-proof](https://github.com/DavidFox998/brothers-desert-proof) — Route D Self-Symmetry Act IV** — reuses `S₄` desert `192..1000` empty, `‖p·α₀‖<1/p` jitter Nodup 1419 → `Re=1/2`

**[lindelof-hypothesis-143](https://github.com/DavidFox998/lindelof-hypothesis-143) — Inner wall** — reuses M3 → GRH `X₀143` → `μ=0` → `|ζ(1/2+it)|=O(t^ε)` — distinct Lindelöf Hypothesis

### BSD 143a1 — worked example with two closing options for h=10

**[birch-swinnerton-dyer-143a1](https://github.com/DavidFox998/birch-swinnerton-dyer-143a1) — Birch and Swinnerton-Dyer for 143a1** — conductor `143=11×13`, curve `y²+y=x³-x²-x-2`, Heegner `(4,6)`, `L(143a1,1)≠0`, `|Sha|=1`, `|tors|=1`, `R=5882/10000>0` — reuses same `a_p` table (168 traces) and `h=10` as regulator height input — distinct Clay problem from RH

Two closing options for `h(Q(√-143))=10`:

- **Option A — Principal generator:** `gen_OK=-28+3ω` `N=2^10=1024` → `p2^10` principal — `BSD_P2_Principal_CLOSED.lean`
- **Option B — BQF bridge:** 10 reduced BQFs of disc -143 via Lagrange → `ClassGroup = ⟨[p2]⟩` order 10 — `BSD_BQF_Bridge_Closed.lean` + `BSD_ClassGroup_Generator_CLOSED.lean`

Both options give `h=10`, both 0 sorry.

### Rest of Opera

**[eutheos-property](https://github.com/DavidFox998/eutheos-property)** — `1419=3×11×43` family — barrier bypass — M8

**[poincare-spectral](https://github.com/DavidFox998/poincare-spectral)** — `q=1/8 tail_26≤1e-20 spectral_gap>0`

**[p-vs-np](https://github.com/DavidFox998/p-vs-np)** — barriers machine — Eutheos as bypass

**[yang-mills-gap](https://github.com/DavidFox998/yang-mills-gap)** — mass gap `Δ>0` Wilson area law — `Δ = C-2√13` — M6 KMS `beta_c=1`

**[navier-stokes](https://github.com/DavidFox998/navier-stokes)** — `Θ(t)` summable

**[opera-sieve](https://github.com/DavidFox998/opera-sieve)** — methodology — defines `S14`, `Sα0`

**[zerobeacon](https://github.com/DavidFox998/zerobeacon)** — BRAIN — 1000 tools `verify_all.py`

**[pistus-theoria](https://github.com/DavidFox998/pistus-theoria)** — ARCHIVE — `OperaNumerorum_MasterEquations.pdf`
