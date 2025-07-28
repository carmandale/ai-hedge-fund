#!/bin/bash

# AI Hedge Fund CLI Runner (uv version)
# This script runs the command-line interface of the AI hedge fund

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists python3; then
        print_error "Python 3 is required but not installed."
        print_error "Please install Python 3.11+ from https://python.org/"
        exit 1
    fi
    
    if ! command_exists uv; then
        print_error "uv is required but not installed."
        print_error "Please install uv from https://docs.astral.sh/uv/"
        exit 1
    fi
    
    print_success "All prerequisites are installed!"
}

# Setup environment
setup_environment() {
    print_status "Setting up Python environment..."
    
    # Create virtual environment if it doesn't exist
    if [[ ! -d ".venv" ]]; then
        print_status "Creating virtual environment..."
        uv venv --python 3.11
    fi
    
    # Check if dependencies are installed
    if source .venv/bin/activate && python -c "import langchain, fastapi" >/dev/null 2>&1; then
        print_success "Dependencies already installed!"
        deactivate
    else
        print_status "Installing dependencies..."
        uv pip install -r requirements.txt
        print_success "Dependencies installed!"
    fi
    
    # Check if .env exists
    if [[ ! -f ".env" ]]; then
        if [[ -f ".env.example" ]]; then
            print_status "Creating .env from .env.example..."
            cp ".env.example" ".env"
            print_status "Please edit the .env file to add your API keys before running the CLI."
        else
            print_error "No .env or .env.example file found."
            print_error "Please create a .env file with your API keys."
            exit 1
        fi
    else
        print_success "Environment file (.env) found!"
    fi
}

# Run the CLI
run_cli() {
    print_status "Starting AI Hedge Fund CLI..."
    echo ""
    
    # Activate virtual environment and run the main script
    source .venv/bin/activate
    python src/main.py "$@"
    deactivate
}

# Main execution
main() {
    echo ""
    print_status "🚀 AI Hedge Fund CLI (uv version)"
    echo ""
    
    check_prerequisites
    setup_environment
    run_cli "$@"
}

# Show help if requested
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "AI Hedge Fund CLI Runner (uv version)"
    echo ""
    echo "Usage: ./run_cli.sh [CLI_ARGUMENTS]"
    echo ""
    echo "This script will:"
    echo "  1. Check for required dependencies (Python, uv)"
    echo "  2. Install Python dependencies using uv"
    echo "  3. Run the AI hedge fund CLI with any provided arguments"
    echo ""
    echo "Requirements:"
    echo "  - Python 3.11+ (https://python.org/)"
    echo "  - uv (https://docs.astral.sh/uv/)"
    echo ""
    echo "Any additional arguments will be passed to the CLI application."
    echo ""
    exit 0
fi

# Run main function with all arguments
main "$@"