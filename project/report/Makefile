report.pdf: report.tex report.bib
	docker build --tag latex .
	docker rm latex-output || true
	docker run --name latex-output --interactive --tty latex
	docker cp latex-output:/etc/report/report.pdf . || true
	docker rm latex-output

open: report.pdf
	open report.pdf
