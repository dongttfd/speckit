---
description: Explore an idea or big vision through structured thinking, project-aware and Internet research, synthesis, and discussion to maintain an evidence-backed long-term direction and roadmap.
handoffs:
  - label: Specify an Initiative
    agent: speckit.specify
    prompt: Create a specification for roadmap initiative...
---

## User Input

```text
$ARGUMENTS
```

Treat the input as an initial idea, broad theme, long-term vision, or request to resume an existing idea—not as a settled problem, solution, or feature.

On every invocation, scan `.specify/memory/ideas/*/brief.md`:

- A named slug or explicit resume/update request selects that saved idea.
- With empty input, list saved ideas compactly by title, status, version, and update date; ask which one to resume or whether to start a new one. If none exist, ask what to explore.
- For a possible new idea, compare its normalized title and proposed slug with saved ideas. When a plausible match exists, ask whether to resume, fork, or use a distinct name before continuing.

## Document Language

Check `.specify/init-options.json` for the `language` field.

- If `"vi"`:
  - Output MUST be written in Vietnamese WITH FULL DIACRITICS (Unicode, có dấu đầy đủ)
  - All explanations MUST use proper Vietnamese spelling and accents
  - DO NOT use non-accented Vietnamese (e.g., "khong dau")
  - Technical terms MAY remain in English when necessary
  - If any content is generated in English or without Vietnamese diacritics, it MUST be rewritten correctly in Vietnamese with full accents
  - This requirement applies to both file content written to disk AND conversational responses in this session

  > IMPORTANT: Vietnamese output MUST include proper diacritics (Unicode). ASCII-only Vietnamese is NOT allowed.

- Otherwise: use English (default).

## Goal

Turn an early idea or multi-year vision into shared, evidence-backed long-term orientation. Explore the landscape and possible futures, expose assumptions and constraints, compare strategic choices, and maintain an adaptable Strategic Idea Brief and Long-Term Roadmap across sessions. The outcome is not an immediate feature specification; an approved initiative may later be handed off independently.

## Core Invariants

1. **RESEARCH INTEGRITY**: Never invent sources, quotes, dates, benchmarks, customer evidence, project findings, or tool results. Material conclusions carry an evidence class and confidence.
2. **USER AUTHORITY**: Exploration stays non-mutating until the user explicitly approves convergence, persistence, a status decision, or a handoff. The Save Procedure may write approved artifacts and temporary recovery bundles. A separately authorized ignore-rule edit and the approved handoff below are the only other writes; that handoff is also the sole exception for invoking another Spec Kit command.
3. **SENSITIVE CONTEXT**: Never send secrets, credentials, personal/customer data, proprietary code, confidential names, or non-public financial details to external tools. Abstract or redact them, and ask before research when safe abstraction is unclear.
4. **BOUNDED RESEARCH**: Stay within the declared global and per-lane budgets. Ask before extending them, and stop when evidence saturates or cannot support a sound conclusion.
5. **ONE QUESTION PER TURN**: At each interactive gate, ask one focused question and wait. This covers framing, directions, duplicates, privacy, budget, iteration, save, and handoff.
6. **ADAPTIVE STRATEGY**: Expand before narrowing and complete the available decision-relevant research before recommending. If Internet research is unavailable or declined, recommendations remain explicitly provisional. Express later horizons through outcomes, dependencies, assumptions, gates, and investment conditions rather than false certainty.

## Workflow

### 1. Establish Time and Project Context

Set `SESSION_DATE` from the runtime environment in `YYYY-MM-DD` form and `SESSION_TIMESTAMP` as an exact UTC RFC 3339 timestamp; use them for access dates, freshness, and lifecycle/recovery metadata rather than inferring recency from URLs or rankings.

Read `.specify/memory/constitution.md` when present. Its principles constrain the roadmap unless the user separately amends the constitution. Inspect relevant README/architecture material, prior specs/plans/decisions, source layout, manifests, integrations, tests, operational constraints, technical debt, and reusable capabilities. Cite safe local evidence by path and keep it out of external tools unless safely abstracted. This pass provides orientation; a later **Internal Reality** lane investigates the project questions that affect a decision.

During broad project scans, skip `.env*`, credential/token stores, key or certificate material, secret mounts, and ignored files whose names or ignore context indicate secrets. Do not open, quote, or persist their contents or exact sensitive paths. When configuration existence matters, record only a sanitized statement such as “private runtime configuration exists.”

### 2. Frame and Expand the Idea

