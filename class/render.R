# Run this from within a class folder's RStudio project (open its .Rproj first)
# to (re)build that class's slides.

lesson <- strsplit(here::here(), "/")[[1]]
lesson <- lesson[length(lesson)]

# Refresh this class's copy of the shared Quarto extensions (lexis + fontawesome).
# The source of truth is class/_extensions/ — edit there, never the per-class copy.
# Each class needs its own copy because the class folders are render-excluded in
# _quarto.yml, so Quarto only looks for _extensions inside the folder itself.
unlink("_extensions", recursive = TRUE)
file.copy("../_extensions", ".", recursive = TRUE)

# Build the slides
renderthis::to_html("index.qmd", "index.html")
renderthis::to_pdf("index.html", paste0(lesson, ".pdf"))

# Compress the PDF to reduce size
tools::compactPDF(paste0(lesson, ".pdf"), gs_quality = 'ebook')

# Files to bundle into the downloadable class-notes zip.
# Edit this list per lesson as needed; only files that exist are included.
notes_files <- c(
  'data',
  'practice.qmd',
  'practice-solutions.qmd'
)
notes_files <- notes_files[file.exists(notes_files)]

zip::zip(
  zipfile = paste0(lesson, ".zip"),
  files = c(notes_files, paste0(lesson, ".Rproj"))
)
