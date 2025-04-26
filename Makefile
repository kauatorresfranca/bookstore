# Python version (updated to match your environment)
PYTHON_VERSION ?= 3.11.9

# Directory containing the library module (updated to your Django app)
LIBRARY_DIRS = bookStore

# Build artifacts directory
BUILD_DIR ?= build

# PyTest options
PYTEST_HTML_OPTIONS = --html=$(BUILD_DIR)/report.html --self-contained-html
PYTEST_TAP_OPTIONS = --tap-combined --tap-outdir $(BUILD_DIR)
PYTEST_COVERAGE_OPTIONS = --cov=$(LIBRARY_DIRS)
PYTEST_OPTIONS ?= $(PYTEST_HTML_OPTIONS) $(PYTEST_TAP_OPTIONS) $(PYTEST_COVERAGE_OPTIONS)

# MyPy typechecking options (updated for Python 3.11)
MYPY_OPTS ?= --python-version 3.11 --show-column-numbers --pretty --html-report $(BUILD_DIR)/mypy

# Poetry settings
POETRY_OPTS ?=
POETRY ?= poetry $(POETRY_OPTS)
RUN_PYPKG_BIN = $(POETRY) run

##@ Utility

.PHONY: help
help:  ## Display this help
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  help            Display this help"
	@echo "  version-python  Echo the Python version in use"
	@echo "  test            Run tests with pytest"
	@echo "  build           Run a build with Poetry"
	@echo "  publish         Publish the build to a repository"
	@echo "  deps-py         Install Python dependencies"
	@echo "  check           Run linters (flake8, black, mypy)"
	@echo "  format-py       Format code with black"
	@echo "  format-isort    Organize imports with isort"

.PHONY: version-python
version-python: ## Echo the Python version in use
	@echo $(PYTHON_VERSION)

##@ Testing

.PHONY: test
test: ## Run tests
	$(RUN_PYPKG_BIN) pytest \
		$(PYTEST_OPTIONS) \
		tests/*.py

##@ Building and Publishing

.PHONY: build
build: ## Run a build
	$(POETRY) build

.PHONY: publish
publish: ## Publish a build to the configured repo
	$(POETRY) publish

.PHONY: deps-py-update
deps-py-update: pyproject.toml ## Update Poetry dependencies
	$(POETRY) update

##@ Setup

.PHONY: deps-py
deps-py: ## Install Python development and runtime dependencies
	$(POETRY) install

##@ Code Quality

.PHONY: check
check: check-py ## Run linters and other tools

.PHONY: check-py
check-py: check-py-flake8 check-py-black check-py-mypy ## Check Python files

.PHONY: check-py-flake8
check-py-flake8: ## Run flake8 linter
	$(RUN_PYPKG_BIN) flake8 .

.PHONY: check-py-black
check-py-black: ## Run black in check mode (no changes)
	$(RUN_PYPKG_BIN) black --check --line-length 118 --fast .

.PHONY: check-py-mypy
check-py-mypy: ## Run mypy
	$(RUN_PYPKG_BIN) mypy $(MYPY_OPTS) $(LIBRARY_DIRS)

.PHONY: format-py
format-py: ## Run black, make changes where necessary
	$(RUN_PYPKG_BIN) black .

.PHONY: format-isort
format-isort: ## Organize imports with isort
	$(RUN_PYPKG_BIN) isort .