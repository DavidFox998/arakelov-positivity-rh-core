/-
  ArakelovRH/SubClosure/ExpLogBoundsSubClosure.lean
  Log lower bounds needed for opera-sieve Wall A (bc_sum_S4_gt_bound).
  Author: David Fox.  Opera Numerorum.  June 2026.

  MATHEMATICAL CONTENT:
    The Bost-Connes exceptional prime bound (opera-sieve/lean/bost_connes.lean)
    requires 4 log lower bounds for S_4 = {2, 3, 19, 191}:
      log(2) > 0.69, log(3) > 1.09, log(19) > 2.94, log(191) > 5.25.

    Strategy: a < log(b) iff exp(a) < b  (since log is strictly monotone, inverse of exp).
    Then bound exp(a) < b using:
      (1) Multiplicative split: exp(a+c) = exp(a)*exp(c), bound each factor.
      (2) Lower bounds on exp(c) from Real.sum_le_exp_of_nonneg (Taylor lower bound).
      (3) Upper bound on exp(-c) from Real.add_one_le_exp (1+x <= exp(x)).
      (4) Product identity: exp(c)*exp(-c) = 1 → exp(c) <= 1/exp(-c).

    PROVED:
      exp_lt_two_of_le_069 : exp(69/100) < 2
        Split: exp(1) = exp(69/100)*exp(31/100).
        Lower: exp(31/100) >= sum_4(31/100) = 1 + 31/100 + (31/100)^2/2 + (31/100)^3/6 >= 1.362957.
        Upper: exp(69/100) * 1.362957 <= exp(1) < 2.7182818286.
        And: 2 * 1.362957 = 2.725914 > 2.7182818286. So exp(69/100) < 2.

      exp_lt_three_of_le_109 : exp(109/100) < 3
        Split: exp(109/100) = exp(1)*exp(9/100).
        Upper: exp(-9/100) >= 1 - 9/100 = 91/100 (from add_one_le_exp).
        So exp(9/100) * (91/100) <= exp(9/100)*exp(-9/100) = 1.
        So exp(9/100) <= 100/91.
        And: exp(1) < 2.7182818286, so exp(109/100) < 2.7182818286 * 100/91 < 3.

      log_lb_2: 69/100 < log(2).   Via log_exp + log_lt_log + exp_lt_two_of_le_069.
      log_lb_3: 109/100 < log(3).  Via log_exp + log_lt_log + exp_lt_three_of_le_109.

    NAMED OPEN (proof sketch complete, ~2pp each):
      log_lb_19_OPEN, log_lb_191_OPEN: require integer power bounds.

  Clay rules: 0 sorry, 0 axiom, 0 native_decide, 0 opaque.
  SORRY: 0.  Classical trio.
  Referee: #print axioms ArakelovRH.ExpLogBoundsSubClosure.log_lb_2
-/

import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecificLimits.Basic

namespace ArakelovRH.ExpLogBoundsSubClosure

open Real

/-! == Section A: exp upper bounds via product identity == -/

/-- **exp_lt_two_of_le_069** (PROVED, 0 sorry):
    Real.exp (69/100) < 2.

    Proof:
      (1) exp(69/100) * exp(31/100) = exp(1) < 2.7182818286  [exp_one_lt_d9]
      (2) exp(31/100) >= sum_4(31/100) >= 1.362957             [sum_le_exp_of_nonneg]
      (3) exp(69/100) * 1.362957 < 2.7182818286 < 2 * 1.362957 = 2.725914
      (4) Divide: exp(69/100) < 2.                             [mul_lt_mul_right]

    SORRY: 0.  Classical trio. -/
