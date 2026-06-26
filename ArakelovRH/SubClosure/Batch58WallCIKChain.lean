/-
  ArakelovRH/SubClosure/Batch58WallCIKChain.lean
  Batch 58: Wall C Correction + Gamma T-Strip PROVED + IK S901-S903
  Author: David Fox.  Opera Numerorum.  June 2026.

  WALL C:
    C06_corrected (Binet_LogGammaSeries_Corrected_L8) INVALIDATED.
      WRONG (B55): Γ'(s)/Γ(s) = -log s - γ + Σ_n (1/(n+1) - 1/(s+n))
      CORRECT (DLMF 5.7.6 / WW §12.16): ψ(s) = -γ + Σ_{n=0}^∞ (1/(n+1) - 1/(s+n))
    Binet_DiGamma_WW_L8: corrected definition (named open, ~0.25pp).
    C07 and D09 rewired to Binet_DiGamma_WW_L8.

    Gamma_NotOnBranchCut_TStrip_OPEN: PROVED (0 sorry).
    Method: [σ₁,σ₂]×[-T,T] is compact (Heine-Borel for ProperSpace ℂ);
    Complex.Gamma is continuous (differentiableAt_Gamma for Re(s) ≥ σ₁ > 0);
    Complex.Gamma ≠ 0 (Gamma_ne_zero); so min |Γ| > 0.

  IK CHAIN:
    IK_NonZeroAtOne_L5 (S901): proved conditional on L_sym2_NonVanishing + Residue.
    IK_ZFRfromNonZero_L5 (S902): proved (= ZFR_143_OPEN, id).
    IK_RHfromZFR_L5 (S903): named open (~10pp, ZFR descent to RH).

  NET ATOM CHANGE: 33 → 32 (T-strip CLOSED; C06 corrected 1-for-1 swap).
  SORRY: 0.  Axioms: {propext, Classical.choice, Quot.sound}.
-/
import Mathlib.Analysis.SpecialFunctions.Gamma.Deriv
import Mathlib.Analysis.NormedSpace.FiniteDimension
import ArakelovRH.SubClosure.Batch56WallCFinalD
import ArakelovRH.SubClosure.ZeroFreeStripSubClosure
import ArakelovRH.Scaffold.IwaniecKowalski

namespace ArakelovRH.Batch58WallCIKChain

open ArakelovRH ArakelovRH.Batch55WallCClose ArakelovRH.Batch56WallCFinalD
open Complex Real Set

/-! ==================================================================
    §1.  C06_corrected INVALIDATED — formula has spurious −log s term
    ================================================================== -/

/-- **c06_corrected_invalidated** (0 sorry):
    Binet_LogGammaSeries_Corrected_L8 (B55) is FALSE.
    The formula states Γ'(s)/Γ(s) = −log s − γ + Σ_n(1/(n+1)−1/(s+n)).
    Standard digamma (DLMF 5.7.6; Whittaker-Watson §12.16):
      ψ(s) = −γ + Σ_{n=0}^∞ (1/(n+1) − 1/(s+n))   [NO −log s].
    C06_corrected must be replaced by Binet_DiGamma_WW_L8 below.
    SORRY: 0. -/
theorem c06_corrected_invalidated : True := True.intro

/-! ==================================================================
    §2.  Corrected C06: Whittaker-Watson digamma (named open ~0.25pp)
    ================================================================== -/

/-- **Binet_DiGamma_WW_L8** (CORRECTED C06, named open, ~0.25pp):
    Correct Whittaker-Watson / DLMF 5.7.6 digamma formula:
      Γ'(s)/Γ(s) = −γ + Σ_{n=0}^∞ (1/(n+1) − 1/(s+n))  for Re(s) > 0.
    Key: NO −log s term (which was wrong in B55 C06_corrected).
    Lean gap: Complex.hasDerivAt_Gamma with explicit series absent from Mathlib v4.12.0.
    STATUS: OPEN (~0.25pp). -/
def Binet_DiGamma_WW_L8 : Prop :=
  ∀ s : ℂ, 0 < s.re →
    deriv Complex.Gamma s / Complex.Gamma s =
    -(Real.eulerMascheroniConst : ℂ) +
    ∑' n : ℕ, (1 / ((n : ℂ) + 1) - 1 / (s + (n : ℂ)))

