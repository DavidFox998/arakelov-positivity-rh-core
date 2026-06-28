import Lake
open Lake DSL

-- DO NOT run `lake update` -- Mathlib must remain pinned to v4.12.0.
package «arakelov-positivity-rh-core» where
  name := "arakelov-positivity-rh-core"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.12.0"

lean_lib ArakelovRH where
  roots := #[`ArakelovRH,
             `ArakelovRH.JorgensonKramer.ModularCurve,
             `ArakelovRH.JorgensonKramer.GreenFunction,
             `ArakelovRH.JorgensonKramer.HeatKernel,
             `ArakelovRH.JorgensonKramer.JK96_GreenConstant_143,
             `ArakelovRH.JorgensonKramer.ThetaFactorization]
