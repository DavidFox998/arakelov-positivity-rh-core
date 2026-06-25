/-
  ArakelovRH/Scaffold/GrowthContradiction.lean
  Route A: conditional reduction via growth bound + zero repulsion.

  _root_.RiemannHypothesis (Mathlib v4.12.0) is the GENUINE predicate:
    forall (s : C) (_ : riemannZeta s = 0)
           (_ : not exists n : N, s = -2*(n+1)) (_ : s != 1), s.re = 1/2

  This file proves _root_.RiemannHypothesis from two named open surfaces.
  GrowthBound is FALSE (classical Omega-results; Titchmarsh Sec 8).
  It is named so the gap is explicit and cannot be silently discharged.

  The ONLY closed mathematical content is exp_loglog_dominates_sq:
    forall C c_1 > 0, exp(c_1*log t / log log t) eventually exceeds C*(log t)^2.
  Proved via Real.tendsto_exp_div_pow_atTop 2.

  SORRY: 0.  No axiom.  No native_decide.
  Axiom footprint: {propext, Classical.choice, Quot.sound}
  Referee: #print axioms ArakelovRH.GrowthContradiction.riemannHypothesis_of_growth_and_repulsion
-/
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Exp

namespace ArakelovRH.GrowthContradiction

open Filter Real

/-! ## Named open surfaces -/

/-- **GrowthBound (OPEN -- in fact false).**
    Exists C > 0, forall t >= 2, |zeta(1/2+it)| <= C*(log t)^2.
    Stronger than Lindelof; FALSE by classical Omega-results (Titchmarsh Sec 8).
    Named here so the gap is explicit.  STATUS: OPEN. -/
def GrowthBound : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ t : ℝ, 2 ≤ t →
    Complex.abs (riemannZeta (1/2 + (t : ℂ) * Complex.I)) ≤ C * (Real.log t) ^ 2

/-- **ZeroRepulsion (OPEN), stated conditionally.**
    If a nontrivial off-line zero rho exists, then |zeta(1/2+it)| is large for
    arbitrarily large t.  Not formalised in Mathlib v4.12.0.  STATUS: OPEN.
    Note: the trivial-zero form -2*(n+1) matches _root_.RiemannHypothesis exactly. -/
def ZeroRepulsion : Prop :=
  (∃ ρ : ℂ, riemannZeta ρ = 0 ∧
    (¬ ∃ n : ℕ, ρ = -2 * ((n : ℂ) + 1)) ∧ ρ ≠ 1 ∧ ρ.re ≠ 1 / 2) →
  ∃ c₁ : ℝ, 0 < c₁ ∧ ∀ B : ℝ, ∃ t : ℝ, B ≤ t ∧
    Real.exp (c₁ * Real.log t / Real.log (Real.log t)) ≤
      Complex.abs (riemannZeta (1 / 2 + (t : ℂ) * Complex.I))

/-! ## Pure-calculus comparison (proved) -/

/-- **exp_loglog_dominates_sq (PROVED, 0 sorry).**
    For C, c_1 > 0: exp(c_1*log t / log log t) eventually exceeds C*(log t)^2.
    Substitution v = log log t: log t = exp v; claim becomes
      log C + 2*v < c_1*exp(v)/v  for large v.
    SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}. -/
theorem exp_loglog_dominates_sq (C c₁ : ℝ) (hC : 0 < C) (hc₁ : 0 < c₁) :
    ∀ᶠ t in atTop,
      C * (Real.log t) ^ 2 < Real.exp (c₁ * Real.log t / Real.log (Real.log t)) := by
  have hexp2 : Tendsto (fun v : ℝ => Real.exp v / v ^ 2) atTop atTop :=
    Real.tendsto_exp_div_pow_atTop 2
  have hsub : Tendsto (fun v : ℝ => c₁ * (Real.exp v / v ^ 2) + (-2)) atTop atTop :=
    tendsto_atTop_add_const_right atTop (-2 : ℝ) (hexp2.const_mul_atTop hc₁)
  have hmul : Tendsto (fun v : ℝ => v * (c₁ * (Real.exp v / v ^ 2) + (-2))) atTop atTop :=
    tendsto_id.atTop_mul_atTop hsub
  have hcore : Tendsto (fun v : ℝ => c₁ * Real.exp v / v - 2 * v) atTop atTop := by
    refine hmul.congr' ?_
    filter_upwards [eventually_gt_atTop (0 : ℝ)] with v hv
    field_simp; ring
  have hv_ineq : ∀ᶠ v in atTop, Real.log C + 2 * v < c₁ * Real.exp v / v := by
    filter_upwards [hcore.eventually_gt_atTop (Real.log C)] with v hv; linarith
  have hloglog : Tendsto (fun t : ℝ => Real.log (Real.log t)) atTop atTop :=
    Real.tendsto_log_atTop.comp Real.tendsto_log_atTop
  filter_upwards [hloglog.eventually hv_ineq,
                  Real.tendsto_log_atTop.eventually_gt_atTop (0 : ℝ)]
    with t htin htpos
  rw [Real.exp_log htpos] at htin
  have hCsq : C * (Real.log t) ^ 2 =
      Real.exp (Real.log C + 2 * Real.log (Real.log t)) := by
    rw [Real.exp_add, Real.exp_log hC, two_mul, Real.exp_add,
        Real.exp_log htpos, ← pow_two]
  rw [hCsq, Real.exp_lt_exp]; exact htin

/-! ## Route A combinator -/

/-- **riemannHypothesis_of_growth_and_repulsion (PROVED, 0 sorry).**
    GrowthBound + ZeroRepulsion -> _root_.RiemannHypothesis.

    _root_.RiemannHypothesis (Mathlib v4.12.0) is:
      forall (s : C) (_ : riemannZeta s = 0)
             (_ : not exists n : N, s = -2*(n+1)) (_ : s != 1), s.re = 1/2

    Assume s is a non-trivial, non-pole zero with s.re != 1/2.
    ZeroRepulsion gives large |zeta(1/2+it)| for arbitrarily large t.
    GrowthBound caps them.  Contradiction via exp_loglog_dominates_sq.

    SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}.
    Referee: #print axioms riemannHypothesis_of_growth_and_repulsion -/
theorem riemannHypothesis_of_growth_and_repulsion
    (hG : GrowthBound) (hR : ZeroRepulsion) : _root_.RiemannHypothesis := by
  intro s hs htriv hs1
  by_contra hre
  obtain ⟨c₁, hc₁, hbig⟩ := hR ⟨s, hs, htriv, hs1, hre⟩
  obtain ⟨C, hC, hub⟩ := hG
  obtain ⟨Ta, hTa⟩ := eventually_atTop.mp (exp_loglog_dominates_sq C c₁ hC hc₁)
  obtain ⟨t, hBt, hge⟩ := hbig (max 2 Ta)
  have h2 : (2 : ℝ) ≤ t := le_trans (le_max_left _ _) hBt
  have hTat : Ta ≤ t := le_trans (le_max_right _ _) hBt
  linarith [hge.trans (hub t h2), hTa t hTat]

end ArakelovRH.GrowthContradiction