Establish the core opportunity, users/stakeholders, desired long-term change, horizon, ambition, constraints, existing advantages, current proposed direction, and which decisions are urgent. Use defaults for low-impact gaps; ask one question when an answer would materially alter research.

Map root causes, adjacent opportunities, second-order effects, incentives/conflicts, enabling capabilities, ecosystem dependencies, and alternative interpretations. Develop 3–5 meaningfully different directions, including staged, combined, and no-action paths when useful. For each, show potential value, assumptions, risks, rough cost/effort, and evidence needed. Present them before Internet research and let the user add, combine, revise, remove, or confirm the set.

### 3. Plan Bounded Research

Create 2–5 decision-relevant lanes. Include **Internal Reality** when project context exists; other lanes may cover users/demand, market and failed precedents, technology/architecture, business models/distribution, regulation/security/ethics/operations, or cost/scalability/capability. For every lane state its question, decision impact, disconfirming evidence, and preferred source types.

Default limits, unless the user approves an extension:

| Scope | Limit |
|-------|-------|
| All lanes, including Internal Reality | 5 |
| Search iterations per Internet lane | 3 |
| Opened Internet sources per lane | 4 |
| Opened Internet sources across the initial cycle | 20 |
| One shared allowance across the entire discussion | 2 targeted searches and 5 newly opened sources |

Before parallel work, allocate non-overlapping lane quotas in one parent ledger; unused quota returns there before reassignment. Pause a lane after two searches add no material evidence, its decision questions are adequately answered or recorded unknown, its allocation is exhausted, evidence remains too weak/contradictory, or the user redirects it. Source volume alone is not a confidence signal.

### 4. Research with Available Capabilities

Discover available Internet search and page-reading capabilities at runtime—built-in, MCP, or browser—and describe capabilities rather than hard-coded tool names. Search discovers candidates; page reading opens the actual source; supplied URLs are opened directly. Browser automation is a fallback for otherwise inaccessible material. If no search/reading capability exists, explain the gap, state that Internet research did not occur, and ask whether to configure one or proceed using project evidence and labeled assumptions.

Up to three independent research sub-agents may run concurrently within assigned quotas. Each brief includes the narrow question and decision, `SESSION_DATE`/recency needs, sanitized context, source/search quota, direct-URL and original-page requirement, publication/update and access dates, evidence class plus confidence, contradictions/limits/unknowns, `## Document Language`, and the research-integrity rule.

Prioritize primary or authoritative sources: standards, papers, regulators, official documentation, first-party material, original datasets, and relevant project files. For each project file used as evidence, record its project-relative path and `sha256:<content-digest>` in the ledger's `Published/Updated or File SHA-256` column at access time; the content hash covers both committed and uncommitted changes. For pivotal claims, seek two independently originated sources when practical. Reposts or pages derived from the same announcement, study, dataset, or reporting count as one origin. Open original pages, cite material claims near the claim, paraphrase accurately, and record negative, contradictory, or missing evidence. When agents disagree, inspect pivotal sources and compare provenance, method, scope, and date; preserve unresolved disagreement instead of voting.

### 5. Build the Knowledge Map and Strategic Synthesis

Classify every material conclusion:

| Class | Meaning |
|-------|---------|
| **Fact** | Directly supported by a cited Internet source or project file |
| **Inference** | Derived from cited facts |
| **Assumption** | Not adequately supported yet |
| **Unknown** | Evidence is absent or contradictory |

Attach `HIGH`, `MEDIUM`, or `LOW` confidence based on authority, recency, directness, method quality, and agreement between independent origins. Build a knowledge map covering established signals/constraints, trends/future shifts, contradictions, causal loops, dependencies, falsifiable assumptions, gaps, and implications across horizons. Give stable `C-01`, `C-02`, … IDs to the decision-critical claims and assumptions defined under Metadata and Revision Semantics.

Compare viable directions using:

| Direction | Evidence IDs | Long-Term Value | Feasibility | Dependencies | Cost/Effort | Risk | Confidence |
|-----------|--------------|-----------------|-------------|--------------|-------------|------|------------|

Give the strongest case for and against each direction, possible combinations/sequences, ranking-reversing assumptions, and unavoidable tensions. Keep the **strategic thesis** (where durable value lies and why) distinct from the **recommendation** (what to invest in, test, defer, combine, or stop now).

### 6. Discuss and Iterate

Ask the question that most expands understanding, reduces strategic uncertainty, or separates leading directions. After each answer, update the idea model and show the meaningful delta. Use the single shared follow-up allowance when targeted research could change the thesis or roadmap; the allowance remains cumulative across multiple answers. State whether research is saturated, budget-limited, evidence-limited, or still useful. A challenge to a finding triggers source review and an evidence-based defense, qualification, or retraction.

