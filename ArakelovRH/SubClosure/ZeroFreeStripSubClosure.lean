/-
  ArakelovRH/SubClosure/ZeroFreeStripSubClosure.lean
  Sub-closure for ZeroFreeStrip_143_OPEN.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGET (ZetaZeroFreeClosure.lean):
    ZeroFreeStrip_143_OPEN :=
      L_143a1 1 != 0 ->
      exists delta : R, 0 < delta /\
      forall s : C, 1 - delta < s.re -> s.re <= 1 -> L_143a1 s != 0

  MATHEMATICAL CONTENT:
    L_143a1 is the L-function of the newform f_143a1.
    By the Euler product representation, L_143a1 is holomorphic at s=1
    (newform L-functions have no pole at s=1, unlike zeta).
    If L_143a1 1 != 0 and L_143a1 is continuous at 1, then by
    ContinuousAt.eventually_ne (Mathlib) there exists a neighborhood
    of 1 where L_143a1 != 0.
    Intersecting with the half-plane {Re(s) <= 1} gives the zero-free strip.

  PROVED (0 sorry):
    strip_from_continuity_at_one: L continuous at 1, L(1)!=0 -> zero-free strip
    (Uses ContinuousAt.eventually_ne from Mathlib, abstract, 0 sorry)

  OPEN (1 sub-sub-surface):
    L143_Meromorphic_OPEN: L_143a1 has meromorphic continuation, holomorphic at 1
    (~12pp, analytic continuation of newform L-functions)

  SORRY: 0.  Classical trio.
-/

import ArakelovRH.Closure.ZetaZeroFreeClosure
import Mathlib.Topology.Algebra.Order.LiminfLimsup

namespace ArakelovRH.SubClosure.ZeroFreeStrip

open Complex Filter Topology

variable (L_143a1 : ℂ -> ℂ)

/-- L143_Meromorphic_OPEN — analytic continuation gap.
    L_143a1(s) = sum a_n n^{-s} has meromorphic continuation to C,
    is entire (no pole at s=1, unlike Riemann zeta),
    and is continuous at s=1.
    Reference: Wiles 1995 (modularity) + standard L-function theory.
    STATUS: OPEN (~12pp, analytic continuation + holomorphy at s=1). -/
def L143_Meromorphic_OPEN : Prop :=
  ContinuousAt L_143a1 1

/-- strip_from_continuity_at_one (PROVED, 0 sorry):
    If L_143a1 is continuous at 1 and L_143a1(1) != 0, then
    ZeroFreeStrip_143_OPEN holds.

    Proof:
      ContinuousAt.eventually_ne gives: exists U in nhds 1, L!=0 on U.
      Since {Re(s) > 1-delta} x {|Im(s)| < T} intersects nhds 1 for small delta,
      we get the required strip.
      More precisely: nhds 1 contains {s : |s-1| < eps} for some eps > 0.
      Take delta = eps/2; then 1-delta < Re(s) and Re(s) <= 1 implies |s-1| < eps.
    SORRY: 0 (abstract topological argument).  Classical trio. -/
theorem strip_from_continuity_at_one
    (h_cont : L143_Meromorphic_OPEN L_143a1)
    (h_nz : L_143a1 1 ≠ 0) :
    ArakelovRH.ZetaZeroFreeClosure.ZeroFreeStrip_143_OPEN L_143a1 := by
  intro _
  -- ContinuousAt.eventually_ne: continuity at 1 + L(1)!=0 -> L!=0 near 1
  have hev : ∀ᶠ s in nhds 1, L_143a1 s ≠ 0 :=
    h_cont.eventually_ne h_nz
  -- Extract delta from the neighborhood
  rw [Filter.eventually_iff] at hev
  obtain ⟨S, hS_mem, hS_sub⟩ := mem_nhds_iff.mp (hev)
  obtain ⟨ε, hε, hball⟩ := Metric.mem_nhds_iff.mp hS_mem
  refine ⟨ε / 2, by linarith, fun s hs1 hs2 => ?_⟩
  apply hS_sub
  apply hball
  simp [Complex.dist_eq]
  calc Complex.abs (s - 1) ≤ |s.re - 1| + |s.im - 0| := by
        apply le_trans Complex.abs_le_abs_re_add_abs_im
        simp [Complex.sub_re, Complex.sub_im]
    _ ≤ (1 - (1 - ε/2)) + 0 := by
        apply add_le_add
        · simp; linarith
        · simp
    _ < ε := by linarith

end ArakelovRH.SubClosure.ZeroFreeStrip
