# Nortal Americas AI Report

Classification report for Nortal Americas' 24 AI initiatives, generated from the Americas AI Board Follow-up Meeting (March 17, 2026).

## What This Is

An interactive HTML report that classifies Nortal Americas' AI initiatives across 13 dimensions — initiative type, technology layer, maturity, strategic priority, offering category, owner, client relationship, revenue impact, AI maturity (Bronze/Silver/Gold), origin, reusability, engagement model, and risk profile. It includes cross-cutting themes, potential next steps, and detailed project cards for all 24 initiatives.

## Viewing the Report

```bash
open output/report.html
```

The report is a self-contained HTML file with no dependencies. Open it in any browser.

## Project Structure

```
input/          Source materials (transcript, notes from AI status meeting)
output/         Generated report artifacts
  report.html               Interactive HTML report (the deliverable)
  initiative_inventory.md   Canonical list of 24 initiatives (source of truth)
  classification_report.md  Classification analysis across 13 dimensions
research/       Background research on Nortal and competitor AI offerings
scripts/        Automation scripts (bootstrap, secrets, index)
secrets/        Secret management (plain is gitignored, enc is committed)
docs/           Documentation
.claude/skills/ Claude Code skills for report automation
```

## Updating the Report

The three output files have a defined relationship:

1. **`initiative_inventory.md`** is the source of truth for initiative names, numbers, owners, descriptions, and statuses
2. **`classification_report.md`** contains the analysis — which initiatives appear in which dimensions, key insights, themes, and next steps
3. **`report.html`** is generated from both markdown files

When making updates:
- Update `initiative_inventory.md` with new information about initiatives
- Update `classification_report.md` if dimension assignments or analysis changes
- Regenerate the HTML (see Claude Code skills below)

## Claude Code Skills

This project includes two Claude Code skills for automation:

- **`/rebuild-report`** — Regenerates `report.html` from the two markdown source files, preserving CSS styling
- **`/validate`** — Checks consistency across all three files, reports errors and warnings including grammar/spelling

## First-Time Setup

### macOS / Linux

```bash
./scripts/bootstrap.sh
```

When prompted, paste the project decryption key (get it from the project owner).

### Windows

Use **WSL** (recommended) or **Git Bash**:

1. Install [age](https://github.com/FiloSottile/age/releases)
2. In WSL or Git Bash: `./scripts/bootstrap.sh`
3. Paste the project decryption key when prompted

Native PowerShell is not supported for the shell scripts. Use WSL or Git Bash.

### Using with Claude Code

Just start Claude Code in the project directory. On first interaction, Claude will automatically check for the decryption key and ask you for it if missing.

## Encryption

Sensitive files in `input/` and `output/` are transparently encrypted in the git
repository using [age](https://github.com/FiloSottile/age) smudge/clean filters.

Each project uses a per-project key stored at `~/.keys/age/<project-name>.txt`
(this project: `nortal-ai-report`). This means multiple projects using this
methodology can coexist without overwriting each other's keys.

### Setup

1. Run `./scripts/bootstrap.sh`
2. When prompted, paste the project decryption key (`AGE-SECRET-KEY-...` string)
   - Get this from the project owner via a secure channel
   - If you are the project creator, type `generate` to create a new key pair

### Encrypted files (defined in `.gitattributes`)

- `input/transcript.md`, `input/notes.md`, `input/initiative_list.md`
- `output/initiative_inventory.md`, `output/classification_report.md`, `output/report.html`

Without a decryption key, these files appear as age-armored ciphertext.

See `docs/secrets-guide.md` for the full encryption workflow.

## Rules

- Never commit files in `secrets/plain/`
- Always encrypt secrets before sharing
- Update INDEX.md after structural changes: `./scripts/index/generate.sh`
