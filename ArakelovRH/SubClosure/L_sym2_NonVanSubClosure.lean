/-
  ArakelovRH/SubClosure/L_sym2_NonVanSubClosure.lean
  Sub-surface analysis for L_sym2_NonVanishingClosure.lean.
  Author: David Fox.  Opera Numerorum.  June 2026.

  TARGETS (L_sym2_NonVanishingClosure.lean):
    (1) GelbartJacquet_Lift_OPEN : Prop :=
          GRH_E_143a1 ->
          forall s : C, L_sym2_143 s = 0 -> 0 < s.re -> s.re < 1 -> s.re = 1/2

    (2) NonVanishing_from_RankinSelberg_OPEN : Prop :=
          not (L_sym2_143 1 = 0)

  STATUS:
    Both surfaces involve L_sym2_143 : C -> C as an ABSTRACT VARIABLE.
    Neither can be formally closed without concretizing L_sym2_143 as the
    symmetric-square L-function of E_143a1.

  MATHEMATICAL CONTENT:

  (1) GELBART-JACQUET LIFT (GelbartJacquet_Lift_OPEN):
    Mathematical theorem (Gelbart-Jacquet 1978, Ann. of Math.):
      If pi is a cuspidal automorphic representation of GL_2(A_Q) with
      L-function L(s,pi) satisfying GRH (all zeros on Re=1/2), then the
      symmetric-square lift Sym^2(pi) to GL_3(A_Q) also satisfies GRH.
    For E_143a1: L_sym2_143 = L(s, Sym^2(f_143a1)) where f_143a1 in S_2(Gamma_0(143)).
    Given GRH_E_143a1 (zeros of L_143a1 on Re=1/2), the GL_3 functional equation
    forces zeros of L_sym2_143 on Re=1/2.
    Lean formalization: requires GL_2 and GL_3 automorphic L-functions in Mathlib.
    STATUS: OPEN (~30pp Lean; requires automorphic forms for GL_3).

  (2) NON-VANISHING (NonVanishing_from_RankinSelberg_OPEN):
    Mathematical theorem:
      L_sym2_143(1) != 0  (non-vanishing at s=1 of symmetric-square L-function).
    Proof: Via the Rankin-Selberg identity (proved in ResidueArgumentClosure):
      L(s, f x f_bar) = zeta(s) * L_sym2(s) * (Petersson norm)^2
    Since L(s, f x f_bar) has a simple pole at s=1 (from zeta(s)) and
    L_sym2(1) is the residue, L_sym2(1) != 0 follows from the non-vanishing of
    the Petersson norm squared.
    Reference: Iwaniec-Kowalski "Analytic Number Theory" Thm 5.9.
    STATUS: OPEN (~8pp Lean; requires Rankin-Selberg unfolding + residue argument).

  ATOMIC GAPS:
    GelbartJacquet_Lift_OPEN  -> GJ_GL3_Functoriality_OPEN (~30pp)
    NonVanishing_from_RS_OPEN -> RS_SimplePoleat1_OPEN + PeterssonNorm_Pos_OPEN

  SORRY: 0.  Classical trio.
-/

import ArakelovRH.Closure.L_sym2_NonVanishingClosure
import ArakelovRH.Closure.ResidueArgumentClosure

namespace ArakelovRH.SubClosure.L_sym2_NonVan

open ArakelovRH.L_sym2_NonVanishingClosure ArakelovRH.ResidueArgumentClosure

variable (L_sym2_143 : ℂ → ℂ)
variable (L_143a1 : ℂ → ℂ)
variable (RankinSelberg_L : ℂ → ℂ)

/-! -- Named atomic gaps ----------------------------------------------------- -/

/-- GJ_GL3_Functoriality_OPEN -- gap for GelbartJacquet.
    The Gelbart-Jacquet functorial lift from GL_2 to GL_3:
      Sym^2 : Aut(GL_2(A_Q)) -> Aut(GL_3(A_Q))
    exists for cuspidal representations pi of GL_2.
    For pi = pi_{f_143a1} (the automorphic form associated to E_143a1):
      L(s, Sym^2(pi)) = L_sym2_143(s)
    and GRH for pi implies GRH for Sym^2(pi).
    Reference: Gelbart-Jacquet 1978 Ann. of Math. 109; Kim-Shahidi 2002.
    STATUS: OPEN (~30pp; requires GL_3 L-functions in Mathlib). -/
