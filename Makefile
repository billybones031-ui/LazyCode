─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────.PHONY: help install lint format test clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install all dependencies
	@if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
	@if [ -f package.json ]; then npm install; fi
	@pip install ruff black pytest pytest-cov 2>/dev/null || true

lint: ## Run all linters
	@if command -v ruff &>/dev/null; then ruff check .; fi
	@if [ -f package.json ]; then npx eslint . 2>/dev/null || true; fi

format: ## Auto-format all code
	@if command -v ruff &>/dev/null; then ruff format .; fi
	@if command -v black &>/dev/null; then black .; fi
	@if [ -f package.json ]; then npx prettier --write . 2>/dev/null || true; fi

test: ## Run all tests
	@if [ -d tests ]; then pytest --tb=short; fi
	@if [ -f package.json ]; then npm test 2>/dev/null || true; fi

clean: ## Remove build artifacts and caches
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name .pytest_cache -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name .ruff_cache -exec rm -rf {} + 2>/dev/null || true
	@rm -rf dist/ build/ *.egg-info/ htmlcov/ .coverage 2>/dev/null || true
	@if [ -f package.json ]; then rm -rf node_modules/ 2>/dev/null || true; fi

check: lint test ## Run lint + tests together
