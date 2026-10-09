# Quarantine — arakelov-positivity-rh-core

Mechanical-hygiene quarantine log. Files here are preserved (structure intact)
but are no longer part of the live build tree. Nothing in this directory is
imported by `ArakelovRH.lean`.

## 2026-10-09 — Batch103–158 shadow closure (56 files)

- **Original paths:** `ArakelovRH/SubClosure/Batch103.lean … Batch158.lean` (56 files):
  `Batch103GrandCertificate.lean`, `Batch104EulerProductCremonaClose.lean`,
  `Batch105ComplexEPAndDecompositions.lean`, `Batch106LargeAtomDecompositions.lean`,
  `Batch107TrivialCloseLevel3.lean`, `Batch108ArithClose_Level4Decomp.lean`,
  `Batch109TrivialCloseB102Decomp.lean`, `Batch110MellinClose_L3Decomp5.lean`,
  `Batch111TrivialClose3_Decomp5.lean`, `Batch112TrivialClose2_Decomp5.lean`,
  `Batch113EpsToZero_Decomp5.lean`, `Batch114GRHExact_Decomp6.lean`,
  `Batch115WeylDiff_Decomp5.lean`, `Batch116SpectralGap_Decomp5.lean`,
  `Batch117MediumAtoms_Decomp6.lean`, `Batch118WBGConclusion_Decomp4.lean`,
  `Batch119LargeAtoms_Decomp6.lean`, `Batch120BC6Gaps_Decomp6.lean`,
  `Batch121ZFSChain_Decomp5.lean`, `Batch122ZFRtoRH_Decomp6.lean`,
  `Batch123LeafPush_Decomp6.lean`, `Batch124Polymath8b_Bridge.lean`,
  `Batch125FinalLeaves_Decomp5.lean`, `Batch126Cascade_Decomp5.lean`,
  `Batch127TerminalLeaves_Decomp5.lean`, `Batch128Cascades_Final5.lean`,
  `Batch129GrandCascades.lean`, `Batch130ZFR_RE_Cascade.lean`,
  `Batch131ZTL_CPS_Cascade.lean`, `Batch132BC6_CPS_Final.lean`,
  `Batch133BC6_Combined_CPS.lean`, `Batch134GrandClosure.lean`,
  `Batch135FinalConnectors.lean`, `Batch136KimSarnak_Deep.lean`,
  `Batch137BC6_Deep.lean`, `Batch138CPS_Deep.lean`, `Batch139IK_Deep.lean`,
  `Batch140DeepIntegration.lean`, `Batch141TrivialClosures.lean`,
  `Batch142SatakeConditional.lean`, `Batch143DeepClosure.lean`,
  `Batch144HasseWiles.lean`, `Batch145HasseDecomp.lean`,
  `Batch146FinalIntegration.lean`, `Batch147RosatiDecomp.lean`,
  `Batch148EichlerShimuraDecomp.lean`, `Batch149PointCounting.lean`,
  `Batch150DegreeNonneg.lean`, `Batch151HeckeOperators.lean`,
  `Batch152HeckeEigenformDecomp.lean`, `Batch153QExpDecomp.lean`,
  `Batch154CloseTrivialGaps.lean`, `Batch155CloseIsogenyGaps.lean`,
  `Batch156HasseBoundClose.lean`, `Batch157QExpClose.lean`,
  `Batch158Unconditional.lean`.
- **Reason (per 2026-10-09 audit):** definitional shadow-closure — trivialized
  `_OPEN` props closed by trivial witnesses (e.g. `lambda_1 := fun _ => 1` in
  `Batch158Unconditional.lean:15`, feeding `theorem riemann_hypothesis_unconditional`
  at line 88). Definitional closure, not a proof of RH.
- **New location:** `Quarantine/ArakelovRH/SubClosure/` (relative structure preserved).
- **Explicitly kept (not quarantined):** `ArakelovRH/RouteBClosed.lean` —
  the honest conditional `route_b_clay_certificate`.

### Open item for the coordinator

`ArakelovRH.lean:216` still contains

```lean
import ArakelovRH.SubClosure.Batch158Unconditional
```

That module now exists only under `Quarantine/`, so it is no longer in the
lake lib's import graph. The import line was NOT removed here (per the
Phase-0 rule to leave importer edits to the coordinator) — but `lake build`
cannot succeed until it is removed or the module is restored.
