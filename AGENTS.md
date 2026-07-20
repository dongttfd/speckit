# AGENTS.md

## About Spec Kit and Specify

**GitHub Spec Kit** is a comprehensive toolkit for implementing Spec-Driven Development (SDD) - a methodology that emphasizes creating clear specifications before implementation. The toolkit includes templates, scripts, and workflows that guide development teams through a structured approach to building software.

**Specify CLI** is the command-line interface that bootstraps projects with the Spec Kit framework. It sets up the necessary directory structures, templates, and AI agent integrations to support the Spec-Driven Development workflow.

The toolkit supports multiple AI coding assistants, allowing teams to use their preferred tools while maintaining consistent project structure and development practices.

## Adding or Updating CLI Commands

Before adding, updating, or reorganizing Specify CLI commands, read
[Shared Command Application Architecture](design/shared.md) and
[Specify CLI Command Architecture](design/cli.md). They define the shared
operation boundary, command-module naming, private phases, nested command
groups, registration ownership, and mirrored tests.

## Adding or Updating MCP Commands

Before adding or changing MCP tools for Specify commands, read
[Shared Command Application Architecture](design/shared.md) and
[Specify MCP Command Architecture](design/mcp.md). They define the shared
operation boundary, typed contracts, explicit inventory, side-effect metadata,
the local stdio protocol boundary, and mirrored tests.

## Adding or Updating Agent Integrations

Before adding or changing AI agent integrations, read
[Agent Integration Design](design/integration.md). It covers
delivery routes, output formats, registration, and install/uninstall ownership.

## Adding or Updating Workflow Steps

Before adding or changing workflow step types, read
[Workflow Step Design](design/workflow-step.md). It covers registration,
validation, execution, resume, and installed step packages.

## Testing Executable Behavior

