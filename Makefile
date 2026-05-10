PROTO_DIR := proto
BUF       := buf
AGAINST   ?= .git#branch=master

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
	cd $(PROTO_DIR) && $(BUF) breaking --against '$(AGAINST)'

ci: lint

ci-docs: build
	@echo "[docs] Generating documentation..."
	uv run sabledocs
