/-
  ArakelovRH/Scaffold/KimSarnakAuxiliary.lean
  Kim-Sarnak 2003 spectral parameter sub-surfaces.
  Author: David Fox.  Opera Numerorum.  May 2026.

  LambdaToNu_OPEN : ∀ N, lambda_1 N = 1/4 - spectral_parameter N²
                    (Selberg 1956 eigenvalue identity)
  NuBound_OPEN    : ∀ N squarefree, |spectral_parameter N| ≤ 7/64
                    (Kim-Sarnak 2003 App 2 Cor 2)

  Both spectral_parameter and lambda_1 are introduced as explicit variables.
  No opaque.  Every theorem that uses them carries them as formal parameters.

  PROVED (0 sorry, classical trio):
    ks_lambda_lb          : nu² ≤ (7/64)² → 975/4096 ≤ 1/4 - nu²
    kim_sarnak_discharge  : LambdaToNu + NuBound → KimSarnak_OPEN

  The proof of kim_sarnak_discharge is formally complete:
    (1) NuBound gives |nu_N| ≤ 7/64
    (2) sq_abs + pow_le_pow_left gives nu_N² ≤ (7/64)²
    (3) ks_lambda_lb gives 975/4096 ≤ 1/4 - nu_N²
    (4) LambdaToNu gives lambda_1 N = 1/4 - nu_N²
    (5) rw + transitivity: 975/4096 ≤ lambda_1 N

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}
  Referee: #print axioms ArakelovRH.KimSarnakAuxiliary.kim_sarnak_discharge
-/
import ArakelovRH.C14_SpectralGap
import Mathlib.Algebra.Squarefree.Basic

namespace ArakelovRH.KimSarnakAuxiliary

open ArakelovRH

/-- lambda_1 : ℕ → ℝ — first Laplace eigenvalue.  Explicit variable. -/
variable (lambda_1 : ℕ → ℝ)

/-- spectral_parameter : ℕ → ℝ — the Selberg spectral parameter ν(N).
    Defined by lambda_1(Y_0(N)) = 1/4 - ν(N)².
    Introduced as an explicit variable; no opaque, no axiom, no sorry. -/
variable (spectral_parameter : ℕ → ℝ)

/-! ## Named open surfaces -/

/-- **LambdaToNu_OPEN** — Selberg 1956 eigenvalue identity.
    lambda_1(Y_0(N)) = 1/4 - spectral_parameter(N)² for all N.
    Not in Mathlib v4.12.0.  STATUS: OPEN. -/
def LambdaToNu_OPEN : Prop :=
  ∀ N : ℕ, lambda_1 N = 1 / 4 - spectral_parameter N ^ 2

/-- **NuBound_OPEN** — Kim-Sarnak 2003, App 2, Cor 2.
    For squarefree N: |spectral_parameter N| ≤ 7/64.
    Requires Gelbart-Jacquet GL_2 → GL_3 + Kim-Shahidi.  ~40 pp.
    Not in Mathlib v4.12.0.  STATUS: OPEN. -/
def NuBound_OPEN : Prop :=
  ∀ N : ℕ, Squarefree N → |spectral_parameter N| ≤ 7 / 64

/-! ## Proved lemmas -/

/-- nu² ≤ (7/64)² implies 975/4096 ≤ 1/4 - nu².
    Proof:  (7/64)² = 49/4096  (norm_num)
            49/4096 ≤ (7/64)²  by hypothesis
            1/4 - (7/64)² = 975/4096  (norm_num)
            so 975/4096 = 1/4 - (7/64)² ≤ 1/4 - nu².  linarith. -/
private lemma ks_lambda_lb {nu : ℝ} (h : nu ^ 2 ≤ (7 / 64 : ℝ) ^ 2) :
    (975 : ℝ) / 4096 ≤ 1 / 4 - nu ^ 2 := by
  have h49 : (7 / 64 : ℝ) ^ 2 = 49 / 4096 := by norm_num
  linarith [h49 ▸ h]

/-- **kim_sarnak_discharge** (0 sorry, classical trio).
    LambdaToNu_OPEN + NuBound_OPEN → KimSarnak_OPEN.

    For squarefree N the five-step proof:
      (1) h_nu N hN      : |spectral_parameter N| ≤ 7/64
      (2) sq_abs         : |ν|² = ν²
          pow_le_pow_left: |ν|² ≤ (7/64)²
          rwa sq_abs      : ν² ≤ (7/64)²
      (3) ks_lambda_lb   : 975/4096 ≤ 1/4 - ν²
      (4) h_ltn N        : lambda_1 N = 1/4 - ν²
      (5) rw h_ltn N     : goal becomes 975/4096 ≤ 1/4 - ν²  ← step (3)

    SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}. -/
theorem kim_sarnak_discharge
    (h_ltn : LambdaToNu_OPEN lambda_1 spectral_parameter)
    (h_nu  : NuBound_OPEN spectral_parameter) :
    KimSarnak_OPEN lambda_1 := by
  intro N hN
  rw [h_ltn N]
  apply ks_lambda_lb
  have habs : |spectral_parameter N| ≤ 7 / 64 := h_nu N hN
  have h1 : |spectral_parameter N| ^ 2 ≤ (7 / 64 : ℝ) ^ 2 :=
    pow_le_pow_left (abs_nonneg _) habs 2
  rwa [sq_abs] at h1

end ArakelovRH.KimSarnakAuxiliary
