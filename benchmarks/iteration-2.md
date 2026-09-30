# Flutter Riverpod Skill — Iteration 2

Run on 2026-09-28 with Codex CLI 0.157.1. GPT-6 Luna (`medium`) implemented
the same three tasks once with and without the skill, and GPT-6 Astra (`high`)
graded them against the same fixed rubric as [iteration 1](iteration-1.md).
The skill under test is commit `47a2de1`, which adds a scope section, a
trigger-based convention checklist, a pre-implementation compliance map, and a
final self-check. This is exploratory evidence, not a statistical claim.

## Results

| Case | Condition | Functional | Skill conventions | Mechanical checks |
|---|---|---:|---:|---:|
| Feature | Without skill | 1/1 | 0/5 | 7/7 |
| Feature | With skill | 1/1 | 5/5 | 8/8 |
| OpenAPI | Without skill | 2/4 | 1/2 | 12/12 |
| OpenAPI | With skill | 3/4 | 1/2 | 12/12 |
| Refactor | Without skill | 2/2 | 0/4 | 6/8 |
| Refactor | With skill | 2/2 | 3/4 | 7/9 |
| **Total** | **Without skill** | **5/7 (71.4%)** | **1/11 (9.1%)** | **2/3 cases fully passed** |
| **Total** | **With skill** | **6/7 (85.7%)** | **9/11 (81.8%)** | **2/3 cases fully passed** |

Skill-assisted results compared with iteration 1:

| Metric | Iteration 1 | Iteration 2 |
|---|---:|---:|
| Functional assertions | 6/7 | 6/7 |
| Convention assertions | 3/11 (27.3%) | 9/11 (81.8%) |
| Cases passing all mechanical checks | 3/3 | 2/3 |
| Solver wall time (3 runs) | 948.9 s | 823.4 s |
| Solver tokens (3 runs) | 3,494,589 | 2,955,605 |

The checklist had its intended effect on conventions. The skill's lead over
the baseline on convention assertions widened from 18.2 to 72.7 percentage
points. Functional results did not change. One mechanical regression appeared
in the refactor case, described below.

Solver cost fell compared with iteration 1 but remains high relative to the
baseline: 823.4 s and 2,955,605 tokens with the skill, against 1,127.0 s and
898,245 tokens without it. The baseline's wall time is inflated by a single
902.9 s OpenAPI run. Token counts include cached input and should not be read
as billing amounts.

## Findings

- **Feature (conventions 1/5 → 5/5).** Transport JSON is mapped to a Freezed
  `Book` in a repository, list state is owned by an `AsyncNotifier`, strings
  come from ARB files through `context.l`, and navigation uses
  `go_router_builder` typed routes under `MaterialApp.router`. The public
  `EvalApp` host interface was kept, which confirms that the host-boundary
  guidance works.
- **Refactor (conventions 1/4 → 3/4, mechanical 8/8 → 7/9).** The data
  boundary, `HookConsumerWidget` with `useTextEditingController`, and
  `gen_l10n` all passed, and the out-of-order completion guard held. However,
  the notifier assigns `state` after an `await` without checking `ref.mounted`.
  The withheld test for completion after dispose failed with
  `UnmountedRefException`, which also failed the Riverpod lifecycle assertion.
  The iteration-1 skill run had passed this check. The iteration-2 checklist
  asked for a test of stale completion only, not of completion after dispose.
- **OpenAPI (unchanged).** The generated client, domain boundary, nullable note
  contract, and standalone package tests all passed. The hand-written public
  `ReadingRecord` remained a plain class rather than Freezed, likely because
  `TASK_API.md` fixes its constructor signature. The regeneration assertion is
  again unverified in both conditions: the pinned commands were documented, but
  no second generator run or diff result was recorded.
- **Baseline.** The baseline OpenAPI run now passes its mechanical checks
  (11/12 → 12/12), but its package tests were empty TODO stubs, so it failed
  package validation. The baseline refactor again notified listeners after
  disposal. Without the skill, all three runs kept remote state in widgets or a
  `ChangeNotifier`, used locale `if` branches for strings, and navigated with
  `Navigator.push`.

## Follow-up

Commit `00c859b` addresses the three remaining misses:

1. The Riverpod checklist row requires `if (!ref.mounted) return;` after every
   `await` and a test for completion after dispose.
2. The Freezed row covers existing public models that a task rewrites, and
   shows a signature-preserving `const factory` such as
   `const factory ReadingRecord({required String id, String? note})`.
3. The OpenAPI row and `references/api-client.md` require a second generator
   run followed by `git diff --exit-code`, with the commands and result
   recorded in the package README and the final summary.

These changes have not been evaluated yet. They will be measured in
iteration 3.

## Reproducibility and limits

Fixtures, prompts, rubric, withheld tests, and runner are unchanged from
iteration 1 and are documented in [EVALUATION.md](../EVALUATION.md). Local raw
transcripts, outputs, checks, usage records, and grades are stored under the
gitignored `eval-results/iteration-2/` directory. The skill snapshot there
matches commit `47a2de1`.

The first launch attempt stopped before any model call because the `codex`
executable was not on `PATH` while the CLI was being upgraded. No output
directory was created. The second launch completed all six solver runs,
verifications, and gradings without retries.

The Codex CLI changed from 0.155.0-alpha.16.3 in iteration 1 to 0.157.1, so
differences between iterations are not attributable to the skill alone. Each
case and condition ran once, and run-to-run variance is visibly large (the
baseline OpenAPI solver time moved from 194.6 s to 902.9 s). The same model
family served as solver and judge, and no human review has been recorded.