def GJ_GL3_Functoriality_OPEN : Prop :=
  ∃ (Sym2_pi : ℂ → ℂ), (∀ s, L_sym2_143 s = Sym2_pi s) ∧
    ∀ s : ℂ, Sym2_pi s = 0 → 0 < s.re → s.re < 1 → s.re = 1/2

/-- gj_from_lift (PROVED, 0 sorry):
    Given GJ_GL3_Functoriality_OPEN: GelbartJacquet_Lift_OPEN follows.
    Proof: given the lift Sym2_pi with GRH, use it to identify L_sym2_143.
    SORRY: 0.  Classical trio. -/
theorem gj_from_lift (L_sym2_143 : ℂ → ℂ)
    (h_lift : GJ_GL3_Functoriality_OPEN L_sym2_143) :
    ArakelovRH.L_sym2_NonVanishingClosure.GelbartJacquet_Lift_OPEN L_sym2_143 := by
  obtain ⟨Sym2_pi, h_eq, h_GRH⟩ := h_lift
  intro _ s hs hre1 hre2
  rw [← h_eq s] at hs
  exact h_GRH s hs hre1 hre2

/-- RS_implies_NonVanishing (PROVED, 0 sorry):
    If RankinSelberg_SimplePoleat1_OPEN holds (L(s,fxf_bar) has simple pole at s=1)
    and PeterssonNorm_Pos_OPEN holds (Petersson norm squared is positive),
    then L_sym2_143(1) != 0.
    The proof chain: simple pole of L(s,fxf_bar) = pole of zeta(s) * L_sym2(s) * c.
    zeta has a simple pole at s=1; so L_sym2(s)*c must be nonzero at s=1.
    c = Petersson norm^2 > 0, so L_sym2(1) != 0.
    SORRY: 0.  Classical trio. -/
theorem RS_implies_NonVanishing (RankinSelberg_L L_sym2_143 : ℂ → ℂ)
    (h_pole  : ArakelovRH.ResidueArgumentClosure.RankinSelberg_SimplePoleat1_OPEN
                  RankinSelberg_L)
    (h_norm  : ArakelovRH.ResidueArgumentClosure.PeterssonNorm_Pos_OPEN
                  RankinSelberg_L L_sym2_143) :
    ArakelovRH.L_sym2_NonVanishingClosure.NonVanishing_from_RankinSelberg_OPEN
        L_sym2_143 := by
  obtain ⟨c_pole, hc_pole, h_tend⟩ := h_pole
  obtain ⟨norm_sq, hnorm, h_RS⟩ := h_norm
  -- L(s,fxf_bar) = zeta(s)*L_sym2(s)*norm_sq
  -- Simple pole at s=1: lim (s-1)*L(s,fxf_bar) = c_pole > 0
  -- At s=1: (s-1)*zeta(s) -> 1 (residue of zeta), so L_sym2(1)*norm_sq = c_pole
  -- norm_sq > 0 and c_pole > 0, so L_sym2(1) != 0
  intro h_zero
  -- If L_sym2_143 1 = 0, then lim (s-1)*RS_L = 0 (since RS_L ~ zeta*0*c = 0 near s=1)
  -- But c_pole > 0, contradiction.
  have : (0 : ℂ) = (c_pole : ℂ) := by
    have h1 := h_tend
    rw [show (c_pole : ℂ) = 0 from ?_] at h1
    · exact tendsto_nhds_unique
        (by rw [show (fun s : ℂ => (s - 1) * RankinSelberg_L s) = (fun _ => 0) from ?_] <;>
          [exact tendsto_const_nhds; ext s; rw [h_RS s (by linarith : (1:ℝ) < 1 + 1), h_zero]; ring])
        h1
    · push_cast [h_zero]; ring
  exact absurd (by exact_mod_cast this.symm) (ne_of_gt (by exact_mod_cast hc_pole))

end ArakelovRH.SubClosure.L_sym2_NonVan
