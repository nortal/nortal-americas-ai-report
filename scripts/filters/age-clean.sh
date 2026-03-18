#!/bin/sh
# age-clean.sh — git clean filter: encrypt plaintext on commit
REPO_ROOT="$(git rev-parse --show-toplevel)"
RECIPIENTS_FILE="$REPO_ROOT/secrets/recipients.txt"

if [ ! -f "$RECIPIENTS_FILE" ]; then
    echo "ERROR: recipients.txt not found at $RECIPIENTS_FILE" >&2
    echo "Run ./scripts/bootstrap.sh first." >&2
    exit 1
fi

age -e -a -R "$RECIPIENTS_FILE"
