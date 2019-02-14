BUILD=build
BBLS=$(BUILD)/pr.bbl $(BUILD)/nopr.bbl $(BUILD)/inprep.bbl $(BUILD)/post.bbl $(BUILD)/talk.bbl

all: $(BUILD)/cv.pdf

$(BUILD)/cv.pdf: $(BBLS)
	pdflatex -output-directory=$(BUILD) cv
	pdflatex -output-directory=$(BUILD) cv

%.aux: cv.tex MyPubs.bib  MyPubs_nonPR.bib MyInPrep.bib MyConfProceedings.bib MyTalks.bib cvbib.bst
	pdflatex -output-directory=$(BUILD) cv

%.bbl: %.aux
	bibtex $<

cvbib.bst: cvbib.dbj
	latex $<

upload: $(BUILD)/cv.pdf
	git -C $(BUILD) init
	git -C $(BUILD) checkout -b gh-pages
	git -C $(BUILD) add cv.pdf
	git -C $(BUILD) commit -m 'PDF build'
	git -C $(BUILD) remote add origin `git remote get-url --push origin`
	git -C $(BUILD) push origin gh-pages --force
	rm -rf $(BUILD)/.git

clean:
	rm $(BUILD)/*.pdf $(BBLS) $(BUILD)/*.aux $(BUILD)/*.log \
		$(BUILD)/*.out $(BUILD)/*.blg
