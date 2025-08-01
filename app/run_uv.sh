#!/bin/bash

# AI Hedge Fund Web Application Setup and Runner (uv version)
# This script makes it easy for non-technical users to run the full web application

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

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to open browser
open_browser() {
    local url="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        open "$url"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command_exists xdg-open; then
            xdg-open "$url"
        elif command_exists firefox; then
            firefox "$url" &
        elif command_exists google-chrome; then
            google-chrome "$url" &
        elif command_exists chromium; then
            chromium "$url" &
        fi
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
        # Windows
        start "$url"
    fi
}

# Function to check if we're in the right directory
check_directory() {
    if [[ ! -d "frontend" ]] || [[ ! -d "backend" ]]; then
        print_error "This script must be run from the app/ directory"
        print_error "Please navigate to the app/ directory and run: ./run_uv.sh"
        exit 1
    fi
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    local missing_deps=()
    
    # Check for Node.js
    if ! command_exists node; then
        missing_deps+=("Node.js (https://nodejs.org/)")
    fi
    
    # Check for npm
    if ! command_exists npm; then
        missing_deps+=("npm (comes with Node.js)")
    fi
    
    # Check for Python
    if ! command_exists python3; then
        missing_deps+=("Python 3 (https://python.org/)")
    fi
    
    # Check for uv - offer to install if missing
    if ! command_exists uv; then
        print_warning "uv is not installed."
        print_status "uv is required to manage Python dependencies for this project."
        echo ""
        read -p "Would you like to install uv automatically? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Installing uv..."
            if curl -LsSf https://astral.sh/uv/install.sh | sh; then
                print_success "uv installed successfully!"
                print_status "Refreshing environment..."
                # Try to refresh the PATH for this session
                export PATH="$HOME/.cargo/bin:$PATH"
                if ! command_exists uv; then
                    print_warning "uv may not be in PATH. You might need to restart your terminal."
                    print_warning "Alternatively, try: source ~/.bashrc or source ~/.zshrc"
                fi
            else
                print_error "Failed to install uv automatically."
                print_error "Please install uv manually from https://docs.astral.sh/uv/"
                exit 1
            fi
        else
            missing_deps+=("uv (https://docs.astral.sh/uv/)")
        fi
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies:"
        for dep in "${missing_deps[@]}"; do
            echo "  - $dep"
        done
        echo ""
        print_error "Please install the missing dependencies and run this script again."
        exit 1
    fi
    
    print_success "All prerequisites are installed!"
}

# Function to setup environment variables
setup_environment() {
    print_status "Setting up environment variables..."
    
    # Check if .env exists in the root directory
    if [[ ! -f "../.env" ]]; then
        if [[ -f "../.env.example" ]]; then
            print_warning "No .env file found. Creating from .env.example..."
            cp "../.env.example" "../.env"
            print_warning "Please edit the .env file in the root directory to add your API keys:"
            print_warning "  - OPENAI_API_KEY=your-openai-api-key"
            print_warning "  - GROQ_API_KEY=your-groq-api-key"
            print_warning "  - FINANCIAL_DATASETS_API_KEY=your-financial-datasets-api-key"
            echo ""
        else
            print_error "No .env or .env.example file found in the root directory."
            print_error "Please create a .env file with your API keys."
            exit 1
        fi
    else
        print_success "Environment file (.env) found!"
    fi
}

# Function to setup database
setup_database() {
    print_status "Setting up database..."
    
    # Database will be automatically created by the backend when it starts
    print_status "Database: SQLite (hedge_fund.db)"
    print_status "Location: Project root directory"
    print_status "Tables will be created automatically on first backend startup"
    
    # Check if database already exists
    if [[ -f "../hedge_fund.db" ]]; then
        print_success "Database file already exists!"
    else
        print_status "Database will be created when backend starts for the first time"
    fi
}

# Function to install backend dependencies
install_backend() {
    print_status "Installing backend dependencies..."
    
    # Work from the project root where .venv and requirements.txt are located
    PROJECT_ROOT="$(pwd)/.."
    cd "$PROJECT_ROOT"
    
    # Check if virtual environment exists and dependencies are installed
    if [[ -d ".venv" ]] && source ".venv/bin/activate" && python -c "import uvicorn; import fastapi" >/dev/null 2>&1; then
        print_success "Backend dependencies already installed!"
        deactivate
    else
        print_status "Installing Python dependencies with uv..."
        
        # Create virtual environment if it doesn't exist
        if [[ ! -d ".venv" ]]; then
            print_status "Creating virtual environment..."
            uv venv --python 3.11
        fi
        
        # Install dependencies using uv pip
        print_status "Installing from requirements.txt..."
        uv pip install -r requirements.txt
        
        # Test if installation worked
        if source ".venv/bin/activate" && python -c "import uvicorn; import fastapi" >/dev/null 2>&1; then
            print_success "Backend dependencies installed!"
            deactivate
        else
            print_error "Failed to install backend dependencies properly"
            print_error "Try running manually: uv pip install -r requirements.txt"
            deactivate
            cd app
            exit 1
        fi
    fi
    
    # Return to app directory
    cd app
}

# Function to install frontend dependencies
install_frontend() {
    print_status "Installing frontend dependencies..."
    
    cd frontend
    
    # Check if node_modules exists and has content
    if [[ -d "node_modules" ]] && [[ -n "$(ls -A node_modules 2>/dev/null)" ]]; then
        print_success "Frontend dependencies already installed!"
    else
        print_status "Installing Node.js dependencies..."
        npm install
        print_success "Frontend dependencies installed!"
    fi
    
    cd ..
}