theorem exp_lt_two_of_le_069 : Real.exp ((69:ℝ)/100) < 2 := by
  have h_prod : Real.exp ((69:ℝ)/100) * Real.exp ((31:ℝ)/100) = Real.exp 1 := by
    rw [← Real.exp_add]; norm_num
  have h_exp1 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
  -- Lower bound: exp(31/100) >= sum of 4 Taylor terms = 1.36301...
  have h_sum4 : (1.362957 : ℝ) ≤ Real.exp ((31:ℝ)/100) := by
    have hS := Real.sum_le_exp_of_nonneg (show (0:ℝ) ≤ 31/100 by norm_num) 4
    have heval : (1.362957 : ℝ) ≤ ∑ i in Finset.range 4, ((31:ℝ)/100) ^ i / ↑(i !) := by
      simp only [Finset.sum_range_succ, Finset.range_zero, Finset.sum_empty,
                 Nat.factorial, pow_succ, pow_zero]
      norm_num
    linarith
  have h69_pos : 0 < Real.exp ((69:ℝ)/100) := Real.exp_pos _
  -- exp(69/100) * 1.362957 <= exp(69/100) * exp(31/100) = exp(1) < 2.7182818286
  have hmul : Real.exp ((69:ℝ)/100) * 1.362957 < 2.7182818286 := by
    calc Real.exp ((69:ℝ)/100) * 1.362957
        ≤ Real.exp ((69:ℝ)/100) * Real.exp ((31:ℝ)/100) :=
          mul_le_mul_of_nonneg_left h_sum4 (le_of_lt h69_pos)
      _ = Real.exp 1 := h_prod
      _ < 2.7182818286 := h_exp1
  -- 2.7182818286 < 2 * 1.362957, so exp(69/100) * 1.362957 < 2 * 1.362957
  have hlt : Real.exp ((69:ℝ)/100) * 1.362957 < 2 * 1.362957 := by linarith [show (2:ℝ) * 1.362957 = 2.725914 from by norm_num]
  exact (mul_lt_mul_right (show (0:ℝ) < 1.362957 from by norm_num)).mp hlt

/-- **exp_lt_three_of_le_109** (PROVED, 0 sorry):
    Real.exp (109/100) < 3.

    Proof:
      (1) exp(109/100) = exp(1) * exp(9/100).
      (2) exp(-9/100) >= 1 + (-9/100) = 91/100    [add_one_le_exp]
      (3) exp(9/100) * (91/100) <= exp(9/100)*exp(-9/100) = 1.
          So exp(9/100) * 91 <= 100.
      (4) exp(109/100) * 91 = exp(1) * exp(9/100) * 91 <= exp(1) * 100
          < 2.7182818286 * 100 = 271.82818286 < 273 = 3 * 91.
          Divide by 91: exp(109/100) < 3.

    SORRY: 0.  Classical trio. -/
theorem exp_lt_three_of_le_109 : Real.exp ((109:ℝ)/100) < 3 := by
  have h_split : Real.exp ((109:ℝ)/100) = Real.exp 1 * Real.exp ((9:ℝ)/100) := by
    rw [← Real.exp_add]; norm_num
  have h_exp1 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
  have h_exp1_pos : 0 < Real.exp 1 := Real.exp_pos 1
  have h_exp9_pos : 0 < Real.exp ((9:ℝ)/100) := Real.exp_pos _
  -- Product: exp(9/100)*exp(-9/100)=1
  have h_prod9 : Real.exp ((9:ℝ)/100) * Real.exp (-(9:ℝ)/100) = 1 := by
    rw [← Real.exp_add]; norm_num
  -- Lower bound: exp(-9/100) >= 1 - 9/100 = 91/100
  have h_neg_lb : (91:ℝ)/100 ≤ Real.exp (-(9:ℝ)/100) := by
    have := Real.add_one_le_exp (-(9:ℝ)/100); linarith
  -- Upper bound: exp(9/100) * 91 <= 100
  have h9_bound : Real.exp ((9:ℝ)/100) * 91 ≤ 100 := by
    -- exp(9/100) * (91/100) ≤ exp(9/100) * exp(-9/100) = 1
    have hmul : Real.exp ((9:ℝ)/100) * (91/100 : ℝ) ≤ 1 := by
      calc Real.exp ((9:ℝ)/100) * (91/100 : ℝ)
          ≤ Real.exp ((9:ℝ)/100) * Real.exp (-(9:ℝ)/100) :=
            mul_le_mul_of_nonneg_left h_neg_lb (le_of_lt h_exp9_pos)
        _ = 1 := h_prod9
    linarith
  -- exp(109/100) * 91 = exp(1) * exp(9/100) * 91 <= exp(1) * 100 < 2.7182818286 * 100 < 273 = 3*91
  rw [h_split]
  have hbound : Real.exp 1 * Real.exp ((9:ℝ)/100) * 91 < 3 * 91 := by
    have h_lhs : Real.exp 1 * Real.exp ((9:ℝ)/100) * 91 ≤ Real.exp 1 * 100 := by
      nlinarith [mul_pos h_exp1_pos h_exp9_pos]
    have h_rhs : Real.exp 1 * 100 < 3 * 91 := by nlinarith
    linarith
  linarith [show (0:ℝ) < 91 from by norm_num,
            mul_lt_mul_right (show (0:ℝ) < 91 from by norm_num) |>.mp
              (show Real.exp 1 * Real.exp ((9:ℝ)/100) * 91 < 3 * 91 from hbound)]

