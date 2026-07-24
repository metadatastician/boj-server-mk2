> **Note:** This documentation reflects the provisional/planned design for the `boj-server-mk2` architecture. Many components (e.g., Elixir orchestration, Idris2 cartridges) are subject to change as the MK2 specification evolves.

# BoJ Server Troubleshooting

## Quick Fixes

```bash
just doctor    # Diagnose all issues
just heal      # Auto-repair
```

## Common Issues

### Server won't start
```bash
lsof -i :3007       # Check port conflict
deno task start      # Retry
```

### Cartridge not loading
Check the cartridge manifest and ensure all dependencies are available:
```bash
curl http://localhost:3007/api/cartridges | jq '.[] | select(.status != "loaded")'
```

### Authentication errors
Ensure environment variables are set:
```bash
echo $GITHUB_TOKEN     # Should not be empty
echo $GITLAB_TOKEN
```

### MCP connection issues
From Claude Code, check the MCP configuration in settings. BoJ should be listed as an MCP server pointing to `http://localhost:3007`.

## Getting Help

```bash
just help-me    # Opens feedback channel
```

Or: https://github.com/hyperpolymath/boj-server/issues/new
