.PHONY: $(MAKECMDGOALS)

SHELL := /bin/bash -ex

MAKEFLAGS += --silent

BREW_PACKAGES := gh hugo prettier uv oxipng imagemagick

init:
	git submodule update --init --recursive
	npm install
	npm install -g wrangler
	for pkg in $(BREW_PACKAGES); do \
		brew list $$pkg &>/dev/null || brew install $$pkg; \
	done
	uv venv -p 3.12
	uv tool install pre-commit
	uv pip install black blacken-docs mypy pytest pytest-cov ruff

lint:
	git status --porcelain | awk '{print $$2}' | xargs -r uvx pre-commit run --files
	git status --porcelain | awk '{print $$2}' | grep '.md' | xargs -n q prettier --write

update:
	git submodule update --remote --merge
	uvx pre-commit autoupdate
	npm update

devserver:
	hugo server --disableFastRender -e production --bind 0.0.0.0 --ignoreCache

convert-jpgs:
	find static/images/ -iname '*.jpg' -o -iname '*.jpeg' | while read filepath; do \
		newpath="$${filepath%.*}.png"; \
		magick "$$filepath" "$$newpath" && rm "$$filepath"; \
	done

upload-static: convert-jpgs
	oxipng -o 6 -r static/images/
	find static -type f | while read filepath; do \
		key=$$(echo "$$filepath" | sed 's|^|akindev-blog/|'); \
		wrangler r2 object put $$key --file "$$filepath" --remote; \
	done
