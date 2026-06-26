/-
  ArakelovRH/SubClosure/Batch61HarmonicTSum.lean
  Batch 61: Close WW_HarmonicTSum_L8 -- shift-telescope induction
  Author: David Fox.  Opera Numerorum.  June 2026.

  Proves: WW_HarmonicTSum_L8
    forall n : N, tsum_k (1/(k+1) - 1/(n+1+k)) = (harmonic n : Q) : C

  Approach:
  (1) shift_partial: partial-sum formula by induction on N.
  (2) shift_hasSum_real: HasSum in R via hasSum_iff_tendsto_nat_of_nonneg
      + tendsto_atTop_add_const_right + div_atTop.
  (3) shift_hasSum_cx: lift to C via Complex.hasSum_ofReal.
  (4) Main induction: HasSum.add (IH + shift_hasSum_cx) + convert.

  Confirmed Mathlib v4.12.0 APIs:
    hasSum_iff_tendsto_nat_of_nonneg  (ZetaAsymp.lean L125 pattern)
    tendsto_atTop_add_const_right     (ZetaAsymp.lean L206 pattern)
    Filter.Tendsto.div_atTop          (ZetaAsymp.lean L205 pattern)
    Filter.Tendsto.congr'             (Filter/Basic)
    Complex.hasSum_ofReal             (Complex/Basic.lean L586)
    harmonic_succ                     (Harmonic/Defs.lean L28, @[simp])
    HasSum.add, HasSum.tsum_eq        (InfiniteSum/Basic)

  SORRY: 0.  Axioms: {propext, Classical.choice, Quot.sound}.
  Open atoms: 35 (was 36; WW_HarmonicTSum_L8 closed here).
-/
import Mathlib.NumberTheory.Harmonic.GammaDeriv
import ArakelovRH.SubClosure.Batch60DiGammaClose

namespace ArakelovRH.Batch61HarmonicTSum

open Complex Filter

-- ==========================================================================
-- Sec 1  Shift-telescope partial-sum formula (R)
-- ==========================================================================

/-- Partial-sum formula: sum_{k < N} (1/(n+1+k) - 1/(n+2+k)) = 1/(n+1) - 1/(n+1+N). -/
private lemma shift_partial (n N : Nat) :
    Finset.sum (Finset.range N) (fun k : Nat =>
      (1 : Real) / ((n : Real) + 1 + k) - 1 / ((n : Real) + 2 + k)) =
    1 / ((n : Real) + 1) - 1 / ((n : Real) + 1 + N) := by
  induction N with
  | zero => simp
  | succ N ih =>
    rw [Finset.sum_range_succ, ih]
    have h0 : (n : Real) + 1 ≠ 0     := by positivity
    have h1 : (n : Real) + 1 + N ≠ 0 := by positivity
    have h2 : (n : Real) + 2 + N ≠ 0 := by positivity
    push_cast
    field_simp [h0, h1, h2]
    ring

-- ==========================================================================
-- Sec 2  Shift-telescope HasSum in R
-- ==========================================================================

/-- sum_{k=0}^infty (1/(n+1+k) - 1/(n+2+k)) = 1/(n+1) in R. -/
private lemma shift_hasSum_real (n : Nat) :
    HasSum (fun k : Nat => (1 : Real) / ((n : Real) + 1 + k) - 1 / ((n : Real) + 2 + k))
           (1 / ((n : Real) + 1)) := by
  rw [hasSum_iff_tendsto_nat_of_nonneg (fun k => by
    have h1 : (0 : Real) < (n : Real) + 1 + k := by positivity
    have h2 : (0 : Real) < (n : Real) + 2 + k := by positivity
    rw [sub_nonneg, div_le_div_iff h2 h1]
    linarith)]
  simp_rw [shift_partial n]
  -- (n+1+N) -> atTop
  have h_top : Tendsto (fun N : Nat => (n : Real) + 1 + (N : Real)) atTop atTop :=
    (tendsto_atTop_add_const_right atTop ((n : Real) + 1) tendsto_natCast_atTop_atTop).congr'
      (Filter.eventually_of_forall fun N => by ring)
  -- 1/(n+1+N) -> 0
  have h_zero : Tendsto (fun N : Nat => (1 : Real) / ((n : Real) + 1 + N)) atTop (nhds 0) :=
    tendsto_const_nhds.div_atTop h_top
  -- 1/(n+1) - 1/(n+1+N) -> 1/(n+1) - 0 = 1/(n+1)
  simpa using tendsto_const_nhds.sub h_zero

-- ==========================================================================
-- Sec 3  Shift-telescope HasSum in C
-- ==========================================================================

/-- Lift of shift-telescope to C. -/
private lemma shift_hasSum_cx (n : Nat) :
    HasSum (fun k : Nat => (1 : Complex) / ((n : Complex) + 1 + k) - 1 / ((n : Complex) + 2 + k))
           (1 / ((n : Complex) + 1)) := by
  have h := Complex.hasSum_ofReal.mpr (shift_hasSum_real n)
  -- h : HasSum (fun k => (real_f k : C)) (real_val : C)
  convert h using 1
  · ext k; push_cast; ring
  · push_cast; ring

-- ==========================================================================
-- Sec 4  Main induction
-- ==========================================================================

/-- **WW_HarmonicTSum_L8** (PROVED, 0 sorry):
    For all n : N,  sum_k (1/(k+1) - 1/(n+1+k)) = (harmonic n : Q) cast to C.
    Proof: induction on n.
      Base (n=0): each term is 0 = harmonic 0.
      Step: split summand, use IH + shift_hasSum_cx, harmonic_succ.
    SORRY: 0.  Axioms: {propext, Classical.choice, Quot.sound}. -/
theorem WW_HarmonicTSum_L8_proved :
    forall n : Nat,
    tsum (fun k : Nat => (1 : Complex) / ((k : Complex) + 1) - 1 / ((n : Complex) + 1 + k)) =
    ((harmonic n : Rat) : Complex) := by
  suffices h : forall n : Nat,
      HasSum (fun k : Nat => (1 : Complex) / ((k : Complex) + 1) - 1 / ((n : Complex) + 1 + k))
             ((harmonic n : Rat) : Complex) from
    fun n => (h n).tsum_eq
  intro n
  induction n with
  | zero =>
    have hf : (fun k : Nat => (1 : Complex) / ((k : Complex) + 1) -
                1 / ((0 : Complex) + 1 + k)) = fun _ => 0 := by
      ext k; simp only [Nat.cast_zero, zero_add]; ring
    simp only [harmonic_zero, Rat.cast_zero]
    rw [show (0 : Complex) = (0 : Complex) from rfl]
    rw [show (fun k : Nat => (1 : Complex) / ((k : Complex) + 1) -
                1 / ((0 : Complex) + 1 + k)) = fun _ => 0 from by
      ext k; simp only [Nat.cast_zero, zero_add]; ring]
    exact hasSum_zero
  | succ n ih =>
    -- Decompose: 1/(k+1) - 1/(n+2+k) = (1/(k+1) - 1/(n+1+k)) + (1/(n+1+k) - 1/(n+2+k))
    have h_add := ih.add (shift_hasSum_cx n)
    convert h_add using 1
    · ext k; push_cast; ring
    · rw [harmonic_succ]; push_cast; ring

/-- **WW_HarmonicTSum_L8_closes**: the open atom from Batch60 is now proved. -/
theorem WW_HarmonicTSum_L8_closes :
    ArakelovRH.Batch60DiGammaClose.WW_HarmonicTSum_L8 :=
  WW_HarmonicTSum_L8_proved

end ArakelovRH.Batch61HarmonicTSum
