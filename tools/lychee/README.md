# lychee

lychee checks internal and external link validity for the toolkit's documentation.
Install the prebuilt binary into `~/.local/bin` with the steps in [install-lychee.md](../../docs/public/how-to/install-lychee.md).

## Configuration

[lychee.toml](lychee.toml) sets exclusions and skip lists per repository.
Add noisy hosts under `exclude` rather than turning the check off.

## Run

```bash
lychee --no-progress --config tools/lychee/lychee.toml \
  'docs/public/**/*.md'
```

Pass the tool-local config explicitly; nothing is auto-discovered outside the tool directory.

## Alerting

The exit code is `0` when all links resolve.
Broken-link findings are reviewed candidates, and false positives are expected.
`--no-progress` keeps output CI-friendly.

## Caveat

Exclude any directory whose links cannot resolve locally; the per-repository exclusion list decides the scope.
