/-
  ArakelovRH/SubClosure/IKResidueAttack.lean
  Batch 24: IK_GRH_to_L_sym2_nv_OPEN via residue-limit decomposition.
  Author: David Fox.  Opera Numerorum.  June 2026.

  STRATEGY:
    IK_GRH_to_L_sym2_nv_OPEN says:
      GRH_E_143a1 → RS has simple pole → RS_Identity → L_sym2(1) ≠ 0.

    Mathematical argument (residue theorem):
      (1) RS(s) = ζ(s) · L_sym2(s) for Re(s) > 1         [RS_Identity_OPEN]
      (2) (s−1)·RS(s) → c > 0  as  s → 1 (full nhds)      [IK_RS_SimplePole_OPEN]
      (3) Restrict (2) to nhdsWithin 1 {Re > 1}: limit c.
      (4) On {Re > 1}: (s−1)·RS = (s−1)·ζ·L_sym2  by (1).
      (5) (s−1)·ζ(s) → 1  along {Re > 1}               [ZetaResidueOne_OPEN]
      (6) L_sym2(s) → L_sym2(1)                        [L_sym2_ContinuousAt1_OPEN]
      (7) Product: (s−1)·ζ·L_sym2 → L_sym2(1).
      (8) Uniqueness (NeBot): L_sym2(1) = c > 0, so L_sym2(1) ≠ 0.

  NEW NAMED OPENS (3 sub-surfaces):
    L_sym2_ContinuousAt1_OPEN (~5pp): ContinuousAt L_sym2_143 1.
    ZetaResidueOne_OPEN (~2pp): Tendsto ((s−1)·ζ) nhdsWithin{Re>1} (nhds 1).
    NhdsWithin_Re_NeBot_OPEN (~1pp): (nhdsWithin 1 {Re>1}).NeBot.

  PROVED COMBINATOR (0 sorry):
    ik_grh_nv_from_residue:
      L_sym2_ContinuousAt1_OPEN → ZetaResidueOne_OPEN →
      NhdsWithin_Re_NeBot_OPEN → IK_GRH_to_L_sym2_nv_OPEN.

  SORRY: 0.  No native_decide.  No opaque.  Classical trio only.
-/

import ArakelovRH.SubClosure.IKSubgateDecomp
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Topology.Algebra.Module.Basic

namespace ArakelovRH.IKResidueAttack

open ArakelovRH ArakelovRH.IwaniecKowalski ArakelovRH.IKSubgateDecomp
open Filter Complex Real

variable (RankinSelberg_L : ℂ → ℂ)
variable (L_sym2_143     : ℂ → ℂ)

/-! -- §1.  Named open sub-surfaces ---------------------------------------- -/

/-- **L_sym2_ContinuousAt1_OPEN** — continuity of L_sym2_143 at s=1 (~5pp).
    ContinuousAt L_sym2_143 1.
    Lean gap: uniform convergence of Dirichlet series on compact strips
    and analytic continuation to s=1 (L_sym2 is entire for weight-2 newform).
    STATUS: OPEN (~5pp Lean). -/
def L_sym2_ContinuousAt1_OPEN : Prop :=
  ContinuousAt L_sym2_143 1

/-- **ZetaResidueOne_OPEN** — riemannZeta has residue 1 at s=1 (~2pp).
    Filter.Tendsto (fun s : ℂ => (s - 1) * riemannZeta s)
      (nhdsWithin 1 {s : ℂ | 1 < s.re}) (nhds 1).
    Should follow from Mathlib.NumberTheory.LSeries.RiemannZeta API.
    STATUS: OPEN (~2pp Lean; expected Mathlib lemma exists). -/
def ZetaResidueOne_OPEN : Prop :=
  Filter.Tendsto (fun s : ℂ => (s - 1) * riemannZeta s)
    (nhdsWithin 1 {s : ℂ | 1 < s.re}) (nhds 1)

/-- **NhdsWithin_Re_NeBot_OPEN** — nhdsWithin 1 {Re > 1} is non-trivial (~1pp).
    (nhdsWithin (1 : ℂ) {s : ℂ | 1 < s.re}).NeBot.
    Equivalently: 1 ∈ closure {s : ℂ | 1 < s.re}.
    Proof: sequence (1 + 1/(n+1) : ℝ → ℂ) ∈ {Re > 1} for all n, → 1.
    STATUS: OPEN (~1pp Lean; proof is clear). -/
