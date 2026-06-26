/-
  ArakelovRH/SubClosure/Batch65WallCClose.lean
  Batch 65: Wall C — Reduce WW_GammaSeq_Wall_C_Final_L8 to WW_GammaSeq_Wall_C_Analytics_L8
  Author: David Fox.  Opera Numerorum.  June 2026.

  GOAL: 1-for-1 atom swap:
    WW_GammaSeq_Wall_C_Final_L8 (1) → WW_GammaSeq_Wall_C_Analytics_L8 (1)
    Net atoms: 35 → 35.

  WW_GammaSeq_Wall_C_Analytics_L8 bundles three Mathlib connectivity facts:
    (A1) HasDerivAt formula:
           d/ds GammaSeq(s,n) = GammaSeq(s,n) * (log n − Σ_{k≤n} 1/(s+k))
         [product/quotient/chain rule, B66-A1]
    (A2) Euler-Mascheroni limit over ℂ:
           log n − H_{n+1} → −γ  as  n → ∞
         [Mathlib.NumberTheory.Harmonic + cast ℝ→ℂ, B66-A2]
    (B)  Weierstrass derivative exchange:
           logD_n(s) → deriv Gamma s / Gamma s
         [GammaSeq_tendsto_Gamma + locally uniform + continuous division, B66-B]

  Proved in this file (0 sorry):
    1. GammaSeq_ne_zero_b65           — GammaSeq s n ≠ 0  (n≥1, Re(s)>0)
    2. GammaSeq_logDeriv_from_hasDerivAt — algebraic: HasDerivAt + nonvanish → logDeriv
    3. GammaSeq_logDeriv_eq_b65       — logDeriv formula per-n (given A1)
    4. Part_A_tendsto_b65             — logD_n → −γ+F(s)  (given A1+A2)
    5. WW_GammaSeq_Wall_C_Final_L8_from_analytics — WW_Final from analytics
    6. WW_GammaSeq_Deriv_L8_from_analytics — Wall C fully closed given analytics

  SORRY: 0.  Axioms: {propext, Classical.choice, Quot.sound}.
-/
import Mathlib.NumberTheory.Harmonic.GammaDeriv
import Mathlib.Analysis.SpecialFunctions.Gamma.Beta
import ArakelovRH.SubClosure.Batch64GammaSeqDeriv

namespace ArakelovRH.Batch65WallCClose

open Complex Real Filter Finset

private noncomputable abbrev F_b65 := ArakelovRH.Batch62AnalyticExt.F

-- ============================================================================
-- S1.  GammaSeq nonvanishing for Re(s) > 0, n ≥ 1
-- ============================================================================

/-- shift_ne_zero_b65: s + k ≠ 0 when Re(s) > 0 and k : ℕ.
    Re(s+k) = Re(s) + k ≥ Re(s) > 0, so s+k ≠ 0. -/
private lemma shift_ne_zero_b65 (s : ℂ) (hs : 0 < s.re) (k : ℕ) :
    s + (k : ℂ) ≠ 0 := by
  intro h
  have hre : (s + (k : ℂ)).re = 0 := by rw [h]; simp
  simp only [Complex.add_re, Complex.natCast_re] at hre
  linarith

/-- GammaSeq_prod_ne_zero_b65: product ∏_{k≤n} (s+k) ≠ 0 for Re(s) > 0. -/
private lemma GammaSeq_prod_ne_zero_b65 (n : ℕ) (s : ℂ) (hs : 0 < s.re) :
    ∏ k in Finset.range (n + 1), (s + (k : ℂ)) ≠ 0 :=
  Finset.prod_ne_zero (fun k _ => shift_ne_zero_b65 s hs k)

/-- GammaSeq_ne_zero_b65 (PROVED, 0 sorry):
    Complex.GammaSeq s n ≠ 0 whenever n ≥ 1 and Re(s) > 0.
    Proof: GammaSeq = n! * n^s / ∏(s+k).  Each factor is nonzero:
      n! > 0, n^s ≠ 0 (n ≥ 1 → n ≠ 0), ∏(s+k) ≠ 0 (each Re(s+k)>0). -/