# Function to start both services
start_services() {
    print_status "Starting the AI Hedge Fund web application..."
    print_status "This will start both the backend API and frontend web interface"
    print_status "Press Ctrl+C to stop both services"
    echo ""
    
    # Create a temporary directory for log files
    LOG_DIR=$(mktemp -d)
    BACKEND_LOG="$LOG_DIR/backend.log"
    FRONTEND_LOG="$LOG_DIR/frontend.log"
    
    # Function to cleanup on exit
    cleanup() {
        print_status "Shutting down services..."
        
        # Kill background processes
        if [[ -n "$BACKEND_PID" ]] && kill -0 "$BACKEND_PID" 2>/dev/null; then
            kill "$BACKEND_PID" 2>/dev/null || true
        fi
        
        if [[ -n "$FRONTEND_PID" ]] && kill -0 "$FRONTEND_PID" 2>/dev/null; then
            kill "$FRONTEND_PID" 2>/dev/null || true
        fi
        
        # Clean up log directory
        rm -rf "$LOG_DIR" 2>/dev/null || true
        
        print_success "Services stopped. Goodbye!"
        exit 0
    }
    
    # Set up signal handlers
    trap cleanup SIGINT SIGTERM
    
    # Start backend
    print_status "Starting backend server..."
    # Run from the project root (parent of app) to ensure proper Python imports and .venv access
    PROJECT_ROOT="$(pwd)/.."
    cd "$PROJECT_ROOT"
    source .venv/bin/activate
    uvicorn app.backend.main:app --reload --host 127.0.0.1 --port 8000 > "$BACKEND_LOG" 2>&1 &
    BACKEND_PID=$!
    deactivate
    cd app
    
    # Wait a moment for backend to start
    sleep 3
    
    # Check if backend started successfully
    if ! kill -0 "$BACKEND_PID" 2>/dev/null; then
        print_error "Backend failed to start. Check the logs:"
        cat "$BACKEND_LOG"
        exit 1
    fi
    
    print_success "Backend server started (PID: $BACKEND_PID)"
    
    # Check database initialization
    print_status "Checking database initialization..."
    sleep 2  # Give backend time to initialize database
    
    if [[ -f "../hedge_fund.db" ]]; then
        print_success "Database initialized successfully!"
    else
        print_warning "Database file not found, but will be created on first API call"
    fi
    
    # Start frontend
    print_status "Starting frontend development server..."
    cd frontend
    npm run dev > "$FRONTEND_LOG" 2>&1 &
    FRONTEND_PID=$!
    cd ..
    
    # Wait a moment for frontend to start
    sleep 5
    
    # Check if frontend started successfully
    if ! kill -0 "$FRONTEND_PID" 2>/dev/null; then
        print_error "Frontend failed to start. Check the logs:"
        cat "$FRONTEND_LOG"
        cleanup
        exit 1
    fi
    
    print_success "Frontend development server started (PID: $FRONTEND_PID)"
    
    # Open browser after frontend is running
    print_status "Opening web browser..."
    sleep 2  # Give frontend a moment to fully start
    open_browser "http://localhost:5173"
    
    echo ""
    print_success "🚀 AI Hedge Fund web application is now running!"
    print_success "🌐 Browser should open automatically to http://localhost:5173"
    echo ""
    print_status "Frontend (Web Interface): http://localhost:5173"
    print_status "Backend (API): http://localhost:8000"
    print_status "API Documentation: http://localhost:8000/docs"
    print_status "Database: SQLite (hedge_fund.db in project root)"
    echo ""
    print_status "Press Ctrl+C to stop both services"
    echo ""
    
    # Wait for user interrupt
    while true; do
        # Check if processes are still running
        if ! kill -0 "$BACKEND_PID" 2>/dev/null; then
            print_error "Backend process died unexpectedly"
            break
        fi
        
        if ! kill -0 "$FRONTEND_PID" 2>/dev/null; then
            print_error "Frontend process died unexpectedly"
            break
        fi
        
        sleep 1
    done
    
    cleanup
}

# Main execution
main() {
    echo ""
    print_status "🚀 AI Hedge Fund Web Application Setup (uv version)"
    print_status "This script will install dependencies and start both frontend and backend services"
    echo ""
    
    check_directory
    check_prerequisites
    setup_environment
    setup_database
    install_backend
    install_frontend
    start_services
}

# Show help if requested
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "AI Hedge Fund Web Application Setup and Runner (uv version)"
    echo ""
    echo "Usage: ./run_uv.sh"
    echo ""
    echo "This script will:"
    echo "  1. Check for required dependencies (Node.js, npm, Python, uv)"
    echo "  2. Install backend dependencies using uv"
    echo "  3. Install frontend dependencies using npm"
    echo "  4. Start both the backend API server and frontend development server"
    echo "  5. Automatically initialize SQLite database on first run"
    echo ""
    echo "Requirements:"
    echo "  - Node.js and npm (https://nodejs.org/)"
    echo "  - Python 3.11+ (https://python.org/)"
    echo "  - uv (https://docs.astral.sh/uv/)"
    echo ""
    echo "After running, you can access:"
    echo "  - Frontend: http://localhost:5173"
    echo "  - Backend API: http://localhost:8000"
    echo "  - API Docs: http://localhost:8000/docs"
    echo "  - Database: SQLite file (hedge_fund.db) in project root"
    echo ""
    exit 0
fi

# Run main function
main