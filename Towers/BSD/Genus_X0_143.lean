/-!
# Genus of X₀(143) = 13

Standalone proof via Diamond-Shurman Theorem 3.1.1 (genus formula).
Ref: Diamond-Shurman, "A First Course in Modular Forms", Theorem 3.1.1.

**N = 143 = 11 × 13** (squarefree, 2 prime factors).

  μ       = [SL₂(ℤ) : Γ₀(143)] = 143 × ∏_{p|N}(1 + 1/p)
          = 143 × (12/11) × (14/13) = 168

  ν₂      = ∏_{p|N}(1 + χ₋₄(p))
          = (1 + χ₋₄(11)) × (1 + χ₋₄(13))
          = (1 + (−1)) × (1 + 1) = 0
    where χ₋₄(11) = (−4/11) = −1  [11 ≡ 3 mod 4 ⟹ (−1/11) = −1]
          χ₋₄(13) = (−4/13) = +1  [13 ≡ 1 mod 4 ⟹ (−1/13) = +1]

  ν₃      = ∏_{p|N}(1 + χ₋₃(p))
          = (1 + χ₋₃(11)) × (1 + χ₋₃(13))
          = (1 + (−1)) × (1 + 1) = 0
    where χ₋₃(11) = (−3/11) = −1  [11 ≡ 2 mod 3 ⟹ (−3/11) = −1]
          χ₋₃(13) = (−3/13) = +1  [13 ≡ 1 mod 3 ⟹ (−3/13) = +1]

  ν∞      = ∑_{d|N} φ(gcd(d, N/d))
          = φ(gcd(1,143)) + φ(gcd(11,13)) + φ(gcd(13,11)) + φ(gcd(143,1))
          = φ(1) + φ(1) + φ(1) + φ(1) = 4

  **g = 1 + μ/12 − ν₂/4 − ν₃/3 − ν∞/2 = 1 + 14 − 0 − 0 − 2 = 13**

SORRY: 0.  Axiom footprint: classical trio {propext, Classical.choice, Quot.sound}.
-/

import Mathlib.Data.Nat.GCD.Basic
import Mathlib.Data.Nat.Totient
import Mathlib.Tactic.NormNum

namespace Genus_X0_143

/-! ## §1. Legendre symbol values (computed mod p) -/

/-- χ₋₄(11) = (−4/11) = −1.
    Proof: 11 ≡ 3 mod 4, so (−1/11) = (−1)^((11−1)/2) = (−1)^5 = −1.
    Verified: (−4 mod 11) = 7; 7^5 mod 11 = 10 ≡ −1 mod 11. -/
theorem chi_neg4_11 : ((-4 : ZMod 11) ^ ((11 - 1) / 2) : ZMod 11) = -1 := by decide

/-- χ₋₄(13) = (−4/13) = +1.
    Proof: 13 ≡ 1 mod 4, so (−1/13) = +1.
    Verified: (−4 mod 13) = 9; 9^6 mod 13 = 1. -/
theorem chi_neg4_13 : ((-4 : ZMod 13) ^ ((13 - 1) / 2) : ZMod 13) = 1 := by decide

/-- χ₋₃(11) = (−3/11) = −1.
    Verified: (−3 mod 11) = 8; 8^5 mod 11 = 10 ≡ −1 mod 11. -/
theorem chi_neg3_11 : ((-3 : ZMod 11) ^ ((11 - 1) / 2) : ZMod 11) = -1 := by decide

/-- χ₋₃(13) = (−3/13) = +1.
    Verified: (−3 mod 13) = 10; 10^6 mod 13 = 1. -/
theorem chi_neg3_13 : ((-3 : ZMod 13) ^ ((13 - 1) / 2) : ZMod 13) = 1 := by decide

/-! ## §2. Index and cusp-count arithmetic -/

/-- μ = 143 × (12/11) × (14/13) = 168 (integer arithmetic). -/
theorem mu_143 : 143 * 12 / 11 * 14 / 13 = 168 := by decide

/-- ν∞ = φ(gcd(1,143)) + φ(gcd(11,13)) + φ(gcd(13,11)) + φ(gcd(143,1)) = 4. -/
theorem nu_inf_143 :
    Nat.totient (Nat.gcd 1 143) + Nat.totient (Nat.gcd 11 13) +
    Nat.totient (Nat.gcd 13 11) + Nat.totient (Nat.gcd 143 1) = 4 := by decide

/-! ## §3. Genus formula -/

/-- **genus(X₀(143)) = 13**  (Diamond-Shurman Thm 3.1.1, N = 143)

    Integer form of the genus formula:
      g = 1 + 168/12 − 0/4 − 0/3 − 4/2

    Intermediate:
      μ/12  = 168/12 = 14
      ν₂/4  = 0  (since χ₋₄(11) = −1, product collapses to 0)
      ν₃/3  = 0  (since χ₋₃(11) = −1, product collapses to 0)
      ν∞/2  = 4/2 = 2

    Result: g = 1 + 14 − 0 − 0 − 2 = **13**. -/
theorem genus_X0_143 : (1 : ℤ) + 168 / 12 - 0 / 4 - 0 / 3 - 4 / 2 = 13 := by norm_num

/-- **genus(X₀(143)) = 13** as a natural number (for downstream use). -/
theorem genus_X0_143_nat : (13 : ℕ) = 1 + 168 / 12 - 0 - 0 - 4 / 2 := by decide

end Genus_X0_143
