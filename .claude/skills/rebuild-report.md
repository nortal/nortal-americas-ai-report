# /rebuild-report

Regenerate `output/report.html` from the markdown source files.

## Instructions

1. Read `output/initiative_inventory.md` to get the canonical list of 24 initiatives (names, numbers, owners, types, statuses, descriptions).

2. Read `output/classification_report.md` to get:
   - Executive Summary
   - 13 classification dimensions (A through M)
   - Cross-Cutting Themes (5 themes)
   - Potential Next Steps / Brainstorming (4 timeframes)

3. Read the `<style>` block from the current `output/report.html` to preserve any CSS tweaks. Add new CSS rules as needed (e.g., for dashboard grid, donut charts) but do not modify existing rules.

4. Generate a complete HTML file with these sections in order:

   **a. Home page** (`<div id="home" class="section active">`):
   - A prominent warning banner (yellow background) noting: "If you are viewing this in Teams, the navigation links will not work correctly. Download the .html file and open it in your browser to navigate between sections."
   - Brief paragraph explaining the report (24 initiatives, 13 dimensions)
   - **Dashboard section** with charts summarizing ALL 13 classification dimensions (A through M). Each chart is clickable and navigates to the corresponding dimension page via `showSection('dim-X')`. Count the actual initiative entries in each sub-category from the classification report.
   - **Chart types supported:** Donut charts, funnel charts, and hidden (no charts). A dropdown selector at the top of the dashboard lets the user switch between chart types. The selected type applies to all charts. Default is funnel.
     - **Donut charts:** Rendered with inline SVG using `<circle>` elements with `stroke-dasharray`/`stroke-dashoffset`. Center number shows total. Each uses a consistent color palette from the report theme.
     - **Funnel charts:** Rendered with inline SVG or styled `<div>` elements. Each segment is a horizontal bar, widest at top (largest category), narrowing toward bottom (smallest). Segment labels and values are displayed inside or beside each bar. Use the same color palette as donuts.
   - **Legends:** Each chart has a legend showing segment labels with both count and percentage: `Label: N (XX%)`. Legends are **sorted from largest to smallest** percentage.
   - Chart titles and chart areas are wrapped in clickable elements with `onclick="showSection('dim-X')"`.
   - Charts are laid out in a responsive grid (4 columns on wide desktop, 3 on desktop, 2 on tablet, 1 on mobile) using CSS grid.
   - When "Hidden" is selected, all chart cards are hidden, showing only the initiative table below.
   - The chart type dropdown and the `switchChartType()` JavaScript function handle showing/hiding the appropriate chart rendering for each card.
   - Below the dashboard: table of all 24 initiatives with columns: #, Initiative (clickable link), Description (from project-short subtitle in inventory), Owner
   - Initiative names are `<a class="init-link" href="#" onclick="goProject('proj-N')">Name</a>` links

   **b. Executive Summary** (`<div id="summary" class="section">`):
   - Content from the Executive Summary section of classification_report.md
   - Participants list

   **c. 13 Classification Dimensions** (`<div id="dim-a" class="section">` through `<div id="dim-m" class="section">`):
   - Each dimension gets its own section
   - Markdown tables (`| col | col |`) convert to HTML `<table>` elements
   - Bullet-point lists of initiatives also convert to HTML tables
   - Initiative names are always `<a class="init-link" href="#" onclick="goProject('proj-N')">Name</a>` links
   - Each table has a "Why It Belongs Here" column with contextual explanation
   - Key Insight boxes use `<div class="key-insight">` styling — only include if present in the classification report source; do not invent new ones
   - Dimension F (Owner): do NOT include a Key Insight box

   **d. Cross-Cutting Themes** (`<div id="themes" class="section">`):
   - 5 themes with descriptions and recommendations
   - Initiative references are clickable links

   **e. Next Steps** (`<div id="next-steps" class="section">`):
   - Use the exact section title from classification_report.md (currently "Potential Next Steps (Brainstorming)")
   - 4 timeframe tables: Immediate, Short-Term, Medium-Term, Strategic

   **f. Appendix** (`<div id="appendix" class="section">`):
   - 24 project cards, each in `<div class="project-card" id="proj-N">`
   - Each card has: project-name, project-short (subtitle from inventory heading), project-desc (full description from inventory), project-meta (owner, client/type, status)

   **g. Sidebar navigation** (`<nav class="sidebar">`):
   - "Nortal AI Report" header
   - Overview group: Home (default active), Executive Summary
   - Classifications group: A through M with short labels
   - Reference group: Cross-Cutting Themes, Next Steps, Appendix: All Projects

   **h. JavaScript**:
   - `showSection(id)` — hides all sections, shows target, updates active sidebar link
   - `goProject(id)` — shows appendix section, scrolls to project card

5. Initiative IDs: `proj-1` through `proj-24` matching `### N.` numbering in initiative_inventory.md.

6. Write the complete HTML to `output/report.html`.

7. Report what changed compared to the previous version (new sections, updated content, removed content).

## Key Rules

- The initiative_inventory.md is the **source of truth** for initiative names, numbers, owners, descriptions, and statuses.
- The classification_report.md is the **source of truth** for which initiatives appear in which dimensions and the analytical content.
- Preserve all existing CSS classes and visual styling.
- Use `&mdash;` for em dashes, `&amp;` for ampersands, `&ldquo;`/`&rdquo;` for smart quotes in HTML.
- Every initiative reference in dimension tables must be a clickable `goProject()` link.
