# embedded.protocols

Shared Protocol Buffer definitions for the embedded garden system.
- [Documentation](https://atilova-garden.github.io/embedded.protocols/)

## Required tools

| Tool | Purpose |
|------|---------|
| [buf](https://buf.build/docs/installation) | Proto linting, formatting, and descriptor generation |
| [Python 3.12+](https://www.python.org/) + [uv](https://docs.astral.sh/uv/) | sabledocs documentation generation (docs only) |

## Usage

```bash
# Lint and format check
make ci

# Generate documentation locally
make ci-docs

# Format protos in place
make format

# Check for breaking changes
make breaking AGAINST=.git#branch=master
```

## Structure

- `proto/common/` — shared types used across components
- `proto/pilot/` — Pilot (MEGA2560 + ESP32) service definitions