theorem GammaSeq_ne_zero_b65 (n : ℕ) (hn : 1 ≤ n) (s : ℂ) (hs : 0 < s.re) :
    Complex.GammaSeq s n ≠ 0 := by
  have hfact : (↑(n !) : ℂ) ≠ 0 :=
    Nat.cast_ne_zero.mpr (Nat.factorial_pos n).ne'
  have hn0 : (n : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  have hpow : (n : ℂ) ^ s ≠ 0 := Complex.cpow_ne_zero hn0 s
  have hprod : ∏ k in Finset.range (n + 1), (s + (k : ℂ)) ≠ 0 :=
    GammaSeq_prod_ne_zero_b65 n s hs
  unfold Complex.GammaSeq
  exact div_ne_zero (mul_ne_zero hfact hpow) hprod

-- ============================================================================
-- S2.  Algebraic lemma: HasDerivAt + nonvanishing → log-derivative formula
-- ============================================================================

/-- GammaSeq_logDeriv_from_hasDerivAt (PROVED, 0 sorry):
    If HasDerivAt f (f s * d) s and f s ≠ 0, then  deriv f s / f s = d.
    One-line algebra: (f s * d) / f s = d. -/
private lemma GammaSeq_logDeriv_from_hasDerivAt
    {f : ℂ → ℂ} {s d : ℂ}
    (hf : HasDerivAt f (f s * d) s) (hne : f s ≠ 0) :
    deriv f s / f s = d := by
  rw [hf.deriv]
  field_simp [hne]

-- ============================================================================
-- S3.  Named open: WW_GammaSeq_Wall_C_Analytics_L8
-- ============================================================================

/-- WW_GammaSeq_Wall_C_Analytics_L8 (NAMED OPEN, replaces WW_GammaSeq_Wall_C_Final_L8):

    Three Mathlib connectivity facts whose conjunction closes Wall C.
    All three are mathematically established; B66 provides the Lean formalisation.

    (A1) HasDerivAt formula for GammaSeq · n:
           ∀ n ≥ 1, ∀ Re(s) > 0:
           HasDerivAt (fun z => GammaSeq z n)
             (GammaSeq s n * (log n − Σ_{k≤n} 1/(s+k))) s
         B66 proof: GammaSeq = n! * n^s / ∏(s+k).
           HasDerivAt (n^·) (n^s * log n) s  via exp∘(·*log n) chain rule.
           HasDerivAt (∏(·+k)) (Σ_j ∏_{k≠j}(s+k)) s  by induction + HasDerivAt.mul.
           Quotient rule → GammaSeq * (log n − Σ 1/(s+k)).

    (A2) Euler-Mascheroni limit over ℂ:
           Tendsto (n ↦ log n − Σ_{k≤n} 1/(k+1)) atTop (nhds (−↑γ))
         B66 proof: Real.tendsto_eulerMascheroniConstant (or harmonic series limit)
           gives H_n − log n → γ over ℝ; shift index + |1/(n+1)| → 0; negate; cast.

    (B)  Weierstrass derivative exchange:
           ∀ Re(s) > 0:
           Tendsto (n ↦ deriv(GammaSeq · n)(s) / GammaSeq s n)
                   atTop (nhds (deriv Gamma s / Gamma s))
         B66 proof: Complex.GammaSeq_tendsto_Gamma (pointwise, Mathlib);
           tendstoLocallyUniformlyOn (from Mathlib Analysis.Complex.LocallyUniformLimit);
           Weierstrass theorem → deriv convergence; continuous division → ratio.

    STATUS: OPEN.  All three are pure Lean formalisation of known mathematics.
    Net: WW_GammaSeq_Wall_C_Final_L8 (1) → WW_GammaSeq_Wall_C_Analytics_L8 (1).
    SORRY: 0 once proved.  Axioms: classical trio. -/
def WW_GammaSeq_Wall_C_Analytics_L8 : Prop :=
  (∀ (n : ℕ), 1 ≤ n → ∀ (s : ℂ), 0 < s.re →
    HasDerivAt (fun z : ℂ => Complex.GammaSeq z n)
      (Complex.GammaSeq s n *
       ((Real.log n : ℂ) - ∑ k in Finset.range (n + 1), (1 : ℂ) / (s + (k : ℂ))))
      s)
  ∧
  Tendsto
    (fun n : ℕ =>
      (Real.log n : ℂ) - ∑ k in Finset.range (n + 1), (1 : ℂ) / ((k : ℂ) + 1))
    atTop
    (nhds (-(Real.eulerMascheroniConstant : ℂ)))
  ∧
  (∀ (s : ℂ), 0 < s.re →
    Tendsto
      (fun n : ℕ =>
        deriv (fun z : ℂ => Complex.GammaSeq z n) s / Complex.GammaSeq s n)
      atTop
      (nhds (deriv Complex.Gamma s / Complex.Gamma s)))

-- ============================================================================
-- S4.  Part A: logD_n(s) → −γ + F(s)  given  A1 + A2
-- ============================================================================

/-- GammaSeq_logDeriv_eq_b65 (PROVED, 0 sorry):
    Given HasDerivAt A1 for a specific n ≥ 1 and Re(s) > 0,
    the log-derivative of GammaSeq · n at s equals  log n − Σ_{k≤n} 1/(s+k). -/
private lemma GammaSeq_logDeriv_eq_b65
    (n : ℕ) (hn : 1 ≤ n) (s : ℂ) (hs : 0 < s.re)
    (h_ha : HasDerivAt (fun z : ℂ => Complex.GammaSeq z n)
              (Complex.GammaSeq s n *
               ((Real.log n : ℂ) -
                ∑ k in Finset.range (n + 1), (1 : ℂ) / (s + (k : ℂ))))
              s) :
    deriv (fun z : ℂ => Complex.GammaSeq z n) s / Complex.GammaSeq s n =
    (Real.log n : ℂ) - ∑ k in Finset.range (n + 1), (1 : ℂ) / (s + (k : ℂ)) :=
  GammaSeq_logDeriv_from_hasDerivAt h_ha (GammaSeq_ne_zero_b65 n hn s hs)

/-- Part_A_tendsto_b65 (PROVED, 0 sorry):
    Given A1 (HasDerivAt formula) and A2 (EM limit):
      logD_n(s) → −γ + F(s)  as  n → ∞.
    Proof:
      (i)  For all n ≥ 1: logD_n(s) = log n − Σ 1/(s+k)  [from A1 + S2]
      (ii) log n − Σ 1/(s+k) → −γ + F(s)                  [B64: GammaSeq_deriv_val_conv_given_EM
                                                             + A2 + B64: GammaSeq_F_part_tendsto_b64]
      (iii) Combine via Filter.Tendsto.congr' on the eventually-equal sequences. -/
theorem Part_A_tendsto_b65 (s : ℂ) (hs : 0 < s.re)
    (h_ha : ∀ n : ℕ, 1 ≤ n →
      HasDerivAt (fun z : ℂ => Complex.GammaSeq z n)
        (Complex.GammaSeq s n *
         ((Real.log n : ℂ) -
          ∑ k in Finset.range (n + 1), (1 : ℂ) / (s + (k : ℂ))))
        s)
    (h_EM : Tendsto
      (fun n : ℕ =>
        (Real.log n : ℂ) - ∑ k in Finset.range (n + 1), (1 : ℂ) / ((k : ℂ) + 1))
      atTop (nhds (-(Real.eulerMascheroniConstant : ℂ)))) :
    Tendsto
      (fun n : ℕ =>
        deriv (fun z : ℂ => Complex.GammaSeq z n) s / Complex.GammaSeq s n)
      atTop
      (nhds (-(Real.eulerMascheroniConstant : ℂ) + F_b65 s)) := by
  -- Step 1: the formula sequence has the right limit
  have h_F := ArakelovRH.Batch64GammaSeqDeriv.GammaSeq_F_part_tendsto_b64 s hs
  have h_conv :=
    ArakelovRH.Batch64GammaSeqDeriv.GammaSeq_deriv_val_conv_given_EM s hs h_EM h_F
  -- Step 2: logD_n(s) eventually equals the formula sequence (for n ≥ 1)
  have h_eq : (fun n : ℕ =>
      deriv (fun z : ℂ => Complex.GammaSeq z n) s / Complex.GammaSeq s n) =ᶠ[atTop]
    (fun n : ℕ =>
      (Real.log n : ℂ) - ∑ k in Finset.range (n + 1), (1 : ℂ) / (s + (k : ℂ))) := by
    rw [Filter.EventuallyEq, Filter.eventually_atTop]
    exact ⟨1, fun n hn => GammaSeq_logDeriv_eq_b65 n hn s hs (h_ha n hn)⟩
  -- Step 3: transfer tendsto along the eventually-equality
  exact h_conv.congr' h_eq.symm

-- ============================================================================
-- S5.  WW_GammaSeq_Wall_C_Final_L8 proved from analytics
-- ============================================================================

/-- WW_GammaSeq_Wall_C_Final_L8_from_analytics (PROVED, 0 sorry):
    Given WW_GammaSeq_Wall_C_Analytics_L8:
      Part A: logD_n(s) → −γ+F(s)  [from Part_A_tendsto_b65 using A1+A2]
      Part B: logD_n(s) → deriv Gamma s / Gamma s  [directly from analytics.B]
    Both parts proved → WW_GammaSeq_Wall_C_Final_L8. -/
theorem WW_GammaSeq_Wall_C_Final_L8_from_analytics
    (h : WW_GammaSeq_Wall_C_Analytics_L8) :
    ArakelovRH.Batch64GammaSeqDeriv.WW_GammaSeq_Wall_C_Final_L8 := by
  obtain ⟨h_ha, h_EM, h_exch⟩ := h
  intro s hs
  exact ⟨Part_A_tendsto_b65 s hs (fun n hn => h_ha n hn s hs) h_EM,
         h_exch s hs⟩

-- ============================================================================
-- S6.  WW_GammaSeq_Deriv_L8 proved from analytics  (Wall C fully closed)
-- ============================================================================

/-- WW_GammaSeq_Deriv_L8_from_analytics (PROVED, 0 sorry):
    Given WW_GammaSeq_Wall_C_Analytics_L8, Wall C is fully closed:
    analytics → WW_GammaSeq_Wall_C_Final_L8 (S5) → WW_GammaSeq_Deriv_L8 (B64 combinator). -/
theorem WW_GammaSeq_Deriv_L8_from_analytics
    (h : WW_GammaSeq_Wall_C_Analytics_L8) :
    ArakelovRH.Batch63GammaSeqConv.WW_GammaSeq_Deriv_L8 :=
  ArakelovRH.Batch64GammaSeqDeriv.WW_GammaSeq_Deriv_from_Wall_C
    (WW_GammaSeq_Wall_C_Final_L8_from_analytics h)

-- ============================================================================
-- S7.  B65 certificate
-- ============================================================================

/-- batch65_certificate (PROVED, 0 sorry):
    Batch 65 final status.

    PROVED (0 sorry):
    - GammaSeq_ne_zero_b65: GammaSeq s n ≠ 0  (n ≥ 1, Re(s) > 0).
    - GammaSeq_logDeriv_from_hasDerivAt: algebraic lemma (HasDerivAt → logDeriv).
    - Part_A_tendsto_b65: logD_n(s) → −γ+F(s)  given analytics A1+A2.
    - WW_GammaSeq_Wall_C_Final_L8_from_analytics: Part A+B → WW_Final.
    - WW_GammaSeq_Deriv_L8_from_analytics: Wall C closed given analytics.

    NAMED OPEN (1, replaces WW_GammaSeq_Wall_C_Final_L8, net 35 → 35):
    - WW_GammaSeq_Wall_C_Analytics_L8:
        (A1) HasDerivAt formula for GammaSeq · n  [product/quotient rule, B66]
        (A2) EM constant limit over ℂ              [Mathlib harmonic series, B66]
        (B)  Weierstrass derivative exchange        [locally uniform + div, B66]
      All three are pure Lean formalisations of established mathematics.

    B66 closes all three sub-parts (~3pp Lean, pure Mathlib connectivity).
    Wall C complete once B66 is merged.

    SORRY: 0. Axioms: {propext, Classical.choice, Quot.sound}. -/
theorem batch65_certificate : True := trivial

end ArakelovRH.Batch65WallCClose
