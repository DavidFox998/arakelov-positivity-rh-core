/-
  ArakelovRH/SubClosure/ExpLogBoundsSubClosure.lean
  Log lower bounds for opera-sieve Wall A (bc_sum_S4_gt_bound): S_4 = {2,3,19,191}.
  Author: David Fox.  Opera Numerorum.  June 2026.

  MATHEMATICAL CONTENT:
    The Bost-Connes exceptional prime bound needs 4 log lower bounds:
      log(2) > 0.69, log(3) > 1.09, log(19) > 2.94, log(191) > 5.25.

    Strategy: a < log(b) iff exp(a) < b (log is strictly increasing).
    Then exp(a) < b via:
      (1) Product split: exp(a)*exp(c)=exp(a+c); choose a+c=1, use exp_one_lt_d9.
      (2) Lower bound on exp(c): Real.sum_le_exp_of_nonneg (c >= 0).
      (3) exp(a) < b via mul_lt_mul_right (divide both sides by exp(c) lb).
      (4) For powers: pow_lt_pow_left + norm_num.

  PROVED (all 0 sorry, classical trio):
    exp_lt_two_of_le_069:   exp(69/100)  < 2    Wall A: log 2
    exp_lt_three_of_le_109: exp(109/100) < 3    Wall A: log 3
    exp_lt_19_of_cube:      exp(294/100) < 19   Wall A: log 19
    exp_lt_191_of_sixth:    exp(525/100) < 191  Wall A: log 191
    log_lb_2:   69/100  < log 2    PROVED, opera-sieve gate_bc6 input 1/4
    log_lb_3:   109/100 < log 3    PROVED, opera-sieve gate_bc6 input 2/4
    log_lb_19:  294/100 < log 19   PROVED, opera-sieve gate_bc6 input 3/4
    log_lb_191: 525/100 < log 191  PROVED, opera-sieve gate_bc6 input 4/4
    wall_a_complete: all four bounds -- gate_bc6 fully dischargeable.

  WALL A STATUS: COMPLETE.  All 4 log lower bounds proved, 0 sorry.
  Clay rules: 0 sorry, 0 axiom keyword, 0 native_decide, 0 opaque.
  Axiom footprint: {propext, Classical.choice, Quot.sound}.
  Referee: #print axioms ArakelovRH.ExpLogBoundsSubClosure.wall_a_complete
-/

import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecificLimits.Basic

namespace ArakelovRH.ExpLogBoundsSubClosure

open Real

theorem exp_lt_two_of_le_069 : Real.exp ((69:ℝ)/100) < 2 := by
  have h_prod : Real.exp ((69:ℝ)/100) * Real.exp ((31:ℝ)/100) = Real.exp 1 := by
    rw [← Real.exp_add]; norm_num
  have h_exp1 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
  have h_sum4 : (1.362957 : ℝ) ≤ Real.exp ((31:ℝ)/100) := by
    have hS := Real.sum_le_exp_of_nonneg (show (0:ℝ) ≤ 31/100 by norm_num) 4
    have heval : (1.362957 : ℝ) <=
        ∑ i in Finset.range 4, ((31:ℝ)/100) ^ i / ↑(i !) := by
      simp only [Finset.sum_range_succ, Finset.range_zero, Finset.sum_empty,
                 Nat.factorial, pow_succ, pow_zero]; norm_num
    linarith
  have h69_pos : 0 < Real.exp ((69:ℝ)/100) := Real.exp_pos _
  have hmul : Real.exp ((69:ℝ)/100) * 1.362957 < 2.7182818286 :=
    calc Real.exp ((69:ℝ)/100) * 1.362957
        ≤ Real.exp ((69:ℝ)/100) * Real.exp ((31:ℝ)/100) :=
          mul_le_mul_of_nonneg_left h_sum4 (le_of_lt h69_pos)
      _ = Real.exp 1 := h_prod
      _ < 2.7182818286 := h_exp1
  have hlt : Real.exp ((69:ℝ)/100) * 1.362957 < 2 * 1.362957 := by
    linarith [show (2:ℝ) * 1.362957 = 2.725914 from by norm_num]
  exact (mul_lt_mul_right (show (0:ℝ) < 1.362957 from by norm_num)).mp hlt

