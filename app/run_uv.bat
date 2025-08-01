@echo off
REM AI Hedge Fund Web Application Setup and Runner (uv version - Windows)
REM This script makes it easy for non-technical users to run the full web application

REM Colors for output
set "INFO=[INFO]"
set "SUCCESS=[SUCCESS]"
set "WARNING=[WARNING]"
set "ERROR=[ERROR]"

REM Check Node.js
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo %ERROR% Node.js is not installed. Please install from https://nodejs.org/
    pause
    exit /b 1
)

REM Check npm
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo %ERROR% npm is not installed. Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

REM Check Python (or python3)
where python >nul 2>&1
if %errorlevel% neq 0 (
    where python3 >nul 2>&1
    if %errorlevel% neq 0 (
        echo %ERROR% Python is not installed. Please install from https://python.org/
        pause
        exit /b 1
    )
)

REM Check uv
where uv >nul 2>&1
if %errorlevel% neq 0 (
    echo %WARNING% uv is not installed.
    echo %INFO% uv is required to manage Python dependencies for this project.
    echo.
    set /p install_uv="Would you like to install uv automatically? (y/N): "
    if /i "%install_uv%"=="y" (
        echo %INFO% Installing uv...
        
        REM Try PowerShell method first
        powershell -Command "irm https://astral.sh/uv/install.ps1 | iex"
        if %errorlevel% neq 0 (
            echo %WARNING% PowerShell installation failed. Trying curl method...
            curl -LsSf https://astral.sh/uv/0.1.18/install.sh | sh
            if %errorlevel% neq 0 (
                echo %ERROR% Failed to install uv automatically.
                echo %INFO% Please install uv manually from https://docs.astral.sh/uv/
                echo %INFO% You can also try: pip install uv
                pause
                exit /b 1
            )
        )
        
        echo %SUCCESS% uv installed successfully!
        echo %INFO% Refreshing environment...
        call refreshenv >nul 2>&1 || echo %WARNING% Could not refresh environment.
        
        REM Check if uv is now available
        where uv >nul 2>&1
        if %errorlevel% neq 0 (
            echo %WARNING% uv was installed but is not yet available in PATH.
            echo %INFO% You may need to restart your terminal.
            echo %INFO% You can also try running the script again after restarting your terminal.
            pause
            exit /b 1
        )
        echo %SUCCESS% uv is now available and ready to use!
    ) else (
        echo %ERROR% uv is required to run this application.
        echo %ERROR% Please install uv manually from https://docs.astral.sh/uv/
        echo %INFO% Or try: pip install uv
        pause
        exit /b 1
    )
)

echo %SUCCESS% uv is available!

REM Ensure correct working directory
if not exist "frontend" (
    echo %ERROR% This script must be run from the app\ directory
    echo %ERROR% Please navigate to the app\ directory and run: run_uv.bat
    pause
    exit /b 1
)

if not exist "backend" (
    echo %ERROR% This script must be run from the app\ directory
    echo %ERROR% Please navigate to the app\ directory and run: run_uv.bat
    pause
    exit /b 1
)

echo.
echo %INFO% AI Hedge Fund Web Application Setup (uv version)
echo %INFO% This script will install dependencies and start both frontend and backend services
echo.

REM Check for .env
if not exist "..\.env" (
    if exist "..\.env.example" (
        echo %WARNING% No .env file found. Creating from .env.example...
        copy "..\.env.example" "..\.env"
        echo %WARNING% Please edit ..\.env to add your API keys:
        echo %WARNING%   - OPENAI_API_KEY=your-openai-api-key
        echo %WARNING%   - GROQ_API_KEY=your-groq-api-key
        echo %WARNING%   - FINANCIAL_DATASETS_API_KEY=your-financial-datasets-api-key
        echo.
    ) else (
        echo %ERROR% No .env or .env.example file found in the root directory.
        echo %ERROR% Please create a .env file with your API keys.
        pause
        exit /b 1
    )
) else (
    echo %SUCCESS% Environment file (.env) found
)

REM Setup database
echo %INFO% Setting up database...
echo %INFO% Database: SQLite (hedge_fund.db)
echo %INFO% Location: Project root directory
echo %INFO% Tables will be created automatically on first backend startup

if exist "..\hedge_fund.db" (
    echo %SUCCESS% Database file already exists
) else (
    echo %INFO% Database will be created when backend starts for the first time
)

REM Install backend dependencies
echo %INFO% Installing backend dependencies...
cd ..

REM Check if virtual environment exists and dependencies are installed
if exist ".venv" (
    .venv\Scripts\activate.bat && python -c "import uvicorn; import fastapi" >nul 2>&1
    if %errorlevel% equ 0 (
        echo %SUCCESS% Backend dependencies already installed
        .venv\Scripts\deactivate.bat >nul 2>&1
    ) else (
        echo %INFO% Installing Python dependencies with uv...
        uv pip install -r requirements.txt
        if %errorlevel% neq 0 (
            echo %ERROR% Failed to install backend dependencies
            pause
            exit /b 1
        ) else (
            echo %SUCCESS% Backend dependencies installed successfully
        )
    )
) else (
    echo %INFO% Creating virtual environment...
    uv venv --python 3.11
    if %errorlevel% neq 0 (
        echo %ERROR% Failed to create virtual environment
        pause
        exit /b 1
    )
    
    echo %INFO% Installing Python dependencies with uv...
    uv pip install -r requirements.txt
    if %errorlevel% neq 0 (
        echo %ERROR% Failed to install backend dependencies
        pause
        exit /b 1
    ) else (
        echo %SUCCESS% Backend dependencies installed successfully
    )
)

cd app

REM Install frontend dependencies
echo %INFO% Installing frontend dependencies...
cd frontend

if exist "node_modules" (
    echo %SUCCESS% Frontend dependencies already installed
) else (
    echo %INFO% Installing Node.js dependencies...
    npm install
    if %errorlevel% neq 0 (
        echo %ERROR% Failed to install frontend dependencies
        pause
        exit /b 1
    )
    echo %SUCCESS% Frontend dependencies installed
)

cd ..

REM Start services
echo %INFO% Starting the AI Hedge Fund web application...
echo %INFO% Press Ctrl+C to stop all services
echo.

REM Start backend
echo %INFO% Launching backend server...
REM Run from project root to ensure proper Python imports
cd ..
start /b .venv\Scripts\activate.bat && uvicorn app.backend.main:app --reload --host 127.0.0.1 --port 8000
cd app

timeout /t 3 /nobreak >nul

REM Check database initialization
echo %INFO% Checking database initialization...
timeout /t 2 /nobreak >nul

if exist "..\hedge_fund.db" (
    echo %SUCCESS% Database initialized successfully
) else (
    echo %WARNING% Database file not found, but will be created on first API call
)

REM Start frontend
echo %INFO% Launching frontend development server...
cd frontend
start /b npm run dev
cd ..

timeout /t 5 /nobreak >nul

echo %INFO% Opening browser...
timeout /t 2 /nobreak >nul
start http://localhost:5173

echo.
echo %SUCCESS% AI Hedge Fund web application is now running
echo %INFO% Frontend: http://localhost:5173
echo %INFO% Backend:  http://localhost:8000
echo %INFO% Docs:     http://localhost:8000/docs
echo %INFO% Database: SQLite (hedge_fund.db in project root)
echo.
echo %INFO% Press any key to stop both services...
pause >nul

REM Stop services
taskkill /f /im "uvicorn.exe" >nul 2>&1
taskkill /f /im "node.exe" >nul 2>&1

echo %SUCCESS% Services stopped. Goodbye
pause