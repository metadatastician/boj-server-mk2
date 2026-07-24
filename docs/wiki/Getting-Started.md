> **Note:** This documentation reflects the provisional/planned design for the `boj-server-mk2` architecture. Many components (e.g., Elixir orchestration, Idris2 cartridges) are subject to change as the MK2 specification evolves.

# Getting Started with BoJ Server

## What is BoJ?

BoJ (Bag of Jobs) is a cartridge-based MCP (Model Context Protocol) server. It provides tool access to AI agents and PanLL panels through a unified interface.

## Prerequisites

- **Deno** (runtime)
- **just** (task runner)

## Installation

```bash
git clone https://github.com/hyperpolymath/boj-server.git
cd boj-server
just setup
```

## First Run

```bash
deno task start    # Start BoJ server on port 3007
```

Verify: `curl http://localhost:3007/health`

## Key Concepts

### Cartridges
A cartridge is a pluggable tool module. Each cartridge:
- Has a unique name and capability set
- Supports one or more protocols (MCP, LSP, DAP, gRPC, REST, GraphQL)
- Can be loaded/unloaded at runtime
- Has a Cartridge Readiness Grade (D through A)

### Protocol Support
| Protocol | Purpose |
|----------|---------|
| MCP | Model Context Protocol (primary) |
| REST | HTTP API access |
| gRPC | High-performance RPC |
| GraphQL | Flexible queries |
| LSP | Language Server Protocol |
| DAP | Debug Adapter Protocol |

## Self-Diagnostic

```bash
just doctor    # Check all services and dependencies
just heal      # Auto-repair common issues
```

## Next Steps

- [Architecture](Architecture) — System design
- [Guides](Guides) — Cartridge development
- [FAQ](FAQ) — Common questions
