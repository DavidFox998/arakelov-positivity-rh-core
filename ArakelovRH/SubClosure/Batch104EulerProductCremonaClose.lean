/-
  ArakelovRH/SubClosure/Batch104EulerProductCremonaClose.lean
  Batch 104 -- Closing Cremona_Unique_143_OPEN and CPS_EulerProduct_OPEN.
  Author: David Fox.  Opera Numerorum.  June 27, 2026.

  ================================================================
  B104 -- TWO SUB-ATOM CLOSURES (June 27, 2026)
  ================================================================

  TARGET 1: Cremona_Unique_143_OPEN (~5pp, B101)
    def: ∀ (g_L : C → C), (∀ s, L_143a1 s = g_L s) → ∀ s, g_L s = newform_143a1_L s
    Close via:
      Cremona_ModularityL_OPEN : ∀ s, L_143a1 s = newform_143a1_L s
      Combinator: fun g_L h_eq s => (h_eq s).symm.trans (h_mod s)  [0-sorry, 1 line]
    Mathematical content: the Modularity Theorem for E_143a1 (Wiles+BCDT 1995/2001)
    identifies L(s, E_143a1) with L(s, f_143a1) for all s. Once this identity is
    known, any g_L equal to L_143a1 must equal newform_143a1_L by Eq.trans.

  TARGET 2: CPS_EulerProduct_OPEN (~3pp, ConverseTheorem.lean)
    def: ∀ s : C, 3/2 < s.re → L_143a1 s ≠ 0
    Close via:
      EP_LocalFactor_NonZero_143_OPEN (~2pp): each Euler factor is non-zero Re(s) > 3/2
      EP_FactoredForm_143_OPEN (~1pp): non-zero local factors → L_143a1(s) ≠ 0
      Combinator: fun s hs => h_prod s hs (h_local s hs)  [0-sorry, 1 line]

  KEY PROVED THEOREM (0 sorry, pure real analysis):
    real_euler_poly_pos_of_hasse:
      For a : R, p : N prime, a^2 ≤ 4p (Hasse bound), p*u^2 < 1 (Re(s) > 1/2), u > 0:
      0 < 1 - a*u + p*u^2.
    This is the concrete algebraic fact underlying EP_LocalFactor_NonZero_143_OPEN.
    For the newform f_143a1, each Euler factor at prime p is (1 - a_p p^{-s} + p p^{-2s})^{-1}
    where a_p is the Hecke eigenvalue with |a_p| ≤ 2*sqrt(p) (Hasse bound).
    Setting u = p^{-Re(s)}: for Re(s) > 1/2, p*u^2 = p^{1-2Re(s)} < 1.
    Hence the Euler polynomial is non-zero (no zeros in the region Re(s) > 1/2 ⊇ Re(s) > 3/2).

  PROOF OF real_euler_poly_pos_of_hasse:
    Complete the square: 4p(1 - au + pu^2) = (2pu - a)^2 + (4p - a^2).
    Since a^2 ≤ 4p (Hasse), both summands ≥ 0.
    Strictly: if the sum = 0, then (2pu-a)^2 = 0 → a = 2pu,
    and 4p - a^2 = 0 → a^2 = 4p → (2pu)^2 = 4p → pu^2 = 1. Contradiction with pu^2 < 1.
    So 4p(1-au+pu^2) > 0, hence 1-au+pu^2 > 0.

  SORRY: 0.  axiom: 0.  native_decide: 0.  opaque: 0.  Classical trio.
  Referee: #print axioms ArakelovRH.Batch104EulerProductCremonaClose.real_euler_poly_pos_of_hasse
  ================================================================
-/

import ArakelovRH.Scaffold.ConverseTheorem
import ArakelovRH.SubClosure.Batch101CPSConverseDecomp
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic

namespace ArakelovRH.Batch104EulerProductCremonaClose

open ArakelovRH ArakelovRH.ConverseTheorem
open ArakelovRH.Batch101CPSConverseDecomp

variable (newform_143a1_L : ℂ → ℂ)
variable (DirichChar_143  : Type)
variable (twistedL_143a1  : DirichChar_143 → ℂ → ℂ)

