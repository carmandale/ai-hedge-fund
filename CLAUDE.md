# AI Hedge Fund - Claude Instructions

## Agent OS Documentation

### Product Context
- **Mission & Vision:** @.agent-os/product/mission.md
- **Technical Architecture:** @.agent-os/product/tech-stack.md
- **Development Roadmap:** @.agent-os/product/roadmap.md
- **Decision History:** @.agent-os/product/decisions.md

### Development Standards
- **Code Style:** @~/.agent-os/standards/code-style.md
- **Best Practices:** @~/.agent-os/standards/best-practices.md

### Project Management
- **Active Specs:** @.agent-os/specs/
- **Spec Planning:** Use `@~/.agent-os/instructions/create-spec.md`
- **Tasks Execution:** Use `@~/.agent-os/instructions/execute-tasks.md`

## Workflow Instructions

When asked to work on this codebase:

1. **First**, check @.agent-os/product/roadmap.md for current priorities
2. **Then**, follow the appropriate instruction file:
   - For new features: @.agent-os/instructions/create-spec.md
   - For tasks execution: @.agent-os/instructions/execute-tasks.md
3. **Always**, adhere to the standards in the files listed above

## Important Notes

- Product-specific files in `.agent-os/product/` override any global standards
- User's specific instructions override (or amend) instructions found in `.agent-os/specs/...`
- Always adhere to established patterns, code style, and best practices documented above.

## Project-Specific Context

### Educational Investment Simulation Platform
This is an **educational-only** investment simulation platform designed for learning, not real trading. All features should maintain this educational focus and avoid any real financial transactions.

### Multi-Agent AI Architecture
The platform uses 17 AI agents representing legendary investors (Warren Buffett, Charlie Munger, Cathie Wood, etc.). When working on agent-related features, maintain the authentic personality and investment philosophy of each legendary investor.

### Tech Stack Specifics
- **Backend:** Python 3.11+ with FastAPI, SQLAlchemy, SQLite
- **Frontend:** React 18 + TypeScript + Vite + Tailwind CSS + shadcn/ui
- **Package Management:** uv (not Poetry) - see migration notes in codebase
- **AI Integration:** LangChain + LangGraph with multi-LLM provider support
- **Visualization:** React Flow (@xyflow/react) for workflow building

### Development Ports
- **Frontend:** Port 5173 (Vite default)
- **Backend:** Port 8000 (FastAPI default)
- **CORS:** Configured for localhost:5173

### Key Directories
- `/src/agents/` - AI agent implementations (Warren Buffett, etc.)
- `/app/frontend/src/` - React TypeScript frontend
- `/app/backend/` - FastAPI backend with routes, services, models
- `/src/llm/` - LLM provider configurations and models
- `/src/graph/` - LangGraph state management
- `/src/tools/` - Financial data API tools

### Testing & Quality
- **Python:** pytest, black (line-length: 420), isort, flake8
- **TypeScript:** ESLint + TypeScript strict mode
- **Database:** Alembic migrations for schema changes
- **API:** FastAPI automatic OpenAPI documentation

### Current Development Phase
Based on the roadmap, we're transitioning from Phase 0 (core platform complete) to Phase 1 (enhanced backtesting & analytics). Focus on improving the backtesting engine, performance analytics, and portfolio optimization features.