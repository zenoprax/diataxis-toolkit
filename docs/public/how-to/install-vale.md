---
title: How to install Vale
type: how-to
domain: toolkit
---

# How to install Vale

> **How-to guide**: Installs the Vale prose linter into `~/.local/bin` without root. Use when the toolkit's QC checks need Vale on a machine.

Install the Vale prose linter into `~/.local/bin` without root. The release archive is self-contained: one binary, no package manager.

## Prerequisites

- `curl` and `tar`.
- `~/.local/bin` on your `PATH`. To add it (once per shell profile):

  ```bash
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  ```

## Steps

1. Resolve the latest release tag. The project lives at `vale-cli/vale` (it moved from `errata-ai/vale`), and the redirect gives you the tag:

   ```bash
   url=$(curl -sL -o /dev/null -w '%{url_effective}' https://github.com/vale-cli/vale/releases/latest)
   tag=${url##*/}
   echo "$tag"   # e.g. v3.24.0
   ```

2. Download the archive for your platform. This uses the `Linux_64-bit` asset; on ARM, substitute `Linux_arm64`:

   ```bash
   curl -sL -o /tmp/vale.tar.gz \
     "https://github.com/vale-cli/vale/releases/download/${tag}/vale_${tag#v}_Linux_64-bit.tar.gz"
   ```

3. Extract the binary and make it executable:

   ```bash
   tar -xzf /tmp/vale.tar.gz -C ~/.local/bin vale
   chmod +x ~/.local/bin/vale
   rm /tmp/vale.tar.gz
   ```

## Verification

Check the version, then smoke-test against a file that should trigger a built-in rule:

```bash
vale --version
# vale version 3.24.0

printf '[*.md]\nBasedOnStyles = Vale\n' > /tmp/vale-smoke.ini
printf '# Test\n\nThis sentence has a mispelled word.\n' > /tmp/vale-smoke.md
vale --config /tmp/vale-smoke.ini /tmp/vale-smoke.md
#  3:21  error  Did you really mean 'mispelled'?  Vale.Spelling
# ✖ 1 error, 0 warnings and 0 suggestions in 1 file.
```

## Troubleshooting

- **`404` on the download** — the asset name pattern changed. Open `https://github.com/vale-cli/vale/releases/expanded_assets/$tag` and copy the Linux asset's exact name.
- **`vale: command not found`** — `~/.local/bin` is not on `PATH`; see Prerequisites.
- **No findings on text that should trip a rule** — check that the smoke config uses `BasedOnStyles = Vale` and the file contains `mispelled`.

## Related

- [How to install markdownlint-cli2](install-markdownlint.md) — the Markdown QC checks.
- [How to install lychee](install-lychee.md) — the link checker.
- [Vale configuration and commands](../../../tools/vale/README.md) — the exact commands and alerting semantics.
