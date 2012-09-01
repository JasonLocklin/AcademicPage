#Recreate CV and main page whenever something needs to be updated
# Jason Locklin
#


all : cv web apa.csl


#TODO add git update and "publish" commands to this makefile

clean: index.html
	rm index.html

index.html: template.html
	pandoc -s --template=template.html -o index.html current_research.md \
		publications.md interests.md

apa.csl:
	wget "http://zotero.org/styles/apa" -O apa.csl 

citations.md: locklin.bib
	#Note, in makefiles, $ needs to be doubled.
	grep "@" locklin.bib | sed 's/@[a-zA-Z]*{/@/' | sed ':a;N;$$!ba;s/\n/ /g'  | sed 's/,$$/]/g' | sed 's/^/[/' > citations.md

	
cv.md: apa.csl citations.md
	pandoc --bibliography locklin.bib --csl=apa.csl -o cv.md citations.md
	tail cv.md -n+2 > cv2.md #this leaves just the bibliography
	#pandoc -S --bibliography locklin.bib --csl=apa.csl -o cv.pdf locklin.md
	#pandoc -t latex --natbib locklin.bib --csl=apa.csl #uncomment for natbib

locklin.tex:
	cd tex
	pandoc -s --template=template.tex -o locklin-test.tex ../education.md \
		../publications.md ../awards.md ../teaching.md ../research_experience.md \
		../other_experience.md ../expertise.md ../interests.md
	sed 's/subsection/section/' locklin.tex > locklin2.tex #CV uses section headings only
	sed 's/\\{itemize}/\\{outerlist}/' locklin2.tex > locklin3.tex #CV uses outerlist/innerlist instead of itemize
	sed 's/\s\\{itemize}/\\{innerlist}/' locklin3.tex > locklin4.tex
	mv locklin4.tex locklin.tex && rm locklin2.tex && rm locklin3.tex #cleanup
	#latex locklin.tex
	cd .. 
