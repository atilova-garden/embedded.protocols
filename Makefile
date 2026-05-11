PROTO_DIR              := proto
BUF                    := buf
DOCS_REPOSITORY_BRANCH ?= master
REMOTE_URL  := $(shell git remote get-url origin | sed 's|git@github.com:|https://github.com/|')
LATEST_TAG  := $(shell git ls-remote --tags --sort=-version:refname origin 'v*' | head -1 | sed 's|.*refs/tags/||')
AGAINST     ?= $(if $(LATEST_TAG),$(REMOTE_URL)\#tag=$(LATEST_TAG),.git\#branch=master)

.PHONY: lint format build clean breaking ci ci-docs

lint:
	@echo "[lint] Linting protos..."
	$(BUF) lint
	@echo "[lint] Checking format..."
	$(BUF) format --diff

format:
	@echo "[format] Formatting protos in place..."
	$(BUF) format -w

build:
	@echo "[build] Generating protobuf descriptor..."
	$(BUF) build --as-file-descriptor-set -o gen/descriptor.pb

clean:
	@echo "[clean] Removing generated artifacts..."
	find gen -mindepth 1 -not -name '.gitkeep' -delete

breaking:
	@echo "[breaking] Checking breaking changes against $(AGAINST)..."
	$(BUF) breaking --against '$(AGAINST)'

ci: lint

ci-docs: build
	@echo "[docs] Generating documentation (branch: $(DOCS_REPOSITORY_BRANCH))..."
	sed 's/{{DOCS_REPOSITORY_BRANCH}}/$(DOCS_REPOSITORY_BRANCH)/g' sabledocs.toml.template > sabledocs.toml
	uv run sabledocs
