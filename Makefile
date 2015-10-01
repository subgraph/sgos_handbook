.PHONY: clean spellcheck

OS := $(shell uname)
ifeq ($(OS),Darwin)
	SHELL := "/bin/bash"
	ASPELLPATH := "/usr/local/bin/aspell"
else
	ASPELLPATH := "/usr/bin/aspell"
endif
ASPELL := $(shell { type $(ASPELLPATH); } 2>/dev/null)
STYLE := $(shell { type /usr/bin/style; } 2>/dev/null)

all: clean spellcheck readability contents sgos_handbook

# requires aspell
spellcheck:
ifdef ASPELL
	find . -maxdepth 1 -name "*.md" -exec $(ASPELLPATH) check {} \;
else
	echo "$(ASPELLPATH) is missing -- no spellcheck possible"
endif

# requires diction
readability: build/readability.txt
build/readability.txt: *.md
ifdef STYLE
	style -p $^ > $@
else 
	echo "/usr/bin/style is missing -- no readability check possible"
endif

# requires texlive and texlive-xetex
contents: build/contents.pdf
build/contents.pdf:  1_intro.md 2_faq.md 3_installation.md 4_everyday_usage.md 5_features_and_advanced_usage.md
	pandoc -r markdown  -o $@ -H templates/style.tex --template=templates/sgos_handbook.latex --latex-engine=xelatex -V mainfont='Droid Sans' $^

sgos_handbook: build/sgos_handbook.pdf
build/sgos_handbook.pdf: static/sgos_handbook_cover.pdf build/contents.pdf 
	pdftk $^ cat output $@

clean:
	rm build/*
