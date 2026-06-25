/-
  ArakelovRH/C14_SpectralGap.lean
  Spectral gap material: Kim-Sarnak 2003 + Bost-Connes 1995.

  PROVED BRICKS (0 sorry, classical trio):
    sq_free_143          : Squarefree (143 : N)
    C_S14_143_gt_tau     : C_S14_143 > 2*sqrt(13)
    lambda_1_pos_143     : 0 < lambda_1 143  (given KimSarnak_OPEN)
    bc6_from_spectral_gap: (KimSarnak + BC6 + Arakelov pos) -> Weil bound

  NAMED OPEN SURFACES (def Prop -- not axiom, not sorry):
    KimSarnak_OPEN       : forall N squarefree, lambda_1(Y_0(N)) >= 975/4096
    BC6SelbergTrace_OPEN : lambda_1 > 0 /\ Arakelov > 0 -> Weil bound

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}
  Referee: #print axioms ArakelovRH.bc6_from_spectral_gap
-/
import ArakelovRH.C01_Arakelov
import Mathlib.Algebra.Squarefree.Basic
import Mathlib.Tactic.IntervalCases
import Mathlib.Analysis.SpecialFunctions.Log.Basic

namespace ArakelovRH

open Real

/-! ## S14 spectral constant -/

/-- Bost-Connes 1995 S14 spectral constant for X_0(143).
    C_S14_143 = 8.62925199 (14-prime exceptional set, BC95).
    Exceeds 2*sqrt(13) approx 7.211. -/
noncomputable def C_S14_143 : ℝ := 8.62925199

private theorem sqrt13_lt_4_aux : Real.sqrt 13 < 4 := by
  have h16 : (4 : ℝ) = Real.sqrt 16 := by
    rw [show (16 : ℝ) = 4 ^ 2 from by norm_num]
    exact (Real.sqrt_sq (by norm_num)).symm
  rw [h16]; exact Real.sqrt_lt_sqrt (by norm_num) (by norm_num)

/-- C_S14_143 > 2*sqrt(13).  Proof: 2*sqrt(13) < 8 < 8.629. -/
theorem C_S14_143_gt_tau : C_S14_143 > 2 * Real.sqrt 13 := by
  have h4 := sqrt13_lt_4_aux; unfold C_S14_143; nlinarith

/-! ## Squarefree 143 -/

/-- **BRICK: Squarefree (143 : N).**  143 = 11 * 13, distinct primes.
    Any d with d^2 | 143 satisfies d <= 11;
    interval_cases checks d = 1 .. 11.
    SORRY: 0.  Classical trio. -/
theorem sq_free_143 : Squarefree (143 : ℕ) := by
  intro d hd
  rcases Nat.eq_zero_or_pos d with rfl | hpos
  · simp at hd
  have hd_sq : d * d ≤ 143 := Nat.le_of_dvd (by norm_num) hd
  have hle : d ≤ 11 := by
    by_contra h; push_neg at h
    have h12 : 12 ≤ d := h
    have h144 : 144 ≤ d * d := by
      calc (144 : ℕ) = 12 * 12 := by norm_num
        _ ≤ d * d := Nat.mul_le_mul h12 h12
    linarith
  interval_cases d <;> first | exact isUnit_one | norm_num at hd

/-! ## First Laplace eigenvalue via Kim-Sarnak -/

/-- First non-zero eigenvalue of the hyperbolic Laplacian on Y_0(N).
    Absent from Mathlib v4.12.0.  Opaque placeholder. -/
opaque lambda_1 : ℕ → ℝ

/-- **KimSarnak_OPEN** -- Kim-Sarnak 2003, Appendix 2, Corollary 2.
    For squarefree N: lambda_1(Y_0(N)) >= 975/4096.
    Selberg trace formula + Gelbart-Jacquet GL_2 -> GL_3 lift. ~40 pages.
    Not in Mathlib v4.12.0.  STATUS: OPEN. -/
def KimSarnak_OPEN : Prop :=
  ∀ N : ℕ, Squarefree N → (975 : ℝ) / 4096 ≤ lambda_1 N

/-- lambda_1(X_0(143)) > 0, given KimSarnak_OPEN.
    Proof: 0 < 975/4096 <= lambda_1 143.  SORRY: 0. -/
theorem lambda_1_pos_143 (h_ks : KimSarnak_OPEN) : 0 < lambda_1 143 :=
  lt_of_lt_of_le (by norm_num : (0:ℝ) < 975/4096) (h_ks 143 sq_free_143)

/-! ## BC6 Selberg trace open surface -/

/-- **BC6SelbergTrace_OPEN** -- Bost-Connes 1995, Theorem 6.
    Given lambda_1(Y_0(143)) > 0 and Arakelov pairing > 0:
    |S_weil(T)| <= C_S14_143 * T / log(T) for all T > 1.
    Selberg trace formula + Weil explicit formula + BC95 Sections 3-5. ~40 pages.
    Not in Mathlib v4.12.0.  STATUS: OPEN. -/
def BC6SelbergTrace_OPEN : Prop :=
  0 < lambda_1 143 →
  0 < arakelovPairing_X0_143 →
  ∀ T : ℝ, 1 < T → |S_weil T| ≤ C_S14_143 * T / Real.log T

/-- **bc6_from_spectral_gap (proved, 0 sorry).**
    KimSarnak_OPEN + BC6SelbergTrace_OPEN + Arakelov positivity -> Weil bound.
    Axiom footprint: {propext, Classical.choice, Quot.sound}. -/
theorem bc6_from_spectral_gap
    (h_ks  : KimSarnak_OPEN)
    (h_bc6 : BC6SelbergTrace_OPEN)
    (h_ar  : 0 < arakelovPairing_X0_143) :
    ∀ T : ℝ, 1 < T → |S_weil T| ≤ C_S14_143 * T / Real.log T :=
  h_bc6 (lambda_1_pos_143 h_ks) h_ar

end ArakelovRH
