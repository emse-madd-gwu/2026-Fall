# Lexis conversion — progress / resume notes

**Task:** Convert every class `index.Rmd` (xaringan) → `index.qmd` (quarto-lexis,
`format: lexis-revealjs`), mirroring how the EDA 2026-Fall course was refactored.
Reference course: `/Users/jhelvy/gh/teaching/EDA/2026-Fall/class`.

## Infrastructure — DONE
- `class/_extensions/` = source of truth (lexis + quarto-ext/fontawesome), copied from EDA.
- `_extensions/` copied into every class folder (folders are render-excluded in `_quarto.yml`, so each needs its own copy).
- `class/render.R` rewritten (refresh `_extensions` from `../_extensions`, render `index.qmd` → html → pdf, zip notes).
- `class/setup.qmd` created (mirrors EDA, MADD logo `https://madd.seas.gwu.edu/images/logo.png`). Provides the title slide + `sp()` + `agenda()` helpers.
- All `.Rproj` files renamed to match their (already-renumbered) folders; each folder got `.gitignore` = `/.luarc.json`.
- `2-agentic-workflows/` folder scaffolded (extensions, Rproj, gitignore, placeholder `index.qmd`).

## Conversion decisions (apply to ALL decks)
1. `child="../setup.Rmd"` → `{{< include ../setup.qmd >}}` (title slide comes from setup.qmd; delete old title-slide markup).
2. `topics/N.Rmd` agenda slides → `agenda(N)` helper calls, driven by an `agenda_items <- c(...)` vector in an `#| include: false` chunk. **Drop the `### BREAK` line** (user chose the clean EDA helper).
3. `class: inverse/middle/center` → `{{< inverse >}}` `{{< middle >}}` `{{< center >}}` shortcodes (each on own line).
4. `background-color: #hex` → `{{< bg-color "#hex" >}}`.
5. `.leftcolNN[]`/`.rightcolNN[]` → consecutive `::: {.col width="NN%"}`. Plain `.leftcol[]`/`.rightcol[]` → `::: {.col}`. Single-width col (e.g. `.rightcol80[]`) → one `::: {.col width="80%"}` (verify it renders OK).
6. `.red[x]`→`[x]{.red}`; `.center[Heading]`→`# [Heading]{.center}`; `.fancy[x]`→`[x]{.fancy}`; `.fontNN[x]`→`::: {.fontNN}` div or `[x]{.fontNN}`. Combine classes on ONE div: `::: {.col .font120 width="80%"}`.
7. `- ### **item**` heading-in-list → `::: {.font150}` bullet list.
8. `-->` → `→`.
9. `--` incremental → `. . .` for paragraphs/lists; wrap stepped headings/columns in `::: {.fragment}` (or add `.fragment` to the `.col`).
10. Images: keep `<center><img src="images/x.png" width=N></center>` HTML (handles filenames with spaces).
11. R chunks: `` ```{r, echo=FALSE} `` → `` ```{r} `` + `#| echo: false`. Code itself unchanged. `eval=FALSE` → `#| eval: false`. Do NOT add chunk labels (avoids dup-label errors).
12. **`week:` = the class number `n_class`** (NOT calendar week). Update `week:` and `displaydate:` to the NEW schedule (see table). YAML also becomes: `format: lexis-revealjs`, `mouse-wheel: true`, `progress: false`, `execute: echo/warning/message/freeze`. `institute:` → "The George Washington University | EMSE". Keep original `subtitle`.
13. **Keep old files** (`index.Rmd`, `css/lexis*.css`, `libs/`) in place — do NOT delete (user chose keep-for-now).

## New schedule week / displaydate per deck (n_class = week:)
| folder | week: | displaydate: |
|---|---|---|
| 1-getting-started | 1 | August 26, 2026 |
| 2-agentic-workflows | 2 | September 02, 2026 |
| 3-data-wrangling | 3 | September 09, 2026 |
| 5-quarto-plotting | 5 | September 23, 2026 |
| 6-intro-to-surveydown | 6 | September 30, 2026 |
| 7-conjoint-questions | 7 | October 07, 2026 |
| 8-utility-models | 8 | October 14, 2026 |
| 9-optimization-mle | 9 | October 21, 2026 |
| 10-uncertainty | 10 | October 28, 2026 |
| 11-doe-power-analysis | 11 | November 04, 2026 |
| 12-wtp-simulation | 12 | November 11, 2026 |
| 13-heterogeneity | 13 | November 18, 2026 |
| 14-story-telling | 14 | December 02, 2026 |
| 15-final-presentations | 15 | December 09, 2026 |

## Decks status
- DONE + render-verified: `15-final-presentations`, `6-intro-to-surveydown`, `12-wtp-simulation`, `13-heterogeneity`, `8-utility-models`, `9-optimization-mle`, `10-uncertainty`, `11-doe-power-analysis`.
- DONE (converted; render blocked by PRE-EXISTING issue, not the conversion): `7-conjoint-questions` — its own setup R chunk hits a cbcTools-version incompatibility (`design_no_choice_short` references `powertrainElectric`); also reads `choice_questions.csv` which isn't in the folder. Markup follows the validated patterns. Renders in the author's cbcTools env.
- DONE + render-verified (cont.): `14-story-telling`, `3-data-wrangling`, `1-getting-started` (its 1 render "error" is the INTENDED `#| error: true` wiki_randomfact demo), `5-quarto-plotting`.
- TODO: none — **all decks converted.** ✅

## ✅ CONVERSION COMPLETE (2026-07-21)
All 14 class decks now have a lexis `index.qmd`: 12 render-verified in isolation, `7-conjoint-questions` converted (render blocked only by its own pre-existing cbcTools-version code + missing `choice_questions.csv`), and `2-agentic-workflows` is a placeholder. Original `index.Rmd` + old `css/`/`libs/` left in place (per user). Nothing committed. Remaining content notes to revisit later: `1-getting-started` deliverable-dates/grades table and the exam wording still reflect the OLD schedule (same bucket as the deferred syllabus grading — see [[schedule-2026-reorg-deferred]]).
- NOTE: `bg-image` shortcode's `data-background-image` is applied by the post-quarto lexis.lua step (real `renderthis`/render.R pipeline), NOT plain `quarto render` — so isolated test html won't show it (EDA's committed html is the same). Not a bug.
- SKIP (archived, off schedule): `13-class-review`.

## How to render-verify a deck (parent `_quarto.yml` breaks a direct `quarto render`)
Copy into an isolated dir with no parent project, then render:
```
SCRATCH=<scratchpad>/rendertest; rm -rf "$SCRATCH"; mkdir -p "$SCRATCH/<folder>"
cp class/setup.qmd "$SCRATCH/setup.qmd"
cp class/<folder>/index.qmd "$SCRATCH/<folder>/"
cp -R class/<folder>/_extensions class/<folder>/images class/<folder>/data "$SCRATCH/<folder>/" 2>/dev/null
cd "$SCRATCH/<folder>" && quarto render index.qmd
```
Real pipeline is `render.R` via `renderthis` from inside each folder's RStudio project.

## NOT committed yet. Also pending from earlier task: exam rework, syllabus grading rebalance, quiz-label check (see memory/schedule-2026-reorg-deferred.md).
