import Lake
open Lake DSL

-- DO NOT run `lake update` — Mathlib must remain pinned to v4.12.0.
package «arakelov-positivity-rh-core» where
  name := "arakelov-positivity-rh-core"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.12.0"

-- C01–C10 Arakelov/RH chain (namespace ArakelovRH)
lean_lib ArakelovRH

-- BSD tower: 51 verbatim files from DavidFox998/Birch-and-Swinnerton-Dyer
-- (namespace Towers.BSD; import Towers.BSD.*)
lean_lib Towers where
  roots := #[`Towers]

-- BSD bridge stubs: resolve "import BSD.X" style imports
-- Each stub is a one-line re-export: import Towers.BSD.X
lean_lib BSD where
  roots := #[`BSD]
