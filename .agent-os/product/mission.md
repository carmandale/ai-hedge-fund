# Product Mission

> Last Updated: 2025-07-28
> Version: 1.0.0

## Pitch

AI Hedge Fund is an educational simulation platform that democratizes investment learning by allowing users to experience the decision-making processes of legendary investors through AI agent simulation. The platform enables risk-free strategy testing and provides deep insights into different investment philosophies through interactive workflow building and backtesting.

## Users

### Primary Customers

- **Investment Students** - University students and self-learners studying finance and investment strategies
- **Financial Educators** - Professors, instructors, and educational institutions teaching investment principles
- **Retail Investors** - Individual investors seeking to understand different investment approaches before committing real capital
- **AI/Finance Researchers** - Researchers exploring the intersection of artificial intelligence and financial decision-making

### User Personas

**Investment Student** (20-35 years old)
- **Role:** Student or self-learner
- **Context:** Learning investment principles and strategies
- **Pain Points:** Theoretical knowledge without practical experience, fear of losing money while learning, difficulty understanding different investment philosophies
- **Goals:** Master investment concepts through simulation, test strategies without financial risk, learn from legendary investors' approaches

**Financial Educator** (30-60 years old)
- **Role:** Professor or instructor
- **Context:** Teaching investment and finance courses
- **Pain Points:** Limited tools for hands-on learning, difficulty demonstrating complex investment strategies, students need practical experience
- **Goals:** Provide engaging educational tools, demonstrate real-world investment scenarios, track student learning progress

**Retail Investor** (25-65 years old)
- **Role:** Individual investor
- **Context:** Managing personal investments and retirement planning
- **Pain Points:** Overwhelmed by investment options, uncertain about strategy effectiveness, fear of making costly mistakes
- **Goals:** Test investment strategies safely, understand successful investor methodologies, build confidence before real investing

## The Problem

### Lack of Risk-Free Investment Learning

Traditional investment education relies heavily on theory without practical application, leaving learners unprepared for real-world decision-making. Paper trading simulators lack the strategic depth and legendary investor insights needed for comprehensive learning.

**Our Solution:** Provide AI-powered simulations of 17+ legendary investors with comprehensive backtesting capabilities.

### Disconnected Investment Philosophy Understanding

Most educational tools teach investment concepts in isolation without showing how different legendary investors would approach the same scenarios, making it difficult to understand diverse investment philosophies.

**Our Solution:** Enable side-by-side comparison of different investor approaches through our visual workflow builder and multi-agent analysis system.

### Barrier to Advanced Investment Strategy Testing

Complex investment strategies require sophisticated tools and market data that are typically only available to institutional investors, creating barriers for individual learning and strategy validation.

**Our Solution:** Provide enterprise-level backtesting tools with real market data integration in an accessible educational format.

## Differentiators

### AI Agent Simulation of Legendary Investors

Unlike generic investment simulators, we provide detailed AI representations of 17 legendary investors (Warren Buffett, Charlie Munger, Cathie Wood, etc.) that make decisions based on their documented philosophies and methodologies. This creates authentic learning experiences that mirror real investment legends' thought processes.

### Visual Workflow Builder for Investment Strategies

Unlike traditional backtesting platforms that require coding knowledge, our React Flow-based visual interface allows users to drag-and-drop investment agents and connect them in custom workflows. This makes complex strategy building accessible to non-technical users.

### Multi-LLM Provider Architecture

Unlike platforms locked to single AI providers, we support OpenAI, Groq, Anthropic, and Ollama, giving users flexibility in AI model selection and preventing vendor lock-in while ensuring consistent availability.

## Key Features

### Core Features

- **17 AI Investment Agents** - Detailed simulations of legendary investors with authentic decision-making processes
- **Visual Workflow Builder** - Drag-and-drop interface using React Flow for creating custom investment strategies
- **Comprehensive Backtesting Engine** - Test strategies against historical market data with detailed performance analytics
- **Multi-LLM Support** - Choose from OpenAI, Groq, Anthropic, or local Ollama models for AI reasoning
- **Real-time Market Data Integration** - Access to current and historical market data for realistic simulations
- **Educational Focus** - All features designed for learning and simulation, not real trading

### Analysis Features

- **Multi-Agent Analysis** - Compare how different investor types would approach the same stocks
- **Risk Management Integration** - Built-in risk assessment and position sizing recommendations
- **Portfolio Management Simulation** - Experience complete portfolio construction and management processes
- **Investment Report Generation** - Detailed explanations of investment decisions and reasoning

### Technical Features

- **FastAPI Backend** - High-performance Python backend with SQLAlchemy ORM
- **React TypeScript Frontend** - Modern, responsive interface with shadcn/ui components
- **SQLite Database** - Lightweight, portable data storage for simulations and results
- **CLI Interface** - Command-line access for advanced users and automation