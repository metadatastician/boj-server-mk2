> **Note:** This documentation reflects the provisional/planned design for the `boj-server-mk2` architecture. Many components (e.g., Elixir orchestration, Idris2 cartridges) are subject to change as the MK2 specification evolves.

# BoJ Server FAQ

### What does BoJ stand for?
Bag of Jobs — a cartridge-based tool server.

### How does BoJ relate to MCP?
BoJ implements the Model Context Protocol (MCP) specification. AI agents like Claude Code connect to BoJ as an MCP server and can use any loaded cartridge as a tool.

### Can I use BoJ without PanLL?
Yes. BoJ is a standalone MCP server. It works with any MCP-compatible client.

### How many cartridges are available?
Currently ~15 production cartridges (GitHub, GitLab, Cloudflare, Vercel, Gmail, Calendar, Browser, Research, ML). Target is 50+ via the 3-a-day programme.

### Why Deno and not Node?
Deno provides secure-by-default permissions, TypeScript support without compilation, and npm compatibility. Node.js is banned in the hyperpolymath ecosystem.

### How do I add a new service integration?
See the [Guides](Guides) page for cartridge creation instructions.