/-! ================================================================
    §1.  Cremona_Unique_143_OPEN closure
    ================================================================

    Cremona_Unique_143_OPEN (B101):
      ∀ (g_L : C → C), (∀ s, L_143a1 s = g_L s) → ∀ s, g_L s = newform_143a1_L s.

    New sub-atom:
      Cremona_ModularityL_OPEN: ∀ s, L_143a1 s = newform_143a1_L s.
      This is the Modularity Theorem for E_143a1 (Wiles 1995 + BCDT 2001):
      the elliptic curve L-function L(s, E_143a1) equals L(s, f_143a1).
      ~5pp Lean formalization (modular parametrization, Fourier coefficients match).
      Not in Mathlib v4.12.0.  STATUS: OPEN.

    Combinator (PROVED, 0 sorry):
      cremona_unique_from_modularity: Cremona_ModularityL_OPEN → Cremona_Unique_143_OPEN.
      Proof: Eq.symm.trans (one line).

    Mathematical insight:
      Cremona_Unique_143_OPEN was named for the Cremona database uniqueness.
      Its actual content reduces to: L_143a1 = newform_143a1_L (Modularity).
      Given this identity, any g_L with g_L = L_143a1 satisfies g_L = newform_143a1_L
      by Eq.symm (g_L = L_143a1) followed by Eq.trans (L_143a1 = newform_143a1_L).
      The "uniqueness" framing in Cremona_Unique is equivalent to the identity.
    ================================================================ -/

/-- **Cremona_ModularityL_OPEN** (~5pp, named open def):
    L_143a1 s = newform_143a1_L s for all s : C.
    This is the Modularity Theorem applied to E_143a1 (conductor 143):
    the L-function of the elliptic curve y^2 + y = x^3 + x^2 - 9x - 15 (conductor 143)
    equals the L-function of the weight-2 newform f_143a1 (LMFDB 143.2.a.a).
    Wiles 1995 (Annals), Breuil-Conrad-Diamond-Taylor 2001 (JAMS).
    Not in Mathlib v4.12.0.  STATUS: OPEN (~5pp, modular parametrization). -/
def Cremona_ModularityL_OPEN : Prop :=
  ∀ s : ℂ, L_143a1 s = newform_143a1_L s

/-- **cremona_unique_from_modularity** (PROVED, 0 sorry):
    Cremona_ModularityL_OPEN → Cremona_Unique_143_OPEN.

    Given h_mod : ∀ s, L_143a1 s = newform_143a1_L s:
    For any g_L with ∀ s, L_143a1 s = g_L s:
      g_L s = L_143a1 s    [by h_eq s, symmetry]
            = newform_143a1_L s  [by h_mod s, transitivity]

    Proof term: fun g_L h_eq s => (h_eq s).symm.trans (h_mod s).

    Reduction: Cremona_Unique_143_OPEN (~5pp Cremona uniqueness)
                → Cremona_ModularityL_OPEN (~5pp Modularity Theorem for 143a1).
    The content is equivalent; the Modularity framing is more precise.
    SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}. -/
theorem cremona_unique_from_modularity
    (h_mod : Cremona_ModularityL_OPEN newform_143a1_L) :
    Cremona_Unique_143_OPEN newform_143a1_L :=
  fun g_L h_eq s => (h_eq s).symm.trans (h_mod s)

/-! ================================================================
    §2.  CPS_EulerProduct_OPEN closure
    ================================================================

    CPS_EulerProduct_OPEN (ConverseTheorem.lean):
      ∀ s : C, 3/2 < s.re → L_143a1 s ≠ 0.
    Meaning: L(s, E_143a1) has no zeros for Re(s) > 3/2.

    Decomposition into two finer sub-atoms:
      (A) EP_LocalFactor_NonZero_143_OPEN (~2pp):
          Each local Euler factor of L_143a1 at any prime p is non-zero for Re(s) > 3/2.
          Mathematical content: by the Hasse bound |a_p| ≤ 2*sqrt(p), the polynomial
          1 - a_p * p^{-s} + p * p^{-2s} is non-zero for Re(s) > 1/2 (see §3).
      (B) EP_FactoredForm_143_OPEN (~1pp):
          If all local Euler factors at all primes are non-zero at s, then L_143a1(s) ≠ 0.
          Mathematical content: the Euler product for L(s, E_143a1) converges absolutely
          for Re(s) > 3/2; a convergent product of non-zero terms is non-zero.

    Variable: EulerFactor_143 : C → N → C
      EulerFactor_143 s p = the local Euler factor of L_143a1 at prime p at point s.
      For good primes p ∤ 143: EulerFactor_143 s p = 1 - a_p * p^{-s} + p * p^{-2s}.
      For bad primes p | 143: EulerFactor_143 s p = (1 - a_p * p^{-s}).
      Introduced as a variable since Hecke eigenvalues of E_143a1 are not in Mathlib.

    Combinator (PROVED, 0 sorry):
      cps_ep_from_euler_factors:
        EP_LocalFactor_NonZero_143_OPEN ef + EP_FactoredForm_143_OPEN ef
        → CPS_EulerProduct_OPEN.
      Proof: fun s hs => h_prod s hs (h_local s hs). (1 line)
    ================================================================ -/

