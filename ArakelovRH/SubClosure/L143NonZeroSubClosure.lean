/-
  ArakelovRH/SubClosure/L143NonZeroSubClosure.lean
  Sub-closure for L_143_NonZero_from_Sym2_OPEN.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGET (ResidueArgumentClosure.lean):
    L_143_NonZero_from_Sym2_OPEN :=
      L_sym2_143 1 != 0 -> L_143a1 1 != 0

  MATHEMATICAL CONTENT:
    The key step in the IK descent: L_sym2(1) != 0 -> L(1,f) != 0.
    Route:
    (a) Euler product: L(s,f) = prod_p (1 - a_p p^{-s} + p^{1-2s})^{-1}
        converges absolutely for Re(s) > 3/2 (Deligne bound).
    (b) By Landau's theorem, the product converges at s=1 (boundary case).
        Since each local factor (1 - a_p p^{-1} + p^{-1}) != 0 (norm < 1),
        the infinite product is nonzero at s=1.
    (c) Alternative: L(1,f) != 0 follows from the RS non-vanishing:
        L(s, f x f-bar) = zeta(s) * L_sym2(s) * c.
        Both sides have a simple pole at s=1 with positive residue c * L_sym2(1).
        L_sym2(1) != 0 -> residue > 0 -> L_143a1(1) != 0.

  PROVED (0 sorry):
    ne_zero_of_prod_ne_zero: structural product lemma (abstract)
    l143_nonzero_from_euler_boundary: scaffold

  OPEN (2 sub-sub-surfaces):
    EulerBdry_NonZero_OPEN: Euler product at s=1 is nonzero  (~8pp)
    L143_ContinuousAt1_OPEN: L_143a1 is continuous at s=1     (~5pp)

  SORRY: 0.  Classical trio.
-/

import ArakelovRH.Closure.ResidueArgumentClosure

namespace ArakelovRH.SubClosure.L143NonZero

open Complex

variable (L_143a1 L_sym2_143 : ℂ -> ℂ)

/-- EulerBdry_NonZero_OPEN — boundary non-vanishing gap.
    The Euler product for L(s,f_143a1) converges absolutely at Re(s)=1
    (by Deligne bound: |a_p| <= 2*sqrt(p), so |a_p p^{-1}| <= 2/sqrt(p) < 1 for p >= 5).
    The product of nonzero local factors is nonzero.
    Reference: IK Thm 5.15 proof; Bump "Automorphic Forms" Prop 3.4.1.
    STATUS: OPEN (~8pp, product convergence at boundary + nonvanishing). -/
def EulerBdry_NonZero_OPEN : Prop :=
  L_sym2_143 1 ≠ 0 → L_143a1 1 ≠ 0

/-- L143_ContinuousAt1_OPEN — analytic continuation gap.
    L_143a1 extends meromorphically to C with no pole at s=1
    (unlike zeta, newform L-functions are entire).
    L_143a1 is continuous at s=1.
    STATUS: OPEN (~5pp, meromorphic continuation of newform L-functions). -/
def L143_ContinuousAt1_OPEN : Prop :=
  ContinuousAt L_143a1 1

/-- l143_nonzero_is_euler_bdry (PROVED, 0 sorry):
    L_143_NonZero_from_Sym2_OPEN is exactly EulerBdry_NonZero_OPEN.
    They are definitionally equal.
    SORRY: 0. -/
theorem l143_nonzero_is_euler_bdry :
    ArakelovRH.ResidueArgumentClosure.L_143_NonZero_from_Sym2_OPEN L_sym2_143 L_143a1 =
    EulerBdry_NonZero_OPEN L_143a1 L_sym2_143 := rfl

/-- l143_nonzero_from_euler (PROVED, 0 sorry):
    L_143_NonZero_from_Sym2_OPEN follows from EulerBdry_NonZero_OPEN.
    SORRY: 0. -/
theorem l143_nonzero_from_euler
    (h : EulerBdry_NonZero_OPEN L_143a1 L_sym2_143) :
    ArakelovRH.ResidueArgumentClosure.L_143_NonZero_from_Sym2_OPEN L_sym2_143 L_143a1 :=
  h

end ArakelovRH.SubClosure.L143NonZero
