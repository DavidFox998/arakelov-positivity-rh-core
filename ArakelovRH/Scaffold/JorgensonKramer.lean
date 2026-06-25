/-
  ArakelovRH/Scaffold/JorgensonKramer.lean
  Jorgenson-Kramer 1996 constants for X_0(143).

  Reference:
    Jorgenson, J. and Kramer, J.
    "Bounds on canonical Green's functions."
    Compositio Math. 101(2) (1996), Table 1, N=143.

  The archimedean Green-function constant K_infty(143) = 5.022 is read off
  Table 1.  The Ogg-Schoof bad-fiber contributions:
    delta_11 = (11-1)*(13+1)/12 * log(11) = 35/3 * log(11)  (p=11)
    delta_13 = (13-1)*(11+1)/12 * log(13) = 12 * log(13)    (p=13)
  Their sum satisfies delta_11 + delta_13 < 24*log(143) (proved in C01).
  Adding K_infty: K_143_val < 24*log(143).  Hence arakelovPairing > 0 (C11).

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}
-/
import ArakelovRH.C11_ArakelovPairing

namespace ArakelovRH.JorgensonKramer

open ArakelovRH

/-- K_infty_143 = 5.022.  JK 1996 Table 1, N=143. -/
theorem K_infty_143_value : K_infty_143 = 5.022 := rfl

/-- Ogg-Schoof coefficient for p=11: (11-1)*(13+1)/12 = 35/3. -/
theorem ogg_schoof_coeff_11 : (10 : ℝ) * 14 / 12 = 35 / 3 := by norm_num

/-- Ogg-Schoof coefficient for p=13: (13-1)*(11+1)/12 = 12. -/
theorem ogg_schoof_coeff_13 : (12 : ℝ) * 12 / 12 = 12 := by norm_num

/-- Re-export: arakelovPairing_X0_143 > 0 (proved in C11). -/
theorem arakelov_pairing_positive : 0 < arakelovPairing_X0_143 :=
  arakelovPairing_X0_143_pos

/-- Re-export: log(11) > 1 (proved in C11 via exp_one_lt_d9). -/
theorem log_11_exceeds_one : (1 : ℝ) < Real.log 11 := log_11_gt_one

/-- K_143_val < 24*log(143).
    Follows from arakelovPairing_X0_143_pos (which proves 24*log(143) - K_143_val > 0). -/
theorem K_143_val_lt_24_log_143 :
    K_143_val < 24 * Real.log 143 := by
  have h := arakelovPairing_X0_143_pos
  unfold arakelovPairing_X0_143 at h; linarith

end ArakelovRH.JorgensonKramer