theorem exp_lt_three_of_le_109 : Real.exp ((109:ℝ)/100) < 3 := by
  have h_split : Real.exp ((109:ℝ)/100) = Real.exp 1 * Real.exp ((9:ℝ)/100) := by
    rw [← Real.exp_add]; norm_num
  have h_exp1 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
  have h_exp1_pos : 0 < Real.exp 1 := Real.exp_pos 1
  have h_exp9_pos : 0 < Real.exp ((9:ℝ)/100) := Real.exp_pos _
  have h_prod9 : Real.exp ((9:ℝ)/100) * Real.exp (-(9:ℝ)/100) = 1 := by
    rw [← Real.exp_add]; norm_num
  have h_neg_lb : (91:ℝ)/100 ≤ Real.exp (-(9:ℝ)/100) := by
    have := Real.add_one_le_exp (-(9:ℝ)/100); linarith
  have h9_bound : Real.exp ((9:ℝ)/100) * 91 ≤ 100 := by
    have hmul : Real.exp ((9:ℝ)/100) * (91/100 : ℝ) ≤ 1 :=
      calc Real.exp ((9:ℝ)/100) * (91/100 : ℝ)
          ≤ Real.exp ((9:ℝ)/100) * Real.exp (-(9:ℝ)/100) :=
            mul_le_mul_of_nonneg_left h_neg_lb (le_of_lt h_exp9_pos)
        _ = 1 := h_prod9
    linarith
  rw [h_split]
  have hbound : Real.exp 1 * Real.exp ((9:ℝ)/100) * 91 < 3 * 91 := by
    have h_lhs : Real.exp 1 * Real.exp ((9:ℝ)/100) * 91 ≤ Real.exp 1 * 100 := by
      nlinarith [mul_pos h_exp1_pos h_exp9_pos]
    nlinarith
  linarith [show (0:ℝ) < 91 from by norm_num,
            (mul_lt_mul_right (show (0:ℝ) < 91 from by norm_num)).mp hbound]

/-- exp(2.94) < 19.
    Split at 0.98+0.02=1. Lower: sum_4(0.02)=765151/750000. Upper: exp(0.98)<2665/1000.
    Cube: (2665/1000)^3 = 18.926... < 19. -/
theorem exp_lt_19_of_cube : Real.exp ((294:ℝ)/100) < 19 := by
  have h_sum4 : (765151:ℝ)/750000 ≤ Real.exp ((2:ℝ)/100) := by
    have hS := Real.sum_le_exp_of_nonneg (show (0:ℝ) ≤ 2/100 by norm_num) 4
    have heval : (765151:ℝ)/750000 <=
        ∑ i in Finset.range 4, ((2:ℝ)/100) ^ i / ↑(i !) := by
      simp only [Finset.sum_range_succ, Finset.range_zero, Finset.sum_empty,
                 Nat.factorial, pow_succ, pow_zero]; norm_num
    linarith
  have h_prod : Real.exp ((98:ℝ)/100) * Real.exp ((2:ℝ)/100) = Real.exp 1 := by
    rw [← Real.exp_add]; norm_num
  have h_exp1 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
  have h98_pos : 0 < Real.exp ((98:ℝ)/100) := Real.exp_pos _
  have hmul : Real.exp ((98:ℝ)/100) * (765151/750000) < 2.7182818286 :=
    calc Real.exp ((98:ℝ)/100) * (765151/750000)
        ≤ Real.exp ((98:ℝ)/100) * Real.exp ((2:ℝ)/100) :=
          mul_le_mul_of_nonneg_left h_sum4 (le_of_lt h98_pos)
      _ = Real.exp 1 := h_prod
      _ < 2.7182818286 := h_exp1
  have h98_ub : Real.exp ((98:ℝ)/100) < 2665/1000 := by
    have hlt : Real.exp ((98:ℝ)/100) * (765151/750000) < (2665/1000) * (765151/750000) := by
      linarith [show (2665:ℝ)/1000 * (765151/750000) > 2.7182818286 from by norm_num]
    exact (mul_lt_mul_right (show (0:ℝ) < 765151/750000 from by norm_num)).mp hlt
  have h_cube_eq : Real.exp ((294:ℝ)/100) = Real.exp ((98:ℝ)/100) ^ 3 := by
    have heq : (294:ℝ)/100 = (98:ℝ)/100 + ((98:ℝ)/100 + (98:ℝ)/100) := by norm_num
    rw [heq, Real.exp_add, Real.exp_add]; ring
  rw [h_cube_eq]
  have h_pow : Real.exp ((98:ℝ)/100) ^ 3 < (2665/1000 : ℝ) ^ 3 :=
    pow_lt_pow_left h98_ub (le_of_lt h98_pos) (by norm_num)
  linarith [show (2665:ℝ)/1000 ^ 3 < 19 from by norm_num]

/-- exp(5.25) < 191.
    Split at 7/8+1/8=1. Lower: sum_5(1/8)=111393/98304. Upper: exp(7/8)<2399/1000.
    Sixth: (2399/1000)^6 = 190.6... < 191. -/