### 7. Converge on Request

When the user asks to finalize, load `.specify/templates/idea-brief-template.md` and `.specify/templates/idea-roadmap-template.md` and render the current synthesis. Templates define document shape; this command defines evidence and lifecycle behavior. Retain the Knowledge Map, reconsideration conditions for rejected/deferred alternatives, cost/effort, stable initiative IDs, status/links, measurable North-Star Outcomes, gates, and leading indicators.

Horizon names and count adapt to context; the template's three are a default rather than a maturity assumption. Prefer named horizons when timing is unknown. Dates requested without timing constraints include their assumptions. Validate the completed documents against `## Document Language`, then ask whether to revise, research an unresolved item, save/update, or specify one initiative.

## Idea Storage and Lifecycle

Apply this section when creating, resuming, updating, or handing off a saved idea.

### Artifacts and Templates

The canonical directory is `.specify/memory/ideas/<idea-slug>/` with stable lowercase kebab-case identity:

| Artifact | Purpose | Structure |
|----------|---------|-----------|
| `brief.md` | Summary, thesis, knowledge map, decisions | `.specify/templates/idea-brief-template.md` |
| `roadmap.md` | Outcomes, horizons, initiatives, gates | `.specify/templates/idea-roadmap-template.md` |
| `sources.md` | Cumulative evidence ledger | `.specify/templates/idea-sources-template.md` |
| `changelog.md` | Cumulative revision history | `.specify/templates/idea-changelog-template.md` |

Load brief/roadmap templates for finalization or snapshot regeneration, the changelog template when appending a revision, and the sources template when creating/repairing its artifact or adding ledger events. A non-mutating routine resume reads saved artifacts rather than all four templates.

Across all four templates, localize user-facing headings and column labels under `## Document Language` while preserving every required section and field. Keep frontmatter keys, ID formats, and all machine-state enum values in English exactly as declared—including status, event, evidence class, assumption state, and confidence values.

### Metadata and Revision Semantics

`brief.md` is authoritative for the shared frontmatter; the other artifacts mirror it. `created` is the idea's original creation date, not each file's date; `updated` is the approved revision date. `storage_policy` records `unconfirmed`, `repository-visible`, `redacted`, or `git-ignored`; existing artifacts without it are treated as `unconfirmed`. Missing artifacts or metadata mismatch route to `### Partial-Save Recovery` before ordinary resume or save.

`redacted` is prospective: choose it on initial save, or reuse it only when the saved policy is already `redacted` and immutable histories pass the scan. In all four outputs, replace identified non-public figures, names, internal paths/identifiers, and credentials with typed `[REDACTED: <category>]` placeholders; keep no reverse map. Scan `new/`, `publish/`, and `recovery.json` for those raw tokens and fail on any match. A non-redacted history containing such a token cannot switch in place; require `git-ignored` so append-only bytes remain unchanged.

`git-ignored` requires the path to match ignore rules and be absent from the Git index; an ignore rule alone does not untrack files. Neither redaction nor ignore removes prior commits: warn that committed sensitive content remains in Git history and needs separate, explicit remediation.

`next_review` is the single shared value. On creation or completion of a review, derive it from the earliest dated roadmap gate, decision-critical ledger `Review By`, or C-inventory `Review By`; when none exists, default to three months after `SESSION_DATE`. Other saves retain the current date unless a newly earlier trigger appears or the user approves a change. Gates and changelog may explain, but not conflict with, that value.

The decision-critical set is the explicit `C-*` inventory in the Knowledge Map: claims, assumptions, or unknowns whose truth could change the thesis, commitments, North-Star Outcomes, prioritization/gates, or legal/security feasibility.

- Each item records `Covered Through` (`YYYY-MM-DD` or `TBD`) and `Review By`. Advance its coverage date only after research for that item is reconciled into the ledger and knowledge map.
- Ledger rows map to applicable items through `Claim IDs`; an unsupported critical assumption remains in the inventory with `TBD` coverage.
- IDs survive wording refinements. A material meaning change retires the old ID and creates a new uncovered one; record the change and rationale in the changelog.

`evidence_cutoff` summarizes the inventory's weakest coverage: use `TBD` when any current critical item is uncovered, otherwise use the earliest `Covered Through` date. Recompute it from the inventory after evidence changes; never copy `updated` into it. A new or changed critical item affects its own coverage without invalidating other items, and resume refreshes specific items rather than the whole inventory. Wording, status/progress changes, roadmap rearrangement based on existing evidence, interrupted research, and handoff do not advance coverage. Source-level dates remain authoritative for individual evidence.

