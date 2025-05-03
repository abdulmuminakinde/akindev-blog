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
	git status --porcelain | awk '{print $$2}' | grep '.md' | xargs -n 1 prettier --write

update:
	git submodule update --remote --merge
	uvx pre-commit autoupdate
	npm update

devserver:
	hugo server --disableFastRender -e production --bind 0.0.0.0 --ignoreCache

convert-jpgs:
	@mkdir -p .cache
	@touch .cache/converted-jpgs
	find static/images/ -iname '*.jpg' -o -iname '*.jpeg' | while read filepath; do \
		hash=$$(sha256sum "$$filepath" | cut -d ' ' -f1); \
		if grep -q "$$hash" .cache/converted-jpgs; then \
			echo "Skipping already converted: $$filepath"; \
		else \
			newpath="$${filepath%.*}.png"; \
			magick "$$filepath" "$$newpath" && rm "$$filepath"; \
			echo "$$hash $$filepath -> $$newpath" >> .cache/converted-jpgs; \
		fi \
	done

upload-static: convert-jpgs
	@mkdir -p .cache
	@touch .cache/oxipng-hashes
	@touch .cache/uploaded-files
	
	# Optimize PNGs with caching
	find static/images -type f -name '*.png' | while read filepath; do \
		hash=$$(sha256sum "$$filepath" | cut -d ' ' -f1); \
		if grep -q "$$hash" .cache/oxipng-hashes; then \
			echo "Skipping already optimized: $$filepath"; \
		else \
			oxipng -o 6 "$$filepath"; \
			echo "$$hash $$filepath" >> .cache/oxipng-hashes; \
		fi \
	done
	
	# Upload with caching
	find static -type f | while read filepath; do \
		key=$$(echo "$$filepath" | sed 's|^|akindev-blog/|'); \
		file_hash=$$(sha256sum "$$filepath" | cut -d ' ' -f1); \
		cache_entry="$$file_hash $$key"; \
		if grep -q "$$cache_entry" .cache/uploaded-files; then \
			echo "Skipping already uploaded: $$key"; \
		else \
			wrangler r2 object put "$$key" --file "$$filepath" --remote; \
			echo "$$cache_entry" >> .cache/uploaded-files; \
		fi \
	done
