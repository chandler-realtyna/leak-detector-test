#!/usr/bin/env bash
# Fills in your GitHub Pages URL across all files.
#   ./setup.sh <github-username> <repo-name>
#   ./setup.sh <github-username>              # for a <username>.github.io repo
set -euo pipefail
U="${1:?usage: ./setup.sh <username> [repo]}"
R="${2:-}"
if [ -z "$R" ]; then BASE="https://${U}.github.io"; else BASE="https://${U}.github.io/${R}"; fi
for f in index.html sourdough-starters-never-die.html sitemap.xml robots.txt; do
  python3 - "$f" "$BASE" <<'PY'
import sys, io
p, base = sys.argv[1], sys.argv[2]
s = io.open(p, encoding="utf-8").read().replace("__BASE__", base)
io.open(p, "w", encoding="utf-8").write(s)
PY
done
echo "Base URL set to: $BASE"
echo "Post URL:        $BASE/sourdough-starters-never-die.html"
