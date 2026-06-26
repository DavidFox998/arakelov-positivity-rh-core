#!/usr/bin/env python3
"""
Seal/audit_lean.py  Opera Numerorum audit tool, David Fox, June 2026.

Strips /- ... -/ block comments and -- line comments BEFORE scanning.
SHA-bound doc-strings contain "0 sorry", "no native_decide" etc. as
provenance text.  These are NOT violations.  Only proof-code occurrences
count.

Usage:
    python3 Seal/audit_lean.py [file.lean ...]   # specific files
    python3 Seal/audit_lean.py                   # all ArakelovRH/**/*.lean

Exit 0 = clean.  Exit 1 = violations found.
"""
import re, sys, os, glob

def strip_comments(src):
    # Preserve line count: replace block-comment interior with blank lines
    def blk(m):
        return "\n" * m.group().count("\n")
    src = re.sub(r"/-.*?-/", blk, src, flags=re.DOTALL)
    # Strip line comments
    cleaned = []
    for line in src.splitlines():
        idx = line.find("--")
        cleaned.append(line[:idx] if idx >= 0 else line)
    return "\n".join(cleaned)

RULES = {
    "sorry":          re.compile(r"\bsorry\b"),
    "native_decide":  re.compile(r"\bnative_decide\b"),
    "opaque":         re.compile(r"\bopaque\b"),
    "axiom_kw":       re.compile(r"^[ \t]*axiom\b", re.MULTILINE),
}

def audit(path):
    try:
        src = open(path).read()
    except FileNotFoundError:
        return [f"NOT FOUND: {path}"]
    code = strip_comments(src)
    hits = []
    for name, pat in RULES.items():
        for m in pat.finditer(code):
            lineno = code[: m.start()].count("\n") + 1
            snippet = code.splitlines()[lineno - 1].strip()[:80]
            hits.append(f"  [{name}] line {lineno}: {snippet}")
    return hits

def main():
    files = sys.argv[1:]
    if not files:
        files = sorted(set(
            glob.glob("ArakelovRH/**/*.lean", recursive=True)
            + glob.glob("ArakelovRH/*.lean")
            + glob.glob("*.lean")
        ))
    total = 0
    for p in files:
        h = audit(p)
        if h:
            print(f"FAIL  {os.path.basename(p)}")
            for line in h:
                print(line)
            total += len(h)
        else:
            print(f"CLEAN {os.path.basename(p)}")
    print()
    print(f"Violations in proof code: {total}")
    print("(Doc-string 'sorry'/'native_decide' inside /- ... -/ are excluded by design.)")
    sys.exit(1 if total else 0)

if __name__ == "__main__":
    main()
