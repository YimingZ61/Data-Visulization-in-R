HTML_FILES=syllabus.html
PDF_FILES=Slides.pdf

all: $(HTML_FILES) $(PDF_FILES)

clean: 
	rm -f $(HTML_FILES) $(PDF_FILES)

%.html: %.Rmd
	Rscript -e 'rmarkdown::render("$<")'

%.pdf: %.Rmd
	Rscript -e "rmarkdown::render("$<")"