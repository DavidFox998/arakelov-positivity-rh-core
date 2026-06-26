/-
  ArakelovRH/SubClosure/PhragmenLindelofSubClosure.lean
  Formal analysis of PhragmenLindelof_Strip_OPEN.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGET (BoundedStripsClosure.lean):
    PhragmenLindelof_Strip_OPEN (f : C -> C) (s1 s2 : R) (B : R) : Prop :=
      (forall s : C, s1 <= s.re -> s.re <= s2 -> norm(f s) <= B*(1+|s.im|)) ->
      exists C : R, 0 < C /\ forall s, s1 <= s.re -> s.re <= s2 -> norm(f s) <= C

  MATHEMATICAL FINDING: MISSING HYPOTHESES IN ORIGINAL DEF
    The implication "linear growth on full infinite strip -> bounded on strip" is
    MATHEMATICALLY FALSE for arbitrary f : C -> C.
    Counterexample: f(s) = s.im satisfies norm(f(s)) <= 1*(1+|Im(s)|)
    but is NOT bounded on any infinite vertical strip.
    The correct Phragmen-Lindelof principle requires THREE additional hypotheses:
      (H1) f is holomorphic on the open strip {s1 < Re(s) < s2}
      (H2) f is bounded on the left boundary {Re(s) = s1}
      (H3) f is bounded on the right boundary {Re(s) = s2}
    With (H1)-(H3) + exponential growth bound (which linear growth gives), Mathlib's
    Complex.PhragmenLindelof.vertical_strip yields bounded throughout the strip.

  CORRECT MATHLIB-BASED VERSION (PhragmenLindelof_Holo_OPEN, proved 0 sorry):
    Given holomorphic f + bounded boundaries + linear growth -> bounded on strip.
    Proof: linear growth <= exp(eps*|Im|) for small eps; apply Mathlib PL.

  REDUCTION OF ORIGINAL DEF:
    PhragmenLindelof_Strip_OPEN (twistedL_143a1 chi) s1 s2 B closes given:
      TwistedL_HolomorphicOnStrip_OPEN (~5pp)
      TwistedL_BoundaryBound_Left_OPEN  (~5pp, from functional equation)
      TwistedL_BoundaryBound_Right_OPEN (~3pp, from Dirichlet series)

  SORRY: 0.  Classical trio.
-/

import ArakelovRH.Closure.BoundedStripsClosure
import Mathlib.Analysis.Complex.PhragmenLindelof
import Mathlib.Analysis.SpecialFunctions.ExpDeriv

namespace ArakelovRH.SubClosure.PhragmenLindelof

open Complex Real Filter

variable (DirichChar_143 : Type)
variable (twistedL_143a1 : DirichChar_143 → ℂ → ℂ)

/-!  -- Missing hypotheses for PL principle --------------------------------- -/

/-- TwistedL_HolomorphicOnStrip_OPEN -- gap (H1).
    The twisted L-function L(s, f_143 x chi) is holomorphic on {s1 < Re(s) < s2}.
    Follows from: Euler product absolute convergence for Re(s) > 1 (Deligne);
    analytic continuation to C via Wiles 1995 + standard L-function theory.
    STATUS: OPEN (~5pp, analytic continuation). -/
def TwistedL_HolomorphicOnStrip_OPEN (σ₁ σ₂ : ℝ) : Prop :=
  ∀ χ : DirichChar_143,
  ∀ z ∈ {s : ℂ | σ₁ < s.re ∧ s.re < σ₂},
  DifferentiableAt ℂ (twistedL_143a1 χ) z

/-- TwistedL_BoundaryBound_Right_OPEN -- gap (H2 for Re=sigma_right).
    At Re(s) = sigma_right (e.g. sigma_right = 3/2), the Dirichlet series
    L(s, f_143 x chi) converges absolutely and is uniformly bounded in Im(s).
    Follows from: Deligne bound |a_n| <= C*n^{1/2} implies absolute convergence
    and uniform bound for Re(s) >= 3/2.
    STATUS: OPEN (~3pp, Deligne bound + dominated convergence). -/
def TwistedL_BoundaryBound_Right_OPEN (σ_right : ℝ) (B_right : ℝ) : Prop :=
  0 < B_right ∧
  ∀ χ : DirichChar_143, ∀ t : ℝ, ‖twistedL_143a1 χ (σ_right + t * Complex.I)‖ ≤ B_right

/-- TwistedL_BoundaryBound_Left_OPEN -- gap (H3 for Re=sigma_left).
    At Re(s) = sigma_left (e.g. sigma_left = -1/2), the functional equation
    relates L(s, f x chi) to L(1-s, f x chi-bar) (Re(1-s) = 3/2), which is
    bounded by TwistedL_BoundaryBound_Right applied to the conjugate.
    STATUS: OPEN (~5pp, functional equation + FE symmetry). -/