def NhdsWithin_Re_NeBot_OPEN : Prop :=
  (nhdsWithin (1 : ℂ) {s : ℂ | 1 < s.re}).NeBot

/-! -- §2.  Main combinator --------------------------------------------------- -/

/-- **ik_grh_nv_from_residue** (PROVED, 0 sorry):
    IK_GRH_to_L_sym2_nv_OPEN follows from three sub-opens:
      h_cont  : ContinuousAt L_sym2_143 1          [~5pp]
      h_zeta  : (s-1)·ζ(s) → 1 along Re>1           [~2pp]
      h_nebot : nhdsWithin 1 {Re>1} is NeBot        [~1pp]

    Proof (0 sorry):
    (1) hc': restrict h_pole to nhdsWithin 1 {Re>1}  (mono_left).
    (2) h_eq: (s-1)·RS = (s-1)·ζ·L_sym2 on {Re>1}  (h_rs_id + mul).
    (3) h_prod: (s-1)·ζ·L_sym2 → L_sym2(1)  (Tendsto.mul + one_mul).
    (4) hc_prod: same function → c  (Tendsto.congr' h_eq).
    (5) heq: L_sym2(1) = c  (tendsto_nhds_unique, NeBot instance).
    (6) L_sym2(1) ≠ 0  since c > 0.
    SORRY: 0. -/
theorem ik_grh_nv_from_residue
    (h_cont  : ContinuousAt L_sym2_143 1)
    (h_zeta  : Filter.Tendsto (fun s : ℂ => (s - 1) * riemannZeta s)
                 (nhdsWithin 1 {s : ℂ | 1 < s.re}) (nhds 1))
    (h_nebot : (nhdsWithin (1 : ℂ) {s : ℂ | 1 < s.re}).NeBot) :
    IK_GRH_to_L_sym2_nv_OPEN RankinSelberg_L L_sym2_143 := by
  intro _hGRH h_pole h_rs_id
  obtain ⟨c, hc_pos, hc_tend⟩ := h_pole
  -- (1) Restrict full-nhds pole limit to right half-plane
  have hc' : Filter.Tendsto (fun s : ℂ => (s - 1) * RankinSelberg_L s)
      (nhdsWithin 1 {s : ℂ | 1 < s.re}) (nhds (c : ℂ)) :=
    hc_tend.mono_left nhdsWithin_le_nhds
  -- (2) On {Re > 1}: (s-1)·RS(s) = (s-1)·ζ(s)·L_sym2(s)
  have h_eq : ∀ᶠ s in nhdsWithin 1 {s : ℂ | 1 < s.re},
      (s - 1) * RankinSelberg_L s = (s - 1) * riemannZeta s * L_sym2_143 s :=
    Filter.eventually_nhdsWithin_of_forall (fun s hs => by
      rw [h_rs_id s hs, ← mul_assoc, mul_comm (riemannZeta s) (L_sym2_143 s)])
  -- (3) Product limit: (s-1)·ζ(s)·L_sym2(s) → L_sym2(1) along {Re > 1}
  have h_prod : Filter.Tendsto (fun s : ℂ => (s - 1) * riemannZeta s * L_sym2_143 s)
      (nhdsWithin 1 {s : ℂ | 1 < s.re}) (nhds (L_sym2_143 1)) := by
    have hmul := h_zeta.mul (h_cont.tendsto.mono_left nhdsWithin_le_nhds)
    simp only [one_mul] at hmul
    exact hmul
  -- (4) Same function also tends to c (via RS rewrite)
  have hc_prod : Filter.Tendsto (fun s : ℂ => (s - 1) * riemannZeta s * L_sym2_143 s)
      (nhdsWithin 1 {s : ℂ | 1 < s.re}) (nhds (c : ℂ)) :=
    hc'.congr' h_eq
  -- (5) Uniqueness of limits: L_sym2(1) = c in ℂ
  haveI : (nhdsWithin (1 : ℂ) {s : ℂ | 1 < s.re}).NeBot := h_nebot
  have heq : L_sym2_143 1 = (c : ℂ) := tendsto_nhds_unique h_prod hc_prod
  -- (6) Conclude: L_sym2(1) = c > 0 ≠ 0
  rw [heq]; exact_mod_cast ne_of_gt hc_pos

/-- Batch 24 IK residue attack complete. -/
theorem ik_residue_batch24_complete : True := True.intro

end ArakelovRH.IKResidueAttack