Status changes need user approval: `exploring` (forming), `active` (approved roadmap with active work), `paused`, `completed` (approved outcomes/criteria met), or `abandoned` (explicitly stopped with rationale retained).

| Bump | Use when |
|------|----------|
| PATCH `x.y.Z` | Evidence/wording/metric/status/progress changes without material thesis or roadmap restructuring |
| MINOR `x.Y.0` | Material direction, thesis, horizon, portfolio, or priority change within the same core vision |
| MAJOR `X.0.0` | A pivot in purpose, users, outcomes, or causal logic invalidates the prior roadmap |

The initial approved creation writes status `exploring` at version `0.1.0`; each later approved save increments once. Explain an ambiguous bump before saving. Initiative IDs use `I-01`, `I-02`, … and survive renaming. Before allocating one, scan the current roadmap and complete changelog for every previously used ID—including cancelled or removed initiatives—and assign one above the historical maximum.

### Historical Artifacts

Below frontmatter, `sources.md` and `changelog.md` are cumulative histories: existing bodies are immutable and new records are appended. Source events are `evidence`, `refresh`, `contradiction`, or `retirement`; each records the revision `Version`, `Recorded` date, a unique ID, and affected rows through `Related IDs`. `Evidence Origin` identifies the original evidence so derivative pages are not counted independently. Current state derives from the highest related version, using append order within one version.

Each approved revision appends one changelog entry shaped by `.specify/templates/idea-changelog-template.md`. Templates cannot replace existing history; updates preserve the complete on-disk bodies byte-for-byte and append to them.

### Resume or Update

For an existing idea:

1. Before normal loading, compare the presence and shared metadata of all four artifacts. A missing artifact or mismatch invokes `### Partial-Save Recovery`. Otherwise read `brief.md` and `roadmap.md` fully; read the latest three version entries (`## <semver> — ...`), the latest older MAJOR/MINOR pivot, and the most recent operational `## Recovery — ...` entry separately. Restrict the initial ledger read to rows cited by current artifacts, marked time-sensitive/disputed, or relevant to the request; retrieve older entries on demand.
2. Summarize the thesis, roadmap state, unresolved assumptions, next review, evidence cutoff, and recent changes; ask what changed or should be revisited.
3. Build a targeted refresh queue from individual `C-*` items and their mapped sources:
   - Queue an item when its `Covered Through` is `TBD` or its own `Review By` has passed.
   - Queue affected items when a mapped time-sensitive source is older than six months; use three months for pricing, regulation, security, vendor capability, or similarly volatile evidence unless a better interval is documented.
   - When the idea cutoff is older than six months, queue only items whose own coverage is that old—not the full inventory.
   - Recompute each cited project file's SHA-256; queue mapped items when it differs from the recorded digest or the file is missing. Also queue items affected by disputes, contradictions, or new results. Stable standards and historical primary sources become stale when superseded, not merely through age.
4. Mark assumptions `supported`, `weakened`, `refuted`, or `unresolved`. Check linked artifact paths and obvious delivery-stage signals, plus plausible unlinked specs left by a pending handoff; propose resulting roadmap/status changes for approval.

### Partial-Save Recovery

When a missing artifact or metadata mismatch indicates an interrupted save:

1. Show the presence and version of each canonical artifact. Inspect matching `.specify/memory/.ideas-save-tmp.<idea-slug>.*` bundles newest-first by `started_at`; select the newest bundle whose recorded old/new hashes explain every canonical file. If none does, request an authoritative version or manual merge rather than guessing.
2. Show the selected bundle's `save_id`, old/new versions, and per-file classification (`old`, `new`, `missing`, or `divergent`), then ask one question: complete the candidate revision or roll back to its baseline.
3. After approval, recreate expendable `publish/` copies from the chosen immutable snapshot. Whenever the chosen result contains `changelog.md`, append the operational entry defined in `.specify/templates/idea-changelog-template.md`; it records the save ID, attempted version, diagnosed versions, and outcome while preserving the chosen frontmatter/version. Restore all four artifacts by same-filesystem `mv`. Rolling back a newly created idea removes only that attempt's partial target; no permanent recovery record is created because no idea history remains.
4. Recheck parity and history. On completion, the first three artifacts match `new/`; on existing-baseline rollback they match `old/`; `changelog.md` matches the chosen snapshot plus exactly one Recovery entry. Absent-baseline rollback leaves all four files absent. Remove the bundle on success; otherwise retain it and report the exact state.