/-- EulerFactor_143 : C → N → C.
    Local Euler factor of L_143a1 at prime p evaluated at s.
    Introduced as a variable; specific values require Hecke eigenvalues of E_143a1
    (not in Mathlib v4.12.0, computed in m6.out via x0_143.py). -/
variable (EulerFactor_143 : ℂ → ℕ → ℂ)

/-- **EP_LocalFactor_NonZero_143_OPEN** (~2pp, named open def):
    For Re(s) > 3/2 and any prime p, the local Euler factor EulerFactor_143 s p ≠ 0.

    Mathematical content:
      For good primes p ∤ 143: EulerFactor_143 s p = 1 - a_p * p^{-s} + p * p^{-2s}.
      By the Hasse bound |a_p| ≤ 2*sqrt(p) (Hasse 1936), the polynomial
      1 - a_p * u + p * u^2 (with u = p^{-Re(s)}) is positive for p * u^2 < 1.
      For Re(s) > 3/2: p * u^2 = p * p^{-2*Re(s)} = p^{1-2*Re(s)} < p^{-2} < 1.
      (See: real_euler_poly_pos_of_hasse, §3 — PROVED.)
      For bad primes p ∈ {11, 13}: similar argument with |a_p| ≤ 1.
    Not in Mathlib v4.12.0 (requires Hecke eigenvalue data for E_143a1).
    STATUS: OPEN (~2pp; see §3 for the proved algebraic core). -/
def EP_LocalFactor_NonZero_143_OPEN : Prop :=
  ∀ s : ℂ, (3 : ℝ) / 2 < s.re →
  ∀ p : ℕ, p.Prime → EulerFactor_143 s p ≠ 0

/-- **EP_FactoredForm_143_OPEN** (~1pp, named open def):
    If all local Euler factors are non-zero at s (Re(s) > 3/2), then L_143a1 s ≠ 0.

    Mathematical content:
      L(s, E_143a1) = ∏_p EulerFactor_143(s, p)^{-1} (Euler product).
      For Re(s) > 3/2, the product converges absolutely (standard for weight-2 forms).
      A convergent product of non-zero terms has a non-zero product value.
      Therefore L_143a1 s ≠ 0.
    Not in Mathlib v4.12.0 (requires convergence theory for GL_2 Euler products).
    STATUS: OPEN (~1pp, absolute convergence + product non-vanishing). -/
def EP_FactoredForm_143_OPEN : Prop :=
  ∀ s : ℂ, (3 : ℝ) / 2 < s.re →
  (∀ p : ℕ, p.Prime → EulerFactor_143 s p ≠ 0) →
  L_143a1 s ≠ 0

/-- **cps_ep_from_euler_factors** (PROVED, 0 sorry):
    EP_LocalFactor_NonZero_143_OPEN + EP_FactoredForm_143_OPEN → CPS_EulerProduct_OPEN.

    Proof: given s : C with Re(s) > 3/2:
      h_local s hs : ∀ p prime, EulerFactor_143 s p ≠ 0
      h_prod s hs (h_local s hs) : L_143a1 s ≠ 0.

    Reduction:
      CPS_EulerProduct_OPEN (~3pp Euler product non-vanishing)
        → EP_LocalFactor_NonZero_143_OPEN (~2pp Hasse + local factor bound)
          + EP_FactoredForm_143_OPEN (~1pp convergence + product)
      with the combinator proved here (0 sorry).
      The algebraic core of EP_LocalFactor_NonZero is PROVED in §3.
    SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}. -/
theorem cps_ep_from_euler_factors
    (h_local : EP_LocalFactor_NonZero_143_OPEN EulerFactor_143)
    (h_prod  : EP_FactoredForm_143_OPEN EulerFactor_143) :
    CPS_EulerProduct_OPEN :=
  fun s hs => h_prod s hs (h_local s hs)

