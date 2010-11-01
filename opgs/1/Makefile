all: out/powerplant.py.html out/powerplant.sml.html

LIB=Makefile highlight.sh strip_comments.py

out/powerplant.py: py/powerplant.py ${LIB}
	${shell ./strip_comments.py py/powerplant.py > out/powerplant.py}


out/powerplant.py.html: out/powerplant.py ${LIB}
	./highlight.sh out/powerplant.py

out/powerplant.sml: sml/powerplant.sml ${LIB}
	${shell ./strip_comments.py sml/powerplant.sml > out/powerplant.sml}	

out/powerplant.sml.html: out/powerplant.sml ${LIB}
	./highlight.sh out/powerplant.sml

clean:
	rm -rf work/* && \
	rm -rf out/*
