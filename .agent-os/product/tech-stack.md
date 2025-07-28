# Technical Stack

> Last Updated: 2025-07-28
> Version: 1.0.0

## Development Environment

### Backend
- **Language:** Python 3.11+
- **Package Manager:** uv (recently migrated from Poetry)
- **Framework:** FastAPI 0.116.1
- **ORM:** SQLAlchemy 2.0.41
- **Database:** SQLite (with Alembic migrations)
- **API Style:** RESTful with OpenAPI/Swagger documentation

### Frontend
- **Framework:** React 18.2.0
- **Language:** TypeScript 5.3.3
- **Build Tool:** Vite 5.0.12
- **State Management:** React Context API + custom hooks
- **UI Framework:** Tailwind CSS 3.4.1
- **Component Library:** shadcn/ui (Radix UI + Tailwind)
- **Icons:** Lucide React + Radix UI Icons

### Specialized Libraries
- **Workflow Visualization:** @xyflow/react 12.5.1 (React Flow)
- **AI/LLM Integration:** LangChain 0.3.0 + LangGraph 0.2.56
- **Data Visualization:** matplotlib 3.10.3 (Python backend)
- **CLI Interface:** questionary 2.1.0 + rich 14.1.0
- **HTTP Client:** httpx 0.28.1

## AI/ML Services

### LLM Providers
- **OpenAI:** GPT-4, GPT-3.5-turbo via langchain-openai
- **Anthropic:** Claude models via langchain-anthropic
- **Groq:** Fast inference via langchain-groq
- **Google:** Gemini models via langchain-google-genai
- **DeepSeek:** DeepSeek models via langchain-deepseek
- **Local Models:** Ollama integration via langchain-ollama

### AI Architecture
- **Multi-Agent System:** 17 specialized investment agents
- **Graph-based Workflow:** LangGraph for agent orchestration
- **Prompt Engineering:** Structured prompts for each investor personality
- **Model Flexibility:** Dynamic model selection per agent

## Data & Analytics

### Market Data
- **Data Sources:** Real-time and historical market data APIs
- **Caching:** Custom caching system for API responses
- **Storage:** SQLite for simulation results and configurations
- **Processing:** Pandas 2.3.1 + NumPy 1.26.4

### Database Schema
- **ORM:** SQLAlchemy with Alembic migrations
- **Tables:** HedgeFundFlow, HedgeFundFlowRun, HedgeFundFlowRunCycle
- **Migrations:** Version-controlled schema changes
- **Connection:** SQLite for development, PostgreSQL-ready architecture

## Development Infrastructure

### Port Configuration
- **Frontend Dev Server:** 5173 (Vite default)
- **Backend API Server:** 8000 (FastAPI default)
- **CORS Configuration:** Configured for localhost:5173

### Environment Configuration
```bash
# Frontend (.env.local)
VITE_API_URL=http://localhost:8000

# Backend (.env)
# LLM API Keys (optional - supports multiple providers)
OPENAI_API_KEY=your_key_here
ANTHROPIC_API_KEY=your_key_here
GROQ_API_KEY=your_key_here
```

### Build & Deployment
- **Backend Build:** uv for dependency management
- **Frontend Build:** TypeScript compilation + Vite bundling
- **Container Support:** Docker configuration available
- **CLI Distribution:** Standalone Python package

## Development Tools

### Code Quality
- **Python Linting:** Black (line-length: 420), isort, flake8
- **TypeScript Linting:** ESLint + TypeScript ESLint parser
- **Type Checking:** TypeScript strict mode
- **Testing:** pytest (Python), potential for Playwright (frontend)

### Package Management
- **Python:** uv (modern pip replacement)
  - requirements.in → requirements.txt compilation
  - Fast dependency resolution and installation
  - Development dependencies separated
- **Node.js:** npm with package-lock.json
  - Frontend dependencies via npm
  - Build scripts in package.json

### Version Control
- **Platform:** Git
- **Branch Strategy:** Feature branches with main branch
- **Migrations:** Alembic for database schema versioning

## Architecture Patterns

### Backend Architecture
- **Pattern:** Clean Architecture with layers
- **Structure:** Routes → Services → Repositories → Models
- **API Design:** Resource-based REST endpoints
- **Error Handling:** FastAPI exception handling
- **Logging:** Python logging module

### Frontend Architecture
- **Pattern:** Component-based with hooks
- **State Management:** Context providers + custom hooks
- **Routing:** Single-page application
- **Components:** Modular shadcn/ui components
- **Styling:** Utility-first with Tailwind CSS

### Integration Architecture
- **API Communication:** RESTful HTTP/JSON
- **Real-time Updates:** Polling-based (WebSocket-ready)
- **Data Flow:** React Flow for visual workflow representation
- **Agent Communication:** LangGraph state management

## Hosting & Deployment

- **Application Hosting:** TBD (Railway/Vercel compatible)
- **Database Hosting:** SQLite file-based (PostgreSQL ready)
- **Asset Hosting:** Static file serving via FastAPI
- **Code Repository:** Git-based (GitHub compatible)
- **Deployment Solution:** Docker containers + standard Python/Node deployment