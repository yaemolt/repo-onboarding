---
name: repo-onboarding
description: Use when the user wants a guided repository onboarding experience, such as learning a new repo, understanding project structure, finding entrypoints and main flows, exploring modules in order, or studying the codebase step by step.
---

# Repo Onboarding

## Overview

Turn a repository into a progressive learning workspace. Teach in layers, persist artifacts on disk, and always leave the user with a clear next step instead of a one-shot code dump.

## Workflow

Follow this flow in order:

1. Determine the repository root being studied.
2. Initialize `<repo-root>/RepoOnboarding` artifacts before giving the first substantive answer.
3. Do a quick scan only: root tree, `README*`, and top-level build or dependency files.
4. Write the architecture summary to `<repo-root>/RepoOnboarding/Architecture/architecture.md`.
5. Update `<repo-root>/RepoOnboarding/Progress/progress.md`.
6. Ask the user which module or directory to study next.
7. On selection, create module notes under `<repo-root>/RepoOnboarding/Modules/<module-name>/`.
8. Drill down from module -> file -> function, updating progress after each step.

## Resolve Repo Root

Before creating any learning artifacts, confirm the repository root that the user wants to study.

- Prefer the actual repo root over the current shell directory.
- If the user already pointed at a repo path, use that path as `<repo-root>`.
- If running inside the target repository, confirm the root from the directory structure or git metadata.
- If the repo root is unclear, determine it before writing files.
- Never assume the skill directory is the target repo.

## Workspace Initialization

Initialize the learning workspace by running:

```bash
scripts/init-repo-onboarding-workspace.sh <repo-root>
```

This script must create or preserve:

- `<repo-root>/RepoOnboarding/Architecture/architecture.md`
- `<repo-root>/RepoOnboarding/Modules/`
- `<repo-root>/RepoOnboarding/Progress/progress.md`
- `<repo-root>/RepoOnboarding/Progress/learning-path.md`

Run the script before writing analysis documents by hand. The script copies the default templates from `templates/`.

## Global Rules

- Always write learning documents under `<repo-root>/RepoOnboarding` before responding with analysis.
- Never dump full source files unless the user explicitly asks for raw code.
- Never scan the entire repository in one pass; use staged exploration for token safety.
- Always preserve a clear "next learning step" for the user.
- Always keep progress state up to date.
- Prefer structured Markdown tables for summaries.
- Mark unknown or deferred areas as TODO instead of guessing.
- Never create `RepoOnboarding` inside the skill directory.
- Never create `RepoOnboarding` relative to the current working directory unless that directory is confirmed to be `<repo-root>`.

## Templates

Use the bundled templates instead of rewriting document skeletons from scratch:

- `templates/architecture.md` for `<repo-root>/RepoOnboarding/Architecture/architecture.md`
- `templates/progress.md` for `<repo-root>/RepoOnboarding/Progress/progress.md`
- `templates/learning-path.md` for `<repo-root>/RepoOnboarding/Progress/learning-path.md`
- `templates/module-overview.md` for `<repo-root>/RepoOnboarding/Modules/<module-name>/module-overview.md`

Keep the templates as the starting structure, then fill them with repo-specific content.

## Scan the Repository

Use multi-phase scanning:

### Phase 1: Quick Scan

Only inspect:

- repository root structure
- `README`, `README.md`, or equivalent
- top-level build and dependency files such as `package.json`, `requirements.txt`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `pom.xml`, `CMakeLists.txt`, `Makefile`

Do not open every source file in this phase.

### Phase 2: Size Check

If the repository is large:

- sample key directories instead of expanding all of them
- record unscanned or deferred areas in architecture notes as TODO
- guide the user through high-value paths first

## Write Architecture Notes

Start from `templates/architecture.md` and fill in the project-specific content inside `<repo-root>/RepoOnboarding/Architecture/architecture.md`.

After writing it, update progress so `总体架构` is checked, then update `learning-path.md` to reflect the current stage and recommend the next area to study.

## Drive the Conversation

After architecture analysis, ask the user to choose the next area, but do not use a fixed menu unless the repository naturally groups that way.

Conversation rules:

- Base the options on the repository you just scanned, not on a generic preset.
- Prefer 2-4 concrete choices such as real directories, packages, services, apps, or layers that exist in the repo.
- Include a short reason for each choice so the user understands the learning value.
- If the repo has a clear primary path, explicitly call it out as the recommended next stop.
- If the structure is still unclear, offer one fallback option such as `我不确定，先带我看主流程`.

Example shape:

```text
我已经帮你完成了项目整体架构分析。

接下来建议从这些方向里选一个继续：
1. `src/server`：这里像是主服务入口，适合先建立主流程认识
2. `src/routes`：如果你想先理解接口如何进入系统，可以先看这里
3. `src/lib`：如果你更想了解通用能力和底层支撑，可以从这里开始

如果你不确定，我也可以直接带你沿着“最核心的一条执行路径”继续看。
```

