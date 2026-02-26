# The Real McCoy - Personal AI Assistant

## Project Overview
A personal AI-powered assistant that automates tasks via cron jobs and interactive commands. The agent runs on an Elysia (Bun) server, reads/writes to a self-hosted Affine instance for notes and context, and uses a vector database for long-term memory.

## Tech Stack
- **Runtime**: Bun
- **Framework**: Elysia (TypeScript)
- **LLM**: Anthropic Claude API
- **Notes/UI**: Self-hosted Affine (no custom frontend needed)
- **Vector DB**: TBD (likely Qdrant, Chroma, or similar)
- **Deployment**: Docker on VPS

## Architecture

```
┌─────────────┐     ┌─────────────────┐     ┌─────────────┐
│   Affine    │◄───►│  Elysia Server  │◄───►│  Claude API │
│  (Notes UI) │     │   (Agent Core)  │     │             │
└─────────────┘     └────────┬────────┘     └─────────────┘
                             │
                    ┌────────▼────────┐
                    │   Vector DB     │
                    │ (Long-term mem) │
                    └─────────────────┘
```

## Project Structure
```
src/
├── index.ts          # Elysia server entry point
├── agent/            # AI agent logic (future)
├── tasks/            # Cron jobs and automations (future)
├── integrations/     # Affine, external APIs (future)
└── db/               # Vector DB client (future)
```

## Commands
- `bun run dev` - Start dev server with hot reload
- `bun run start` - Start production server
- `bun run typecheck` - Type check without emitting
- `docker compose up` - Run in Docker (dev)
- `docker compose -f docker-compose.yml -f docker-compose.prod.yml up` - Run in Docker (prod)

## Conventions
- Use Bun APIs over Node.js equivalents (Bun.file, Bun.env, etc.)
- Bun auto-loads .env files - no dotenv needed
- Elysia for HTTP server (not Bun.serve directly)
- TypeScript strict mode

## Environment Variables (future)
```
ANTHROPIC_API_KEY=
AFFINE_URL=
AFFINE_API_KEY=
VECTOR_DB_URL=
```

## Deployment

### CI/CD Pipeline (GitHub Actions)
On push to `main`:
1. Builds Docker image (prod target)
2. Pushes to GitHub Container Registry (ghcr.io)
3. SSHs into VPS and pulls/restarts the container

### GitHub Secrets Required
```
VPS_HOST      - VPS IP or hostname
VPS_USER      - SSH username
VPS_SSH_KEY   - Private SSH key
VPS_APP_PATH  - App directory on VPS (e.g., /opt/therealmccoy)
```

### First-time VPS Setup
```bash
ssh user@vps 'bash -s' < scripts/setup-vps.sh
```
Then edit `/opt/therealmccoy/.env` with your secrets.

### Manual Deploy
```bash
# On VPS
cd /opt/therealmccoy
docker compose pull && docker compose up -d
```

## Current Status
- [x] Elysia server scaffold
- [x] Docker setup (dev + prod)
- [x] CI/CD pipeline (GitHub Actions → GHCR → VPS)
- [ ] Anthropic SDK integration
- [ ] Affine integration
- [ ] Vector DB setup
- [ ] Cron job system
- [ ] Agent core logic

## Notes
- Affine will serve as the "frontend" - write notes there, agent reads/responds
- Vector DB for semantic search over notes and conversation history
- Cron jobs for scheduled automations (daily summaries, reminders, etc.)
