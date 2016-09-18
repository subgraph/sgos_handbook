.PHONY: clean spellcheck

OS := $(shell uname)
ifeq ($(OS),Darwin)
	SHELL := "/bin/bash"
	ASPELLPATH := "/usr/local/bin/aspell"
	FONT := Palatino
else
	ASPELLPATH := "/usr/bin/aspell"
	FONT := Nimbus Sans L

endif
ASPELL := $(shell { type $(ASPELLPATH); } 2>/dev/null)
STYLE := $(shell { type /usr/bin/style; } 2>/dev/null)
BUILD_DIR := "build"
DOCBOOK_TEST_IMAGE_PATH := "<imagedata fileref=\"..\/static"


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
$(BUILD_DIR)/contents.pdf:  1_intro.md 2_faq.md 3_installation.md 4_everyday_usage.md 5_features_and_advanced_usage.md
	pandoc -r markdown  -o $@ -H templates/style.tex --template=templates/sgos_handbook.latex --toc --latex-engine=xelatex -V mainfont="$(FONT)" $^

sgos_handbook: $(BUILD_DIR)/sgos_handbook.pdf
$(BUILD_DIR)/sgos_handbook.pdf: static/sgos_handbook_cover.pdf build/contents.pdf 
	pdftk $^ cat output $@

docbook: $(BUILD_DIR)/sgos_handbook.xml
$(BUILD_DIR)/sgos_handbook.xml: 4_everyday_usage.md
	pandoc -s -r markdown -t docbook -o $@ $^

docbook_fix_links_dev:
	sed -i 's/<imagedata fileref="static/<imagedata fileref="..\/static/g' $(BUILD_DIR)/sgos_handbook.xml

clean:
	rm -f $(BUILD_DIR)/*.pdf $(BUILD_DIR)/*.txt
