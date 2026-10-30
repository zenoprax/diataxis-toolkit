# diataxis-toolkit

A repository-agnostic documentation system built on the [Diátaxis](https://diataxis.fr/) framework.
It gives each repository one way to plan, write, review, and maintain its public-facing documentation.
The core agent skill is the working entry point, with checkers for prose, Markdown, and links.

## The standard structure

| Path                            | Description                                           |
| ------------------------------- | ----------------------------------------------------- |
| `tools/skills/`                 | The `diataxis` skill                                  |
| `tools/vale/`                   | Prose/style checker, styles, and config               |
| `tools/markdownlint/`           | Markdown checker config and README                    |
| `tools/lychee/`                 | Link checker config and README                        |
| `docs/public/<type>/`           | `tutorials/`, `how-to/`, `reference/`, `explanation/` |

The [Diátaxis skill](tools/skills/diataxis/SKILL.md) is the primary tool.
The [docs-commit](tools/commands/docs-commit.md) command is a commit helper.
There are some agent and subagents under [tools/agents/](tools/agents/) to help constrain but the skill works without them.

## Checks

- [Vale](tools/vale/README.md) checks prose and style.
- [markdownlint-cli2](tools/markdownlint/README.md) checks Markdown structure.
- [lychee](tools/lychee/README.md) checks internal and external links.
- [Page checks](tools/skills/diataxis/scripts/README.md) cover front matter and visual entities.

You will need to adjust paths, configurations, and rule sets to fit your repo.

## The pipeline

```text
   diff / PR    ┐
   idea / note  ├───▶  ┌───────────────────────────────┐
   finding      │      │           SKILL.md            │ ①
   document(s)  ┘      │   what triggered the work?    │
                       │   passive ▸ rides a commit    │
                       │   active  ▸ its own span      │
                       └───────────────┬───────────────┘
                                       ▼
  ── ANALYSIS (1-analysis/) ── reads, classifies, decides  ───────────────── ②
  ┌───────────────────┐     ┌───────────────────┐     ┌───────────────────┐
  │ triage            │     │ audit             │     │ plan              │
  │ the input         │     │ the set           │     │ the future        │
  │ ▸ work plan       │     │ ▸ findings,       │     │ ▸ inventory +     │
  │ ▸ primed targets  │     │   prioritized     │     │   roadmap         │
  └─────────┬─────────┘     └─────────┬─────────┘     └─────────┬─────────┘
            │                         │                         │
            └─────────────────────────┼─────────────────────────┘
                                      ▼
  ── PRODUCTION (2-production/) ── creates or restructures pages ─────────── ③
  ┌───────────────────┐     ┌───────────────────┐     ┌───────────────────┐
  │ edit              │     │ create            │     │ convert           │
  │ the target        │     │ the gap           │     │ the mix           │
  │ ▸ the owner's     │     │ ▸ new page        │     │ ▸ split set,      │
  │   page edited     │     │   from a template │     │   source retired  │
  └─────────┬─────────┘     └─────────┬─────────┘     └─────────┬─────────┘
            │                         │                         │
            └─────────────────────────┼─────────────────────────┘
                                      ▼
                      ┌───────────────────────────────┐ ④
                      │       ── VALIDATION ──        │
                      │ 1. verify ▸ facts + citations │
                      │ 2. style  ▸ voice & QC        │
                      └───────────────┬───────────────┘
                                      ▼
                      ┌───────────────────────────────┐ ⑤
                      │         docs/public/          │
                      │   one quadrant per document   │
                      │                               │
                      └───────────────────────────────┘
```

## Start here

For public-facing documentation work, including creating, updating, fixing, verifying, or restructuring, read the skill:

The skill branches out based on what triggered the work:
- **Passive**: a code change invalidates behavior an existing page describes; see [passive.md](tools/skills/diataxis/0-modes/passive.md).
- **Active**: deliberate prompting or a new user-facing feature with no existing owner, such as notes, gaps, findings, or a README that grew too big; see [active.md](tools/skills/diataxis/0-modes/active.md).

Both modes run the same stages: [analysis](tools/skills/diataxis/1-analysis/) (triage/audit/plan), [production](tools/skills/diataxis/2-production/) (edit/create/convert), and [validation](tools/skills/diataxis/3-validation/) (verify/style).
Validation is mandatory in every mode because mistakes are inevitable.

## The four quadrants

Every document should serve exactly one quadrant.
If a document mixes quadrants it should be split or merged as needed.

| Quadrant     | Answers                    | Directory                                |
| ------------ | -------------------------- | ---------------------------------------- |
| Tutorial     | How do I learn to do this? | [tutorials/](docs/public/tutorials/)     |
| How-to guide | How do I do this now?      | [how-to/](docs/public/how-to/)           |
| Reference    | What is this?              | [reference/](docs/public/reference/)     |
| Explanation  | Why does it work this way? | [explanation/](docs/public/explanation/) |

## Authority

A fact should have exactly one authoritative home.
When sources disagree the following authority is observed:

1. **Code and tests**: behavior is what the implementation does.
2. **Generated reference**: output derived from code, authoritative for the surface it covers.
3. **Canonical prose**: the documentation in [docs/public/](docs/public/).
4. **Dated notes and plans**: research, plans, and dated notes; never authoritative.

## Adopting this in a repository

1. Install the `tools/skills/diataxis` into a discovery path such as `.opencode/skills/diataxis/` or `.agents/skills/`.
2. Copy the checker configurations ([Vale config](tools/vale/.vale.ini), [.markdownlint-cli2.jsonc](tools/markdownlint/.markdownlint-cli2.jsonc), [lychee.toml](tools/lychee/lychee.toml)) or adapt their paths to your layout.
3. Update your [AGENTS.md](AGENTS.md): "For documentation work, use the `diataxis` skill" along with any other documentation-specific guidance.
4. Optionally, install the commit command and/or agents.
5. Decide on the standard structure for the documentation such as `docs/public/<type>/` and update the [skill's scripts](tools/skills/diataxis).
