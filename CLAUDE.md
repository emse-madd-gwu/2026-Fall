# CLAUDE.md

Project guidance for the EMSE 6035 **Marketing Analytics for Design Decisions**
course website (Fall 2026), built with [Quarto](https://quarto.org/).

> **This course is mid-revision (as of August 2026).** Like its sibling course
> (EMSE 4572/6572 Exploratory Data Analysis, at `../../EDA/2026-Fall`), it is
> shifting from *hand-writing* R code toward **directing agentic AI tools
> (Claude Code in Positron) to do the data work**, while still teaching the
> underlying choice-modeling concepts so students can supervise and verify the
> AI. **When in doubt about a convention, check the EDA repo — it is further
> along and this course is being brought into parallel with it.**

## The revision in a nutshell

- **Concepts stay** (conjoint design, utility models, MLE, uncertainty, DOE &
  power analysis, WTP & simulation, heterogeneity). **The toolchain changes.**
- **Week 2 is the new `2-agentic-workflows` deck** — GitHub Desktop (no git
  CLI) + setting up Claude Code in Positron. It parallels EDA's week 2.
- **Submission moved to GitHub.** Each student gets a private repo in the
  `madd-f26` org, pre-loaded with a folder per assignment. HW1 walks them
  through making a practice repo and cloning their course repo on day 1.

## Current state (what's done vs. pending)

- ✅ All 14 decks converted from xaringan `index.Rmd` → lexis `index.qmd`
  (see `class/CONVERSION-PROGRESS.md` for the conversion decisions).
- ✅ **RStudio → Positron + `here()` → `file.path()` sweep** (August 2026).
  See the conventions below.
- ⏳ **`class/2-agentic-workflows/index.qmd` is still a placeholder.** It is the
  one genuinely new deck. EDA's `class/2-agentic-workflows/` is the model.
- ⏳ **The per-student repos in `madd-f26` don't exist yet** — the org currently
  holds only `class-practice`. Students submit their GitHub usernames via the
  [class sheet](https://docs.google.com/spreadsheets/d/14bLHRcs7hQUX4LDLNKllcA9UhLyuYBZH6VH75Y2_fyU/edit?usp=sharing)
  (linked from both HW1 and the week 1 break slide); the `madd-netID` repos get
  created from that list, pre-loaded with an `hwN/` folder per assignment plus a
  `reflection.qmd` in each. HW1 step 4 has nothing to clone until they exist.
- ⏳ **Deck PDFs are stale-named** — each is one number behind its folder
  (`10-uncertainty/9-uncertainty.pdf`, etc.), left over from last year's
  numbering. Don't just rename them: the content is also last year's. They get
  fixed when each deck is re-rendered via `class/render.R`.
- ⏳ **`7-conjoint-questions`' zip lost its surveydown templates.** The old zip
  shipped `conjoint_buttons/` and `conjoint_tables/` folders that aren't in the
  repo, so the zip is now just `data/`. `render.R` still lists them in
  `practice_extras`, so restoring the folders is all that's needed.
- ⏳ **HW2+ still use downloadable template zips** (`templates/hwN.zip`) while
  HW1 now uses the course repo. Reconcile as each `-temp` file is released.

## Conventions

- **IDE is Positron, not RStudio.** Don't write or leave instructions telling
  students to open a `.Rproj` file or open/use "RStudio" — direct them to open
  the project folder in Positron (**File › Open Folder…**) instead.
  - **Remaining RStudio strings are deliberate and must NOT be swapped:**
    external URLs and org names (`rstudio.com/products`, `rstudio-education.
    github.io`, `rstudio.cloud`, `resources.rstudio.com`), image filenames
    (`images/rstudio-panes.png`, `images/rstudio-cheatsheet-*.png`), the
    RStudio cheatsheet listings in `references.qmd`, the Hadley Wickham
    attribution in `fragments/pep-talk.qmd`, and "RStudio Package Manager" in
    `.github/workflows/main.yml`. Renaming any of these breaks links or images.
  - ⏳ `class/1-getting-started/` still shows `images/rstudio-panes.png` on two
    slides labeled "Positron Orientation". Needs a Positron screenshot.

- **Class practice files ship as a per-class zip.** Each `class/N-stub/` folder
  holds that week's practice files; `class/render.R` zips them into
  `class/N-stub/N-stub.zip`, and the class landing page offers it as a download.
  *(A shared `madd-f26/class-practice` clone-once repo exists in the org but is
  NOT used — EDA tried that approach mid-2026 and reverted to per-class zips.)*
  - **The zip's file list lives in `render.R`, keyed by folder name, not week
    number** — `practice_base` (`data/`, plus `practice.qmd`/`practice.R` and
    their `-solutions` counterparts) plus a `practice_extras` entry for the few
    weeks with one-off files. Keying by name means renumbering the schedule
    can't silently hand out the wrong week's files. Listed files that don't
    exist are dropped, so a lecture-only week produces no zip and
    `fragments/class.qmd` hides the download button on its own.
  - **Both `.qmd` and `.R` forms are in `practice_base`** — the early weeks hand
    out plain scripts, the later weeks hand out Quarto docs.
  - **Re-run `class/render.R` from inside a deck folder** after touching that
    week's practice files. It derives `lesson` from the working directory, so
    there is nothing to edit per class — set the folder, run the whole script.
  - **No `.Rproj` goes in the zip** — see the path convention below.

- **File paths: `here::here()` for the site, `file.path()` everywhere else.**
  Three zones, and they don't behave the same:
  - **The site itself** (`fragments/`, `_common.R`, the `child = here::here(...)`
    includes, and the `class/N-stub.qmd` *landing pages*) — **keep `here()`.**
    These files live inside the site's Quarto project, so `here()` walks up to
    the repo root's `_quarto.yml`, which is the correct root. This is the case
    `here` is good at, and it lets fragments reach parent folders without
    counting `../`.
  - **Slide decks (`class/N-stub/`)** — **use `file.path()`, paths relative to
    the deck folder.** Deck folders are *nested inside* the project `here()`
    locks onto, so it roots at the repo, never the deck; the `.Rproj` files
    existed only to override that, and are now all deleted. knitr sets the
    working directory to the `.qmd`'s own folder on render, so relative paths
    resolve correctly no matter what's open in Positron.
  - **Student practice files** — **use `file.path()`, relative to the folder.**
    Once unzipped these sit anywhere on a student's disk, so whether `here()`
    resolves depends on what happens to be above them. A `.here` marker would
    work but is one more unexplained file in the folder.
  - `file.path('data', 'x.csv')` over `'data/x.csv'` is deliberate — it's the
    habit being taught, and it survives being shared across Mac and Windows.
  - **`class/render.R` uses `basename(getwd())`, not `here::here()`**, to derive
    `lesson` — with the deck `.Rproj` files gone, `here()` there returns the repo
    root and every output would be named `2026-Fall`.
  - **Only the repo-root `EMSE-MADD-2026-Fall.Rproj` remains.** No deck needs
    one, and new decks should never get one.

- **Class landing pages are all built from `fragments/class.qmd`** — one child
  fragment feeds every `class/N-*.qmd`, so edit it, not the individual pages. It
  derives the slides (`index.html`), slide PDF (`<class>.pdf`), and practice zip
  (`<class>.zip`) paths from `params$class`. The practice-zip button is gated on
  `file.exists()`, **not** a `notes:` param — a page can't advertise a zip that
  `render.R` didn't build. The `logitrcars:` and `surveydown:` params are still
  real and still per-page.

- **Data-driven schedule:** edit `schedule.csv`; `_common.R` (`get_schedule()`)
  builds the HTML columns and `schedule.lua` is a Pandoc table filter. Don't
  hand-edit the table in `schedule.qmd`.
- **`fragments/`** = reusable snippets included via `child = here::here(...)` or
  `{{< include ../fragments/... >}}`. `placeholder.qmd` is the "Coming soon!"
  stub; `hw-submit.qmd` is the shared commit-and-push submission instructions.
- **Class slides** live in `class/N-stub/` and are **excluded from render** in
  `_quarto.yml`; the landing page `class/N-stub.qmd` links to them.
- **Slide-deck Quarto extensions have ONE source of truth:**
  `class/_extensions/` (lexis + fontawesome). Each deck folder needs an
  `_extensions` entry of its own because the deck folders are render-excluded:
  Quarto treats an excluded file as standalone and only looks for
  `_extensions` in the file's own directory (no upward search). So **every
  `class/N-*/_extensions` is a symlink to `../_extensions`** — edit/update
  `class/_extensions/` and every deck picks it up with no copying step. New
  deck folders need the link created: `ln -s ../_extensions _extensions`.
- **Course-wide variables** in `_variables.yml` (`{{< var name >}}`).
- **`ROLLOVER.md`** = the separate checklist for rolling the site to a new
  semester.

## Raw material (render-excluded — don't delete)

The original xaringan sources (`class/N-stub/index.Rmd`, plus each deck's
`css/`, `libs/`, and `topics/`) are kept in place alongside the converted
`index.qmd`. `class/13-class-review/` is archived and off the schedule.

## Building

```bash
quarto preview   # live preview
quarto render    # build to _site/
```

**Do not render `.qmd` files yourself** — the instructor renders and previews.
`quarto inspect` is fine for validating config without rendering.
