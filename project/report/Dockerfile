FROM ubuntu

RUN apt-get --force-yes --assume-yes update
RUN apt-get --force-yes --assume-yes install wget unzip make

RUN apt-get --force-yes --assume-yes install texlive
RUN apt-get --force-yes --assume-yes install texinfo
RUN apt-get --force-yes --assume-yes install texlive-latex-extra
RUN apt-get --force-yes --assume-yes install texlive-bibtex-extra biber

RUN mkdir -p /etc/report
ADD . /etc/report

CMD cd /etc/report && pdflatex report.tex && biber report.bcf && pdflatex report.tex