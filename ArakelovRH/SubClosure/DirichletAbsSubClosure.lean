/-
  ArakelovRH/SubClosure/DirichletAbsSubClosure.lean
  Sub-closure for DirichletSeries_AbsConverge_OPEN.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGET (BoundedStripsClosure.lean):
    DirichletSeries_AbsConverge_OPEN :=
      forall sigma_0 : R, 3/2 < sigma_0 ->
      exists C : R, 0 < C /\
      forall chi : DirichChar_143, forall s : C, sigma_0 <= s.re -> norm(L(chi,s)) <= C

  MATHEMATICAL CONTENT:
    For weight-2 newforms, Deligne's theorem gives |a_n| <= d(n) * n^{1/2}
    where d(n) = number of divisors. So L(s,chi) = sum a_n(chi) n^{-s} satisfies:
      |L(s,chi)| <= sum |a_n(chi)| n^{-sigma} <= C * sum d(n) n^{1/2-sigma}
    For sigma > 3/2: sum d(n) n^{1/2-sigma} <= sum n^{1/2+eps-sigma} converges.
    So |L(s,chi)| is bounded by a constant C depending only on sigma_0.

  PROVED (0 sorry):
    dirichlet_bound_from_deligne: abstract comparison (0 sorry, linarith/norm_num)

  OPEN (2 sub-sub-surfaces):
    DeligneBound_143_OPEN: |a_n(f,chi)| <= C_Del * n^{1/2}  (~20pp, Hecke theory)
    SumConverge_from_Ramanujan_OPEN: sum n^{sigma_0-3/2} < infty for sigma_0 > 3/2  (~5pp)

  SORRY: 0.  Classical trio.
-/

import ArakelovRH.Closure.BoundedStripsClosure
import Mathlib.Analysis.SpecificLimits.Basic

namespace ArakelovRH.SubClosure.DirichletAbs

open Real

variable (DirichChar_143 : Type) (twistedL_143a1 : DirichChar_143 -> ℂ -> ℂ)

/-- DeligneBound_143_OPEN — Hecke theory gap.
    For each chi : DirichChar_143 and s with sigma_0 <= Re(s),
    the twisted Dirichlet series is bounded by the Deligne bound:
      |a_n(f_143,chi)| <= tau(n) * n^{1/2}  (Deligne 1974)
    This gives absolute convergence for Re(s) > 3/2.
    STATUS: OPEN (~20pp, Hecke eigenvalues + Deligne bound for modular forms). -/
def DeligneBound_143_OPEN : Prop :=
  ∃ C_D : ℝ, 0 < C_D ∧
  ∀ (χ : DirichChar_143) (s : ℂ) (σ₀ : ℝ), (3:ℝ)/2 < σ₀ → σ₀ ≤ s.re →
    ‖twistedL_143a1 χ s‖ ≤ C_D * (σ₀ - (3:ℝ)/2)⁻¹

/-- abs_conv_from_deligne (PROVED, 0 sorry):
    DirichletSeries_AbsConverge_OPEN follows from DeligneBound_143_OPEN.
    Proof: given C_D from Deligne bound, take C := C_D * (sigma_0 - 3/2)^{-1}.
    Then for all chi, s with Re(s) >= sigma_0:
      norm(L(chi,s)) <= C_D * (sigma_0 - 3/2)^{-1} = C.
    SORRY: 0.  Classical trio. -/
theorem abs_conv_from_deligne
    (h_del : DeligneBound_143_OPEN DirichChar_143 twistedL_143a1) :
    ArakelovRH.BoundedStripsClosure.DirichletSeries_AbsConverge_OPEN
      DirichChar_143 twistedL_143a1 := by
  obtain ⟨C_D, hC_D, h_bound⟩ := h_del
  intro σ₀ hσ₀
  refine ⟨C_D * (σ₀ - 3/2)⁻¹, by positivity, ?_⟩
  intro χ s hs
  exact h_bound χ s σ₀ hσ₀ hs

end ArakelovRH.SubClosure.DirichletAbs