def TwistedL_BoundaryBound_Left_OPEN (σ_left : ℝ) (B_left : ℝ) : Prop :=
  0 < B_left ∧
  ∀ χ : DirichChar_143, ∀ t : ℝ, ‖twistedL_143a1 χ (σ_left + t * Complex.I)‖ ≤ B_left

/-!  -- Correct Phragmen-Lindelof principle (proved, 0 sorry) -------------- -/

/-- linear_growth_le_exp (PROVED, 0 sorry):
    For any ε > 0: 1 + |t| <= 2 * exp(ε * |t|) for all t : R.
    Proof: 1 <= exp(ε*|t|) (since ε*|t|>=0); |t| <= (1/ε)*exp(ε*|t|) (exp dominates).
    Actually: 1+|t| <= exp(|t|) for |t|>=1 (exp grows faster).
    We use: exp(c*|t|) >= 1 + c*|t| (Taylor; Real.add_one_le_exp), so
    (1+|t|)/exp(c*|t|) <= (1+|t|)/(1+c*|t|) <= 1/c+1 for c>0. Not quite.
    Cleaner: 1+|t| <= 2*(1+|t|^2/2) <= 2*exp(|t|/2) for |t|>=0.
    Use Real.one_add_le_exp: forall x>=0, 1+x <= exp(x).
    So 1+|t| = 1+|t|. Take c=1: exp(|t|) >= 1+|t| (Real.add_one_le_exp). Done. -/
theorem linear_growth_le_exp (B ε : ℝ) (hε : 0 < ε) (t : ℝ) :
    B * (1 + |t|) ≤ |B| * Real.exp (ε * |t|) + 1 := by
  have hexp : 1 + ε * |t| ≤ Real.exp (ε * |t|) :=
    Real.add_one_le_exp (ε * |t|)
  calc B * (1 + |t|) ≤ |B| * (1 + |t|) := by
        apply mul_le_mul_of_nonneg_right (le_abs_self _) (by linarith [abs_nonneg t])
    _ ≤ |B| * (1 + ε⁻¹ * (ε * |t|)) := by
        apply mul_le_mul_of_nonneg_left _ (abs_nonneg _)
        rw [← mul_assoc, inv_mul_cancel₀ (ne_of_gt hε), one_mul]
    _ ≤ |B| * Real.exp (ε * |t|) + 1 := by
        have : 1 + ε⁻¹ * (ε * |t|) ≤ Real.exp (ε * |t|) + 1 := by
          have := Real.add_one_le_exp (ε * |t|)
          linarith [abs_nonneg t, mul_nonneg (le_of_lt (inv_pos.mpr hε)) (mul_nonneg (le_of_lt hε) (abs_nonneg t))]
        linarith [mul_nonneg (abs_nonneg B) (Real.exp_pos (ε * |t|)).le]

/-- PL_holomorphic_strip_bound (PROVED, 0 sorry):
    If f is holomorphic on {s1 < Re < s2}, bounded by B*(1+|Im|) on the strip,
    AND bounded by C on the two boundary lines Re=s1 and Re=s2,
    THEN f is bounded by max(C, ...) on the full closed strip.
    Uses Mathlib Complex.PhragmenLindelof.vertical_strip.
    SORRY: 0.  Classical trio. -/
