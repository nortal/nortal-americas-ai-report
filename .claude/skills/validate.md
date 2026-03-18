# /validate

Check consistency across all Nortal AI Report documentation files.

## Instructions

1. Read all three files:
   - `output/initiative_inventory.md` — canonical source of truth
   - `output/classification_report.md` — classification analysis
   - `output/report.html` — generated HTML report

2. Extract the canonical list from `initiative_inventory.md`:
   - 24 initiatives, each with: number (1-24), name, owner, type, description, status

3. **Check initiative_inventory.md**:
   - Exactly 24 initiatives numbered 1-24
   - Each has: Owner, Type, Description, Status fields
   - Report any missing fields as ERRORS

4. **Check classification_report.md against inventory**:
   - All initiative name references match inventory exactly (same spelling, same number)
   - Owner attributions match inventory (WARNINGS for format variations like "Nico" vs "Nicolas Duran")
   - Every initiative (1-24) appears at least once across all dimensions
   - No phantom references to initiatives that don't exist in inventory
   - Report mismatches as ERRORS, format variations as WARNINGS

5. **Check report.html against both markdown files**:
   - 24 project cards exist with IDs `proj-1` through `proj-24`
   - Project card names match inventory names
   - Project card owners match inventory owners (WARNINGS for format variations)
   - Project card descriptions match inventory descriptions
   - 13 dimension sections exist (`dim-a` through `dim-m`)
   - Home section exists with initiative table
   - All initiative links use correct `proj-N` IDs
   - Sidebar has all navigation links (Home, Executive Summary, 13 dimensions, Themes, Next Steps, Appendix)
   - Report missing sections or wrong names as ERRORS

6. **Check grammar and spelling** across all three files:
   - Scan all descriptions, table entries, headings, and prose for spelling errors, grammatical issues, and awkward phrasing
   - Report issues as WARNINGS with the file, location, and suggested correction

7. **Output format**:

   ```
   === VALIDATION RESULTS ===

   ERRORS (must fix):
   - [description of error]

   WARNINGS (review recommended):
   - [description of warning]

   OK:
   - [what passed]

   Summary: X errors, Y warnings
   ```

8. If ERRORS are found, ask the user which file is the source of truth for resolution. Default assumption: `initiative_inventory.md` is canonical for names/numbers/owners, `classification_report.md` is canonical for dimension assignments.

## What to Check (Checklist)

- [ ] Inventory has exactly 24 initiatives
- [ ] All inventory fields present (Owner, Type, Description, Status)
- [ ] Classification report references match inventory names/numbers
- [ ] Classification report owner attributions match inventory
- [ ] Every initiative appears in at least one dimension
- [ ] No phantom initiative references in classification report
- [ ] HTML has 24 project cards (proj-1 through proj-24)
- [ ] HTML project names match inventory
- [ ] HTML has home section with initiative table
- [ ] HTML has 13 dimension sections (dim-a through dim-m)
- [ ] HTML sidebar has all navigation links
- [ ] HTML initiative links use correct proj-N IDs
- [ ] Grammar and spelling correct across all three files (WARNINGS for issues)
