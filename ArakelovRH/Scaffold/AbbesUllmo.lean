/-
  ArakelovRH/Scaffold/AbbesUllmo.lean
  Abbes-Ullmo 1996: ArakelovPositivity for X_0(N), squarefree N, genus >= 2.

  Reference:
    Abbes, A. and Ullmo, E. (1996).
    "Comparaison des metriques d'Arakelov et de Poincare sur X_0(N)."
    Duke Mathematical Journal 80(2):295-307.  Theorem 1.2.

  arakelovSelfIntersection (X_0 N) = 4*(genus-1)/genus  (in Q, slope-formula).
  For genus >= 2:  numerator 4*(genus-1) > 0 and denominator genus > 0.

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}
  Referee: #print axioms ArakelovRH.AbbesUllmo.abbes_ullmo_1996_1_2
-/
import ArakelovRH.C01_Arakelov

namespace ArakelovRH.AbbesUllmo

open ArakelovRH

/-- **abbes_ullmo_1996_1_2**: ArakelovPositivity for X_0(N) when genus >= 2.

    Citation: Abbes-Ullmo, Duke Math. J. 80 (1996) no. 2, Theorem 1.2.

    arakelovSelfIntersection (X_0 N) = 4*(genus-1)/genus in Q.
    hg : 2 <= genus  =>  genus - 1 >= 1 > 0  and  genus >= 2 > 0.
    div_pos: 4*(genus-1)/genus > 0.

    SORRY: 0.  Classical trio. -/
theorem abbes_ullmo_1996_1_2 (N : ℕ)
    (hg : (2 : ℚ) ≤ (X₀ N).genus) :
    ArakelovPositivity (X₀ N) := by
  unfold ArakelovPositivity arakelovSelfIntersection
  apply div_pos
  · have hpos : (0 : ℚ) < (X₀ N).genus - 1 := by linarith
    have h4 : (0 : ℚ) < 4 := by norm_num
    exact mul_pos h4 hpos
  · linarith

/-- **h2_weil_transfer_abbes_ullmo**: ArakelovPositivity (X_0 143).
    Specialises abbes_ullmo_1996_1_2 to N=143 using genus=13 >= 2.
    SORRY: 0.  Classical trio. -/
theorem h2_weil_transfer_abbes_ullmo : ArakelovPositivity (X₀ 143) :=
  abbes_ullmo_1996_1_2 143 (by rw [X₀_143_genus]; norm_num)

end ArakelovRH.AbbesUllmo