Before changing code or configuration that runs or controls execution without
an LLM, read
[Testing deterministic behavior](CONTRIBUTING.md#testing-deterministic-behavior).
Behavioral changes need positive and negative coverage; bug fixes need
before-and-after regression evidence.

## PowerShell Compatibility

All PowerShell scripts in the repository and all generated PowerShell
functionality MUST target Windows PowerShell 5.1, the version included with
Windows. When adding or changing PowerShell code, use only syntax, cmdlets,
parameters, and .NET APIs available in Windows PowerShell 5.1. Account for
encoding and other runtime differences, preserve the required behavioral
parity with Bash and Python implementations, and provide Windows PowerShell
5.1 validation evidence for behavioral changes.

## Branches and Agent Contributions

When creating a branch, follow [Branch naming](CONTRIBUTING.md#branch-naming).
Before authoring commits, opening PRs, or posting review comments, read
[Agent-authored Git and review activity](CONTRIBUTING.md#agent-authored-git-and-review-activity).
Agent-authored commits and AI-generated PRs and comments each require their
own disclosure; a PR-body disclosure alone does not cover later activity.

## Other Contribution Guidance

For contribution or repository-workflow questions not covered above, or when
the applicable guidance is unclear, read [CONTRIBUTING.md](CONTRIBUTING.md)
before acting.

## Common Pitfalls

- **Running tests against the wrong environment:** Run the suite inside this
  worktree's own virtualenv (`uv sync --extra test` then
  `.venv/bin/python -m pytest`). A bare `uv run pytest` can pick up an
  editable install from another worktree and fail to import new subpackages.

1. **Using shorthand keys for CLI-based integrations**: For CLI-based integrations (`requires_cli: True`), the `key` must match the executable name (e.g., `"cursor-agent"` not `"cursor"`). `shutil.which(key)` is used for CLI tool checks — mismatches require special-case mappings. IDE-based integrations (`requires_cli: False`) are not subject to this constraint.
2. **Reintroducing context handling into the CLI**: The opt-in `agent-context` extension owns everything about context files — including the per-agent default mapping in `agent-context-defaults.json`. Integration classes must **not** declare a `context_file`, and no CLI code should read, write, resolve, or migrate context files. All context-file logic lives in `.specify/extensions/agent-context/` and its bundled scripts.
3. **Incorrect `requires_cli` value**: Set to `True` only for agents that have a CLI tool; set to `False` for IDE-based agents.
4. **Wrong argument format**: Use `$ARGUMENTS` for Markdown agents, `{{args}}` for TOML agents.
5. **Skipping registration**: The import and `_register()` call in `_register_builtins()` must both be added.
6. **Running tests against the wrong environment**: Always run the suite inside this working tree's own virtualenv (`uv sync --extra test` then `.venv/bin/python -m pytest`, or activate the venv first). A bare `uv run pytest` can resolve to an ambient/global interpreter whose editable `.pth` points at a *different* worktree. The failure is sneaky: test collection still imports `specify_cli` successfully, but newly-added subpackages (e.g. a fresh `specify_cli/bundler/`) resolve as a stale namespace package and raise `ModuleNotFoundError`. If a brand-new subpackage imports under `python -c` but not under pytest, suspect environment contamination, not your code.

---

## Error Handling and Debugging

### Common Errors and Fixes

| Symptom | Likely Cause | Fix |
|---|---|---|
| `Integration '<key>' not found` | Missing `_register()` call | Add `_register(<Name>Integration())` inside `_register_builtins()` |
| `NameError: name '<Name>Integration' is not defined` at startup | Missing import | Add `from .<package_dir> import <Name>Integration` inside `_register_builtins()` |
| CLI check fails for a `requires_cli: True` agent | `key` does not match the executable name | Set `key` to the exact name `shutil.which(key)` must resolve (e.g. `"cursor-agent"`, not `"cursor"`) |
| Command files have the wrong argument syntax | Wrong `args` value in `registrar_config` | Use `$ARGUMENTS` for Markdown agents, `{{args}}` for TOML/YAML agents, or the agent's custom placeholder |
| `ModuleNotFoundError` on a brand-new subpackage under pytest only | Ambient interpreter with a stale editable `.pth` | Run inside this tree's own venv (see Common Pitfall 6) |
| Uninstall leaves files behind, or skips files you expected removed | Files not recorded via the manifest, or their hash changed after install | Route every created file through `manifest.record_file(...)`; user-edited files are intentionally skipped unless `force=True` |
| Context file (`CLAUDE.md`, etc.) not updated | Expecting the CLI to manage it | Context files are owned by the opt-in `agent-context` extension, not the integration — see [Context file behavior](#4-context-file-behavior) |

### Debugging Tips

**Inspect the manifest** to see what an installed integration tracks:

```bash
cat .specify/integrations/<key>.manifest.json
```

**Verify a CLI tool is detected** before debugging a `requires_cli` agent:

```bash
which <key>        # Should print the executable path if installed
```

**Verify the installed output structure** after `specify init`:

```bash
find my-project/<folder> -type f
```

---

## Contribution Checklist

Before opening or merging an integration PR, confirm the following:

- [ ] Added the integration subpackage under `src/specify_cli/integrations/<package_dir>/`.
- [ ] Registered it (import **and** `_register()`) in `src/specify_cli/integrations/__init__.py`, both alphabetical.
- [ ] Added or updated tests in `tests/integrations/test_integration_<key>.py`.
- [ ] Verified the install/uninstall flow with `specify init --integration <key>`.
- [ ] Did **not** add `context_file` handling to the CLI (that belongs to the `agent-context` extension).
- [ ] Updated devcontainer files if the agent needs a VS Code extension or CLI install step.
- [ ] Updated this guide or other relevant docs if the integration has special setup or limitations.

---

*This documentation should be updated whenever new integrations are added to maintain accuracy and completeness.*

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **speckit** (16061 symbols, 24815 relationships, 257 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> If any GitNexus tool warns the index is stale, run `npx gitnexus analyze` in terminal first.

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `gitnexus_impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `gitnexus_detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `gitnexus_query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `gitnexus_context({name: "symbolName"})`.

## Never Do

- NEVER edit a function, class, or method without first running `gitnexus_impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `gitnexus_rename` which understands the call graph.
- NEVER commit changes without running `gitnexus_detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/speckit/context` | Codebase overview, check index freshness |
| `gitnexus://repo/speckit/clusters` | All functional areas |
| `gitnexus://repo/speckit/processes` | All execution flows |
| `gitnexus://repo/speckit/process/{name}` | Step-by-step execution trace |

## CLI

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
