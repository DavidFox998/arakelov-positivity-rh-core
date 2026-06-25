import Towers.BSD.BSD_MasterProof
import Towers.BSD.BSD_ClassNumberBounds
import Towers.BSD.BSD_ClassNumberLowerProof
import Mathlib.RingTheory.ClassGroup
import Mathlib.GroupTheory.OrderOfElement

/-!
# BSD_OrderOf_CLOSED — Milestone 5.6: ClassGroup OrderOf surface closures

Closes three `_OPEN` surfaces about the order of [𝔭₂] in `ClassGroup(𝓞 K)`.

## Mathematical content

**`EvenK_NonPrincipal_Bridge_CLOSED`** (alias):
  `EvenK_NonPrincipal_Bridge_p2_OK` was already proved by `EvenK_NonPrincipal_Bridge_proof`
  in `BSD_ClassNumberLowerProof.lean` (§7d). Proof: for k ∈ {2,4,6,8}, if p₂^k were
  principal with generator u = (a,b), then b=0 forces a²=2^k and a ∣ repr(ω^k)_1. But
  repr(ω^2)_1=1, repr(ω^4)_1=-71, repr(ω^6)_1=3745, repr(ω^8)_1=-173879 are all
  non-divisible by 2, 4, 8, 16 respectively. Contradiction.

**`BSD_orderOf_p2_CLOSED`** (explicit witness):
  `BSD_orderOf_p2_OPEN := ∃ p2 : ClassGroup (𝓞 K), 10 ≤ orderOf p2`.
  Witness: `g := ClassGroup.mk0 ⟨p₂_OK, _⟩`. For any k ∈ {1,...,9},
  `g^k = 1` would imply `p₂^k` principal — proved impossible by
  `master_not_principal_1_to_9`. So `orderOf g ≥ 10`.

  This extracts steps 1-4 of `BSD_classNumber_lower_bound` (BSD_MasterProof §3)
  into a standalone `∃` statement, using only public theorems.

**`ClassGroup_OrderOf_Bridge_CLOSED`**:
  `ClassGroup_OrderOf_Bridge_p2_OK := EvenK_NonPrincipal_Bridge_p2_OK → ∃ p2, 10 ≤ orderOf p2`.
  Immediate: the conclusion holds unconditionally (BSD_orderOf_p2_CLOSED), so the
  implication is trivially true.

## SORRY: 0   ## AXIOMS: classical trio only
-/

namespace Towers.BSD

open NumberField

/-- **CLOSED — EvenK non-principality** (Milestone 5.6):
    For k ∈ {2,4,6,8}, `p2_OK^k` is NOT principal in `Ideal (𝓞 K)`.

    Proof: `EvenK_NonPrincipal_Bridge_proof` (BSD_ClassNumberLowerProof.lean §7d, 0 sorry).
    Strategy: each k forces a²=2^k and a ∣ repr(nω^k)_1, but the repr values
    1, -71, 3745, -173879 are non-divisible by 2, 4, 8, 16 respectively. -/
theorem EvenK_NonPrincipal_Bridge_CLOSED : EvenK_NonPrincipal_Bridge_p2_OK :=
  EvenK_NonPrincipal_Bridge_proof

/-- **CLOSED — orderOf [𝔭₂] ≥ 10** (Milestone 5.6):
    `∃ p2 : ClassGroup (𝓞 K), 10 ≤ orderOf p2`.

    Explicit witness: `g := ClassGroup.mk0 ⟨p₂_OK, _⟩`.
    For any k ∈ {1,...,9}: `g^k = 1` ↔ `p₂^k` principal ↔ FALSE
    (by `master_not_principal_1_to_9` for odd k and EvenK bridge for even k).
    Therefore `orderOf g ≥ 10`.

    This is the explicit extraction of steps 1-4 of `BSD_classNumber_lower_bound`. -/
theorem BSD_orderOf_p2_CLOSED : BSD_orderOf_p2_OPEN := by
  have hp2_ne : (p2_OK : Ideal (𝓞 K)) ≠ 0 := by
    intro h
    have h2 := absNorm_p2_eq_2
    rw [h, Ideal.zero_eq_bot, Ideal.absNorm_bot] at h2
    norm_num at h2
  have hp₂_mem : p2_OK ∈ (Ideal (𝓞 K))⁰ :=
    mem_nonZeroDivisors_iff_ne_zero.mpr hp2_ne
  let I₂ : (Ideal (𝓞 K))⁰ := ⟨p2_OK, hp₂_mem⟩
  let g : ClassGroup (𝓞 K) := ClassGroup.mk0 I₂
  refine ⟨g, ?_⟩
  by_contra hlt
  push_neg at hlt
  have hlt9 : orderOf g ≤ 9 := Nat.lt_succ_iff.mp hlt
  have hpos : 0 < orderOf g := orderOf_pos g
  have hpow_ne : ∀ k : ℕ, 1 ≤ k → k ≤ 9 → g ^ k ≠ 1 := by
    intro k hk1 hk9 hgk
    have hmap : g ^ k = ClassGroup.mk0 (I₂ ^ k) :=
      (map_pow (ClassGroup.mk0 (R := 𝓞 K)) I₂ k).symm
    have hcoe : (↑(I₂ ^ k) : Ideal (𝓞 K)) = p2_OK ^ k := by
      simp only [SubmonoidClass.coe_pow, I₂]
    have hprinc : (↑(I₂ ^ k) : Ideal (𝓞 K)).IsPrincipal :=
      (ClassGroup.mk0_eq_one_iff (I₂ ^ k).prop).mp (hmap ▸ hgk)
    exact master_not_principal_1_to_9 k hk1 hk9 (hcoe ▸ hprinc)
  exact hpow_ne (orderOf g) hpos hlt9 (pow_orderOf_eq_one g)

/-- **CLOSED — ClassGroup OrderOf bridge** (Milestone 5.6):
    `ClassGroup_OrderOf_Bridge_p2_OK :=
      EvenK_NonPrincipal_Bridge_p2_OK → ∃ p2 : ClassGroup (𝓞 K), 10 ≤ orderOf p2`.

    Proof: the consequent holds unconditionally (`BSD_orderOf_p2_CLOSED`), so
    the implication is trivially true regardless of the antecedent. -/
theorem ClassGroup_OrderOf_Bridge_CLOSED : ClassGroup_OrderOf_Bridge_p2_OK :=
  fun _ => BSD_orderOf_p2_CLOSED

/-- **Milestone 5.6 OrderOf surface ledger**: all 3 ClassGroup order surfaces closed.
    No sorry, classical trio only. -/
theorem BSD_OrderOf_all_CLOSED :
    EvenK_NonPrincipal_Bridge_p2_OK ∧
    BSD_orderOf_p2_OPEN ∧
    ClassGroup_OrderOf_Bridge_p2_OK :=
  ⟨EvenK_NonPrincipal_Bridge_proof, BSD_orderOf_p2_CLOSED, ClassGroup_OrderOf_Bridge_CLOSED⟩

/-- Open surface count for OrderOf module: 0 (all 3 closed at Milestone 5.6). -/
def BSD_OrderOf_open_count : ℕ := 0

end Towers.BSD
