# Shared cargo targets for every example.
# Each example's Makefile includes this file. Run these from inside the
# container, in the example's folder (e.g. examples/01-hello-world).

CARGO ?= cargo
ARGS  ?=

.DEFAULT_GOAL := help
.PHONY: help build release run test check fmt fmt-check lint doc clean ci

help: ## Show available commands
	@grep -hE '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

build: ## Compile in debug mode
	$(CARGO) build

release: ## Compile an optimized release build
	$(CARGO) build --release

run: ## Run the program (pass arguments with ARGS="...")
	$(CARGO) run -- $(ARGS)

test: ## Run the tests
	$(CARGO) test

check: ## Type-check quickly without producing a binary
	$(CARGO) check

fmt: ## Format the code
	$(CARGO) fmt

fmt-check: ## Fail if the code is not formatted
	$(CARGO) fmt --check

lint: ## Run clippy and treat warnings as errors
	$(CARGO) clippy --all-targets -- -D warnings

doc: ## Build the docs for this crate
	$(CARGO) doc --no-deps

clean: ## Delete build artifacts (the target/ folder)
	$(CARGO) clean

ci: fmt-check lint test ## Run format check, lint, and tests together
