TEXLIBS='LATEX'
MINTED=1
SRC=rapport.tex
TEX=pdflatex

# -----------------------------------------------------------------

# if not defined, src is any .tex file in the current directory
SRC ?= $(wildcard *.tex) # change it if you have more than one 



OUT=$(SRC:.tex=.pdf)

OUT_DIR=./out  # if you do not want it, remove ARGS and compile deps

ifdef I
ARGS=-output-directory=$(OUT_DIR)
else
ARGS=-interaction=nonstopmode -output-directory=$(OUT_DIR)
endif
# if we use the mint latex package for code highlight, turn of shell escape
ifdef MINTED
ARGS+=-shell-escape
endif


EXTRA_END_ARGS=
ifdef KILE
LOG ?= $(SRC:.tex=.log)
EXTRA_END_ARGS= | tee $(LOG)
endif

# if your templates are not in your path (like in ~/texmf folder), 
# set the TEXINPUTS path like this:
#	export TEXINPUTS="path to directory":
# or pass it to make using 
#	TEXLIBS=<path to dir>


# =========================

compile: $(OUT_DIR)
	@echo TEXLIBS is $(TEXLIBS) $$TEXINPUTS
	TEXINPUTS=$(TEXLIBS): $(TEX) $(ARGS) $(SRC) $(EXTRA_END_ARGS) #| tee $(SRC:.tex=.log)
	-mv out/$(OUT) . 


bibtex: 
	biber out/$(SRC:%.tex=%)

bcompile: bibtex compile

all: compile clean show

show: 
	if [ ! -e $(OUT) ]; then make compile; fi
	xdg-open "$(OUT)" > /dev/null 2>&1 &

# ------------------------

$(OUT_DIR):
	mkdir $(OUT_DIR)

# ------------------------

clean_all: clean
	rm -f $(OUT)

clean:
	rm -rf $(OUT_DIR) *.log 

# ------------------------

.PHONY: all clean show
