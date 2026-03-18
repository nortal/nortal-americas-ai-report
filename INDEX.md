# Project Index

This file provides an overview of the repository structure.

## Quick Links

### Getting Started
- [README.md](README.md) — Project overview, setup, and encryption
- [CLAUDE_START.md](CLAUDE_START.md) — Claude Code getting started guide
- [CLAUDE.md](CLAUDE.md) — Claude instructions and project rules

### Report Files (Three-File Workflow)
- [output/initiative_inventory.md](output/initiative_inventory.md) — **Source of truth**: 24 initiatives with names, owners, descriptions, statuses
- [output/classification_report.md](output/classification_report.md) — Classification analysis across 13 dimensions
- [output/report.html](output/report.html) — Interactive HTML report (the deliverable)

### Skills (Slash Commands)
- [.claude/skills/rebuild-report.md](.claude/skills/rebuild-report.md) — `/rebuild-report`: Regenerate HTML from markdown sources
- [.claude/skills/validate.md](.claude/skills/validate.md) — `/validate`: Check consistency across all files

### Source Materials
- [input/transcript.md](input/transcript.md) — Meeting transcript
- [input/notes.md](input/notes.md) — Meeting notes

### Research
- [research/nortal_background.md](research/nortal_background.md) — Nortal company background
- [research/competitor_ai_frameworks.md](research/competitor_ai_frameworks.md) — Competitor AI offering analysis

### Infrastructure
- [docs/secrets-guide.md](docs/secrets-guide.md) — Secrets and encryption guide
- [scripts/bootstrap.sh](scripts/bootstrap.sh) — First-time setup script
- [.age-project](.age-project) — Project identifier for per-project encryption keys
- [.gitattributes](.gitattributes) — Files marked for transparent encryption

<!-- GENERATED:START -->
## Repository Map

```
.
├── .claude/
│   ├── skills/
│   │   ├── bootstrap.md
│   │   ├── encrypt.md
│   │   ├── rebuild-report.md
│   │   ├── reindex.md
│   │   ├── secrets-audit.md
│   │   └── validate.md
│   ├── instructions.md
│   └── settings.json
├── .githooks/
│   └── pre-commit
├── docs/
│   └── secrets-guide.md
├── input/
│   ├── notes.md
│   ├── README.md
│   └── transcript.md
├── output/
│   ├── classification_report.md
│   ├── initiative_inventory.md
│   └── report.html
├── research/
│   ├── competitor_ai_frameworks.md
│   └── nortal_background.md
├── scripts/
│   ├── filters/
│   │   ├── age-clean.sh
│   │   ├── age-smudge.sh
│   │   ├── age-textconv.sh
│   │   └── migrate-to-encrypted.sh
│   ├── index/
│   │   ├── generate.sh
│   │   └── generate_index.py
│   ├── secrets/
│   │   ├── audit.sh
│   │   ├── decrypt_all.sh
│   │   ├── encrypt_all.sh
│   │   └── gen_keys.sh
│   ├── bootstrap.sh
│   └── install_hooks.sh
├── secrets/
│   ├── enc/
│   │   ├── .gitkeep
│   │   └── demo.env.age
│   ├── manifest.json
│   └── recipients.txt
├── .age-project
├── .gitattributes
├── .gitignore
├── CLAUDE.md
├── CLAUDE_START.md
└── README.md
```
<!-- GENERATED:END -->