Do not continue into module details until the user chooses.

## Module-Level Notes

When the user chooses a module or directory, create:

`<repo-root>/RepoOnboarding/Modules/<module-name>/module-overview.md`

Start from `templates/module-overview.md`, then replace placeholders and fill in the actual module content.

When filling the module overview:

- Explain the module's job in the overall system, not just its local contents.
- Identify the best entry file or primary starting point inside the module when one exists.
- Highlight 2-4 important files or symbols so the user can see where the module's center of gravity is.
- Give a suggested reading order inside the module instead of presenting files as a flat list.
- Rewrite the module-level `你可以这样继续问我` section so it uses real file names, class names, function names, routes, commands, or exports from that module.
- Keep the follow-up questions focused on the current module. Prefer questions that help the user choose the next file, understand the current file's role, or continue along the local execution path.

Then update `<repo-root>/RepoOnboarding/Progress/progress.md` under `模块层`, update `learning-path.md`, and ask which file the user wants to learn next.

## File and Function Learning

For each selected file:

- summarize responsibility, important types, main exports, and control flow
- list key functions or classes instead of pasting the whole file
- explain dependencies and where the file sits in the module
- offer the next drill-down choice: function, class, or neighboring file

For each selected function or class:

- explain purpose, inputs, outputs, and side effects
- describe the call chain and important collaborators
- include short code excerpts only when they materially improve understanding
- update file-level and function-level progress

After each file-level or function-level explanation, update `learning-path.md` so it reflects the newest current position and the next recommended stop.

## Maintain Learning Navigation

Treat `<repo-root>/RepoOnboarding/Progress/learning-path.md` as the live study dashboard.

Update it after:

- initializing the workspace
- finishing architecture analysis
- selecting or finishing a module
- selecting or finishing a file
- selecting or finishing a function or class

Start from `templates/learning-path.md` and keep the same section layout while updating the current state and recommendations.

Navigation rules:

- Treat `learning-path.md` as a current dashboard, not an append-only log.
- Keep recommendations to 2-3 items.
- Include both `原因` and `学完收获` for every recommendation.
- If the user explicitly chooses the next target, prefer the user's choice over system recommendations.
- Prefer core paths over scattered utilities when the repository is large.
- Rewrite the `你可以这样继续问我` section on every update instead of leaving generic placeholder questions in place.
- Generate those follow-up questions from the real repository structure, current learning level, and current object.
- Use actual repo names when possible: directory names, package names, entry files, exported symbols, routes, services, commands, jobs, or scripts.
- Questions should help the user move one step deeper or sideways from the current learning path, not jump to unrelated areas.
- Avoid fixed question lists. Keep the structure stable, but vary the content with the repo and the current stage.

Recommendation heuristics:

- If architecture is not complete, recommend architecture and root-level entry materials first.
- If a module is selected but no file is selected, recommend the module's entry file, main service, controller, or primary export.
- If a file is selected but no function is selected, recommend the main class, primary function, or the most central symbol in that file.
- After a function is learned, recommend its caller, callee, or an adjacent file in the same execution path.
- When one path is finished, recommend the most related next module instead of a random directory.

Question-generation heuristics for `你可以这样继续问我`:

- At architecture level, generate questions about selecting the next module, locating the main entry path, comparing major areas, or deciding where a beginner should start.
- At module level, generate questions about the module's responsibility, its entry file, the best reading order inside it, or how it participates in the main flow.
- At file level, generate questions about the file's role, the main symbols inside it, its upstream and downstream neighbors, or whether it is worth reading next.
- At function or class level, generate questions about inputs and outputs, side effects, callers, callees, and the next hop in the execution path.
- Prefer specific prompts such as `为什么先看 <path> 而不是 <path>?` over generic prompts such as `接下来该看什么?`.
- Keep the list short and scannable: usually 3-5 questions total, grouped by intent when helpful.

## Response Style

- Teach progressively from macro to micro.
- Prefer explanation, mapping, and learning order over implementation advice.
- Use Chinese if the user is speaking Chinese, while preserving code identifiers in English.
- Keep answers structured and study-oriented.
- End each step with one concrete next choice.

## Common Mistakes

- Scanning the full repo immediately instead of doing a staged scan.
- Writing only chat replies without persisting `<repo-root>/RepoOnboarding` artifacts.
- Creating `RepoOnboarding` in the wrong directory because the repo root was never confirmed.
- Dumping source code instead of summarizing architecture and learning paths.
- Advancing to deep file analysis before the user chooses a module.
- Forgetting to update progress after generating a new learning artifact.
