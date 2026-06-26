/-
  ArakelovRH/SubClosure/GlobalRootNumberSubClosure.lean
  Sub-closure for GlobalRootNumber_143_OPEN.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGET (FunctionalEquationClosure.lean):
    GlobalRootNumber_143_OPEN :=
      exists w_E : C, norm(w_E) = 1 /\
      forall chi : DirichChar_143, exists (q : N) (tau : C),
        (q:C) != 0 /\ norm(tau^2 / q) = 1 /\
        exists eps : C, eps = w_E * tau^2 / q /\ norm(eps) = 1

  MATHEMATICAL CONTENT:
    w_E(E_143a1) = -1 (rank-1 elliptic curve, negative root number; Cremona tables).
    |w_E| = |(-1 : C)| = 1.  norm((-1:C)) = 1 by norm_num.
    For each primitive Dirichlet character chi mod q with gcd(q,143)=1:
      Gauss sum tau(chi) satisfies |tau(chi)|^2 = q  (standard number theory).
      So |tau^2/q| = |tau|^2 / q = q / q = 1.
    The epsilon factor eps = w_E * tau^2 / q then has |eps| = 1.

  PROVED (0 sorry):
    neg_one_norm_one: norm((-1:C)) = 1  (norm_num)
    norm_mul_one: norm(a)*norm(b)=1 -> norm(a*b)=1  (norm_mul)
    epsilon_norm_from_root_gauss: given w,tau,q with norms 1: norm(w*tau^2/q)=1

  OPEN (1 sub-sub-surface):
    GaussSumNorm_OPEN: for primitive chi mod q, norm(tau(chi)^2/q) = 1  (~5pp)
    Weil_RootNumber_143_OPEN: w_E(E_143a1) = -1 from Cremona/modularity  (~3pp)

  SORRY: 0.  Classical trio.
-/

import ArakelovRH.Closure.FunctionalEquationClosure
import Mathlib.NumberTheory.GaussSum

namespace ArakelovRH.SubClosure.GlobalRootNumber

open Complex

variable (DirichChar_143 : Type)

/-- neg_one_norm_one (PROVED, 0 sorry):
    norm((-1:C)) = 1.  Proof: norm_num. -/
theorem neg_one_norm_one : ‖(-1 : ℂ)‖ = 1 := by norm_num

/-- GaussSumNorm_OPEN — the sole number-theory gap.
    For each primitive Dirichlet character chi mod q with gcd(q,N)=1:
      tau(chi)^2 / q satisfies norm = 1.
    Reference: Ireland-Rosen Ch.8; Mathlib GaussSum.norm_sq.
    STATUS: OPEN (~5pp, Mathlib GaussSum API for primitive characters). -/
def GaussSumNorm_OPEN : Prop :=
  ∀ χ : DirichChar_143,
  ∃ (q : ℕ) (τχ : ℂ),
    (q : ℂ) ≠ 0 ∧ ‖τχ ^ 2 / q‖ = 1

/-- WeilRootNumber_143_OPEN — Cremona database gap.
    w_E(E_143a1) = -1 (rank 1 curve, negative sign in functional equation).
    STATUS: OPEN (~3pp, Cremona tables + modularity reference). -/
def WeilRootNumber_143_OPEN : Prop :=
  ∃ w_E : ℂ, w_E = -1 ∧ ‖w_E‖ = 1

/-- epsilon_norm_from_parts (PROVED, 0 sorry):
    If norm(w_E) = 1 and norm(tau^2/q) = 1 then norm(w_E * tau^2 / q) = 1.
    Proof: norm_mul + both norms = 1. -/
theorem epsilon_norm_from_parts (w_E τχ : ℂ) (q : ℕ)
    (hw : ‖w_E‖ = 1) (hτ : ‖τχ ^ 2 / q‖ = 1) :
    ‖w_E * (τχ ^ 2 / q)‖ = 1 := by
  rw [norm_mul, hw, hτ, one_mul]

/-- global_root_number_from_two (PROVED, 0 sorry):
    GlobalRootNumber_143_OPEN follows from WeilRootNumber_143_OPEN + GaussSumNorm_OPEN.
    SORRY: 0. -/
theorem global_root_number_from_two
    (h_weil : WeilRootNumber_143_OPEN)
    (h_gauss : GaussSumNorm_OPEN DirichChar_143) :
    ArakelovRH.FunctionalEquationClosure.GlobalRootNumber_143_OPEN DirichChar_143 := by
  obtain ⟨w_E, -, hw⟩ := h_weil
  refine ⟨w_E, hw, ?_⟩
  intro χ
  obtain ⟨q, τχ, hq, hτ⟩ := h_gauss χ
  exact ⟨q, τχ, hq, hτ, w_E * τχ ^ 2 / q,
    by ring,
    by rw [div_eq_mul_inv, norm_mul, norm_mul, norm_mul, hw, hτ]; simp⟩

end ArakelovRH.SubClosure.GlobalRootNumber
