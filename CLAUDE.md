# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Plugin Overview

`zk-wiki` (v0.3.1) is a Claude Code plugin that turns a Zettelkasten-style raw source directory into an automatically maintained wiki. It ships as a **Claude Code plugin** — no build step, no test runner. All logic is declarative markdown (skills, commands, agents).

## Repository Structure

```
.claude-plugin/
  plugin.json          # Plugin metadata, version, author
  marketplace.json     # Distribution listing (separate version from plugin.json)
skills/
  ingest-pipeline.md   # 6-stage raw → wiki pipeline logic
  wiki-conventions.md  # Page ID format, frontmatter schema, atomic-note rules
  wiki-maintenance.md  # Templates, update rules, backlink protocol
  zettelkasten-conventions.md  # Fleeting→permanent promotion rules
commands/
  zk-ingest.md         # /zk-wiki:zk-ingest <file-path>
  zk-lint.md           # /zk-wiki:zk-lint
  zk-query.md          # /zk-wiki:zk-query <question>
  fleeting.md          # /zk-wiki:fleeting <text>
  synthesize.md        # /zk-wiki:synthesize <topic>
  clip.md              # /zk-wiki:clip <URL>
agents/
  ingester.md          # model: claude-sonnet-4-6 — runs ingest-pipeline
  linter.md            # model: haiku — read-only health check, never writes
  synthesizer.md       # model: claude-sonnet-4-6 — creates MOC pages
hooks/
  hooks.json           # Currently empty; PostToolUse hook for raw/ changes planned
```

## How the Plugin Works

Commands delegate to agents. Agents load skills as their knowledge base. Skills are pure-text rules (no executable code).

**Ingest flow**: `/zk-ingest <path>` → validates path is under `raw/` → spawns **ingester** agent → 6-stage pipeline: read source → extract propositions → deduplicate against existing wiki → create/update wiki pages → cross-link related pages → update `index.md` + append to `log.md`.

**Clip flow**: `/clip <URL>` → WebFetch → save to `raw/articles/<id>-<slug>.md` → auto-invokes ingester.

**Synthesize flow**: `/synthesize <topic>` → spawns **synthesizer** → scans all wiki subdirs → creates `wiki/moc/<slug>.md` → updates index + log.

**Lint flow**: `/zk-lint` → spawns **linter** (read-only, haiku model) → produces structured report (Critical / Warning / Info).

## Assumed Knowledge Base Layout

This plugin assumes the consuming project has this structure already in place:

```
<kb-root>/
├─ raw/articles/   # immutable — never modify existing files
├─ raw/books/      # immutable
├─ raw/assets/     # immutable
├─ raw/fleeting/   # append-only via /fleeting command
├─ wiki/concepts/
├─ wiki/entities/
├─ wiki/summaries/
├─ wiki/moc/
├─ .claude/rules/  # llm-behavior.md, conventions.md
├─ .claude/template/
├─ index.md
└─ log.md
```

## Key Conventions

**Zettel ID**: `yyyymmddhhmm` (12 digits). Collision suffix: `-2`, `-3`. Filename: `<id>-<slug>.md`.

**Frontmatter** (all fields required):
```yaml
---
id: "202605121847"
type: concept       # concept | entity | summary | moc
created: "2026-05-12"
updated: "2026-05-12"
tags: [tag1, tag2]
source: "raw/fleeting/..."   # raw/-prefixed path or URL
links:
  - "[[wiki/concepts/202605121920-some-concept]]"
---
```

`links:` must be YAML multiline list — inline arrays (`links: [...]`) are forbidden.

**Idempotency**: before creating a wiki page, check `index.md` and `wiki/` for an existing page from the same source. Update in place rather than creating a duplicate.

## Versioning

`plugin.json` and `marketplace.json` carry separate version fields. When bumping the release version, update **both** files.

## Obsidian Integration

The knowledge base root can be opened as an Obsidian Vault. `[[wikilink]]` format is intentionally compatible. Recommended Obsidian setting: Attachment folder path → `raw/assets/`.