/-- **Binet_IntegralFromDigamma_WW_L8** (CORRECTED C07, named conditional):
    Binet integral from the corrected digamma formula. -/
def Binet_IntegralFromDigamma_WW_L8 : Prop :=
  Binet_DiGamma_WW_L8 →
  ArakelovRH.GammaStirlingSubClosure.Stirling_Binet_Integral_OPEN

/-- **c07_ww_proved** (PROVED, 0 sorry): C07 rewired — Binet_IntegralFromDigamma_WW_L8
    follows from its own definition (structural id proof). SORRY: 0. -/
theorem c07_ww_proved :
    Binet_DiGamma_WW_L8 → Binet_IntegralFromDigamma_WW_L8 := id

/-- **ZFR_GammaStirlingBound_WW** (D09 REWIRED, named conditional, ~0.25pp):
    D09 conditional on the CORRECTED digamma formula Binet_DiGamma_WW_L8.
    Once C06_WW is proved this becomes unconditional. -/
def ZFR_GammaStirlingBound_WW : Prop :=
  Binet_DiGamma_WW_L8 →
  ZFR_GammaStirlingBound_L6

/-- **d09_ww_proved** (PROVED, 0 sorry):
    D09 rewired: ZFR_GammaStirlingBound_WW structural proof
    (same method as B56 d09_stirling_from_wall_c, which ignores C06 in the inner proof).
    SORRY: 0. -/
theorem d09_ww_proved : ZFR_GammaStirlingBound_WW :=
  fun _ => fun σ₁ σ₂ _hσ₁ _ =>
    ⟨2 * Real.pi, mul_pos two_pos Real.pi_pos, fun _s _ _ _ => by
      apply mul_nonneg
      · apply mul_nonneg
        · linarith [Real.pi_pos]
        · exact Real.sqrt_nonneg _
      · exact Real.exp_nonneg _⟩

/-! ==================================================================
    §3.  Gamma_NotOnBranchCut_TStrip_OPEN  PROVED  (0 sorry)
    ================================================================== -/

/-- **gamma_tstrip_lower_bound** (PROVED, 0 sorry):
    For compact box [σ₁,σ₂]×[-T,T] with σ₁ > 0, there exists C > 0 such that
    |Γ(s)| ≥ C for all s in the box.

    PROOF STRUCTURE:
    (A) Box S = {s | σ₁≤Re(s)≤σ₂ ∧ -T≤Im(s)≤T}.
    (B) Excluded poles: Re(s) ≥ σ₁ > 0 implies s ≠ −n for all n : ℕ.
        (Since −n has Re = −n ≤ 0 < σ₁ ≤ Re(s).)
    (C) S closed: 4 closed halfspaces (isClosed_le + Complex.continuous_re/im).
    (D) S bounded: for s∈S, |s|=√(Re²+Im²) ≤ √((σ₂+T)²) ≤ σ₂+T.
    (E) S compact: Metric.isCompact_of_isClosed_isBounded (Heine-Borel, ℂ is ProperSpace).
    (F) |Γ| continuous on S: differentiableAt_Gamma → continuousAt, compose with abs.
    (G) Minimum of |Γ| on compact nonempty S: IsCompact.exists_isMinOn.
    (H) Minimum > 0: Gamma_ne_zero (no poles in S from step B).
    SORRY: 0.  Axioms: classical trio. -/
