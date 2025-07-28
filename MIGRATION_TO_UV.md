# Migration from Poetry to uv

This document outlines the migration of the AI Hedge Fund project from Poetry to uv for better dependency management and performance.

## Changes Made

### 1. Dependency Files Created

#### `requirements.in` (Main Dependencies)
```
# Main dependencies for ai-hedge-fund
langchain==0.3.0
langchain-anthropic==0.3.5
langchain-groq==0.2.3
langchain-openai>=0.3.5
langchain-deepseek>=0.1.2
langchain-ollama>=0.2.0
langgraph==0.2.56
pandas>=2.1.0
numpy>=1.24.0
python-dotenv==1.0.0
matplotlib>=3.9.2
tabulate>=0.9.0
colorama>=0.4.6
questionary>=2.1.0
rich>=13.9.4
langchain-google-genai>=2.0.11
# Backend dependencies
fastapi[standard]>=0.104.0
fastapi-cli>=0.0.7
pydantic>=2.4.2
httpx>=0.27.0
sqlalchemy>=2.0.22
alembic>=1.12.0
```

#### `requirements-dev.in` (Development Dependencies)
```
# Development dependencies for ai-hedge-fund
-r requirements.in
pytest>=7.4.0
black>=23.7.0
isort>=5.12.0
flake8>=6.1.0
```

#### `requirements.txt` and `requirements-dev.txt`
These are automatically generated from the `.in` files using:
```bash
uv pip compile requirements.in -o requirements.txt
uv pip compile requirements-dev.in -o requirements-dev.txt
```

### 2. Updated pyproject.toml

The original Poetry-based `pyproject.toml` has been replaced with a uv-compatible version:

```toml
[project]
name = "ai-hedge-fund"
version = "0.1.0"
description = "An AI-powered hedge fund that uses multiple agents to make trading decisions"
readme = "README.md"
requires-python = ">=3.11"

[build-system]
requires = ["setuptools>=69", "wheel"]
build-backend = "setuptools.build_meta"

[tool.setuptools]
packages = ["src", "app"]

[tool.black]
line-length = 420
target-version = ['py311']
include = '\.pyi?$'

[tool.isort]
profile = "black"
force_alphabetical_sort_within_sections = true

[tool.uv]
dev-dependencies = [
    "pytest>=7.4.0",
    "black>=23.7.0",
    "isort>=5.12.0",
    "flake8>=6.1.0",
]
```

### 3. New Scripts

#### `app/run_uv.sh` (Web Application Runner)
Updated version of the original `run.sh` that uses uv instead of Poetry:
- Checks for uv installation and offers to install it automatically
- Creates and manages uv virtual environment
- Installs dependencies using `uv pip install -r requirements.txt`
- Starts both backend and frontend services

#### `run_cli.sh` (CLI Runner)
New script for running the command-line interface:
- Sets up uv environment
- Runs the CLI application with provided arguments

### 4. Environment Configuration

#### `.env.local` (Frontend Development Configuration)
```
# Frontend development server configuration
PORT=5173
VITE_API_URL=http://localhost:8000
```

## Migration Commands

Here are the exact commands that were used for migration:

### 1. Install uv (if not already installed)
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. Create Virtual Environment
```bash
uv venv --python 3.11
```

### 3. Generate Requirements Files
```bash
# Create requirements.in and requirements-dev.in files (as shown above)
uv pip compile requirements.in -o requirements.txt
uv pip compile requirements-dev.in -o requirements-dev.txt
```

### 4. Install Dependencies
```bash
source .venv/bin/activate
uv pip install -r requirements-dev.txt
```

### 5. Backup and Replace pyproject.toml
```bash
mv pyproject.toml pyproject_poetry_backup.toml
# Create new pyproject.toml (as shown above)
```

## Usage

### Web Application
```bash
cd app/
./run_uv.sh
```

### CLI Application
```bash
./run_cli.sh [arguments]
```

### Development Commands

#### Install dependencies
```bash
source .venv/bin/activate
uv pip install -r requirements-dev.txt
```

#### Update dependencies
```bash
# Edit requirements.in or requirements-dev.in
uv pip compile requirements.in -o requirements.txt
uv pip compile requirements-dev.in -o requirements-dev.txt
uv pip install -r requirements-dev.txt
```

#### Add new dependency
```bash
# Add to requirements.in
echo "new-package>=1.0.0" >> requirements.in
uv pip compile requirements.in -o requirements.txt
uv pip install -r requirements.txt
```

#### Development tools
```bash
source .venv/bin/activate

# Code formatting
black src/ app/
isort src/ app/

# Linting
flake8 src/ app/

# Testing
pytest tests/
```

## Benefits of uv Migration

1. **Speed**: uv is significantly faster than Poetry for dependency resolution and installation
2. **Modern**: Built on Rust, designed for modern Python development
3. **Compatibility**: Works with standard requirements.txt format
4. **Flexibility**: Easy to switch between different Python versions
5. **Simplicity**: Fewer configuration files and simpler commands

## Backward Compatibility

- Original Poetry files are backed up as `pyproject_poetry_backup.toml` and `poetry.lock`
- Original run script is still available as `app/run.sh`
- All dependencies and versions are preserved
- Project structure remains identical

## Troubleshooting

### Virtual Environment Issues
```bash
# Remove and recreate virtual environment
rm -rf .venv
uv venv --python 3.11
uv pip install -r requirements-dev.txt
```

### Dependency Conflicts
```bash
# Clean install
uv pip compile requirements.in -o requirements.txt --upgrade
uv pip install -r requirements.txt
```

### Missing Dependencies
```bash
# Check what's installed
uv pip list
# Install specific dependency
uv pip install package-name
```

## Next Steps

1. Test both web application and CLI functionality
2. Update CI/CD pipelines to use uv instead of Poetry
3. Update documentation to reference uv commands
4. Consider removing Poetry backup files after confirming everything works

The migration preserves all functionality while providing improved performance and modern Python dependency management.