theorem exp_lt_191_of_sixth : Real.exp ((525:ℝ)/100) < 191 := by
  have h_sum5 : (111393:ℝ)/98304 ≤ Real.exp ((1:ℝ)/8) := by
    have hS := Real.sum_le_exp_of_nonneg (show (0:ℝ) ≤ 1/8 by norm_num) 5
    have heval : (111393:ℝ)/98304 <=
        ∑ i in Finset.range 5, ((1:ℝ)/8) ^ i / ↑(i !) := by
      simp only [Finset.sum_range_succ, Finset.range_zero, Finset.sum_empty,
                 Nat.factorial, pow_succ, pow_zero]; norm_num
    linarith
  have h_prod : Real.exp ((7:ℝ)/8) * Real.exp ((1:ℝ)/8) = Real.exp 1 := by
    rw [← Real.exp_add]; norm_num
  have h_exp1 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
  have h78_pos : 0 < Real.exp ((7:ℝ)/8) := Real.exp_pos _
  have hmul : Real.exp ((7:ℝ)/8) * (111393/98304) < 2.7182818286 :=
    calc Real.exp ((7:ℝ)/8) * (111393/98304)
        ≤ Real.exp ((7:ℝ)/8) * Real.exp ((1:ℝ)/8) :=
          mul_le_mul_of_nonneg_left h_sum5 (le_of_lt h78_pos)
      _ = Real.exp 1 := h_prod
      _ < 2.7182818286 := h_exp1
  have h78_ub : Real.exp ((7:ℝ)/8) < 2399/1000 := by
    have hlt : Real.exp ((7:ℝ)/8) * (111393/98304) < (2399/1000) * (111393/98304) := by
      linarith [show (2399:ℝ)/1000 * (111393/98304) > 2.7182818286 from by norm_num]
    exact (mul_lt_mul_right (show (0:ℝ) < 111393/98304 from by norm_num)).mp hlt
  have h_sixth_eq : Real.exp ((525:ℝ)/100) = Real.exp ((7:ℝ)/8) ^ 6 := by
    have heq : (525:ℝ)/100 = (7:ℝ)/8 + ((7:ℝ)/8 + ((7:ℝ)/8 + ((7:ℝ)/8 + ((7:ℝ)/8 + (7:ℝ)/8)))) := by
      norm_num
    rw [heq, Real.exp_add, Real.exp_add, Real.exp_add, Real.exp_add, Real.exp_add]; ring
  rw [h_sixth_eq]
  have h_pow : Real.exp ((7:ℝ)/8) ^ 6 < (2399/1000 : ℝ) ^ 6 :=
    pow_lt_pow_left h78_ub (le_of_lt h78_pos) (by norm_num)
  linarith [show (2399:ℝ)/1000 ^ 6 < 191 from by norm_num]

theorem log_lb_2 : (69:ℝ)/100 < Real.log 2 :=
  calc (69:ℝ)/100 = Real.log (Real.exp ((69:ℝ)/100)) := (Real.log_exp _).symm
    _ < Real.log 2 := Real.log_lt_log (Real.exp_pos _) exp_lt_two_of_le_069

theorem log_lb_3 : (109:ℝ)/100 < Real.log 3 :=
  calc (109:ℝ)/100 = Real.log (Real.exp ((109:ℝ)/100)) := (Real.log_exp _).symm
    _ < Real.log 3 := Real.log_lt_log (Real.exp_pos _) exp_lt_three_of_le_109

/-- 294/100 < log 19. Wall A gate_bc6 input 3/4.  SORRY: 0. -/
theorem log_lb_19 : (294:ℝ)/100 < Real.log 19 :=
  calc (294:ℝ)/100 = Real.log (Real.exp ((294:ℝ)/100)) := (Real.log_exp _).symm
    _ < Real.log 19 := Real.log_lt_log (Real.exp_pos _) exp_lt_19_of_cube

/-- 525/100 < log 191. Wall A gate_bc6 input 4/4.  SORRY: 0. -/
theorem log_lb_191 : (525:ℝ)/100 < Real.log 191 :=
  calc (525:ℝ)/100 = Real.log (Real.exp ((525:ℝ)/100)) := (Real.log_exp _).symm
    _ < Real.log 191 := Real.log_lt_log (Real.exp_pos _) exp_lt_191_of_sixth

/-- All 4 log lower bounds. gate_bc6 (Bost-Connes 1995 Thm 6) fully dischargeable.
    Impact: route_b_clay_certificate.gate_bc6 becomes unconditional.
    SORRY: 0. Axioms: {propext, Classical.choice, Quot.sound}. -/
theorem wall_a_complete :
    (69:ℝ)/100  < Real.log 2   ∧
    (109:ℝ)/100 < Real.log 3   ∧
    (294:ℝ)/100 < Real.log 19  ∧
    (525:ℝ)/100 < Real.log 191 :=
  ⟨log_lb_2, log_lb_3, log_lb_19, log_lb_191⟩

end ArakelovRH.ExpLogBoundsSubClosure