### Save Procedure

Run one logical revision after the user chooses save/update:

Concurrency policy: deliberately use no lock or lease for this single-user workflow. Accept the narrow TOCTOU window between final hash check and sequential `mv`; pre/post verification plus the recovery bundle mitigate it. Revisit only if concurrent saves become an observed problem.

1. **Identity gate**: re-scan idea metadata and resolve duplicate, fork, and slug questions before continuing.
2. **Privacy gate**: compare `storage_policy` with Git ignore/index state and current sensitivity; reuse it when consistent. Otherwise ask in a separate turn using only options eligible under the rules above, persist the English enum in all four frontmatters, and obtain approval for ignore/index changes. Show the Git-history warning whenever content was tracked or committed.
3. **Conflict baseline**: compare current disk metadata/version with the session baseline. Then read complete raw `sources.md` and `changelog.md`; record every source row/ID and changelog entry, their counts, and exact snapshots or hashes for all four files. A new idea records confirmed target absence. A mismatch invokes Partial-Save Recovery or reload/merge.
4. **Revision**: for creation initialize `exploring` at `0.1.0` with `created=SESSION_DATE`; otherwise choose one version bump and retain the idea's original `created`. Set `updated=SESSION_DATE`, apply the cutoff rules above, and mirror metadata. Regenerate complete `brief.md`/`roadmap.md` snapshots. For `sources.md`/`changelog.md`, change only mirrored frontmatter and appended records while preserving their raw historical bodies; append exactly one changelog entry.
5. **Stage and validate**: shell/filesystem operations are allowed for this approved save. Generate a unique `save_id`, then create `.specify/memory/.ideas-save-tmp.<idea-slug>.XXXXXX` with `mktemp -d`, outside the discovery glob but on the same filesystem. Store immutable `old/` and `new/` snapshots plus `recovery.json` containing `save_id`, `started_at`, slug, old/new versions, per-file presence, and hashes; create expendable candidates under `publish/`. Validate template sections, metadata parity, evidence/citations, approved sensitivity, Document Language, unchanged history, non-decreasing source rows, one new version entry, and unique IDs/version.
6. **Publish and verify**: immediately before publishing, re-read every canonical target and compare its presence/hash with Step 3; any difference aborts without touching canonical files and deletes only this attempt's bundle. Otherwise create the idea directory if needed and same-filesystem `mv` each expendable candidate into place. Each rename is atomic; the four-file group is best-effort. Re-read all four files and verify expected hashes, frontmatter parity, and history invariants. On success, refresh the session baseline, remove the bundle, and report paths/version/status/cutoff/review. On rename or verification failure, keep the bundle, report its path plus the exact presence/version/hash state of every canonical file, and route the next invocation through Partial-Save Recovery.

A new save creates all four artifacts. Later saves replace brief/roadmap snapshots while preserving and extending source/changelog bodies.

## Optional Handoff to Specification

Handoff applies to one approved roadmap initiative rather than the whole long-term idea:

1. Select a saved initiative by stable ID and carry its outcome, dependencies, gate, cost/effort, constraints, and necessary roadmap context into a small independently valuable scope. Put `[Roadmap provenance: idea_id=<idea-slug>; initiative_id=<I-nn>]` in the `__SPECKIT_COMMAND_SPECIFY__` user description so the resulting specification preserves a deterministic backlink. If the user wants preparation without execution, return that exact prompt without invoking it.
2. To execute, explain that specification creation and a traceability PATCH are one operation, then obtain one confirmation covering both. Invoke `__SPECKIT_COMMAND_SPECIFY__` under the Core Invariants' approved exception.
3. Resolve the resulting feature directory/branch, verify that its `spec.md` exists, retains both provenance IDs in a visible input/provenance field, and passes basic integrity checks, then capture project-relative paths and date. Ambiguous or invalid output leaves initiative state unchanged.
4. Hold a pending traceability record with initiative ID, prior/target (`specified`) status, paths, branch, date, and outcome. Apply it to `Linked Artifacts`, roadmap status, and changelog through the Save Procedure; handoff completes after its four-file post-write verification. Handoff does not advance `evidence_cutoff`.
5. Failed/cancelled specification discards the pending record. A verified spec followed by save conflict/failure is reported as **Specification created; traceability pending** with exact recovery identifiers; retain/retry it before unrelated work and withhold completion. On resume, detect and reconcile linked artifacts and plausible unlinked specs before creating another handoff.
