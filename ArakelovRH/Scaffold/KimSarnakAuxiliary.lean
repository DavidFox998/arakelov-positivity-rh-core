/-
  ArakelovRH/Scaffold/KimSarnakAuxiliary.lean
  Kim-Sarnak 2003 spectral parameter sub-surfaces.

  Provides the two sub-surfaces that discharge KimSarnak_OPEN:
    LambdaToNu_OPEN : forall N, lambda_1 N = 1/4 - spectral_parameter N^2
    NuBound_OPEN    : forall N squarefree, |spectral_parameter N| <= 7/64

  These represent:
    - Selberg 1956: lambda_1 = 1/4 - nu^2
    - Kim-Sarnak 2003 App 2 Cor 2: nu <= 7/64 for squarefree levels

  Proved arithmetic: 1/4 - (7/64)^2 = 975/4096  (norm_num)
  closes the gap from LambdaToNu + NuBound to KimSarnak_OPEN.

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}
  Referee: #print axioms ArakelovRH.KimSarnakAuxiliary.kim_sarnak_discharge
-/
import ArakelovRH.C14_SpectralGap
import Mathlib.Algebra.Squarefree.Basic

namespace ArakelovRH.KimSarnakAuxiliary

open ArakelovRH

/-- Spectral parameter nu: lambda_1 = 1/4 - nu^2 (Selberg 1956).
    Absent from Mathlib v4.12.0.  Opaque placeholder. -/
opaque spectral_parameter : ℕ → ℝ

/-- **LambdaToNu_OPEN** -- Selberg 1956 eigenvalue identity.
    lambda_1(Y_0(N)) = 1/4 - spectral_parameter(N)^2.
    Not in Mathlib v4.12.0.  STATUS: OPEN. -/
def LambdaToNu_OPEN : Prop :=
  ∀ N : ℕ, lambda_1 N = 1 / 4 - spectral_parameter N ^ 2

/-- **NuBound_OPEN** -- Kim-Sarnak 2003, Appendix 2, Corollary 2.
    For squarefree N: |spectral_parameter N| <= 7/64.  ~40 pages.
    Not in Mathlib v4.12.0.  STATUS: OPEN. -/
def NuBound_OPEN : Prop :=
  ∀ N : ℕ, Squarefree N → |spectral_parameter N| ≤ 7 / 64

/-- nu^2 <= (7/64)^2 implies 975/4096 <= 1/4 - nu^2.
    Core: 1/4 - (7/64)^2 = 975/4096 by norm_num. -/
private lemma ks_lambda_lb {nu : ℝ} (h : nu ^ 2 ≤ (7 / 64 : ℝ) ^ 2) :
    (975 : ℝ) / 4096 ≤ 1 / 4 - nu ^ 2 := by
  have h49 : (7 / 64 : ℝ) ^ 2 = 49 / 4096 := by norm_num
  linarith [h49 ▸ h]

/-- **kim_sarnak_discharge (proved, 0 sorry).**
    LambdaToNu_OPEN + NuBound_OPEN -> KimSarnak_OPEN.
    For squarefree N:
      NuBound -> |nu_N| <= 7/64 -> nu_N^2 <= (7/64)^2
      ks_lambda_lb -> 975/4096 <= 1/4 - nu_N^2
      LambdaToNu -> 975/4096 <= lambda_1 N.
    SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}. -/
theorem kim_sarnak_discharge
    (h_ltn : LambdaToNu_OPEN)
    (h_nu  : NuBound_OPEN) :
    KimSarnak_OPEN := by
  intro N hN
  rw [h_ltn N]
  apply ks_lambda_lb
  have hnu := h_nu N hN
  have : spectral_parameter N ^ 2 ≤ (7 / 64 : ℝ) ^ 2 := by
    have h1 : |spectral_parameter N| ^ 2 ≤ (7 / 64 : ℝ) ^ 2 :=
      pow_le_pow_left (abs_nonneg _) hnu 2
    rwa [sq_abs] at h1
  exact this

end ArakelovRH.KimSarnakAuxiliary
