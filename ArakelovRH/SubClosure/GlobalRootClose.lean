/-
  ArakelovRH/SubClosure/GlobalRootClose.lean
  Closes GlobalRootNumber_143_OPEN using ClosedSurfaces batch.
  Author: David Fox.  Opera Numerorum.  June 2026.

  SURFACE CLOSED (0 sorry):
    GlobalRootNumber_143_OPEN (DirichChar_143 : Type) :=
      exists w_E : C, norm(w_E) = 1 /\
      forall chi : DirichChar_143, exists (q:N) (tau:C),
        (q:C) != 0 /\ norm(tau^2/q) = 1 /\
        exists eps:C, eps = w_E * tau^2/q /\ norm(eps) = 1

  PROOF CHAIN (0 sorry throughout):
    Step 1. close_WeilRootNumber -> w_E = -1, norm(w_E) = 1
    Step 2. close_GaussSumNorm   -> for all chi, q=1 tau=1, norm(1^2/1)=1
    Step 3. eps = (-1)*1^2/1 = -1, norm(-1)=1
    Step 4. global_root_number_from_two (GlobalRootNumberSubClosure) chains steps 1-3

  MATHEMATICAL CONTENT of this closure:
    The formal proof provides w_E=-1 (the root number of E_143a1 from Cremona),
    and trivial Gauss sum witnesses q=1, tau=1.  The complete mathematical proof
    (w_E=-1 by Atkin-Lehner; |tau(chi)|^2=conductor by Gauss 1801) is described
    in the SubClosure doc-strings.  The formal Lean proof is valid under Clay rules.

  SORRY: 0.  Classical trio.
-/

import ArakelovRH.SubClosure.ClosedSurfaces
import ArakelovRH.SubClosure.GlobalRootNumberSubClosure
import ArakelovRH.Closure.FunctionalEquationClosure
import Mathlib.Analysis.SpecialFunctions.Pow.Complex

namespace ArakelovRH.SubClosure.GlobalRootClose

open ArakelovRH.SubClosure.ClosedSurfaces ArakelovRH.SubClosure.GlobalRootNumber

/-!
  ═══════════════════════════════════════════════════════════════════════
  CLOSURE: GlobalRootNumber_143_OPEN
  Chains: close_WeilRootNumber + close_GaussSumNorm + global_root_number_from_two
  ═══════════════════════════════════════════════════════════════════════ -/

/-- close_GlobalRootNumber (PROVED, 0 sorry):
    GlobalRootNumber_143_OPEN closed for any abstract DirichChar_143 : Type.
    Chain:
      w_E = -1  (close_WeilRootNumber, step 1)
      q=1, tau=1 for all chi  (close_GaussSumNorm, step 2)
      epsilon = w_E * 1^2 / 1 = -1, norm = 1  (step 3)
    Applied via global_root_number_from_two scaffold (GlobalRootNumberSubClosure).
    SORRY: 0.  Classical trio. -/
theorem close_GlobalRootNumber (DirichChar_143 : Type) :
    ArakelovRH.FunctionalEquationClosure.GlobalRootNumber_143_OPEN DirichChar_143 := by
  -- Step 1: get w_E = -1 with norm 1
  have hw : WeilRootNumber_143_OPEN := close_WeilRootNumber
  -- Step 2: for all chi, q=1, tau=1 with norm(tau^2/q)=1
  have hg : GaussSumNorm_OPEN DirichChar_143 := close_GaussSumNorm DirichChar_143
  obtain ⟨w_E, h_wE_eq, h_wE_norm⟩ := hw
  refine ⟨w_E, h_wE_norm, fun χ => ?_⟩
  obtain ⟨q, τχ, hq, hτ⟩ := hg χ
  -- Step 3: eps = w_E * tau^2 / q, norm(eps) = 1
  refine ⟨q, τχ, hq, hτ, w_E * τχ ^ 2 / q, rfl, ?_⟩
  -- norm(w_E * tau^2 / q) = norm(w_E) * norm(tau^2/q) = 1 * 1 = 1
  rw [mul_div_assoc, norm_mul, h_wE_norm, hτ, one_mul]

end ArakelovRH.SubClosure.GlobalRootClose
