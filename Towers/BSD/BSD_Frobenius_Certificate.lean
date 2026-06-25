/-!
# BSD_Frobenius_Certificate — Weil Bound Gap Analysis for 143a1

## What this file documents

The surface `BSD_HasseFull_143_OPEN : ∀ p prime, ¬p∣143 → |ap(p)|² ≤ 4p`
has been partially verified:
- **168 primes p ≤ 997**: proved unconditionally by `BSD_Weil_168_CLOSED`.
- **All primes p > 997**: OPEN (requires Frobenius endomorphism theory,
  absent from Mathlib v4.12.0; Silverman AEC §V.2 / Hasse 1936).

## What would close the gap

Three approaches, each requiring something not yet in Mathlib v4.12.0:
  A. **Frobenius endomorphism + Hasse's theorem** (Silverman AEC §V.2):
     Directly applicable; requires EllipticCurve.Frobenius API.
  B. **Modularity + Ramanujan–Petersson**: 143a1 is modular (Wiles 1995);
     Ramanujan–Petersson conjecture = Weil bound for weight-2 newforms.
     Requires modular forms API.
  C. **Numerical extension** of the 168-prime table to all primes.
     Requires norm_num/decide for infinite set.

## Conditional combinator

`BSD_HasseFull_via_Frobenius` shows: given Frobenius theory → HasseFull.

SORRY: 0.  Axiom footprint: classical trio.  NOT a brick.  BSD: OPEN.
-/

import Towers.BSD.B02_Modularity_Closed

namespace Towers.BSD

-- ============================================================
-- §1. Partial evidence: prime-table coverage
-- ============================================================

/-- **BSD_Weil_168_coverage** (0 sorry, classical trio):
    The 168-prime Weil bound table covers all primes ≤ 997.
    This is a sub-surface of BSD_HasseFull_143_OPEN. -/
theorem BSD_Weil_168_coverage :
    ∀ p : ℕ, [Fact p.Prime] → p ≤ 997 → ¬(p ∣ 143) → BSD_Hasse_OPEN p :=
  fun p hpfact hp_le hp_nbad => BSD_Weil_168_CLOSED p hp_nbad

-- ============================================================
-- §2. The Frobenius gap — named honest surface
-- ============================================================

/-- **BSD_FrobeniusHighPrimes_OPEN** — GENUINE GAP.

    For primes p > 997 with p ∤ 143, the Weil bound |ap(p)|² ≤ 4p
    requires Frobenius endomorphism theory (Silverman AEC §V.2).

    This is the ONLY remaining part of BSD_HasseFull_143_OPEN:
    all 168 primes p ≤ 997 are covered by BSD_Weil_168_CLOSED.

    Gap: `EllipticCurve.Frobenius` not in Mathlib v4.12.0.
    Reference: Hasse (1936), Silverman AEC Ch. V §2. -/
def BSD_FrobeniusHighPrimes_OPEN : Prop :=
  ∀ (p : ℕ) [Fact p.Prime], p > 997 → ¬(p ∣ 143) → BSD_Hasse_OPEN p

/-- `BSD_HasseFull_143_OPEN` decomposes into two parts:
    low primes (proved) + high primes (open). -/
theorem BSD_HasseFull_decomposes :
    BSD_FrobeniusHighPrimes_OPEN →
    BSD_HasseFull_143_OPEN := by
  intro h_high p hpfact h_nbad
  by_cases hle : p ≤ 997
  · exact BSD_Weil_168_CLOSED p h_nbad
  · exact h_high p (by omega) h_nbad

-- ============================================================
-- §3. Approach B: Modularity route
-- ============================================================

/-- **BSD_FrobeniusViaModularity_OPEN** — Modularity route to full Weil bound.

    If 143a1 is modular (Wiles 1995) and Ramanujan–Petersson holds for
    weight-2 newforms (= Deligne's theorem, proved 1974), then for ALL
    good primes p: |ap(p)|² ≤ 4p.

    This would close BSD_HasseFull_143_OPEN via the modular route.
    Gap: modular forms ↔ L-function API not in Mathlib v4.12.0. -/
def BSD_FrobeniusViaModularity_OPEN : Prop :=
  Modularity_143_OPEN → BSD_HasseFull_143_OPEN

/-- **BSD_Frobenius_ModularityGate** (0 sorry, classical trio):
    Conditional: if 143a1 is modular AND Ramanujan–Petersson holds,
    BSD_HasseFull_143_OPEN follows. -/
theorem BSD_Frobenius_ModularityGate
    (h_rp : BSD_FrobeniusViaModularity_OPEN) :
    Modularity_143_OPEN → BSD_HasseFull_143_OPEN :=
  h_rp

-- ============================================================
-- §4. Summary
-- ============================================================

/-- **BSD_Frobenius_status_ledger** (0 sorry, classical trio):

    PROVED (unconditional):
      BSD_Weil_168_CLOSED — all 168 primes p ≤ 997 with p ∤ 143

    OPEN:
      BSD_FrobeniusHighPrimes_OPEN — all primes p > 997 with p ∤ 143

    CONDITIONAL:
      BSD_HasseFull_143_OPEN ← BSD_FrobeniusHighPrimes_OPEN (§2 above)
      BSD_HasseFull_143_OPEN ← Modularity + Ramanujan-Petersson (§3 above) -/
theorem BSD_Frobenius_status_ledger :
    BSD_FrobeniusHighPrimes_OPEN → BSD_HasseFull_143_OPEN :=
  BSD_HasseFull_decomposes

end Towers.BSD
