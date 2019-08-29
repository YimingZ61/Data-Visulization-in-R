syllabus.html: syllabus.Rmd
	Rscript -e 'rmarkdown::render("syllabus.Rmd")'


clean:
	rm syllabus.md syllabus.html
