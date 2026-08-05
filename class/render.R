lesson <- basename(getwd())

# Note: each deck's _extensions is a symlink to class/_extensions (lexis +
# fontawesome), the single source of truth.

# Build the slides
renderthis::to_html("index.qmd", "index.html")
renderthis::to_pdf("index.html", paste0(lesson, ".pdf"))

# Compress the PDF to reduce size
tools::compactPDF(paste0(lesson, ".pdf"), gs_quality = 'ebook')

# Build the 1-2 page class summary
quarto::quarto_render("summary.qmd", output_format = "typst")
file.rename("summary.pdf", paste0(lesson, "-summary.pdf"))

# Zip up the class practice files students download from the class page.
#
practice_base <- c(
  'data',
  'practice.qmd',
  'practice-solutions.qmd',
  'practice.R',
  'practice-solutions.R'
)

practice_extras <- list(
  '1-getting-started' = 'intro-to-R.R',
  '5-quarto-plotting' = c(
    'bears.qmd',
    'bears_solutions.qmd',
    'ggplot2.qmd',
    'ggplot2_solutions.qmd',
    'logo.png',
    'quarto_demo.qmd'
  ),
  '7-conjoint-questions' = c(
    'conjoint_buttons',
    'conjoint_tables'
  ),
  '8-utility-models' = 'simulate-choices.R',
  '11-doe-power-analysis' = c(
    'balance-orthogonality.qmd',
    'design-efficiency.qmd',
    'interactions.qmd',
    'power-analysis.qmd'
  )
)

extras <- if (lesson %in% names(practice_extras)) {
  practice_extras[[lesson]]
} else {
  character(0)
}

practice_files <- c(practice_base, extras)
practice_files <- practice_files[file.exists(practice_files)]

zipfile <- paste0(lesson, ".zip")
unlink(zipfile)

# Lecture-only weeks have nothing to hand out -- no zip, and the class page
# drops the download button on its own.
#
# Nothing but the practice files goes in: decks and practice files build paths
# with file.path() relative to their own folder, so there is no .Rproj or .here
# marker to ship.
if (length(practice_files)) {
  zip::zip(zipfile = zipfile, files = practice_files)
}
