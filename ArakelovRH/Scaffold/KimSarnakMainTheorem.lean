/-
  ArakelovRH/Scaffold/KimSarnakMainTheorem.lean

  Explicit arithmetic of the Kim-Sarnak 7/64 spectral gap.
  Author: David Fox.  Opera Numerorum.  May 2026.

  The Hecke method: N = 143 = 11*13 (squarefree) forces |nu| <= 7/64
  by Kim-Sarnak 2003 (Gelbart-Jacquet GL_2->GL_3 + Kim-Shahidi).
  Each arithmetic step is a named theorem for auditability.

  PROVED (0 sorry, classical trio):
    kim_sarnak_arithmetic      : 1/4 - (7/64)^2 = 975/4096
    sq_le_of_abs_le            : |nu| <= 7/64 -> nu^2 <= (7/64)^2
    lambda_lb_of_nu_sq_ub      : nu^2 <= (7/64)^2 -> 975/4096 <= 1/4 - nu^2
    kim_sarnak_squarefree_scaffold : LambdaToNu + NuBound -> KimSarnak_OPEN
    kim_sarnak_143_scaffold    : specialisation to N = 143
    lambda_1_pos_143_scaffold  : 0 < lambda_1 143

  NAMED OPEN SURFACES (def Prop, not proved, not axiom):
    LambdaToNu_OPEN : lambda_1 N = 1/4 - nu(N)^2   (Selberg 1956)
    NuBound_OPEN    : |nu(N)| <= 7/64 for squarefree N  (Kim-Sarnak 2003)

  SORRY: 0.  No native_decide.  Classical trio.
  Referee: #print axioms ArakelovRH.KimSarnakMainTheorem.kim_sarnak_squarefree_scaffold
-/
import ArakelovRH.C14_SpectralGap
import Mathlib.Algebra.Squarefree.Basic

namespace ArakelovRH.KimSarnakMainTheorem

open ArakelovRH

/-- Opaque spectral parameter nu(N): lambda_1(Y_0(N)) = 1/4 - nu(N)^2.
    Selberg 1956.  Abstract function; implementation absent from Mathlib v4.12.0. -/
opaque spectral_parameter_mt : ℕ → ℝ

/-- **OPEN**: lambda_1(N) = 1/4 - nu(N)^2  (Selberg 1956). -/
def LambdaToNu_OPEN : Prop :=
  ∀ N : ℕ, lambda_1 N = 1 / 4 - spectral_parameter_mt N ^ 2

/-- **OPEN**: squarefree N implies |nu(N)| <= 7/64  (Kim-Sarnak 2003).
    Requires Gelbart-Jacquet lift + Kim-Shahidi non-vanishing. -/
def NuBound_OPEN : Prop :=
  ∀ N : ℕ, Squarefree N → |spectral_parameter_mt N| ≤ 7 / 64

/-! ## Named arithmetic steps -/

/-- 1/4 - (7/64)^2 = 975/4096.  Core of the Kim-Sarnak spectral gap. -/
theorem kim_sarnak_arithmetic : (1 : ℝ) / 4 - (7 / 64) ^ 2 = 975 / 4096 := by norm_num

/-- |nu| <= 7/64 implies nu^2 <= (7/64)^2. -/
theorem sq_le_of_abs_le {nu : ℝ} (h : |nu| ≤ 7 / 64) :
    nu ^ 2 ≤ (7 / 64 : ℝ) ^ 2 := by
  have h1 : |nu| ^ 2 ≤ (7 / 64 : ℝ) ^ 2 := pow_le_pow_left (abs_nonneg nu) h 2
  rwa [sq_abs] at h1

/-- nu^2 <= (7/64)^2 implies 975/4096 <= 1/4 - nu^2. -/
theorem lambda_lb_of_nu_sq_ub {nu : ℝ} (h : nu ^ 2 ≤ (7 / 64 : ℝ) ^ 2) :
    (975 : ℝ) / 4096 ≤ 1 / 4 - nu ^ 2 := by
  have h49 : (7 / 64 : ℝ) ^ 2 = 49 / 4096 := by norm_num
  linarith [h49 ▸ h]

/-! ## Main combinator -/

/-- **kim_sarnak_squarefree_scaffold** (0 sorry, classical trio):
    LambdaToNu_OPEN + NuBound_OPEN -> KimSarnak_OPEN.

    Proof chain:
      h_nu N hN       : |nu(N)| <= 7/64              (NuBound, open)
      sq_le_of_abs_le : nu(N)^2 <= (7/64)^2          (proved)
      lambda_lb_of_nu : 975/4096 <= 1/4 - nu^2       (proved)
      h_ltn N         : lambda_1 N = 1/4 - nu^2      (LambdaToNu, open)
      -> 975/4096 <= lambda_1 N                       QED -/
theorem kim_sarnak_squarefree_scaffold
    (h_ltn : LambdaToNu_OPEN)
    (h_nu  : NuBound_OPEN) :
    KimSarnak_OPEN := by
  intro N hN
  rw [h_ltn N]
  exact lambda_lb_of_nu_sq_ub (sq_le_of_abs_le (h_nu N hN))

/-- 143 is squarefree -> 975/4096 <= lambda_1 143.  Conditional. -/
theorem kim_sarnak_143_scaffold
    (h_ltn : LambdaToNu_OPEN)
    (h_nu  : NuBound_OPEN) :
    (975 : ℝ) / 4096 ≤ lambda_1 143 :=
  kim_sarnak_squarefree_scaffold h_ltn h_nu 143 sq_free_143

/-- 0 < lambda_1 143.  Follows since 975/4096 > 0. -/
theorem lambda_1_pos_143_scaffold
    (h_ltn : LambdaToNu_OPEN)
    (h_nu  : NuBound_OPEN) :
    0 < lambda_1 143 := by
  linarith [kim_sarnak_143_scaffold h_ltn h_nu,
            show (0 : ℝ) < 975 / 4096 by norm_num]

end ArakelovRH.KimSarnakMainTheorem