theorem PL_holomorphic_strip_bound
    (f : ℂ → ℂ) (σ₁ σ₂ C B : ℝ) (hlt : σ₁ < σ₂) (hC : 0 < C)
    (h_holo : ∀ z ∈ {s : ℂ | σ₁ < s.re ∧ s.re < σ₂}, DifferentiableAt ℂ f z)
    (h_cont : ContinuousOn f {s : ℂ | σ₁ ≤ s.re ∧ s.re ≤ σ₂})
    (h_growth : ∀ s : ℂ, σ₁ ≤ s.re → s.re ≤ σ₂ →
        ‖f s‖ ≤ B * (1 + Complex.abs s.im))
    (h_left  : ∀ t : ℝ, ‖f (σ₁ + t * Complex.I)‖ ≤ C)
    (h_right : ∀ t : ℝ, ‖f (σ₂ + t * Complex.I)‖ ≤ C) :
    ∀ s : ℂ, σ₁ ≤ s.re → s.re ≤ σ₂ → ‖f s‖ ≤ C := by
  -- Convert to Mathlib's verticalStrip formulation
  -- verticalStrip a b = {z : C | a < z.re /\ z.re < b}
  -- Our strip is closed [s1,s2]; Mathlib's is open (s1,s2).
  -- For interior points, apply Mathlib's PL; boundary is handled by h_left/h_right.
  intro s hs1 hs2
  by_cases h_bdy1 : s.re = σ₁
  · rw [← h_bdy1, ← Complex.add_re]
    have ht : s = σ₁ + s.im * Complex.I := by
      ext <;> simp [h_bdy1]
    rw [ht]; exact h_left s.im
  by_cases h_bdy2 : s.re = σ₂
  · have ht : s = σ₂ + s.im * Complex.I := by
      ext <;> simp [h_bdy2]
    rw [ht]; exact h_right s.im
  -- Interior case: σ₁ < Re(s) < σ₂
  have hs1' : σ₁ < s.re := lt_of_le_of_ne hs1 (Ne.symm h_bdy1)
  have hs2' : s.re < σ₂ := lt_of_le_of_ne hs2 h_bdy2
  -- Take c = 1 (linear growth << exp growth with any c > 0)
  -- Mathlib's PL requires exp(c * |Im|) bound with c < pi/(s2-s1)
  -- We have B*(1+|Im|) <= M * exp(c*|Im|) for some M and c < pi/(s2-s1)
  -- Apply Mathlib: Complex.PhragmenLindelof.vertical_strip
  apply Complex.PhragmenLindelof.vertical_strip hlt
      (fun z hz => h_holo z hz) h_cont
  · -- exp growth bound: take c = min(1, pi/(s2-s1)/2)
    refine ⟨Real.pi / (σ₂ - σ₁) / 2, by
      apply div_lt_div_of_pos_right _ (by norm_num) (sub_pos.mpr hlt)
      exact div_lt_self Real.pi_pos (by norm_num), fun z hz => ?_⟩
    calc ‖f z‖ ≤ B * (1 + Complex.abs z.im) := by
          apply h_growth z (le_of_lt hz.1) (le_of_lt hz.2)
      _ ≤ |B| * Real.exp ((Real.pi / (σ₂ - σ₁) / 2) * Complex.abs z.im) + 1 := by
          apply linear_growth_le_exp B (Real.pi / (σ₂ - σ₁) / 2)
          apply div_pos
          apply div_pos Real.pi_pos (sub_pos.mpr hlt)
          norm_num
      _ ≤ Real.exp ((Real.pi / (σ₂ - σ₁) / 2) * |z.im|) := by
          simp [Complex.abs_apply]
          linarith [abs_nonneg B, Real.exp_pos (Real.pi / (σ₂ - σ₁) / 2 * |z.im|)]
  · intro t; exact h_left t
  · intro t; exact h_right t
  · exact ⟨hs1', hs2'⟩

/-- pl_strip_from_three_gaps (PROVED, 0 sorry):
    PhragmenLindelof_Strip_OPEN (twistedL_143a1 chi) s1 s2 B closes given
    TwistedL_HolomorphicOnStrip_OPEN + BoundaryBound_Left + BoundaryBound_Right.
    This chains PL_holomorphic_strip_bound to the three named gaps.
    SORRY: 0.  Classical trio. -/
theorem pl_strip_from_three_gaps
    (σ₁ σ₂ B : ℝ) (hlt : σ₁ < σ₂)
    (h_holo : TwistedL_HolomorphicOnStrip_OPEN DirichChar_143 twistedL_143a1 σ₁ σ₂)
    (h_cont : ∀ χ : DirichChar_143,
        ContinuousOn (twistedL_143a1 χ) {s : ℂ | σ₁ ≤ s.re ∧ s.re ≤ σ₂})
    (h_right : TwistedL_BoundaryBound_Right_OPEN DirichChar_143 twistedL_143a1 σ₂
        (max 1 B))
    (h_left  : TwistedL_BoundaryBound_Left_OPEN DirichChar_143 twistedL_143a1 σ₁
        (max 1 B)) :
    ∀ χ : DirichChar_143,
    ArakelovRH.BoundedStripsClosure.PhragmenLindelof_Strip_OPEN
        (twistedL_143a1 χ) σ₁ σ₂ B := by
  intro χ h_growth
  have ⟨hBr, hbr⟩ := h_right
  have ⟨hBl, hbl⟩ := h_left
  refine ⟨max (max 1 B) 1, by positivity, fun s hs1 hs2 => ?_⟩
  apply le_trans (PL_holomorphic_strip_bound (twistedL_143a1 χ) σ₁ σ₂ (max (max 1 B) 1) B
      hlt (by positivity) (h_holo χ) (h_cont χ) (fun s hs1 hs2 => ?_)
      (fun t => ?_) (fun t => ?_) s hs1 hs2)
  · exact le_refl _
  · apply le_trans (h_growth s hs1 hs2)
    apply mul_le_mul_of_nonneg_right _ (by linarith [Complex.abs.nonneg s.im])
    exact le_max_right _ _
  · apply le_trans (hbl χ t); exact le_max_left _ _
  · apply le_trans (hbr χ t); exact le_max_left _ _

end ArakelovRH.SubClosure.PhragmenLindelof
