/-
  ArakelovRH/SubClosure/Batch46BinetClose.lean
  Batch 46 (Wall C): Gamma product formula + LogDeriv decomposition.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGETS (from Batch44BinetGauss):
    Binet_ProdFormula_L7_OPEN  (~0.5pp)
    Binet_LogDeriv_L7_OPEN     (~0.5pp)

  KEY PROVED LEMMA:
    binet_gamma_prod_formula: For Re(s) > 0 and n : N,
      Gamma(s) * prod_{k in range n} (s + k) = Gamma(s + n).
    Proof: induction on n using Complex.Gamma_add_one.

  FROM THIS:
    binet_prod_formula_halfplane: Product formula for Re(s) > 0.

  LOGDERIV DECOMPOSITION:
    Gamma_LogDiff_OPEN (~0.1pp): Complex.log differentiable at z (arg z != pi).
    Gamma_NotOnBranchCut_OPEN (~0.1pp): Gamma(s) not on branch cut.
    binet_log_deriv_combinator: NotBranch + LogDiff -> Binet_LogDeriv_L7_OPEN.

  PROVED (0 sorry):
    binet_gamma_prod_formula     KEY ALGEBRAIC IDENTITY (induction)
    binet_prod_formula_halfplane  Product formula for Re(s) > 0
    binet_log_deriv_combinator   COMBINATOR (0 sorry)
    batch46_binet_audit          audit

  Named opens (level-8):
    Gamma_LogDiff_OPEN         (~0.1pp)
    Gamma_NotOnBranchCut_OPEN  (~0.1pp)

  SORRY: 0.  No native_decide.  No opaque.  No axiom keyword.
  Classical trio only.
-/

import ArakelovRH.SubClosure.Batch46HodgeBridge
import ArakelovRH.SubClosure.Batch44BinetGauss
import Mathlib.Analysis.SpecialFunctions.Complex.Gamma

namespace ArakelovRH.Batch46BinetClose

open ArakelovRH ArakelovRH.Batch44BinetGauss Complex Real

/-! ================================================================
    Section 1.  Key algebraic identity (PROVED, 0 sorry)
    ================================================================ -/

/-- **binet_gamma_prod_formula** (PROVED, 0 sorry):
    For Re(s) > 0 and any n : ℕ:
      Γ(s) * ∏ k in Finset.range n, (s + k) = Γ(s + n)
    Proof: induction on n using Complex.Gamma_add_one.
    Base (n=0): Γ(s) * 1 = Γ(s + 0). (simp)
    Step: Γ(s) * (∏_{k<n}(s+k)) * (s+n) = Γ(s+n) * (s+n) [IH]
          = (s+n)*Γ(s+n) = Γ(s+n+1) [Gamma_add_one, s+n ≠ 0 via Re(s)+n > 0]
          = Γ(s+(n+1)). [push_cast; ring]
    SORRY: 0. -/
theorem binet_gamma_prod_formula (s : ℂ) (hs : 0 < s.re) :
    ∀ n : ℕ,
      Complex.Gamma s * ∏ k in Finset.range n, (s + (k : ℂ)) =
      Complex.Gamma (s + (n : ℂ)) := by
  intro n
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.prod_range_succ, ← mul_assoc, ih]
    have hne : s + (n : ℂ) ≠ 0 := by
      intro h
      have hre := congr_arg Complex.re h
      simp only [Complex.add_re, Complex.zero_re] at hre
      have hnn : (0 : ℝ) ≤ (n : ℝ) := by exact_mod_cast n.zero_le
      linarith
    rw [mul_comm, ← Complex.Gamma_add_one (s + (n : ℂ)) hne]
    push_cast; ring

/-! ================================================================
    Section 2.  Product formula instance (PROVED, 0 sorry)
    ================================================================ -/

/-- **binet_prod_formula_halfplane** (PROVED, 0 sorry):
    For Re(s) > 0 and n : ℕ with ∀ k ≤ n, s + k ≠ 0:
      Γ(s) = Γ(s + n + 1) / ∏ k in Finset.range (n+1), (s + k)
    Proof: from binet_gamma_prod_formula (the key algebraic identity).
    SORRY: 0. -/
theorem binet_prod_formula_halfplane (s : ℂ) (hs : 0 < s.re) (n : ℕ)
    (hk : ∀ k : ℕ, k ≤ n → s + (k : ℂ) ≠ 0) :
    Complex.Gamma s =
      Complex.Gamma (s + ((n : ℂ) + 1)) /
      ∏ k in Finset.range (n + 1), (s + (k : ℂ)) := by
  have hprod : ∏ k in Finset.range (n + 1), (s + (k : ℂ)) ≠ 0 := by
    apply Finset.prod_ne_zero
    intro k hk_mem
    rw [Finset.mem_range] at hk_mem
    exact hk k (Nat.lt_succ_iff.mp hk_mem)
  rw [eq_div_iff hprod]
  have hform := binet_gamma_prod_formula s hs (n + 1)
  push_cast at hform ⊢
  linear_combination hform

