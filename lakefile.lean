import Lake
open Lake DSL

package «arakelov-positivity-rh-core» where
  version := v!"2.0.0"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.12.0"

lean_lib Arakelov where
  roots := #[`Arakelov]

lean_lib Towers where
  roots := #[`Towers]
