---
title: How to install markdownlint-cli2
type: how-to
domain: toolkit
---

# How to install markdownlint-cli2

> **How-to guide**: Installs markdownlint-cli2, the toolkit's Markdown linter, with npm into a user-level prefix. Use when the Markdown QC checks need markdownlint-cli2 on a machine.

Install markdownlint-cli2, the Markdown linter for this toolkit's Markdown QC checks, into a user-level prefix.
It needs no root access and does not touch the system Node installation.

## Prerequisites

- Node.js 20 or later and npm.
  Confirm both resolve:

  ```bash
  node --version
  npm --version
  ```

## Steps

1. Install the package globally under `~/.local`:

   ```bash
   npm install -g --prefix "$HOME/.local" markdownlint-cli2
   ```

2. Confirm the install. npm places binaries in `~/.local/bin`, which must be on your `PATH` (see [How to install Vale](install-vale.md)):

   ```bash
   npm ls -g --prefix "$HOME/.local" markdownlint-cli2 --depth=0
   # /home/you/.local/lib
   # └── markdownlint-cli2@0.24.0
   ```

## Verification

Smoke-test with a trailing space on a text line:

```bash
mkdir -p .local
printf '# Title\n\ntext \n' > .local/smoke.md
markdownlint-cli2 --config tools/markdownlint/.markdownlint-cli2.jsonc \
  .local/smoke.md
# .local/smoke.md:3:5 error MD009/no-trailing-spaces Trailing spaces [Expected: 0 or 2; Actual: 1]
# Summary: 1 issue in 1 file
```

Exit status is `0` when the file is clean and `1` when findings exist.
Run from the repository root so the relative config path resolves.

## Troubleshooting

- **`markdownlint-cli2: command not found`** — `~/.local/bin` is not on `PATH`; see Prerequisites.
- **`npm: command not found`** — install Node.js 20 or later, which provides npm.
- **`Summary: 0 issues in 0 files`** — the glob matched nothing. Quote it so the shell does not expand it, and run from the repository root.
- **A finding you disagree with** — check whether the configuration should disable or tune the rule before suppressing it ad hoc; the QC configuration is in [the Markdown linter configuration](../../../tools/markdownlint/README.md).

## Related

- [How to install Vale](install-vale.md) — the prose and style QC checks.
- [How to install lychee](install-lychee.md) — the link checker.
- [Markdown linter configuration and commands](../../../tools/markdownlint/README.md) — the exact commands and alerting semantics.
