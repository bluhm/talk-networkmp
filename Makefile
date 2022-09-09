USE_PDFLATEX =	yes
NAME =		networkmp-slides
TEXSRCS	=	networkmp-slides.tex
CLEAN_FILES =	${NAME:=.nav} ${NAME:=.snm} gnuplot/*
# make does not support : in file name, it is a variable modifier
# latex does not support . in file name, it is a suffix
GNUPLOTS = \
    2019-02-04T15:10:35Z tcp - - - - - \
    2019-08-10T05:41:55Z tcp 3 1564614000 1564707600 3000000000 3500000000

test.data:
	ftp http://bluhm.genua.de/perform/results/test.data

.for d p n x X y Y in ${GNUPLOTS}

TEXSRCS +=	gnuplot/${d:S/:/-/g}-$p${n:N-:S/^/-/}.tex

.PATH: bin

gnuplot/${d:S/:/-/g}-$p${n:N-:S/^/-/}.tex: \
    gnuplot.pl Buildquirks.pm Html.pm Testvars.pm plot.gp test.data
	mkdir -p gnuplot
	rm -f $@
	perl bin/gnuplot.pl -L -d $d -p $p ${n:N-:S/^/-N /} \
	    ${x:N-:S/^/-x /} ${X:N-:S/^/-X /} \
	    ${y:N-:S/^/-y /} ${Y:N-:S/^/-Y /}
	cp gnuplot/$d-$p${n:N-:S/^/-/}.tex $@

.endfor

.include </usr/local/share/latex-mk/latex.mk>
