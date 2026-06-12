# Semester Rollover Checklist

Manual steps for rolling the course site over to a new semester. The bulk copy
(file copy, year/URL updates, schedule.csv date shift, placeholder class pages,
temp HW versions) is done first; these are the remaining steps that can't be
scripted.

## One-time setup (before semester starts)

- [x] Fill in the new CRN in `_variables.yml` (6035: 55690)
- [ ] Create the new Slack workspace (links already point to
      `emse-madd-f26.slack.com` in `_variables.yml` and `_quarto.yml`)
- [ ] Create a new Google Calendar booking page and update the signup link in
      `class/4-workshop-proposals.qmd`
- [ ] Update HW template zip files in `templates/` if needed
- [ ] Verify class dates against the official GW academic calendar
      (first class, Thanksgiving break, last class)
- [ ] Render the site locally and click through all pages
- [ ] Make a baseline git commit before editing content

## Weekly (as the semester progresses)

For each class week:

- [ ] Update the week's slides in `class/<week>/index.Rmd`, then re-render
      slides, PDF, and notes zip with `class/render.R` (the copied
      `index.html` / `.pdf` / `.zip` files are still last year's renders)
- [ ] Restore the class page: in `class/<week>.qmd`, swap the
      `fragments/placeholder.qmd` child back to `fragments/class.qmd`
- [ ] Release the HW: replace the "Coming soon!" version with the full
      assignment by renaming `hw/<assignment>-temp.qmd` over
      `hw/<assignment>.qmd` (review content/links before releasing)

## End of semester

- [ ] Distribute the take-home exam (HW 12) in class on 11/18; due 11/22
- [ ] Update the project showcase with the new semester's examples
