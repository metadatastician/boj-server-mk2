> **Note:** This documentation reflects the provisional/planned design for the `boj-server-mk2` architecture. Many components (e.g., Elixir orchestration, Idris2 cartridges) are subject to change as the MK2 specification evolves.

# BoJ Server Guides

## Creating a New Cartridge

1. Create a new file in `cartridges/your-cartridge/`
2. Implement the Cartridge interface
3. Register in the cartridge manifest
4. Add tests
5. Run `just test`

## Using BoJ from Claude Code

BoJ tools appear automatically in Claude Code via MCP. Just use them:

```
Use the boj_github_list_repos tool to list my repos
```

## Using BoJ from PanLL

```rescript
// Emit a BoJ request from any panel
PanelBus.emit(BojRequest("github", "list_repos", {owner: "hyperpolymath"}))
```

## Cartridge 3-a-Day Programme

We're building 3 new cartridges per day. To contribute:

1. Pick a service from the open-source queue
2. Write the cartridge (REST/gRPC client)
3. Add integration tests
4. Submit PR

## Monitoring Cartridge Health

```bash
curl http://localhost:3007/api/cartridges    # List all cartridges
curl http://localhost:3007/api/health         # Server health
```

## Configuring Authentication

Each cartridge that needs auth reads from environment variables:
- `GITHUB_TOKEN` — GitHub API access
- `GITLAB_TOKEN` — GitLab API access
- `CLOUDFLARE_API_TOKEN` — Cloudflare access
- See `.env.example` for all variables