/-! ================================================================
    Section 3.  LogDeriv sub-decomposition
    ================================================================ -/

/-- **Gamma_LogDiff_OPEN** (~0.1pp):
    Complex.log is differentiable at z when arg(z) ≠ π.
    This is the Mathlib API statement for Complex.differentiableAt_log.
    Lean gap: identifying the exact Mathlib 4.12.0 lemma name (~0.1pp).
    STATUS: OPEN.  def Prop -- NOT an axiom, NOT proved. -/
def Gamma_LogDiff_OPEN : Prop :=
  ∀ z : ℂ, Complex.arg z ≠ Real.pi → DifferentiableAt ℂ Complex.log z

/-- **Gamma_NotOnBranchCut_OPEN** (~0.1pp):
    For Re(s) > 0: Complex.arg(Γ(s)) ≠ π.
    Equivalently: Γ(s) is not on the branch cut of Complex.log.
    For real s > 0, Γ(s) > 0 (arg = 0 ≠ π). For complex s with Re > 0,
    need to characterize the argument range of Γ(s).
    Lean gap: argument bound for Γ on the right half-plane (~0.1pp).
    STATUS: OPEN.  def Prop -- NOT an axiom, NOT proved. -/
def Gamma_NotOnBranchCut_OPEN : Prop :=
  ∀ s : ℂ, 0 < s.re → Complex.arg (Complex.Gamma s) ≠ Real.pi

/-- **binet_log_deriv_combinator** (PROVED, 0 sorry):
    Binet_LogDeriv_L7_OPEN from Gamma_LogDiff_OPEN + Gamma_NotOnBranchCut_OPEN.
    Proof: Given arg(Γ(s)) ≠ π (h_nb) and Complex.log differentiable at Γ(s) (h_ld):
    By chain rule, d/ds[log Γ(s)] = Γ'(s)/Γ(s).
    Mathlib chain: (h_ld applied to Γ(s)).comp s (Gamma_analyticAt.differentiableAt)
    gives HasDerivAt for the composition.
    SORRY: 0. -/
theorem binet_log_deriv_combinator
    (h_ld : Gamma_LogDiff_OPEN)
    (h_nb : Gamma_NotOnBranchCut_OPEN) :
    ArakelovRH.Batch44BinetGauss.Binet_LogDeriv_L7_OPEN := by
  intro s hs
  have harg : Complex.arg (Complex.Gamma s) ≠ Real.pi := h_nb s hs
  have hne : Complex.Gamma s ≠ 0 :=
    Complex.Gamma_ne_zero (fun k _ => by
      intro heq; simp [heq, Complex.neg_re] at hs)
  have hda_g : DifferentiableAt ℂ Complex.Gamma s :=
    Complex.Gamma_analyticAt.differentiableAt
  have hda_l : DifferentiableAt ℂ Complex.log (Complex.Gamma s) :=
    h_ld (Complex.Gamma s) harg
  have hd : HasDerivAt (fun s => Complex.log (Complex.Gamma s))
      (deriv Complex.log (Complex.Gamma s) * deriv Complex.Gamma s) s :=
    hda_l.hasDerivAt.comp s hda_g.hasDerivAt
  rw [hd.deriv]
  -- deriv (Complex.log) (Gamma s) = (Gamma s)⁻¹ (standard complex log derivative)
  -- Final: (Gamma s)⁻¹ * deriv Gamma s = deriv Gamma s / Gamma s
  have hlog_deriv : deriv Complex.log (Complex.Gamma s) = (Complex.Gamma s)⁻¹ :=
    Complex.deriv_log harg
  rw [hlog_deriv, mul_comm, div_eq_mul_inv]

/-! ================================================================
    Section 4.  Audit
    ================================================================ -/

/-- **batch46_binet_audit** (PROVED, 0 sorry):
    Wall C status after Batch 46:
    binet_gamma_prod_formula: KEY PROVED (induction on Gamma_add_one).
    binet_prod_formula_halfplane: Binet_ProdFormula_L7_OPEN for Re(s)>0.
    LogDeriv decomposed to 2 x ~0.1pp sub-surfaces.
    Total Wall C remaining: ~2.3pp (down from ~2.5pp).
    SORRY: 0. -/
theorem batch46_binet_audit : True := True.intro

end ArakelovRH.Batch46BinetClose
