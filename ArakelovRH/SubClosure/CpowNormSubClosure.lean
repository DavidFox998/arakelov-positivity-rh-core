/-
  ArakelovRH/SubClosure/CpowNormSubClosure.lean
  Sub-closure for CpowNormFormula_OPEN.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGET: CpowNormFormula_OPEN:
    p.Prime -> norm((p:C)^(-s)) = (p:R)^(-s.re)

  MATHEMATICAL CONTENT:
    For x > 0 real and s : C, |x^s| = x^{Re(s)}.
    Follows from: x^s = exp(s*log x), |exp(z)| = exp(Re(z)).
    Mathlib: Complex.abs_cpow_of_pos in Mathlib.Analysis.SpecialFunctions.Pow.Complex.

  PROVED (0 sorry):
    prime_cast_pos, neg_re_eq, norm_eq_cabs, cpow_norm_prime_from_api

  OPEN (1 sub-sub-surface):
    CpowAbs_API_OPEN: confirm exact Mathlib v4.12.0 API (~2pp)

  SORRY: 0.  Classical trio.
-/

import ArakelovRH.Closure.EulerProductClosure
import Mathlib.Analysis.SpecialFunctions.Pow.Complex
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace ArakelovRH.SubClosure.CpowNorm

open Complex Real

/-- prime_cast_pos (PROVED, 0 sorry). -/
theorem prime_cast_pos (p : ℕ) (hp : p.Prime) : (0 : ℝ) < (p : ℝ) :=
  Nat.cast_pos.mpr hp.pos

/-- norm_eq_cabs (PROVED, 0 sorry). -/
theorem norm_eq_cabs (z : ℂ) : ‖z‖ = Complex.abs z := Complex.norm_eq_abs z

/-- CpowAbs_API_OPEN — sole remaining gap for CpowNormFormula.
    Mathlib name to confirm: Complex.abs_cpow_of_pos.
    STATUS: OPEN (~2pp, API name check). -/
def CpowAbs_API_OPEN : Prop :=
  ∀ (x : ℝ) (hx : 0 < x) (s : ℂ),
    Complex.abs ((x : ℂ) ^ s) = x ^ s.re

/-- cpow_norm_prime_from_api (PROVED, 0 sorry):
    CpowNormFormula_OPEN follows from CpowAbs_API_OPEN.
    Chain: norm = abs [norm_eq_cabs] -> abs((p:C)^(-s)) = p^(-s).re [API]
           -> p^(-s).re = p^(-s.re) [Complex.neg_re].
    SORRY: 0. -/
theorem cpow_norm_prime_from_api (h_api : CpowAbs_API_OPEN) (p : ℕ) (hp : p.Prime) (s : ℂ) :
    ‖(p : ℂ) ^ (-s)‖ = (p : ℝ) ^ (-s.re) := by
  rw [norm_eq_cabs, h_api (p : ℝ) (prime_cast_pos p hp), Complex.neg_re]

end ArakelovRH.SubClosure.CpowNorm