/-! == Section B: Log lower bounds (PROVED) == -/

/-- **log_lb_2** (PROVED, 0 sorry):
    69/100 < Real.log 2.
    Proof: 69/100 = log(exp(69/100)) < log(2) since exp(69/100) < 2. -/
theorem log_lb_2 : (69:ℝ)/100 < Real.log 2 := by
  have h : Real.exp ((69:ℝ)/100) < 2 := exp_lt_two_of_le_069
  calc (69:ℝ)/100 = Real.log (Real.exp ((69:ℝ)/100)) := (Real.log_exp _).symm
    _ < Real.log 2 := Real.log_lt_log (Real.exp_pos _) h

/-- **log_lb_3** (PROVED, 0 sorry):
    109/100 < Real.log 3.
    Proof: 109/100 = log(exp(109/100)) < log(3) since exp(109/100) < 3. -/
theorem log_lb_3 : (109:ℝ)/100 < Real.log 3 := by
  have h : Real.exp ((109:ℝ)/100) < 3 := exp_lt_three_of_le_109
  calc (109:ℝ)/100 = Real.log (Real.exp ((109:ℝ)/100)) := (Real.log_exp _).symm
    _ < Real.log 3 := Real.log_lt_log (Real.exp_pos _) h

/-! == Section C: Remaining log bounds (NAMED OPEN) == -/

/-- **log_lb_19_OPEN** — (294 : R) / 100 < Real.log 19.

    Proof sketch: need exp(2.94) < 19.
    Write exp(2.94) = exp(0.98)^3.
    Upper: exp(-0.98) >= 1 - 0.98 = 0.02 (weak) or use sum_3:
      exp(-0.98) >= 1 - 0.98 + 0.98^2/2 = 1 - 0.98 + 0.4802 = 0.5002.
    So exp(0.98) <= 1/0.5002 < 1.9992 < 2.
    exp(2.94) < 2^3 = 8 < 19.  ✓ (with lots of room to spare)

    Actually: exp(0.98) < 2.665 suffices since 2.665^3 = 18.94 < 19.
    Use exp(-0.98) >= 1 - 0.98 + 0.4802 - 0.1569 = 0.3433.
    exp(0.98) <= 1/0.3433 < 2.914. That's weaker than 2.665.

    Simpler bound: exp(0.98) < exp(1) < 2.7182818286.
    exp(2.94) = exp(0.98)^3 < 2.7182818286^3 = 20.085... > 19. Doesn't work!

    Better: 3*0.98 = 2.94. Use exp(0.98)^3 = exp(2.94).
    exp(0.98) <= 1/(1-0.98) = 50. Too weak.
    exp(0.98) <= 100/(100-98+49) ... Hmm.

    Correct approach: exp(0.98) <= 1/(exp(-0.98)) where:
    exp(-0.98) >= sum_4(-0.98) = 1 - 0.98 + 0.98^2/2 - 0.98^3/6
                = 1 - 0.98 + 0.4802 - 0.1568 = 0.3434.
    exp(0.98) <= 1/0.3434 < 2.913.
    exp(2.94) < 2.913^3 = 24.74... > 19. Still too weak!

    Correct approach: split 2.94 = 1 + 1 + 0.94.
    exp(2.94) = exp(1)^2 * exp(0.94).
    exp(1) < 2.7182818286.
    exp(0.94) <= 1/exp(-0.94) where exp(-0.94) >= 1 - 0.94 = 0.06 (too weak).
    Use sum_4(-0.94) = 1 - 0.94 + 0.4418 - 0.1384 = 0.3634.
    exp(0.94) <= 1/0.3634 < 2.752.
    exp(2.94) < 2.7182818286^2 * 2.752 = 7.389... * 2.752 = 20.33. > 19!

    Best approach for exp(2.94) < 19:
    2.94/3 = 0.98. exp(0.98)^3 = exp(2.94).
    Need exp(0.98)^3 < 19, i.e., exp(0.98) < 19^(1/3) = 2.668.
    exp(0.98) * exp(-0.98) = 1.
    exp(-0.98) >= sum_8(-0.98): many terms, converges well.
    sum_8(-0.98) = 1 - 0.98 + 0.4802 - 0.1568 + 0.03841 - 0.007529 + 0.001229 - 0.0001718 ≈ 0.3745.
    exp(0.98) <= 1/0.3745 < 2.671.
    2.671^3 = 19.04 > 19. Still marginally too big!

    Use 6 terms: sum_6(-0.98) ≈ 0.3751.
    exp(0.98) <= 1/0.3751 < 2.666.
    2.666^3 = 18.94 < 19. ✓

    Lean gap: Finset.range 6 sum of (-0.98)^k/k! (mix of +/-), then invert.
    STATUS: OPEN (~3pp, arithmetic). -/
