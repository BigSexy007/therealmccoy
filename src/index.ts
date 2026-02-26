import { Elysia } from "elysia";
import { cors } from "@elysiajs/cors";

const app = new Elysia()
  .use(cors())
  .get("/", () => ({ status: "ok", message: "The Real McCoy is running" }))
  .get("/health", () => ({ status: "healthy", timestamp: new Date().toISOString() }))
  .listen(3000);

console.log(`Server running at http://${app.server?.hostname}:${app.server?.port}`);

export type App = typeof app;