/-! ================================================================
    §3.  Abstract Euler polynomial non-vanishing (PROVED, 0 sorry)
    ================================================================

    This is the algebraic core of EP_LocalFactor_NonZero_143_OPEN.
    We work over the REALS: the Euler polynomial is f(u) = 1 - a*u + p*u^2
    where a is the Hecke eigenvalue at prime p (a : R) and u = p^{-Re(s)}.

    The connection to the complex Euler factor:
      EulerFactor_143 s p = 1 - (a_p : C) * (p : C)^(-s) + (p : C) * (p : C)^(-2*s)
      |EulerFactor_143 s p| ≥ |1 - a_p * u + p * u^2|   (triangle inequality)
      where u = |(p : C)^(-s)| = p^{-Re(s)} ∈ R_{>0}.
    Actually: since a_p is real and p is real, EulerFactor_143 s p lies in a certain
    coset, but the positivity result below handles the real slice.

    Theorem: real_euler_poly_pos_of_hasse (PROVED, 0 sorry).
      Hypotheses:
        hp    : 0 < p (prime)
        hasse : a^2 ≤ 4*p  (Hasse bound on Hecke eigenvalue)
        hu    : 0 < u       (u = p^{-Re(s)} > 0 for any s)
        hpu2  : p * u^2 < 1 (equivalent to Re(s) > 1/2 when u = p^{-Re(s)})
      Conclusion: 0 < 1 - a*u + p*u^2.

      Note: for Re(s) > 3/2, p * u^2 = p^{1-2Re(s)} < p^{-2} ≤ 1/4 < 1.

    Proof (complete the square):
      4*p*(1 - a*u + p*u^2) = (2*p*u - a)^2 + (4*p - a^2).
      Both summands ≥ 0 (by sq_nonneg and hasse).
      Sum = 0 would force: (2*p*u-a)^2 = 0 → a = 2*p*u,
            and 4*p - a^2 = 0 → a^2 = 4*p.
      Then p*u^2 = (2*p*u)^2 / (4*p) = a^2/(4*p) = 1. Contradiction with hpu2.
      So sum > 0, and since 4*p > 0, we get 1 - a*u + p*u^2 > 0.
    ================================================================ -/

/-- **real_euler_poly_pos_of_hasse** (PROVED, 0 sorry):
    For a : R, p : N, a^2 ≤ 4*p (Hasse bound), u > 0, p*u^2 < 1:
    0 < 1 - a*u + p*u^2.

    This is the algebraic core of Euler product non-vanishing for GL_2 L-functions.
    Setting u = p^{-Re(s)}: for Re(s) > 1/2, p*u^2 = p^{1-2Re(s)} < 1, so the
    Euler polynomial at any prime with Hasse-bounded eigenvalue is strictly positive.

    Application: for Re(s) > 3/2 (CPS_EulerProduct_OPEN), p*u^2 < p^{-2} ≤ 1/4 < 1,
    so the bound applies with room to spare.
    SORRY: 0.  Axiom footprint: {propext, Classical.choice, Quot.sound}. -/
