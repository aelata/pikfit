# This Makefile only checks whether any file in TARGET needs to be updated.
# Run "Export > HTML > HTML (cdn hosted)" in the preview of VS Code to update.

MFD := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CWD := $(shell pwd)/
ifneq ($(MFD), $(CWD))
  $(error Run make in $(MFD))
endif

TARGET=$(shell find docs -name '*.md' | sed -e 's/\.md/\.html/')

all: $(TARGET)

%.html: %.md
	@echo $@ is out of date.

gh-pages:
	@if make -q all; then \
		git switch main && \
		git branch -D gh-pages 2>/dev/null || true && \
		git switch --orphan gh-pages && \
		git add -f README.txt docs/index.html docs/pikfit.png $(TARGET) && \
		git commit -m "Update html" && \
		git switch main && \
		git restore --source=gh-pages --overlay -- README.txt "*.html" "*.png"; \
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

clean:
	rm -f $(TARGET)
