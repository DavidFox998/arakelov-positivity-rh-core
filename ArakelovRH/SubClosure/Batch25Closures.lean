/-
  ArakelovRH/SubClosure/Batch25Closures.lean
  Batch 25: PROVED — NhdsWithin_Re_NeBot_OPEN closed with a real Lean proof.
  Author: David Fox.  Opera Numerorum.  June 2026.

  NhdsWithin_Re_NeBot_OPEN (defined in IKResidueAttack) is:
    (nhdsWithin (1 : C) {s : C | 1 < s.re}).NeBot.

  PROOF STRATEGY (0 sorry):
    1. By mem_closure_iff_nhdsWithin_neBot: suffices to show 1 in closure {Re>1}.
    2. By mem_closure_iff_nhds: for every nhd U of 1, (U n {Re>1}).Nonempty.
    3. Witness: (1 + e/2 : R) : C for any e-ball nhd of 1.
       dist((1+e/2:R):C, 1) = e/2 < e   (Complex.abs_ofReal + ring)
       Re((1+e/2:R):C) = 1+e/2 > 1      (Complex.ofReal_re + linarith)

  SORRY: 0.  No native_decide.  No opaque.  Classical trio only.
-/

import ArakelovRH.SubClosure.IKResidueAttack
import Mathlib.Topology.MetricSpace.Basic

namespace ArakelovRH.Batch25Closures

open ArakelovRH.IKResidueAttack
open Complex Filter Set Metric Topology

/-- **nhdsWithin_re_gt1_neBot** (PROVED, 0 sorry):
    (nhdsWithin (1 : C) {s | 1 < s.re}).NeBot.
    Proof: 1 in closure {Re > 1} via explicit e/2 witness in every nhd. -/
theorem nhdsWithin_re_gt1_neBot :
    (nhdsWithin (1 : C) {s : C | 1 < s.re}).NeBot := by
  rw [← mem_closure_iff_nhdsWithin_neBot]
  apply mem_closure_iff_nhds.mpr
  intro U hU
  obtain ⟨e, he, hball⟩ := Metric.mem_nhds_iff.mp hU
  refine ⟨((1 + e / 2 : R) : C), ?_, ?_⟩
  · apply hball
    rw [Metric.mem_ball, Complex.dist_eq]
    have heq : ((1 + e / 2 : R) : C) - 1 = ((e / 2 : R) : C) := by push_cast; ring
    rw [heq, Complex.abs_ofReal, abs_of_pos (half_pos he)]
    exact half_lt_self he
  · simp only [mem_setOf_eq, Complex.ofReal_re]
    linarith [half_pos he]

/-- NhdsWithin_Re_NeBot_OPEN is PROVED (0 sorry). -/
theorem NhdsWithin_Re_NeBot_proved :
    NhdsWithin_Re_NeBot_OPEN :=
  nhdsWithin_re_gt1_neBot

theorem batch25_closures_complete : True := True.intro

end ArakelovRH.Batch25Closures
