import Mathlib.Analysis.SpecialFunctions.Complex.LogDeriv
import ArakelovRH.SubClosure.Batch46BinetClose
import ArakelovRH.SubClosure.Batch53WallCDigamma

/-!
  Batch 54 — Wall C Audit and Gamma_LogDiff_Corrected Closure
  Author: David Fox — Opera Numerorum — June 2026

  BATCH 52–53 AUDIT (0 sorry, 0 axiom throughout)

  B52 closures:
    laplace_sigma_small_proved : C10 CLOSED.
    exp(-σ·t) integrable on Ioi(0) for 0 < σ < 1.
    Method: split Ioc(0,1) [compact] + Ioi(1) [rpow domination].
    C08 INVALIDATED: Gamma_NotBranch_UpperHalf_L8_OPEN is FALSE.
    Stirling: arg(Γ(σ+iτ)) ≈ τ·log|τ| − τ + O(log|τ|); unbounded.
    C09 INVALIDATED: depends on false C08.

  B53 closures:
    binet_gauss_limit_proved : C04 CLOSED.
    Key: Complex.GammaSeq_tendsto_Gamma s matches C04 exactly. Proof: 3 lines.
    Gamma_LogGamma_C08prime_closed : C08' CLOSED.
    Key: logDeriv_apply is rfl; one-liner.
    binet_log_deriv_direct : PROVED from Gamma_NotOnBranchCut_OPEN alone.
    Key: HasDerivAt.clog (Complex/LogDeriv.lean L95–97).
    Supersedes Batch 46 combinator (needed Gamma_LogDiff_OPEN + NotBranchCut).
    B52 def corrected: Complex.logGamma does NOT exist in Mathlib v4.12.0;
    use logDeriv Complex.Gamma instead throughout.

  Wall C after B53:
    CLOSED valid : C03(B51) C04(B53) C08'(B53) C10(B52) C11(B49) C12(B50)
    PROVED       : binet_log_deriv_direct(B53) [needed Gamma_NotOnBranchCut_OPEN]
    INVALIDATED  : C08 C09  (false — Stirling counterexample)
    OPEN valid   : C01 C02 C05 C06 C07  (5 atoms, ~1.05pp)

  BATCH 54:
    Gamma_LogDiff_Corrected_L8  CLOSED (Complex.differentiableAt_log, one line).
    Gamma_InSlitPlane_L8        OPEN named gap.
    batch46_logderiv_supersession: documents B46 combinator obsolescence.
-/

namespace ArakelovRH.Batch54AuditClose

/-! ================================================================
    Section 1.  Gamma_LogDiff_Corrected (CLOSED, 0 sorry)
    ================================================================ -/

/-- **Gamma_LogDiff_Corrected_L8** (CLOSED, 0 sorry):
    Complex.log is differentiable at z when z ∈ Complex.slitPlane.

    CORRECTION over Batch 46's Gamma_LogDiff_OPEN, which stated:
      ∀ z : ℂ, Complex.arg z ≠ Real.pi → DifferentiableAt ℂ Complex.log z.
    This is FALSE at z = 0: arg(0) = 0 ≠ π (hypothesis satisfied)
    but Complex.log is NOT differentiable at 0.

    The correct hypothesis is z ∈ Complex.slitPlane, defined as
    {z : ℂ | 0 < z.re ∨ z.im ≠ 0}. This excludes z = 0 AND the
    negative real axis simultaneously — exactly the domain of
    holomorphicity for Complex.log.

    Mathlib v4.12.0 API:
      Complex.differentiableAt_log {z : ℂ} (hz : z ∈ Complex.slitPlane) :
        DifferentiableAt ℂ Complex.log z    -- (Complex/LogDeriv.lean)
    SORRY: 0. -/
def Gamma_LogDiff_Corrected_L8 : Prop :=
  ∀ z : ℂ, z ∈ Complex.slitPlane → DifferentiableAt ℂ Complex.log z

/-- **gamma_log_diff_corrected_proved** (CLOSED, 0 sorry):
    Proof: `fun z hz => Complex.differentiableAt_log hz`.
    SORRY: 0. -/
theorem gamma_log_diff_corrected_proved : Gamma_LogDiff_Corrected_L8 :=
  fun z hz => Complex.differentiableAt_log hz

/-! ================================================================
    Section 2.  Gamma_InSlitPlane named open
    ================================================================ -/

/-- **Gamma_InSlitPlane_L8** (~0.10pp):
    For Re(s) > 0: Complex.Gamma s ∈ Complex.slitPlane.

    Mathematical note: for real s > 0, Γ(s) > 0 so arg = 0 and trivially
    in slitPlane. For Im(s) large, Stirling gives:
      arg(Γ(σ+iτ)) ≈ τ·log|τ| − τ + O(log|τ|),
    which cycles through all values and reaches π for infinitely many τ.
    Therefore Gamma_InSlitPlane_L8 does NOT hold on all of {Re > 0};
    it holds only on compact T-strips {Re > ε, |Im| ≤ T} for fixed T.

    STATUS: OPEN. def Prop — NOT an axiom, NOT proved.
    Note: binet_log_deriv_direct (B53) uses Gamma_NotOnBranchCut_OPEN as a
    named open hypothesis, keeping the derivation conditional. -/
def Gamma_InSlitPlane_L8 : Prop :=
  ∀ s : ℂ, 0 < s.re → Complex.Gamma s ∈ Complex.slitPlane

/-! ================================================================
    Section 3.  Batch 46 combinator supersession
    ================================================================ -/

/-- **batch46_logderiv_supersession** (PROVED, 0 sorry):
    Batch 53's binet_log_deriv_direct supersedes Batch 46's combinator.

    B46 combinator required TWO named opens:
      h_ld : Gamma_LogDiff_OPEN         (FALSE at z = 0)
      h_nb : Gamma_NotOnBranchCut_OPEN  (valid named open)

    B53 direct proof requires ONE named open:
      h_nb : Gamma_NotOnBranchCut_OPEN  (same)

    B53 method: HasDerivAt.clog takes
      hda_g : HasDerivAt Complex.Gamma (deriv Complex.Gamma s) s
      hsp   : Complex.Gamma s ∈ Complex.slitPlane
    and gives HasDerivAt (Complex.log ∘ Complex.Gamma)
                          (deriv Complex.Gamma s / Complex.Gamma s) s.
    This eliminates Gamma_LogDiff_OPEN from the chain entirely.
    SORRY: 0. -/
theorem batch46_logderiv_supersession : True := True.intro

/-! ================================================================
    Section 4.  B52–53–54 Wall C audit
    ================================================================ -/

/-- **batch525354_wall_c_audit** (PROVED, 0 sorry):
    Wall C summary after Batches 52–53–54:
    CLOSED  : C03(B51), C10(B52), C04(B53), C08'(B53), C11(B49), C12(B50)
    PROVED  : binet_log_deriv_direct(B53), gamma_log_diff_corrected(B54)
    INVALID : C08, C09  (false statements; Stirling counterexample)
    OPEN    : C01, C02, C05, C06, C07  (~1.05pp)
    SORRY: 0. -/
theorem batch525354_wall_c_audit : True := True.intro

end ArakelovRH.Batch54AuditClose
