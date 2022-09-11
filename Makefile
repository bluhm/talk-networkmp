USE_PDFLATEX =	yes
NAME =		networkmp-slides
TEXSRCS	=	networkmp-slides.tex
CLEAN_FILES =	${NAME:=.nav} ${NAME:=.snm} gnuplot/*
# make does not support : in file name, it is a variable modifier
# latex does not support . in file name, it is a suffix
GNUPLOTS = \
    2022-09-04T20:23:45Z udp 2 1662249599 1662249603 0 3500000000 \
    7.1 forward 0,1 - - - - \
    7.1 tcp - - - - - \
    7.1 tcp6 - - - - - \
    6.9 ipsec - - - - - \

results/test.data:
	mkdir -p results
	ftp http://bluhm.genua.de/perform/results/test.data
	mv test.data $@

results/6.9/ipsec.data \
results/7.1/tcp.data results/7.1/tcp6.data results/7.1/forward.data:
	mkdir -p ${@:H}
	ftp http://bluhm.genua.de/perform/${@:H}/gnuplot/${@:T}
	mv ${@:T} $@

.for d p n x X y Y in ${GNUPLOTS}

TEXSRCS +=	gnuplot/${d:C/[:.]/-/g}-$p${n:N-:S/^/-/}.tex

.PATH: bin

gnuplot/${d:C/[:.]/-/g}-$p${n:N-:S/^/-/}.tex: \
    gnuplot.pl Buildquirks.pm Html.pm Testvars.pm plot.gp results/test.data
	mkdir -p gnuplot
	rm -f $@
	perl bin/gnuplot.pl -L \
	    ${d:M*-*:S/^/-d /} ${d:M*.*:S/^/-r /} \
	    -p $p ${n:N-:S/^/-N /} \
	    ${x:N-:S/^/-x /} ${X:N-:S/^/-X /} \
	    ${y:N-:S/^/-y /} ${Y:N-:S/^/-Y /}
	cp gnuplot/$d-$p${n:N-:S/^/-/}.tex $@

.endfor

.include </usr/local/share/latex-mk/latex.mk>
