#!/bin/sh
# age-smudge.sh — git smudge filter: decrypt on checkout
# Uses per-project key file at ~/.keys/age/<project>.txt

REPO_ROOT="$(git rev-parse --show-toplevel)"
PROJECT=$(cat "$REPO_ROOT/.age-project" 2>/dev/null | tr -d '[:space:]')

if [ -z "$PROJECT" ]; then
    echo "WARNING: No .age-project file found. Cannot determine key file." >&2
    cat
    exit 0
fi

KEY_FILE="$HOME/.keys/age/${PROJECT}.txt"

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT
cat > "$TMPFILE"

if head -1 "$TMPFILE" | grep -q "^-----BEGIN AGE ENCRYPTED FILE-----"; then
    if [ ! -f "$KEY_FILE" ]; then
        echo "WARNING: No age key at $KEY_FILE — cannot decrypt. Run ./scripts/bootstrap.sh and provide the project key." >&2
        cat "$TMPFILE"
        exit 0
    fi
    if ! age -d -i "$KEY_FILE" < "$TMPFILE" 2>/dev/null; then
        echo "WARNING: age decryption failed (wrong key?). Passing through encrypted content." >&2
        cat "$TMPFILE"
        exit 0
    fi
else
    cat "$TMPFILE"
fi
