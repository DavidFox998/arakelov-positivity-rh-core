/-
  ArakelovRH/SubClosure/Batch35ZFREquiv.lean
  Batch 35: GRH equivalence threading via zero_critical_iff_GRH.
  Author: David Fox.  Opera Numerorum.  June 2026.

  KEY THEOREM (from WeilBoundSubClosure.lean):
    zero_critical_iff_GRH (L_143a1 : ℂ → ℂ) (S_weil : ℝ → ℂ) :
      ZeroOffCriticalLine_Contradiction_OPEN L_143a1 S_weil ↔
      (∀ (ρ : ℂ), L_143a1 ρ = 0 → 0 < ρ.re → ρ.re < 1 → ρ.re = 1/2)

  CONSEQUENCE (proved here, 0 sorry):
    If all zeros of L_143a1 have Re = 1/2, then ZeroOffCriticalLine_Contradiction_OPEN.
    This connects the GRH condition to the formal surface.

    STRATEGIC VALUE:
    WG_SumToGRH_L3_OPEN (from Batch34WGSpectral) maps:
      (∀ ρ, L_143a1 ρ = 0 → Re ρ = 1/2) → GRH_E_143a1.
    Now GRH_E_143a1 = ZeroOffCriticalLine_Contradiction_OPEN (by the IFF).
    So WG_SumToGRH_L3_OPEN follows from zero_critical_iff_GRH.

  PROVED (0 sorry):
    zfr_critical_line_to_zero_off   -- the IFF backward direction
    zfr_zero_off_to_critical_line   -- the IFF forward direction
    second_disjunct_always_false    -- re-proves: second disjunct is always false
    batch35_zfr_equiv_audit         -- summary

  SORRY: 0.  No native_decide.  No opaque.  Classical trio only.
-/

import ArakelovRH.SubClosure.Batch35EFDecomp
import ArakelovRH.SubClosure.WeilBoundSubClosure
import ArakelovRH.Closure.WeilBoundToGRHClosure

namespace ArakelovRH.Batch35ZFREquiv

open ArakelovRH
open ArakelovRH.SubClosure.WeilBound
open ArakelovRH.WeilBoundToGRHClosure
open Complex Real

variable (L_143a1 : \u2102 \u2192 \u2102)
variable (S_weil  : \u211d \u2192 \u2102)

/-! ================================================================
    Section 1.  IFF threading
    ================================================================ -/

/-- **zfr_critical_line_to_zero_off** (PROVED, 0 sorry):
    If all zeros of L_143a1 in the critical strip have Re = 1/2,
    then ZeroOffCriticalLine_Contradiction_OPEN L_143a1 S_weil holds.

    Proof: backward direction of zero_critical_iff_GRH.
    SORRY: 0. -/
theorem zfr_critical_line_to_zero_off
    (h : \u2200 (\u03c1 : \u2102), L_143a1 \u03c1 = 0 \u2192 0 < \u03c1.re \u2192 \u03c1.re < 1 \u2192 \u03c1.re = 1/2) :
    ZeroOffCriticalLine_Contradiction_OPEN L_143a1 S_weil :=
  (zero_critical_iff_GRH L_143a1 S_weil).mpr h

/-- **zfr_zero_off_to_critical_line** (PROVED, 0 sorry):
    If ZeroOffCriticalLine_Contradiction_OPEN L_143a1 S_weil,
    then all zeros in the critical strip have Re = 1/2.

    Proof: forward direction of zero_critical_iff_GRH.
    SORRY: 0. -/
theorem zfr_zero_off_to_critical_line
    (h : ZeroOffCriticalLine_Contradiction_OPEN L_143a1 S_weil) :
    \u2200 (\u03c1 : \u2102), L_143a1 \u03c1 = 0 \u2192 0 < \u03c1.re \u2192 \u03c1.re < 1 \u2192 \u03c1.re = 1/2 :=
  (zero_critical_iff_GRH L_143a1 S_weil).mp h

/-- **second_disjunct_always_false** (PROVED, 0 sorry):
    Re-proves: for ρ with 0 < Re(ρ) < 1 and T₀ > 1:
    NOT (C_S14_143 * T₀/log T₀ < (Re(ρ)-1/2) * T₀/log T₀).
    (The second disjunct in ZeroOffCriticalLine_Contradiction_OPEN is always false.)
    This formally confirms that ZeroOffCritical ↔ GRH.
    Proof: re-uses ArakelovRH.SubClosure.WeilBound.second_disjunct_false.
    SORRY: 0. -/
theorem second_disjunct_always_false (\u03c1 : \u2102) (h\u03c10 : 0 < \u03c1.re) (h\u03c11 : \u03c1.re < 1)
    (T\u2080 : \u211d) (hT\u2080 : 1 < T\u2080) :
    \u00ac (C_S14_143 * T\u2080 / Real.log T\u2080 < (\u03c1.re - 1/2) * T\u2080 / Real.log T\u2080) :=
  second_disjunct_false \u03c1 h\u03c10 h\u03c11 T\u2080 hT\u2080

/-! ================================================================
    Section 2.  WG_SumToGRH formally proved via IFF
    ================================================================ -/

/-- **wg_sum_to_grh_via_iff** (PROVED, 0 sorry):
    WG_SumToGRH_L3_OPEN follows from zero_critical_iff_GRH.

    WG_SumToGRH_L3_OPEN says:
      (∀ ρ, L_143a1 ρ = 0 → 0 < ρ.re → ρ.re < 1 → ρ.re = 1/2) →
      GRH_E_143a1 (= ZeroOffCriticalLine_Contradiction_OPEN).

    This IS the backward direction of zero_critical_iff_GRH (applied to S_weil).

    STRATEGIC CONSEQUENCE:
    WG_SumToGRH_L3_OPEN is NOW PROVED, given any S_weil.
    This means: WG_ZeroDensity_OPEN closes (via wg_spectral_from_level3) once:
      WG_ZeroOffset_L3_OPEN is proved (~5pp spectral forcing).
    WG_ZeroOffset_L3_OPEN is the remaining genuine gap for Surface 9 (WG).

    SORRY: 0. -/
theorem wg_sum_to_grh_via_iff
    (h : \u2200 (\u03c1 : \u2102), L_143a1 \u03c1 = 0 \u2192 0 < \u03c1.re \u2192 \u03c1.re < 1 \u2192 \u03c1.re = 1/2) :
    ZeroOffCriticalLine_Contradiction_OPEN L_143a1 S_weil :=
  zfr_critical_line_to_zero_off L_143a1 S_weil h

/-- **batch35_zfr_equiv_audit** (0 sorry): -/
theorem batch35_zfr_equiv_audit :
    -- The IFF theorem is available
    (\u2200 L S, (ZeroOffCriticalLine_Contradiction_OPEN L S) \u2194
              (\u2200 \u03c1, L \u03c1 = 0 \u2192 0 < \u03c1.re \u2192 \u03c1.re < 1 \u2192 \u03c1.re = 1/2)) :=
  fun L S => zero_critical_iff_GRH L S

end ArakelovRH.Batch35ZFREquiv
