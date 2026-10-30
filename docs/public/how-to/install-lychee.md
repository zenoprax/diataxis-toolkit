---
title: How to install lychee
type: how-to
domain: toolkit
---

# How to install lychee

> **How-to guide**: Installs the lychee link checker into `~/.local/bin` without root. Use when the toolkit's QC checks need link checking on a machine.

Install the lychee link checker into `~/.local/bin` without root. Pre-built archives are published for Linux, macOS, and Windows.

## Prerequisites

- `curl` and `tar`.
- `~/.local/bin` on your `PATH` (see [How to install Vale](install-vale.md) for the one-line addition).

## Steps

1. Download the archive for your platform. This uses the GNU build for x86_64 Linux; the releases page also carries `linux-musl` and macOS/Windows builds. The version is pinned in the URL; bump it when you want a newer release.

   ```bash
   curl -sL -o /tmp/lychee.tar.gz \
     https://github.com/lycheeverse/lychee/releases/download/lychee-v0.24.2/lychee-x86_64-unknown-linux-gnu.tar.gz
   ```

2. Extract the binary. The archive has a top-level directory, so extract into a directory and move the binary out:

   ```bash
   tar -xzf /tmp/lychee.tar.gz -C /tmp
   mv /tmp/lychee-x86_64-unknown-linux-gnu/lychee ~/.local/bin/lychee
   chmod +x ~/.local/bin/lychee
   rm -rf /tmp/lychee.tar.gz /tmp/lychee-x86_64-unknown-linux-gnu
   ```

## Verification

Check the version, then check a file with one live link:

```bash
lychee --version
# lychee 0.24.2

printf '# Links\n\n[Validate HTML](https://validator.w3.org)\n' > /tmp/links.md
lychee --no-progress /tmp/links.md
# 🔍 1 Total (in 162ms) 🔗 1 Unique ✅ 1 OK 🚫 0 Errors
```

Exit status is `0` when every link resolves.

## Troubleshooting

- **`tar: lychee: Not found in archive`** — the binary sits inside a version directory. Extract the whole archive first and move `lychee-x86_64-unknown-linux-gnu/lychee` out, as in step 2.
- **`👻 N Excluded` in the summary** — an exclusion list or the default excludes are skipping those links; run with `--verbose` to see which and why.
- **Exit status `2` with network noise** — remote hosts time out; treat failures as candidates, not verdicts.

## Related

- [How to install Vale](install-vale.md) — the prose and style QC checks.
- [How to install markdownlint-cli2](install-markdownlint.md) — the Markdown QC checks.
- [lychee configuration and commands](../../../tools/lychee/README.md) — the exact commands and reviewed-candidate policy.
