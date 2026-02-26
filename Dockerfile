FROM oven/bun:1 AS base
WORKDIR /app

# Install dependencies
FROM base AS deps
COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile

# Development stage
FROM base AS dev
COPY --from=deps /app/node_modules ./node_modules
COPY . .
CMD ["bun", "run", "dev"]

# Production build
FROM base AS prod
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NODE_ENV=production
USER bun
EXPOSE 3000
CMD ["bun", "run", "start"]
