/-
  ArakelovRH/Scaffold/GrowthContradiction.lean
  Route A: conditional reduction via growth bound + zero repulsion.

  NOTE: In Mathlib v4.12.0, _root_.RiemannHypothesis := True (a stub).
  This file uses RH_genuine -- the genuine mathematical predicate.
  Route A proves RH_genuine, NOT the Mathlib stub.

  This file does NOT prove the Riemann Hypothesis.
  It formalises an honest conditional reduction (David Fox):
    GrowthBound + ZeroRepulsion -> RH_genuine

  The only closed mathematical content is exp_loglog_dominates_sq:
    forall C c_1 > 0, exp(c_1*log t / log log t) eventually exceeds C*(log t)^2.
  Proved via Real.tendsto_exp_div_pow_atTop 2.  No RH content.

  GrowthBound is FALSE (Omega-results; Titchmarsh Sec 8).  Named so the gap
  is explicit and cannot be silently discharged.

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}
  Referee: #print axioms ArakelovRH.GrowthContradiction.riemannHypothesis_of_growth_and_repulsion
-/
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Exp

namespace ArakelovRH.GrowthContradiction

open Filter Real

/-! ## The genuine RH predicate -/

/-- **RH_genuine**: the genuine Riemann Hypothesis.
    All non-trivial zeros of riemannZeta lie on Re(s) = 1/2.
    In Mathlib v4.12.0, _root_.RiemannHypothesis := True (a stub).
    This def captures the actual mathematical content. -/
def RH_genuine : Prop :=
  ∀ s : ℂ, riemannZeta s = 0 → s ≠ 1 →
    (¬ ∃ n : ℕ, s = -(2 * ((n : ℂ) + 1))) →
    s.re = 1 / 2

/-! ## Named open surfaces -/

/-- **GrowthBound (OPEN -- in fact false).**
    Exists C > 0, forall t >= 2, |zeta(1/2+it)| <= C*(log t)^2.
    Stronger than Lindelof; FALSE by classical Omega-results.
    Named here so the gap is explicit.  STATUS: OPEN. -/
def GrowthBound : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ t : ℝ, 2 ≤ t →
    Complex.abs (riemannZeta (1/2 + (t : ℂ) * Complex.I)) ≤ C * (Real.log t)^2

/-- **ZeroRepulsion (OPEN), stated conditionally.**
    If an off-line zero rho exists (zeta(rho)=0, rho != 1,
    not a trivial zero, rho.re != 1/2), then |zeta(1/2+it)| is large
    for arbitrarily large t.  Not formalised in Mathlib v4.12.0.  STATUS: OPEN. -/
def ZeroRepulsion : Prop :=
  (∃ ρ : ℂ, riemannZeta ρ = 0 ∧ ρ ≠ 1 ∧
    (¬ ∃ n : ℕ, ρ = -(2 * ((n : ℂ) + 1))) ∧ ρ.re ≠ 1/2) →
  ∃ c₁ : ℝ, 0 < c₁ ∧ ∀ B : ℝ, ∃ t : ℝ, B ≤ t ∧
    Real.exp (c₁ * Real.log t / Real.log (Real.log t)) ≤
      Complex.abs (riemannZeta (1/2 + (t : ℂ) * Complex.I))

/-! ## Pure-calculus comparison (proved) -/

/-- **exp_loglog_dominates_sq (PROVED, 0 sorry).**
    For C, c_1 > 0: exp(c_1*log t / log log t) eventually exceeds C*(log t)^2.
    Substitution v = log log t: log t = exp v; claim is
      log C + 2*v < c_1*exp(v)/v  for large v  (since exp v / v -> inf).
    SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}. -/
theorem exp_loglog_dominates_sq (C c₁ : ℝ) (hC : 0 < C) (hc₁ : 0 < c₁) :
    ∀ᶠ t in atTop,
      C * (Real.log t)^2 < Real.exp (c₁ * Real.log t / Real.log (Real.log t)) := by
  have hexp2 : Tendsto (fun v : ℝ => Real.exp v / v ^ 2) atTop atTop :=
    Real.tendsto_exp_div_pow_atTop 2
  have hsub : Tendsto (fun v : ℝ => c₁ * (Real.exp v / v ^ 2) + (-2)) atTop atTop :=
    tendsto_atTop_add_const_right atTop (-2 : ℝ) (hexp2.const_mul_atTop hc₁)
  have hmul : Tendsto (fun v : ℝ => v * (c₁ * (Real.exp v / v ^ 2) + (-2))) atTop atTop :=
    tendsto_id.atTop_mul_atTop hsub
  have hcore : Tendsto (fun v : ℝ => c₁ * Real.exp v / v - 2 * v) atTop atTop := by
    refine hmul.congr' ?_
    filter_upwards [eventually_gt_atTop (0 : ℝ)] with v hv
    have hv' : v ≠ 0 := ne_of_gt hv
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

/-! ## Route A combinator (proved) -/

/-- **riemannHypothesis_of_growth_and_repulsion (PROVED, 0 sorry).**
    GrowthBound + ZeroRepulsion -> RH_genuine.

    Genuine Lean proof (classical trio, 0 sorry).  Mathematical content
    lives in the two OPEN hypotheses.  Only closed step: exp_loglog_dominates_sq.

    Assume s is an off-line zero.  ZeroRepulsion gives large |zeta(1/2+it)|
    for arbitrarily large t.  GrowthBound caps them.  Contradiction via
    exp_loglog_dominates_sq.

    SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}.
    Referee: #print axioms riemannHypothesis_of_growth_and_repulsion -/
theorem riemannHypothesis_of_growth_and_repulsion
    (hG : GrowthBound) (hR : ZeroRepulsion) : RH_genuine := by
  intro s hs hs1 htriv
  by_contra hre
  obtain ⟨c₁, hc₁, hbig⟩ := hR ⟨s, hs, hs1, htriv, hre⟩
  obtain ⟨C, hC, hub⟩ := hG
  obtain ⟨Ta, hTa⟩ := eventually_atTop.mp (exp_loglog_dominates_sq C c₁ hC hc₁)
  obtain ⟨t, hBt, hge⟩ := hbig (max 2 Ta)
  have h2 : (2 : ℝ) ≤ t := le_trans (le_max_left _ _) hBt
  have hTat : Ta ≤ t := le_trans (le_max_right _ _) hBt
  linarith [hge.trans (hub t h2), hTa t hTat]

end ArakelovRH.GrowthContradiction
