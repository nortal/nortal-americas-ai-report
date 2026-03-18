#!/bin/sh
# migrate-to-encrypted.sh — One-time migration to age-crypt filter
set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"

echo "=== Migrating files to age-crypt filter ==="

FILES="
input/transcript.md
input/notes.md
input/initiative_list.md
output/initiative_inventory.md
output/classification_report.md
output/report.html
"

for file in $FILES; do
    filepath="$REPO_ROOT/$file"
    if [ -f "$filepath" ]; then
        echo "Re-staging: $file"
        git rm --cached "$file" 2>/dev/null || true
        git add "$file"
    else
        echo "Skipping (not found): $file"
    fi
done

echo ""
echo "Files re-staged with encryption. Verify with:"
echo "  git diff --cached --stat"
echo ""
echo "Then commit:"
echo "  git commit -m 'Encrypt sensitive files via age-crypt filter'"
echo ""
echo "NOTE: Previous plaintext content remains in git history."
echo "If this is a concern, consider git-filter-repo to rewrite history."
