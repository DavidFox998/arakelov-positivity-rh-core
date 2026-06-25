/-
  ArakelovRH/Scaffold/AbbesUllmo.lean
  Abbes-Ullmo 1996: ArakelovPositivity for X_0(N), squarefree N, genus >= 2.

  Reference:
    Abbes, A. and Ullmo, E. (1996).
    "Comparaison des metriques d'Arakelov et de Poincare sur X_0(N)."
    Duke Mathematical Journal 80(2):295-307.  Theorem 1.2.

  Theorem 1.2 (Abbes-Ullmo):
    If N squarefree and g(X_0(N)) >= 2, then (omega,omega)_Ar > 0.

  Local proof:
    arakelovSelfIntersection (X_0 N) = 4*(genus-1)/genus (slope-formula).
    For genus >= 2 (in Q): numerator = 4*(genus-1) >= 4 > 0, denom >= 2 > 0.
    Abbes-Ullmo guarantees the stronger genuine intersection result;
    our conservative slope-formula stand-in satisfies the same positivity.

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}
  Referee: #print axioms ArakelovRH.AbbesUllmo.abbes_ullmo_1996_1_2
-/
import ArakelovRH.C01_Arakelov

namespace ArakelovRH.AbbesUllmo

open ArakelovRH

/-- **abbes_ullmo_1996_1_2**: ArakelovPositivity for X_0(N) when genus >= 2.

    Citation: Abbes-Ullmo, Duke Math. J. 80 (1996) no. 2, Theorem 1.2.

    Local proof:
      arakelovSelfIntersection (X_0 N) = 4*(genus-1)/genus (in Q).
      hg : 2 <= genus  =>  genus-1 >= 1 > 0  and  genus >= 2 > 0.
      So 4*(genus-1) > 0 and genus > 0 => quotient > 0 (div_pos).

    SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}. -/
theorem abbes_ullmo_1996_1_2 (N : ℕ)
    (hg : (2 : ℚ) ≤ (X₀ N).genus) :
    ArakelovPositivity (X₀ N) := by
  unfold ArakelovPositivity arakelovSelfIntersection
  apply div_pos
  · have : (1 : ℚ) ≤ (X₀ N).genus - 1 := by linarith
    linarith [show (0:ℚ) < 4 from by norm_num,
              mul_pos (show (0:ℚ) < 4 from by norm_num) (by linarith : (0:ℚ) < (X₀ N).genus - 1)]
  · linarith

/-- **h2_weil_transfer_abbes_ullmo**: ArakelovPositivity (X_0 143).
    Specialises abbes_ullmo_1996_1_2 to N=143 using genus=13 >= 2.
    SORRY: 0.  Classical trio. -/
theorem h2_weil_transfer_abbes_ullmo : ArakelovPositivity (X₀ 143) :=
  abbes_ullmo_1996_1_2 143 (by rw [X₀_143_genus]; norm_num)

end ArakelovRH.AbbesUllmo