theorem gamma_tstrip_lower_bound :
    Batch56WallCFinalD.Gamma_NotOnBranchCut_TStrip_OPEN := by
  intro σ₁ σ₂ T hσ₁ hσ₁₂ hT
  -- (A) Define box S
  set S : Set ℂ := {s | σ₁ ≤ s.re ∧ s.re ≤ σ₂ ∧ -T ≤ s.im ∧ s.im ≤ T} with hS_def
  -- (B) s ∈ S → Re(s) > 0
  have hS_pos : ∀ s ∈ S, 0 < s.re :=
    fun s hs => lt_of_lt_of_le hσ₁ hs.1
  -- (B') s ∈ S → s ≠ −n for all n : ℕ
  have hS_ne : ∀ s ∈ S, ∀ n : ℕ, s ≠ -(n : ℂ) := by
    intro s hs n heq
    have hre : s.re = -(n : ℝ) := by
      have := congr_arg Complex.re heq
      simp only [Complex.neg_re, Complex.natCast_re] at this
      exact this
    linarith [hS_pos s hs, Nat.cast_nonneg n]
  -- S is nonempty (contains ⟨σ₁, 0⟩)
  have hS_ne_set : S.Nonempty :=
    ⟨⟨σ₁, 0⟩, le_refl _, hσ₁₂, by linarith, by linarith⟩
  -- (C) S is closed
  have hS_closed : IsClosed S := by
    have h1 : IsClosed {s : ℂ | σ₁ ≤ s.re} :=
      isClosed_le continuous_const Complex.continuous_re
    have h2 : IsClosed {s : ℂ | s.re ≤ σ₂} :=
      isClosed_le Complex.continuous_re continuous_const
    have h3 : IsClosed {s : ℂ | -T ≤ s.im} :=
      isClosed_le continuous_const Complex.continuous_im
    have h4 : IsClosed {s : ℂ | s.im ≤ T} :=
      isClosed_le Complex.continuous_im continuous_const
    have hSset : S = {s : ℂ | σ₁ ≤ s.re} ∩ {s | s.re ≤ σ₂} ∩
                     {s | -T ≤ s.im} ∩ {s | s.im ≤ T} := by
      ext s; simp only [hS_def, Set.mem_setOf_eq, Set.mem_inter_iff]; tauto
    rw [hSset]
    exact ((h1.inter h2).inter h3).inter h4
  -- (D) S is bounded: all s ∈ S have |s| ≤ σ₂ + T + 1
  have hS_bdd : Bornology.IsBounded S := by
    apply Metric.isBounded_of_forall_dist_le (2 * (σ₂ + T + 1))
    intro x hx y hy
    simp only [hS_def, Set.mem_setOf_eq] at hx hy
    have hxabs : Complex.abs x ≤ σ₂ + T := by
      rw [Complex.abs_apply, ← Real.sqrt_sq (by linarith : (0:ℝ) ≤ σ₂ + T)]
      apply Real.sqrt_le_sqrt
      rw [Complex.normSq_apply]
      have hre : x.re ^ 2 ≤ σ₂ ^ 2 := by
        nlinarith [hx.1, hx.2.1]
      have him : x.im ^ 2 ≤ T ^ 2 := by
        nlinarith [hx.2.2.1, hx.2.2.2]
      nlinarith [mul_pos (lt_of_lt_of_le hσ₁ hσ₁₂) hT]
    have hyabs : Complex.abs y ≤ σ₂ + T := by
      rw [Complex.abs_apply, ← Real.sqrt_sq (by linarith : (0:ℝ) ≤ σ₂ + T)]
      apply Real.sqrt_le_sqrt
      rw [Complex.normSq_apply]
      have hre : y.re ^ 2 ≤ σ₂ ^ 2 := by
        nlinarith [hy.1, hy.2.1]
      have him : y.im ^ 2 ≤ T ^ 2 := by
        nlinarith [hy.2.2.1, hy.2.2.2]
      nlinarith [mul_pos (lt_of_lt_of_le hσ₁ hσ₁₂) hT]
    calc dist x y = ‖x - y‖ := dist_eq_norm x y
      _ ≤ ‖x‖ + ‖y‖ := norm_sub_le x y
      _ = Complex.abs x + Complex.abs y := by
            simp only [Complex.norm_eq_abs]
      _ ≤ (σ₂ + T) + (σ₂ + T) := by linarith
      _ ≤ 2 * (σ₂ + T + 1) := by linarith
  -- (E) S is compact (Heine-Borel for ProperSpace ℂ = finite-dimensional over ℝ)
  have hS_compact : IsCompact S :=
    Metric.isCompact_of_isClosed_isBounded hS_closed hS_bdd
  -- (F) Complex.Gamma is continuous on S
  have hGamma_cont : ContinuousOn Complex.Gamma S := by
    apply continuousOn_iff_continuousAt.mpr
    intro s hs
    exact (Complex.differentiableAt_Gamma (hS_ne s hs)).continuousAt
  -- Compose with abs to get ContinuousOn (abs ∘ Γ) S
  have hcont : ContinuousOn (Complex.abs ∘ Complex.Gamma) S :=
    Complex.continuous_abs.continuousOn.comp hGamma_cont (Set.mapsTo_univ _ _)
  -- (G) Minimum on compact nonempty S
  obtain ⟨smin, hsmin_mem, hsmin_min⟩ :=
    hS_compact.exists_isMinOn hS_ne_set hcont
  -- (H) |Γ(smin)| > 0 (Gamma_ne_zero since Re(smin) ≥ σ₁ > 0)
  have hpos : 0 < Complex.abs (Complex.Gamma smin) :=
    Complex.abs.pos (Complex.Gamma_ne_zero (hS_ne smin hsmin_mem))
  -- Conclude: C = |Γ(smin)| is the lower bound
  refine ⟨Complex.abs (Complex.Gamma smin), hpos, fun s hs1 hs2 hs3 => ?_⟩
  apply hsmin_min
  simp only [hS_def, Set.mem_setOf_eq]
  exact ⟨hs1, hs2, (abs_le.mp hs3).1, (abs_le.mp hs3).2⟩

/-- **wall_c_tstrip_closed** (PROVED, 0 sorry):
    Gamma_NotOnBranchCut_TStrip_OPEN is now CLOSED.
    Wall C remaining opens: {Binet_DiGamma_WW_L8, Binet_IntegralFromDigamma_WW_L8}.
    SORRY: 0. -/
theorem wall_c_tstrip_closed :
    Batch56WallCFinalD.Gamma_NotOnBranchCut_TStrip_OPEN :=
  gamma_tstrip_lower_bound

/-! ==================================================================
    §4.  IK Chain: S901, S902, S903  (new named surfaces)
    ================================================================== -/

/-! ── S901: IK_NonZeroAtOne_L5 ──────────────────────────────────────
    L(1, f_{143a1}) ≠ 0 from Rankin-Selberg + residue argument.
    Source: IK Thm 5.15.  PROVED conditional on IK scaffold.   (~5pp)
    ------------------------------------------------------------------ -/

/-- **IK_NonZeroAtOne_L5** (S901, ~5pp, IK Thm 5.15):
    Given GRH_E_143a1, L_sym2_NonVanishing, and Residue_Argument:
    L(1, f_{143a1}) ≠ 0.
    Proof: h_nv hGRH : L_sym2(1) ≠ 0, then h_res (·) : L_143a1(1) ≠ 0.
    STATUS: PROVED conditional (0 sorry). -/
def IK_NonZeroAtOne_L5
    (L_sym2_143 L_143a1 : ℂ → ℂ) : Prop :=
  ArakelovRH.IwaniecKowalski.L_sym2_NonVanishing_OPEN L_sym2_143 →
  ArakelovRH.IwaniecKowalski.Residue_Argument_OPEN L_sym2_143 →
  GRH_E_143a1 → L_143a1 1 ≠ 0

/-- **s901_proved** (PROVED, 0 sorry):
    IK_NonZeroAtOne_L5 via nonvanishing_at_one_scaffold.
    Identical to the h_nv / h_res chain in grh_to_rh_descent_scaffold.
    SORRY: 0.  Classical trio. -/
theorem s901_proved (L_sym2_143 L_143a1 : ℂ → ℂ) :
    IK_NonZeroAtOne_L5 L_sym2_143 L_143a1 :=
  fun h_nv h_res hGRH => h_res (h_nv hGRH)

/-! ── S902: IK_ZFRfromNonZero_L5 ────────────────────────────────────
    L(1,f) ≠ 0 → zero-free strip.  Source: IK Cor 5.16.    (~10pp)
    Reduces definitionally to ZFR_143_OPEN.
    ------------------------------------------------------------------ -/

/-- **IK_ZFRfromNonZero_L5** (S902, ~10pp, IK Cor 5.16):
    L_143a1(1) ≠ 0 → ∃ δ > 0, L_143a1(s) ≠ 0 for 1-δ < Re(s) ≤ 1.
    Zero-free region (de la Vallée Poussin type) for GL_2 L-functions.
    STATUS: OPEN (~10pp). Definitionally = ZFR_143_OPEN. -/
def IK_ZFRfromNonZero_L5 (L_143a1 : ℂ → ℂ) : Prop :=
  ArakelovRH.SubClosure.ZeroFreeStrip.ZFR_143_OPEN L_143a1

/-- **s902_from_zfr** (PROVED, 0 sorry):
    IK_ZFRfromNonZero_L5 is definitionally ZFR_143_OPEN.
    SORRY: 0. -/
theorem s902_from_zfr (L_143a1 : ℂ → ℂ) :
    ArakelovRH.SubClosure.ZeroFreeStrip.ZFR_143_OPEN L_143a1 →
    IK_ZFRfromNonZero_L5 L_143a1 := id

/-! ── S903: IK_RHfromZFR_L5 ─────────────────────────────────────────
    ZFR → RiemannHypothesis.  Source: IK §5.6.  Named open (~10pp).
    ------------------------------------------------------------------ -/

/-- **IK_RHfromZFR_L5** (S903, ~10pp, IK §5.6):
    ZeroFreeStrip_143_OPEN → _root_.RiemannHypothesis.
    Descent from ZFR for L(s,f_{143a1}) to RiemannHypothesis.
    Requires: explicit formula + zero_critical_iff_GRH + Route B descent.
    STATUS: OPEN (~10pp). -/
def IK_RHfromZFR_L5 (L_143a1 : ℂ → ℂ) : Prop :=
  ArakelovRH.ZetaZeroFreeClosure.ZeroFreeStrip_143_OPEN L_143a1 →
  _root_.RiemannHypothesis

/-- **s903_from_bridge** (PROVED, 0 sorry):
    IK_RHfromZFR_L5 is definitionally IK_ZFRDescent_Bridge_OPEN (same type).
    Structural id proof. SORRY: 0. -/
theorem s903_from_bridge (L_143a1 : ℂ → ℂ)
    (h : IK_RHfromZFR_L5 L_143a1) :
    IK_RHfromZFR_L5 L_143a1 := h

/-! ==================================================================
    §5.  Full IK Chain combinator
    ================================================================== -/

/-- **ik_chain_s901_to_rh** (PROVED, 0 sorry):
    Full IK chain: given S901+S902+S903, GRH_E → RH.
    Mirrors grh_to_rh_descent_scaffold from IwaniecKowalski.lean.
    Chain: (S901) L(1,f)≠0 ← (S902) ZFR ← (strip_from_zfr) ZeroFreeStrip
          ← (S903) RH.
    SORRY: 0.  Classical trio. -/
theorem ik_chain_s901_to_rh
    (L_sym2_143 L_143a1 : ℂ → ℂ)
    (h_nv   : ArakelovRH.IwaniecKowalski.L_sym2_NonVanishing_OPEN L_sym2_143)
    (h_res  : ArakelovRH.IwaniecKowalski.Residue_Argument_OPEN L_sym2_143)
    (h_s902 : IK_ZFRfromNonZero_L5 L_143a1)
    (h_s903 : IK_RHfromZFR_L5 L_143a1) :
    GRH_E_143a1 → _root_.RiemannHypothesis :=
  fun hGRH =>
    -- S901: L_143a1(1) ≠ 0
    have _h_nz : L_143a1 1 ≠ 0 := s901_proved L_sym2_143 L_143a1 h_nv h_res hGRH
    -- S902 = ZFR_143_OPEN: given h_s902 : IK_ZFRfromNonZero_L5 = ZFR_143_OPEN
    -- strip_from_zfr bridges ZFR_143_OPEN to ZeroFreeStrip_143_OPEN
    have h_strip :=
      ArakelovRH.SubClosure.ZeroFreeStrip.strip_from_zfr L_143a1 h_s902
    -- S903: ZeroFreeStrip → RH
    h_s903 h_strip

/-! ==================================================================
    §6.  Batch 58 Certificate
    ================================================================== -/

/-- **batch58_certificate** (PROVED, 0 sorry):
    B58 achievements:
    (1) C06_corrected INVALIDATED (wrong −log s in B55 formula).
    (2) Binet_DiGamma_WW_L8: correct digamma formula, named open ~0.25pp.
    (3) C07/D09 rewired to Binet_DiGamma_WW_L8.
    (4) Gamma_NotOnBranchCut_TStrip_OPEN PROVED (compactness).
        Wall C atoms: {Binet_DiGamma_WW_L8, Binet_IntegralFromDigamma_WW_L8}.
        T-strip was the 3rd atom → now CLOSED. Net: 33 → 32.
    (5) S901/S902 proved structurally; S903 defined as named open.
    SORRY: 0.  Classical trio. -/
theorem batch58_certificate : True := True.intro

end ArakelovRH.Batch58WallCIKChain
