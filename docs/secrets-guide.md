# Secrets Management Guide

This project uses [age](https://github.com/FiloSottile/age) for secret encryption.

## Overview

| Location | Git Status | Purpose |
|----------|------------|---------|
| `secrets/plain/` | gitignored | Local working secrets |
| `secrets/enc/` | committed | Encrypted team secrets |
| `secrets/recipients.txt` | committed | Public keys for encryption |
| `secrets/manifest.json` | committed | Secret metadata |

## Setup

### First-Time Setup

Run bootstrap to generate your keys and register as a recipient:

```bash
./scripts/bootstrap.sh
```

This will:
1. Check that age is installed
2. Generate keys to `~/.keys/age/keys.txt` (if not present)
3. Add your public key to `secrets/recipients.txt`

### Installing age

```bash
# macOS
brew install age

# Linux (Debian/Ubuntu)
sudo apt install age

# From source
go install filippo.io/age/cmd/...@latest
```

## Daily Workflow

### Creating a New Secret

```bash
# 1. Create the plaintext file
echo "API_KEY=your_secret_value" > secrets/plain/api.env

# 2. Encrypt all plaintext secrets
./scripts/secrets/encrypt_all.sh

# 3. Verify encryption
ls secrets/enc/
# Output: api.env.age

# 4. Commit encrypted version
git add secrets/enc/ secrets/manifest.json
git commit -m "Add API secret"
```

### Getting Secrets After Pull

```bash
# Decrypt all encrypted secrets
./scripts/secrets/decrypt_all.sh

# Verify
cat secrets/plain/api.env
```

### Checking Secret Health

```bash
./scripts/secrets/audit.sh
```

This shows:
- Number of recipients configured
- Key file status
- List of plaintext and encrypted files
- Staleness warnings (files encrypted >30 days ago)

## Team Workflow

### Adding a New Team Member

1. Have them generate keys:
   ```bash
   age-keygen -o ~/.keys/age/keys.txt
   ```

2. They share their public key (the `age1...` line)

3. You add it to `secrets/recipients.txt`:
   ```bash
   echo "# teammate@example.com" >> secrets/recipients.txt
   echo "age1abc123..." >> secrets/recipients.txt
   ```

4. Re-encrypt all secrets:
   ```bash
   ./scripts/secrets/encrypt_all.sh
   ```

5. Commit and push:
   ```bash
   git add secrets/enc/ secrets/recipients.txt secrets/manifest.json
   git commit -m "Add teammate as recipient"
   git push
   ```

### Removing a Team Member

1. Remove their public key from `secrets/recipients.txt`
2. Re-encrypt all secrets: `./scripts/secrets/encrypt_all.sh`
3. Commit and push

Note: They can still decrypt any secrets encrypted before removal if they have copies.

## Key Management

### Key Location

Keys are stored per-project at: `~/.keys/age/<project-name>.txt`

The project name is defined in `.age-project` at the repo root. For this project,
the key file is `~/.keys/age/nortal-ai-report.txt`.

This per-project approach means multiple projects can use this encryption
methodology without overwriting each other's keys.

The key file contains both your secret key and public key:
```
# created: 2025-01-01T12:00:00Z
# public key: age1abc123...
AGE-SECRET-KEY-...
```

### Backing Up Keys

**Important**: If you lose your keys, you cannot decrypt secrets.

Options:
1. Store in a password manager
2. Print and store securely (the key is just text)
3. Store encrypted copy in secure location

### Rotating Keys

1. Generate new keys:
   ```bash
   age-keygen -o ~/.keys/age/keys.txt
   ```

2. Add new public key to recipients:
   ```bash
   grep "^age1" ~/.keys/age/keys.txt >> secrets/recipients.txt
   ```

3. Re-encrypt all secrets:
   ```bash
   ./scripts/secrets/encrypt_all.sh
   ```

4. Remove old public key from `recipients.txt` after all team members have updated

## Troubleshooting

### "age: command not found"

Install age (see Setup section above).

### "No recipients in recipients.txt"

Run bootstrap or manually add a recipient:
```bash
grep "^age1" ~/.keys/age/keys.txt >> secrets/recipients.txt
```

### "decryption failed: no identity matched"

Your key is not in the recipients list. Ask a team member to:
1. Add your public key to `recipients.txt`
2. Re-encrypt all secrets
3. Push the changes

### Pre-commit hook blocking commit

You're trying to commit a secret file. Either:
1. Remove from staging: `git reset HEAD <file>`
2. Encrypt first: `./scripts/secrets/encrypt_all.sh`
3. Add to `.gitignore` if not a secret

## Transparent File Encryption

In addition to the `secrets/plain/` and `secrets/enc/` workflow, sensitive content
files in `input/` and `output/` are transparently encrypted using git smudge/clean
filters. This means the files appear as plaintext in your working tree but are stored
encrypted in the git repository.

### Which Files Are Encrypted

The encrypted files are defined in `.gitattributes` at the repo root:

- `input/transcript.md`
- `input/notes.md`
- `input/initiative_list.md`
- `output/initiative_inventory.md`
- `output/classification_report.md`
- `output/report.html`

### How It Works

- **On commit (clean filter)**: Plaintext is piped through `age -e` before being
  stored in git, using the recipients in `secrets/recipients.txt`.
- **On checkout (smudge filter)**: Encrypted content is piped through `age -d`
  using your project key at `~/.keys/age/<project>.txt`, so you see plaintext in your working tree.
- **On diff (textconv)**: Encrypted blobs are decrypted on the fly for readable diffs.

### Setup

Run bootstrap after cloning to configure the filters:

```bash
./scripts/bootstrap.sh
```

This registers the `age-crypt` filter in your local `.git/config`.

### What Happens Without Keys

If you do not have a key at `~/.keys/age/<project>.txt`, or your key is not in the
recipients list, the smudge filter passes through the encrypted ciphertext as-is.
You will see age-armored text (starting with `-----BEGIN AGE ENCRYPTED FILE-----`)
in your working tree instead of plaintext. This is safe — no data is lost.

### Adding a New File to Encryption

1. Add a line to `.gitattributes`:
   ```
   path/to/file.md filter=age-crypt diff=age-crypt
   ```

2. Re-stage the file so the clean filter runs:
   ```bash
   git rm --cached path/to/file.md
   git add path/to/file.md
   ```

3. Commit the change.

### Verifying Encryption

To confirm a file is stored encrypted in git:

```bash
git show HEAD:input/transcript.md | head -5
```

You should see:
```
-----BEGIN AGE ENCRYPTED FILE-----
```

### Re-encryption When Recipients Change

When you add or remove recipients in `secrets/recipients.txt`, the encrypted content
in git needs to be re-encrypted. Re-stage and commit the affected files:

```bash
git rm --cached input/transcript.md
git add input/transcript.md
git commit -m "Re-encrypt with updated recipients"
```

Or use the migration script to re-stage all filtered files at once:

```bash
./scripts/filters/migrate-to-encrypted.sh
```

### Merge Workflow

Git merges operate on the clean (encrypted) content in the repository. In practice,
merges work on plaintext in your working tree because git applies the smudge filter
after resolving conflicts. If you encounter merge conflicts, you will see plaintext
(not ciphertext) in the conflict markers.

## Security Best Practices

1. **Never commit plaintext secrets** - The pre-commit hook helps prevent this
2. **Rotate keys periodically** - Especially when team members leave
3. **Audit regularly** - Run `audit.sh` to check for stale secrets
4. **Minimize recipients** - Only add people who need access
5. **Use specific files** - Don't put all secrets in one file
6. **Review before commit** - Check `git status` before committing
