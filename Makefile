HTML_FILES=syllabus.html Slides.html

all: $(HTML_FILES) 

clean: 
	rm -f $(HTML_FILES) 

%.html: %.Rmd
	Rscript -e 'rmarkdown::render("$<")'