# Getting Started with Nortal AI Report

## First Steps

1. Read this file completely
2. Read `CLAUDE.md` for project-specific instructions and rules
3. Read `INDEX.md` for the repository structure

## Project Purpose

This project takes the transcript and notes from a Nortal AI status meeting and produces an interactive HTML report classifying 24 AI initiatives across 13 dimensions.

## Key Files (Three-File Workflow)

The report system has three interconnected files in `output/`:

| File | Role | When to Edit |
|------|------|-------------|
| `initiative_inventory.md` | **Source of truth** for initiative names, numbers, owners, descriptions, statuses | When initiative details change |
| `classification_report.md` | Classification analysis — dimension assignments, key insights, themes, next steps | When dimension assignments or analysis changes |
| `report.html` | Interactive HTML report generated from both markdown files | Regenerated via `/rebuild-report`, not edited directly |

## Skills (Slash Commands)

- **`/rebuild-report`** — Regenerates `report.html` from the two markdown source files. Preserves CSS styling.
- **`/validate`** — Checks consistency across all three files. Reports ERRORS (missing data, wrong names) and WARNINGS (format variations, grammar/spelling). Inventory is the default source of truth.

## Update Workflow

1. User provides new information about initiatives
2. Update `initiative_inventory.md` with the new details
3. **Wait for user to say to rebuild** before modifying other files
4. When told to rebuild: update `classification_report.md` if needed, then run `/rebuild-report`
5. Run `/validate` to catch inconsistencies

## Key Directories

- `input/` — Source materials (transcript, meeting notes, initiative lists)
- `output/` — Generated report and analysis artifacts
- `research/` — Background research on Nortal and competitor frameworks
- `scripts/` — Automation scripts (bootstrap, secrets, index)
- `secrets/` — Secret management (plain is gitignored, enc is committed)
- `docs/` — Documentation

## Important Rules

1. NEVER commit files in `secrets/plain/`
2. ALWAYS encrypt secrets before sharing
3. Run `./scripts/bootstrap.sh` on first clone
4. Update INDEX.md after structural changes: `./scripts/index/generate.sh`

## Transparent Encryption

Content files in `input/` and `output/` are transparently encrypted in the git
repository using age smudge/clean filters. After running `./scripts/bootstrap.sh`,
these files appear as plaintext in your working tree but are stored as age-encrypted
ciphertext in the remote repo.

Each project has its own decryption key, identified by the `.age-project` file
(this project: `nortal-americas-ai-report`). The key is stored at
`~/.keys/age/nortal-americas-ai-report.txt`. This per-project approach prevents different
projects from overwriting each other's keys.

**If the key file is missing**, ask the user for the project decryption key (an
`AGE-SECRET-KEY-...` string) and save it to `~/.keys/age/nortal-americas-ai-report.txt`
with permissions `chmod 600`.

The encrypted files are listed in `.gitattributes`.

## First-Time Setup

```bash
# macOS / Linux / WSL / Git Bash
./scripts/bootstrap.sh
```

On Windows without WSL/Git Bash, Claude can manually set up the key file at
`%USERPROFILE%\.keys\age\nortal-americas-ai-report.txt` — see CLAUDE.md for details.
