> **Note:** This documentation reflects the provisional/planned design for the `boj-server-mk2` architecture. Many components (e.g., Elixir orchestration, Idris2 cartridges) are subject to change as the MK2 specification evolves.

# BoJ Server Architecture

## Overview

BoJ Server is a cartridge-based tool server that provides unified access to tools across the hyperpolymath ecosystem. It acts as the bridge between AI agents (Claude, etc.) and the tool ecosystem.

## System Design

```
┌─────────────────────────────────────────────────────┐
│  AI Agent (Claude Code, PanLL, etc.)                │
│                    │ MCP Protocol                    │
├─────────────────────────────────────────────────────┤
│  BoJ Server (Deno, port 3007)                       │
│  ├── Cartridge Registry                             │
│  ├── Protocol Router (MCP/REST/gRPC/GraphQL)        │
│  ├── Health Monitor                                 │
│  └── Cartridge Loader                               │
├─────────────────────────────────────────────────────┤
│  Cartridges                                         │
│  ├── GitHub (issues, PRs, repos, code search)       │
│  ├── GitLab (projects, MRs, pipelines, mirrors)     │
│  ├── Cloudflare (zones, DNS, workers, KV, R2, D1)   │
│  ├── Vercel (deployments, projects)                 │
│  ├── Gmail (search, read, draft)                    │
│  ├── Calendar (events, scheduling)                  │
│  ├── Browser (navigate, screenshot, execute JS)     │
│  ├── Research (web search, fetch)                   │
│  ├── ML (HuggingFace model access)                  │
│  └── ... (50+ cartridges planned)                   │
└─────────────────────────────────────────────────────┘
```

## Cartridge Structure

Each cartridge is a Deno module that implements:

```typescript
interface Cartridge {
  name: string;
  description: string;
  tools: Tool[];
  setup(): Promise<void>;
  teardown(): Promise<void>;
}
```

## CRG (Cartridge Readiness Grade)

| Grade | Level | Requirements |
|-------|-------|-------------|
| D | Alpha | Skeleton + basic tests |
| C | Beta | Integration tests, CI wired |
| B | RC | Benchmarks, docs, bindings |
| A | Production | Formally verified ABI, full coverage |

## Integration Points

- **PanLL** — Panels call BoJ cartridges via PanelBus
- **Claude Code** — MCP tools exposed to Claude
- **Hypatia** — Security scanning via panic-attack cartridge
- **VeriSimDB** — Data operations via database cartridge
- **Gossamer** — Desktop integration

## Ports

| Service | Port |
|---------|------|
| BoJ Server | 3007 |
| VeriSimDB (BoJ data) | 8094 |
| ECHIDNA | 9000 |
