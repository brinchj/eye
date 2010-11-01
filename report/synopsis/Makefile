all: draft.pdf

draft.pdf: synopsis.pdf
	cp synopsis.pdf draft.pdf.part && mv draft.pdf.part draft.pdf

synopsis.pdf: $(wildcard *.tex sections/*.tex) Makefile
	pdflatex synopsis.tex
