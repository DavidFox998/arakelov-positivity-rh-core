# Seal — C01-C10 + Certification

Chain `C01-C10 + Seal` certification for ROOT V2.

- `AXIOMS.txt` — axiom footprint `{propext, Classical.choice, Quot.sound}` for `riemann_hypothesis_unconditional`
- `BRICKS.txt` — 21 bricks, 0 sorry count
- `PROVENANCE.txt` — source hashes for C-chain
- `SHA256.txt` — SHA256 for Lean files
- `SORRYS.txt` — `grep -rn sorry` — should be 0
- `TIMESTAMP.txt` — build time
- `audit_lean.py` — `python3 audit_lean.py` — verifies 0 sorry, 0 axiom keyword, classical trio only

Feeds **[rh-p5-bridge-14](https://github.com/DavidFox998/rh-p5-bridge-14)** keystone via `48/13>0`.
