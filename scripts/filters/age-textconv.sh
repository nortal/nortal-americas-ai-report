#!/bin/sh
# age-textconv.sh — git textconv for age-encrypted files
# Uses per-project key file at ~/.keys/age/<project>.txt

REPO_ROOT="$(git rev-parse --show-toplevel)"
PROJECT=$(cat "$REPO_ROOT/.age-project" 2>/dev/null | tr -d '[:space:]')
KEY_FILE="$HOME/.keys/age/${PROJECT}.txt"

if head -1 "$1" | grep -q "^-----BEGIN AGE ENCRYPTED FILE-----"; then
    if [ -n "$PROJECT" ] && [ -f "$KEY_FILE" ]; then
        age -d -i "$KEY_FILE" "$1" 2>/dev/null || cat "$1"
    else
        echo "[encrypted — no key available for decryption]"
    fi
else
    cat "$1"
fi
