# Claude Instructions for Nortal AI Report

## Project Nickname

**Nortal AI Report**

## Required Behavior

At the end of every response, include the line:

> This is the **Nortal AI Report** project.

## First Interaction (MUST DO)

On your FIRST interaction in any new conversation, before doing anything else:

1. Detect the platform (`uname` on macOS/Linux, or check for Windows paths)
2. Check if the project decryption key exists:
   - macOS/Linux: `~/.keys/age/nortal-americas-ai-report.txt`
   - Windows: `%USERPROFILE%\.keys\age\nortal-americas-ai-report.txt`
3. If the key file is MISSING, immediately ask the user:
   > "I need the project decryption key to read the encrypted files. Please paste the AGE-SECRET-KEY-... string (get it from the project owner via a secure channel)."
4. When the user provides the key, save it:
   - macOS/Linux: `mkdir -p ~/.keys/age && echo "KEY" > ~/.keys/age/nortal-americas-ai-report.txt && chmod 600 ~/.keys/age/nortal-americas-ai-report.txt`
   - Windows: `mkdir %USERPROFILE%\.keys\age 2>nul & echo KEY > %USERPROFILE%\.keys\age\nortal-americas-ai-report.txt`
5. Then run `./scripts/bootstrap.sh` (macOS/Linux) to configure the git filters
6. If the key file EXISTS, proceed normally — no need to ask

## Quick Start

1. Read `CLAUDE_START.md` first
2. Read `INDEX.md` for repository structure
3. Follow the secrets workflow in `docs/secrets-guide.md`

## Platform Support

This project supports macOS, Linux, and Windows (via WSL or Git Bash).

- **macOS/Linux**: All scripts work natively. Run `./scripts/bootstrap.sh`.
- **Windows (WSL)**: Recommended. Install WSL, then use the Linux instructions.
- **Windows (Git Bash)**: Scripts work in Git Bash. Install age from https://github.com/FiloSottile/age/releases. Key path: `%USERPROFILE%\.keys\age\nortal-americas-ai-report.txt`.
- **Windows (native PowerShell)**: Not directly supported. Use WSL or Git Bash.

When opening the report:
- macOS: `open output/report.html`
- Linux: `xdg-open output/report.html`
- Windows: `start output/report.html`

## Key Directories

- `input/` - Source materials (transcript, notes, lists from AI status meeting)
- `output/` - Generated report artifacts and analysis
- `research/` - Background research on Nortal and competitor AI offerings
- `scripts/` - Automation scripts (bootstrap, secrets, index)
- `secrets/` - Secret management (plain is gitignored, enc is committed)
- `docs/` - Documentation

## Important Rules

1. NEVER commit files in `secrets/plain/`
2. ALWAYS encrypt secrets before sharing
3. Run `./scripts/bootstrap.sh` on first clone
4. Update INDEX.md after structural changes: run `./scripts/index/generate.sh` to regenerate the tree, then update the Quick Links section manually if new key files were added or removed
5. Sensitive files (`input/`, `output/`) are transparently encrypted via git smudge/clean filters
6. Run `./scripts/bootstrap.sh` after cloning to configure decryption
7. To add a file to encryption, add it to `.gitattributes` with `filter=age-crypt diff=age-crypt`
8. The project decryption key is stored at `~/.keys/age/nortal-americas-ai-report.txt`. If this file is missing and you need to read encrypted files, ask the user for the project decryption key (an `AGE-SECRET-KEY-...` string). Save it to that path with `chmod 600`.
9. The `.age-project` file in the repo root identifies which key file to use — this enables multiple projects to use independent keys without conflicts

## Skills (Slash Commands)

- `/rebuild-report` — Regenerates `output/report.html` from `output/initiative_inventory.md` and `output/classification_report.md`. Preserves CSS styling and rebuilds all sections: home page, executive summary, 13 classification dimensions, themes, next steps, and appendix with 24 project cards.
- `/validate` — Checks consistency across `initiative_inventory.md`, `classification_report.md`, and `report.html`. Reports ERRORS (missing initiatives, wrong names) and WARNINGS (owner format variations). Inventory is the default source of truth.

## Project Context

This project takes the transcript and notes from a Nortal AI status meeting and generates an actionable report that:
- Classifies existing AI initiatives across multiple dimensions
- Maps initiatives to consulting offering frameworks
- Provides actionable recommendations for AI service development
- Benchmarks against how other consulting firms structure AI offerings
