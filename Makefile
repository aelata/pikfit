# Makefile for GitHUb Pages with Markdown Preview Enhanced
#   This Makefile only checks whether any file in TARGET needs to be updated.
#   Run "Export > HTML > HTML (cdn hosted)" in the preview of VS Code to update.

#   $(ENTRANCE) and $(TARGEt) should be included .gitignore of main branch
#   Use SVG images which will be embedded into HTML files.
#   imginsvg is found here:
#     https://gist.github.com/aelata/3ded90b6a6859c466b59b8b25eb0b0f2

# (c) 2026 aelata
# This script is licensed under the MIT No Attribution (MIT-0) License.
# https://opensource.org/license/mit-0

MFD := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CWD := $(shell pwd)/
ifneq ($(MFD), $(CWD))
  $(error Run make in $(MFD))
endif

# ENTRANCE and TARGET are tracked in gh-pages but not in main (.gitignore)
ENTRANCE = README.txt docs/index.html
TARGET = $(shell find docs -name '*.md' | sed -e 's/\.md/\.html/')
# IMG =  $(shell find docs -name '*.png' | sed -e 's/\.png/\.svg/')
# IMG += $(shell find docs -name '*.jpg' | sed -e 's/\.jpg/\.svg/')

PAGES = $(ENTRANCE) $(TARGET)

all: $(TARGET) # $(IMG)

%.html: %.md
	@echo $@ is out of date.
#	pandoc -o $@ $< # pandoc does not embed SVG images

# %.svg: %.png
# 	imginsvg $< > $@

# %.svg: %.jpg
# 	imginsvg $< > $@

clean:
	rm -f $(TARGET)

gh-pages:
	@if make -q all; then \
		git switch main && \
		git branch -D gh-pages 2>/dev/null || true && \
		git switch --orphan gh-pages && \
		git add -f $(PAGES) && \
		git commit -m "Update html" && \
		git switch main && \
		git restore --source=gh-pages --overlay -- $(PAGES); \
	else \
		echo "Any file in TARGET is out of date."; \
		exit 1; \
	fi

push-gh-pages:
	@if make -q all; then \
		git push --force origin gh-pages; \
	else \
		echo "Any file in TARGET is out of date."; \
		exit 1; \
	fi

overlay-gh-pages:
	@git restore --source=gh-pages --overlay -- $(PAGES)