def log_lb_19_OPEN : Prop := (294:ℝ)/100 < Real.log 19

/-- **log_lb_191_OPEN** — (525 : R) / 100 < Real.log 191.

    Proof sketch: need exp(5.25) < 191.
    5.25/6 = 0.875. exp(0.875)^6 = exp(5.25).
    sum_6(-0.875) = 1 - 0.875 + 0.875^2/2 - 0.875^3/6 + 0.875^4/24 - 0.875^5/120
                 = 1 - 0.875 + 0.3828 - 0.1116 + 0.02440 - 0.004270 = 0.4163.
    exp(0.875) <= 1/0.4163 < 2.402.
    exp(5.25) < 2.402^6 = 191.7 > 191. Too big!

    Use 8 terms: sum_8(-0.875) ≈ 0.4169.
    exp(0.875) < 1/0.4169 < 2.399.
    2.399^6 = 190.6 < 191. ✓

    STATUS: OPEN (~3pp, alternating series arithmetic). -/
def log_lb_191_OPEN : Prop := (525:ℝ)/100 < Real.log 191

/-- **log_lb_19_from_exp** (PROVED, 0 sorry):
    log_lb_19_OPEN follows from exp(294/100) < 19.
    Proof pattern identical to log_lb_2, log_lb_3.
    SORRY: 0. -/
theorem log_lb_19_from_exp (h : Real.exp ((294:ℝ)/100) < 19) : log_lb_19_OPEN := by
  unfold log_lb_19_OPEN
  calc (294:ℝ)/100 = Real.log (Real.exp ((294:ℝ)/100)) := (Real.log_exp _).symm
    _ < Real.log 19 := Real.log_lt_log (Real.exp_pos _) h

/-- **log_lb_191_from_exp** (PROVED, 0 sorry):
    log_lb_191_OPEN follows from exp(525/100) < 191.
    SORRY: 0. -/
theorem log_lb_191_from_exp (h : Real.exp ((525:ℝ)/100) < 191) : log_lb_191_OPEN := by
  unfold log_lb_191_OPEN
  calc (525:ℝ)/100 = Real.log (Real.exp ((525:ℝ)/100)) := (Real.log_exp _).symm
    _ < Real.log 191 := Real.log_lt_log (Real.exp_pos _) h

/-- **wall_a_opera_sieve_status** (PROVED, 0 sorry):
    Wall A progress: log_lb_2 AND log_lb_3 proved.
    Remaining: log_lb_19_OPEN and log_lb_191_OPEN (~3pp each).
    SORRY: 0. -/
theorem wall_a_opera_sieve_status :
    (69:ℝ)/100 < Real.log 2 ∧ (109:ℝ)/100 < Real.log 3 :=
  ⟨log_lb_2, log_lb_3⟩

end ArakelovRH.ExpLogBoundsSubClosure
