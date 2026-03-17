# This Makefile only checks whether any file in TARGET needs to be updated.
# Run "Export > HTML > HTML (cdn hosted)" in the preview of VS Code to update.

MFD := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CWD := $(shell pwd)/
ifneq ($(MFD), $(CWD))
  $(error Run make in $(MFD))
endif

# ENTRANCE and TARGET are tracked in gh-pages but not in main (.gitignore)
ENTRANCE = README.txt docs/index.html
TARGET = $(shell find docs -name '*.md' | sed -e 's/\.md/\.html/')
# IMG is tracked both in main and gh-pages
IMG = $(shell find docs -name '*.png') # -or -name '*.jpg'

PAGES = $(ENTRANCE) $(TARGET) $(IMG)

all: $(TARGET)

%.html: %.md
	@echo $@ is out of date.

clean:
	rm -f $(TARGET)

gh-pages:
	@if make -q all; then \
		git switch main && \
		git branch -D gh-pages 2>/dev/null || true && \
		git switch --orphan gh-pages && \
		git restore --source=main --overlay -- $(IMG) && \
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