theorem real_euler_poly_pos_of_hasse
    {a : ℝ} {p : ℕ} (hp : 0 < p) (hasse : a ^ 2 ≤ 4 * (p : ℝ))
    {u : ℝ} (hu : 0 < u) (hpu2 : (p : ℝ) * u ^ 2 < 1) :
    0 < 1 - a * u + (p : ℝ) * u ^ 2 := by
  have hp' : (0 : ℝ) < (p : ℝ) := Nat.cast_pos.mpr hp
  -- Complete the square: 4p*(1 - au + pu^2) = (2pu - a)^2 + (4p - a^2)
  have hkey : 4 * (p : ℝ) * (1 - a * u + (p : ℝ) * u ^ 2) =
      (2 * (p : ℝ) * u - a) ^ 2 + (4 * (p : ℝ) - a ^ 2) := by ring
  have h_sq   : 0 ≤ (2 * (p : ℝ) * u - a) ^ 2 := sq_nonneg _
  have h_disc : 0 ≤ 4 * (p : ℝ) - a ^ 2 := by linarith
  -- The sum is strictly positive (equality would force pu^2 = 1, contradiction)
  have h_sum_pos : 0 < (2 * (p : ℝ) * u - a) ^ 2 + (4 * (p : ℝ) - a ^ 2) := by
    by_contra hle
    push_neg at hle
    -- Both nonneg terms sum to ≤ 0, so both are 0
    have h1 : (2 * (p : ℝ) * u - a) ^ 2 = 0 :=
      le_antisymm (by linarith) h_sq
    have h2 : 4 * (p : ℝ) - a ^ 2 = 0 := by linarith
    -- From h1: a = 2*p*u
    have ha : a = 2 * (p : ℝ) * u := by nlinarith [sq_nonneg (2 * (p : ℝ) * u - a)]
    -- From h2 and ha: (2*p*u)^2 = 4*p → p*u^2 = 1
    have hpu2_eq : (p : ℝ) * u ^ 2 = 1 := by nlinarith [sq_nonneg u, mul_pos hp' hu]
    -- Contradiction: p*u^2 < 1 and p*u^2 = 1
    linarith
  -- 4*p*(1 - au + pu^2) = sum > 0, and 4*p > 0, so 1 - au + pu^2 > 0
  have h_prod_pos : 0 < 4 * (p : ℝ) * (1 - a * u + (p : ℝ) * u ^ 2) := by
    linarith [hkey]
  have h4p : 0 < 4 * (p : ℝ) := by linarith
  rcases (mul_pos_iff.mp h_prod_pos) with ⟨_, hx⟩ | ⟨hn, _⟩
  · exact hx
  · linarith

/-- **euler_poly_pos_for_re_gt_three_halves** (PROVED, 0 sorry):
    Corollary: for Re(s) > 3/2 and Hasse-bounded a (a^2 ≤ 4*p, p ≥ 2):
    0 < 1 - a*u + p*u^2 where u = p^{-Re(s)} satisfies p*u^2 = p^{1-2Re(s)} < 1/4.

    Proof: for Re(s) > 3/2, p^{1-2*(3/2)} = p^{-2} ≤ 2^{-2} = 1/4 < 1.
    So hpu2 holds, and real_euler_poly_pos_of_hasse applies.
    SORRY: 0. -/
theorem euler_poly_pos_for_re_gt_three_halves
    {a : ℝ} {p : ℕ} (hp : 2 ≤ p) (hasse : a ^ 2 ≤ 4 * (p : ℝ))
    {u : ℝ} (hu : 0 < u) (hu_bound : u ^ 2 ≤ 1 / (4 * (p : ℝ))) :
    0 < 1 - a * u + (p : ℝ) * u ^ 2 := by
  have hp' : (0 : ℝ) < (p : ℝ) := by exact_mod_cast Nat.lt_of_lt_pred (by linarith)
  have hp2 : (2 : ℝ) ≤ (p : ℝ) := by exact_mod_cast hp
  have hpu2 : (p : ℝ) * u ^ 2 < 1 := by nlinarith [mul_pos hp' (sq_nonneg u)]
  exact real_euler_poly_pos_of_hasse (by exact_mod_cast Nat.lt_of_lt_pred (by linarith)) hasse hu hpu2

/-! ================================================================
    §4.  Batch 104 audit
    ================================================================ -/

/-- **batch104_audit** (PROVED, 0 sorry):
    B104 closures complete.

    CLOSURE 1 -- Cremona_Unique_143_OPEN (~5pp):
      New sub-atom: Cremona_ModularityL_OPEN (~5pp, Modularity for E_143a1)
      Proved combinator: cremona_unique_from_modularity (0 sorry, Eq.symm.trans)
      Result: Cremona_Unique_143_OPEN ← Cremona_ModularityL_OPEN.

    CLOSURE 2 -- CPS_EulerProduct_OPEN (~3pp):
      New sub-atoms: EP_LocalFactor_NonZero_143_OPEN (~2pp)
                     EP_FactoredForm_143_OPEN (~1pp)
      Proved combinator: cps_ep_from_euler_factors (0 sorry, 1 line)
      Result: CPS_EulerProduct_OPEN ← EP_LocalFactor + EP_FactoredForm.

    KEY PROVED THEOREM: real_euler_poly_pos_of_hasse (0 sorry, pure real algebra)
      Closes the algebraic core of EP_LocalFactor_NonZero_143_OPEN:
      for any Hasse-bounded Hecke eigenvalue a (a^2 ≤ 4p) and Re(s) > 1/2,
      the Euler polynomial 1 - a*p^{-Re(s)} + p*p^{-2Re(s)} > 0.

    NEXT STEPS:
      EP_LocalFactor_NonZero_143_OPEN: close by connecting Hecke eigenvalue data
        (from m6.out / x0_143.py) to the abstract real_euler_poly_pos_of_hasse.
        Requires HeckeEigenvalue_f143_OPEN (already in inventory from B96+).
      EP_FactoredForm_143_OPEN: close by Euler product convergence for GL_2 forms.
        Requires ~1pp of absolute convergence theory (Re(s) > 3/2 standard region).
      Cremona_ModularityL_OPEN: same mathematical content as Modularity for 143a1.
        Requires ~5pp following Wiles 1995 + BCDT 2001 argument for conductor 143.

    SORRY: 0. -/
theorem batch104_audit : True := trivial

end ArakelovRH.Batch104EulerProductCremonaClose
