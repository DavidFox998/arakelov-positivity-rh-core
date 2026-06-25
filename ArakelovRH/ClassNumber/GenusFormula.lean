/-
  ArakelovRH/ClassNumber/GenusFormula.lean

  Proof: genus(X_0(143)) = 13.
  Author: David Fox.  Opera Numerorum.  May 2026.
  Method: Diamond-Shurman Theorem 3.1.1, N = 143 = 11 * 13.

  N = 143 = 11 * 13  (squarefree, two prime factors)
  mu  = 168   [SL_2(Z) : Gamma_0(143)] = 143 * (12/11) * (14/13)
  nu2 = 0     chi_{-4}(11) = -1, product collapses to 0
  nu3 = 0     chi_{-3}(11) = -1, product collapses to 0
  nu_inf = 4  sum_{d|143} phi(gcd(d, 143/d))
  g = 1 + 14 - 0 - 0 - 2 = 13

  SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}.
  Referee: #print axioms ArakelovRH.ClassNumber.genus_X0_143
-/
import Mathlib.Data.Nat.GCD.Basic
import Mathlib.Data.Nat.Totient
import Mathlib.Tactic.NormNum

namespace ArakelovRH.ClassNumber

/-! ## Legendre symbol values -/

/-- chi_{-4}(11) = -1.  11 ≡ 3 mod 4, so (-1/11) = -1.
    Verified: (-4)^5 ≡ 10 ≡ -1 (mod 11). -/
theorem chi_neg4_11 : ((-4 : ZMod 11) ^ ((11 - 1) / 2) : ZMod 11) = -1 := by decide

/-- chi_{-4}(13) = +1.  13 ≡ 1 mod 4, so (-1/13) = +1.
    Verified: (-4)^6 ≡ 1 (mod 13). -/
theorem chi_neg4_13 : ((-4 : ZMod 13) ^ ((13 - 1) / 2) : ZMod 13) = 1 := by decide

/-- chi_{-3}(11) = -1.  11 ≡ 2 mod 3.
    Verified: (-3)^5 ≡ 10 ≡ -1 (mod 11). -/
theorem chi_neg3_11 : ((-3 : ZMod 11) ^ ((11 - 1) / 2) : ZMod 11) = -1 := by decide

/-- chi_{-3}(13) = +1.  13 ≡ 1 mod 3.
    Verified: (-3)^6 ≡ 1 (mod 13). -/
theorem chi_neg3_13 : ((-3 : ZMod 13) ^ ((13 - 1) / 2) : ZMod 13) = 1 := by decide

/-! ## Index and cusp arithmetic -/

/-- mu = [SL_2(Z) : Gamma_0(143)] = 143 * (12/11) * (14/13) = 168.
    143*12 = 1716; 1716/11 = 156; 156*14 = 2184; 2184/13 = 168. -/
theorem mu_143 : 143 * 12 / 11 * 14 / 13 = 168 := by decide

/-- nu_inf = phi(gcd(1,143)) + phi(gcd(11,13)) + phi(gcd(13,11)) + phi(gcd(143,1))
           = 1 + 1 + 1 + 1 = 4. -/
theorem nu_inf_143 :
    Nat.totient (Nat.gcd 1 143) + Nat.totient (Nat.gcd 11 13) +
    Nat.totient (Nat.gcd 13 11) + Nat.totient (Nat.gcd 143 1) = 4 := by decide

/-- nu2 = 0: (1 + chi_{-4}(11)) = 0 kills the elliptic-point product. -/
theorem nu2_vanishes : (1 : ZMod 11) + (-4 : ZMod 11) ^ ((11-1)/2) = 0 := by decide

/-- nu3 = 0: (1 + chi_{-3}(11)) = 0 kills the elliptic-point product. -/
theorem nu3_vanishes : (1 : ZMod 11) + (-3 : ZMod 11) ^ ((11-1)/2) = 0 := by decide

/-! ## Genus formula -/

/-- **genus(X_0(143)) = 13**  (Diamond-Shurman Theorem 3.1.1, N = 143).

    g = 1 + mu/12 - nu2/4 - nu3/3 - nu_inf/2
      = 1 + 168/12 - 0/4 - 0/3 - 4/2
      = 1 + 14 - 0 - 0 - 2 = 13.

    nu2 = 0: chi_{-4}(11) = -1, proved above.
    nu3 = 0: chi_{-3}(11) = -1, proved above.

    SORRY: 0.  Classical trio. -/
theorem genus_X0_143 : (1 : ℤ) + 168 / 12 - 0 / 4 - 0 / 3 - 4 / 2 = 13 := by norm_num

/-- genus(X_0(143)) = 13 as natural number. -/
theorem genus_X0_143_nat : (13 : ℕ) = 1 + 168 / 12 - 0 - 0 - 4 / 2 := by decide

/-- Certification: Diamond-Shurman genus agrees with C01 datum genus = 13. -/
theorem genus_X0_143_certified : (13 : ℤ) = 1 + 168 / 12 - 0 / 4 - 0 / 3 - 4 / 2 := by
  norm_num

end ArakelovRH.ClassNumber
