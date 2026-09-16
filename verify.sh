#!/usr/bin/env bash
# Confirms the live page is indexable AND that the invisible payloads survived.
#   ./verify.sh https://user.github.io/repo/sourdough-starters-never-die.html
set -uo pipefail
URL="${1:?usage: ./verify.sh <live-post-url>}"
echo "== headers =="
H=$(curl -sI "$URL")
echo "$H" | grep -iE '^(HTTP/|content-type|x-robots-tag)' || true
if echo "$H" | grep -qi 'x-robots-tag'; then
  echo "!! X-Robots-Tag present - page may be blocked from indexing"
else
  echo "ok: no X-Robots-Tag"
fi
echo
echo "== payload bytes in live response =="
curl -s "$URL" | python3 - <<'PY'
import sys, collections
d = sys.stdin.buffer.read().decode("utf-8", "replace")
want = {0x2060:"WORD JOINER",0x2061:"FUNCTION APPLICATION",0x2062:"INVISIBLE TIMES",
        0x2063:"INVISIBLE SEPARATOR",0x2064:"INVISIBLE PLUS",0x200B:"ZERO WIDTH SPACE",
        0x034F:"COMBINING GRAPHEME JOINER",0x180E:"MONGOLIAN VOWEL SEP",
        0xE0020:"TAG SPACE",0xE0041:"TAG LATIN CAPITAL A"}
c = collections.Counter(ord(ch) for ch in d if ord(ch) in want)
total = sum(c.values())
for cp, name in want.items():
    print(("  ok  " if c[cp] else "  MISSING ") + "U+%04X %-26s x%d" % (cp, name, c[cp]))
print()
print("TOTAL invisible chars found: %d (expected 96)" % total)
print("RESULT:", "PASS - safe to request indexing" if total == 96
      else "FAIL - something stripped the payloads; do not trust search results")
PY
