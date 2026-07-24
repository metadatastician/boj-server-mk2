> **Note:** This documentation reflects the provisional/planned design for the `boj-server-mk2` architecture. Many components (e.g., Elixir orchestration, Idris2 cartridges) are subject to change as the MK2 specification evolves.

# BoJ Server

Unified MCP server consolidating all hyperpolymath tooling into a single endpoint.

## Quick Start

See the [main README](https://github.com/hyperpolymath/boj-server#readme) for installation and configuration.

```bash
git clone https://github.com/hyperpolymath/boj-server
cd boj-server/mcp-bridge && npm install
claude mcp add boj-server -- node mcp-bridge/main.js
```

## Key Concepts

- **Single MCP endpoint** -- BoJ (Bureau of Justice) unifies GitHub, GitLab, Cloudflare, Vercel, Verpex, Gmail, Calendar, browser automation, research, and ML into one server that Claude Code can call directly.
- **Cartridge system** -- 50+ pluggable open-source service integrations. Each cartridge wraps an external service with a consistent invoke/info interface.
- **All MCP through BoJ** -- hyperpolymath policy routes all MCP tool access through BoJ rather than standalone MCP servers.

## Architecture

BoJ exposes a REST API (port 7700) with an MCP bridge layer that translates between Claude's MCP protocol and the internal cartridge/service dispatch.

See [docs/](https://github.com/hyperpolymath/boj-server/tree/main/docs) for architecture details.

## Related Projects

- [PanLL](https://github.com/hyperpolymath/panll) -- Human-Things Interface that consumes BoJ services
- [Hypatia](https://github.com/hyperpolymath/hypatia) -- Neurosymbolic CI/CD scanning
- [VeriSimDB](https://github.com/hyperpolymath/verisimdb) -- Cross-modal consistency engine
- [Gossamer](https://github.com/hyperpolymath/gossamer) -- Desktop app shell

## Contributing

See [CONTRIBUTING.md](https://github.com/hyperpolymath/boj-server/blob/main/CONTRIBUTING.md).

## License

[PMPL-1.0-or-later](https://github.com/hyperpolymath/palimpsest-license)