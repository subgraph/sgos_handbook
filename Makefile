.PHONY: clean spellcheck docbook_fix_links

OS := $(shell uname)
ifeq ($(OS),Darwin)
	SHELL := "/bin/bash"
	ASPELLPATH := "/usr/local/bin/aspell"
	FONT := Palatino
else
	ASPELLPATH := "/usr/bin/aspell"
	FONT := Noto Sans
	EPUB_FONTS := 'static/fonts/Liberation*.ttf'
endif

ASPELL := $(shell { type $(ASPELLPATH); } 2>/dev/null)
STYLE := $(shell { type /usr/bin/style; } 2>/dev/null)
BUILD_DIR := "build"
BOOK_CH1 := $(sort $(wildcard 01_*))
BOOK_CH2 := $(sort $(wildcard 02_*))
BOOK_CH3 := $(sort $(wildcard 03_*))
BOOK_CH4 := $(sort $(wildcard 04_*))
BOOK_CH5 := $(sort $(wildcard 05_*))
BOOK_CH_ALL := $(BOOK_CH1) $(BOOK_CH2) $(BOOK_CH3) $(BOOK_CH4) $(BOOK_CH4) $(BOOK_CH5)

all: clean spellcheck readability contents sgos_handbook
docbook_dev: docbook docbook_fix_links_dev

# requires aspell, aspell-en
spellcheck:
ifdef ASPELL
	find . -maxdepth 1 -name "*.md" -exec $(ASPELLPATH) check {} \;
else
	echo "$(ASPELLPATH) is missing -- no spellcheck possible"
endif

# requires diction
readability: $(BUILD_DIR)/readability.txt
$(BUILD_DIR)/readability.txt: *.md
ifdef STYLE
	style -p $^ > $@
else 
	echo "/usr/bin/style is missing -- no readability check possible"
endif

# requires texlive, texlive-xetex, lmodern, pdftk
contents: $(BUILD_DIR)/contents.pdf
$(BUILD_DIR)/contents.pdf:  $(BOOK_CH_ALL) metadata.yaml
	pandoc -r markdown  -o $@ -H templates/style.tex --template=templates/sgos_handbook.latex --toc --latex-engine=xelatex -V mainfont="$(FONT)" $^

sgos_handbook: $(BUILD_DIR)/sgos_handbook.pdf
$(BUILD_DIR)/sgos_handbook.pdf: static/sgos_handbook_cover.pdf build/contents.pdf 
	pdftk $^ cat output $@

epub: $(BUILD_DIR)/sgos_handbook.epub
$(BUILD_DIR)/sgos_handbook.epub: $(BOOK_CH_ALL) metadata.yaml
	pandoc -r markdown --epub-embed-font=$(EPUB_FONTS) --epub-cover-image=static/sgos_handbook_cover.png -o $@ $^


docbook: $(BUILD_DIR)/sgos_handbook.xml
$(BUILD_DIR)/sgos_handbook.xml: $(BOOK_CH4) $(BOOK_CH5) metadata.yaml
	pandoc -s -r markdown -t docbook -o $@ $^

docbook_fix_links_dev:
	sed -i 's/<imagedata fileref="static\/images/<imagedata fileref="..\/static\/images/g' $(BUILD_DIR)/sgos_handbook.xml

html: $(BUILD_DIR)/sgos_handbook.html 
$(BUILD_DIR)/sgos_handbook.html: $(BOOK_CH_ALL) metadata.yaml
	pandoc -s -r markdown -t html -o $@ $^

clean:
	rm -f $(BUILD_DIR)/*.pdf $(BUILD_DIR)/*.txt
