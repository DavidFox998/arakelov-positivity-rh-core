/-
  Towers/RH/Chain/C08_M4WeilBridge.lean
  Bridge: re-exports ArakelovRH.C08_Positivity under the TheoremaAureum namespace.

  Purpose: Towers.BSD.BSD_Clay_Certificate imports this file and calls
    TheoremaAureum.arakelov_positivity_X0_143 : ArakelovPositivity (X₀ 143)
  using ArakelovPositivity and X₀ without the ArakelovRH. prefix.

  This file is the only new file written for the import bridge.
  No BSD files are adapted.  No other lakefile is touched.

  Clay rules: no sorry · no axiom · no opaque · no native_decide
  Axiom footprint: {propext, Classical.choice, Quot.sound}
-/
import ArakelovRH.C08_Positivity

-- Root-level aliases: makes ArakelovPositivity and X₀ visible without prefix
-- in any file that imports this bridge.
abbrev ArakelovPositivity := ArakelovRH.ArakelovPositivity
abbrev X₀ := ArakelovRH.X₀

namespace TheoremaAureum

/-- BRIDGE BRICK: ArakelovPositivity (X₀ 143).

    Re-exports ArakelovRH.arakelov_positivity_X0_143 (proved in C08_Positivity.lean
    by arakelovSelfIntersection_X0_143_pos, norm_num, 0 sorry) under the
    TheoremaAureum namespace expected by BSD_Clay_Certificate.lean.

    Axiom footprint: {propext, Classical.choice, Quot.sound}. -/
theorem arakelov_positivity_X0_143 : ArakelovPositivity (X₀ 143) :=
  ArakelovRH.arakelov_positivity_X0_143

end TheoremaAureum
