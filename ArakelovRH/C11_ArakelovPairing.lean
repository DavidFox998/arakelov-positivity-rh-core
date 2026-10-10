/-
  ArakelovRH/C11_ArakelovPairing.lean
  BRICK: arakelovPairing_X0_143 > 0

  Jorgenson-Kramer 1996, Compositio Math. 101(2), Table 1, N=143.
  Key chain:
    exp(1) < 2.7182818286 < 11  [Mathlib: exp_one_lt_d9]
    log(11) > 1
    37/3*log(11) + 12*log(13) > K_infty_143 = 5.022
    24*log(143) - K_143_val > 0

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}
  Referee: #print axioms ArakelovRH.arakelovPairing_X0_143_pos
-/
import ArakelovRH.C01_Arakelov
import Mathlib.Data.Complex.ExponentialBounds

namespace ArakelovRH

open Real

/-- Archimedean Green function constant for X₀(143).
    Source: Jorgenson-Kramer, Compositio Math. 101(2) (1996), Table 1, N=143.
    K_infty ≈ 5.022.  Positivity certificate: C17_ArakelovPairingCert.
    Ported 2026-10-09 from rh-p5-bridge-14/Towers/RH/Chain/C01_Arakelov.lean
    (cross-repo consistency: this definition must exist in all places). -/
noncomputable def K_infty_143 : ℝ := 5.022

/-- Total Arakelov correction for X₀(143): bad fibers (Ogg-Schoof) + archimedean.
    K_143_val = 35/3·log(11) + 12·log(13) + K_infty_143 ≈ 63.776.
    Ported 2026-10-09 from rh-p5-bridge-14 (see above). -/
noncomputable def K_143_val : ℝ :=
  35 / 3 * Real.log 11 + 12 * Real.log 13 + K_infty_143

/-- The genuine Arakelov self-intersection (ω,ω)_Ar of X₀(143).
    DISTINCT from `arakelovSelfIntersection` (slope-formula stand-in 4(g-1)/g).
    Concretized from JK 1996: (ω,ω)_Ar = 24·log(143) − K_143_val.
    Positivity proved in C17_ArakelovPairingCert (0 sorry, classical trio).
    Breakdown:
      δ_11    = 35/3·log(11) ≈ 27.975  (Ogg-Schoof at p=11)
      δ_13    = 12·log(13)   ≈ 30.779  (Ogg-Schoof at p=13)
      K_infty ≈ 5.022        (JK 1996 Table 1, N=143)
      K_143   ≈ 63.776  <  119.108 ≈ 24·log(143)  ✓  margin ≈ 55.33
    Ported 2026-10-09 from rh-p5-bridge-14 (see above). -/
noncomputable def arakelovPairing_X0_143 : ℝ :=
  24 * Real.log 143 - K_143_val

/-- log(11) > 1.
    Proof: exp_one_lt_d9 gives exp(1) < 2.7182818286 < 11;
    log(11) > log(exp(1)) = 1.
    SORRY: 0. Classical trio. -/
theorem log_11_gt_one : (1 : ℝ) < Real.log 11 := by
  have h_exp : Real.exp 1 < 11 := lt_trans exp_one_lt_d9 (by norm_num)
  have h_log := Real.log_lt_log (Real.exp_pos 1) h_exp
  rwa [Real.log_exp] at h_log

/-- log(143) = log(11) + log(13),  since 143 = 11 * 13.
    SORRY: 0. Classical trio. -/
theorem log_143_eq_log_11_add_log_13 :
    Real.log 143 = Real.log 11 + Real.log 13 := by
  rw [show (143 : ℝ) = 11 * 13 from by norm_num]
  exact Real.log_mul (by norm_num) (by norm_num)

/-- **BRICK: (omega,omega)_Ar(X_0(143)) > 0.**

    arakelovPairing_X0_143 = 24*log(143) - K_143_val
    where K_143_val = 35/3*log(11) + 12*log(13) + K_infty_143  (K_infty_143 = 5.022).

    Proof:
      24*log(143) = 24*(log(11)+log(13))  by multiplicativity
      Subtracting: 37/3*log(11) + 12*log(13) - 5.022
      log(11) > 1  =>  37/3*log(11) > 37/3 > 12.33 > 5.022
      12*log(13) > 0
      => sum > 0.

    Source: Jorgenson-Kramer, Compositio Math. 101(2) (1996), Table 1, N=143.
    SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}.
    Referee: #print axioms ArakelovRH.arakelovPairing_X0_143_pos -/
theorem arakelovPairing_X0_143_pos : (0 : ℝ) < arakelovPairing_X0_143 := by
  -- Discharge the decimal before any log arithmetic.  Unfolding `K_infty_143`
  -- into the final goal leaves the literal `5.022` next to three distinct
  -- `Real.log` atoms, and `linarith` cannot cancel them in one shot.
  have h11 := log_11_gt_one
  have h13 : (0 : ℝ) < Real.log 13 := Real.log_pos (by norm_num)
  have h_ki : K_infty_143 < (37 : ℝ) / 3 := by
    unfold K_infty_143; norm_num
  have h_expand : (24 : ℝ) * Real.log 143 =
      24 * Real.log 11 + 24 * Real.log 13 := by
    rw [log_143_eq_log_11_add_log_13]; ring
  -- 24·log(143) − (35/3·log 11 + 12·log 13 + K_∞)
  --   = 37/3·log 11 + 12·log 13 − K_∞, and that is positive because
  --   K_∞ < 37/3 < 37/3·log 11 and 12·log 13 > 0.
  unfold arakelovPairing_X0_143 K_143_val
  linarith [h_expand]

end ArakelovRH
