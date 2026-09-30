# Flutter Riverpod Skill — Iteration 9

Run three times on 2026-09-30 with Codex CLI 0.157.1 (`iteration-9-run1` to
`iteration-9-run3`). In each run, GPT-6 Luna (`medium`) implemented the three
tasks once with and once without the skill, and GPT-6 Astra (`high`) graded
them against the unchanged rubric. The fixtures are the same as in iterations
4–8. The harness is the version from commit `d674807`, which records skill-set
changes around every Codex call and retries a preflight once when they occur.

The skill under test is commit `b958851`. It adds three changes on top of
[iteration 8](iteration-8.md):

- **Freezed trigger.** Any plain public data class already present in an
  edited file is now a direct trigger in the Freezed checklist row. This
  holds even when the task only asks to keep the class's constructor
  signature. It no longer depends on the final self-check step, which the
  model skipped in iteration 8.
- **Resubmission and retry.** With provider families, resubmitting the same
  parameters must still start a new request. Every error state must offer a
  retry action.
- **Example fix.** The Reading Shelf example now refreshes the search when
  the same query is submitted again, and has a widget test for it.

This is exploratory evidence, not a statistical claim.

## Results

| Run | Condition | Functional | Conventions | Mechanical | Solver time | Solver tokens |
|---|---|---:|---:|---:|---:|---:|
| 1 | Without skill | 6/7 | 1/11 | 1/3 | 825.1 s | 1.42 M |
| 1 | With skill | 7/7 | 11/11 | 3/3 | 1,001.8 s | 4.57 M |
| 2 | Without skill | 5/7 | 1/11 | 1/3 | 374.2 s | 0.82 M |
| 2 | With skill | 7/7 | 11/11 | 3/3 | 732.7 s | 1.74 M |
| 3 | Without skill | 6/7 | 1/11 | 2/3 | 786.1 s | 0.81 M |
| 3 | With skill | 7/7 | 11/11 | 3/3 | 1,179.5 s | 3.26 M |
| **Total** | **Without skill** | **17/21** | **3/33** | **4/9** | **1,985.4 s** | **3.05 M** |
| **Total** | **With skill** | **21/21** | **33/33** | **9/9** | **2,914.0 s** | **9.57 M** |

Compared with the three iteration-8 runs:

| Three-run total, with skill | Iteration 8 | Iteration 9 |
|---|---:|---:|
| Functional assertions | 20/21 | 21/21 |
| Convention assertions | 31/33 | 33/33 |
| Cases passing all mechanical checks | 9/9 | 9/9 |
| Solver time relative to baseline | 1.4× | 1.5× |
| Solver tokens relative to baseline | 1.8× | 3.1× |

The skill-assisted runs passed every functional, convention, and mechanical
check in all three runs. This is the first skill version to reach a full pass
across repeated runs.

The cost of that result grew. Across the three runs, the skill used about 1.5
times the baseline's solver time and 3.1 times its tokens. Token use varied
widely between runs: 1.74 M to 4.57 M with the skill. Token counts include
cached input and should not be read as billing amounts.

## Findings

- **Freezed fixed in every run.** All three skill-assisted API runs converted
  the fixture's pre-existing plain `ReadingRecord` to Freezed. In iteration 8
  it stayed a plain class in two of three runs. Moving the trigger into the
  checklist row worked where the final self-check step had not.
- **Feature behavior held in every run.** No skill-assisted feature run
  repeated the iteration-8 miss, in which resubmitting the same query did not
  start a new search and the detail error had no retry.
- **Earlier fixes held.** Every skill-assisted run passed all mechanical
  checks, including the independent regeneration diff, the package's plain
  `dart analyze` and non-interactive `build_runner`, and the withheld race and
  disposal tests.
- **Baseline.** Without the skill, all nine runs failed the same conventions
  as before. Remote state stayed in widgets or a `ChangeNotifier`, strings
  were switched with locale checks, typed routes and Freezed were not used,
  and the refactor notified listeners after disposal in every run. In run 2,
  the baseline API run also failed regeneration, and its feature run failed
  analysis.

## Harness observations

- **Preflight retry worked.** In run 1, the solver's preflight saw the skill
  set change while it ran. The runner kept that attempt as
  `preflight-solver-stale.*`, retried once, and the retry passed with
  `NO_SKILLS`. The iteration-8 launch had failed at the same point for the
  same reason.
- **Skill set changed during one baseline grading.** In run 3, Codex
  re-extracted its system skills at 10:11:40 (the trigger is unknown).
  - The baseline API solver had finished at 10:10:44 with a complete disable
    list of 12 entries, so its implementation was unaffected.
  - The judge for that run built its disable list during the extraction. The
    list had 10 entries and was missing `plugin-creator`, which may therefore
    have been enabled while that one grading ran.
  - The grading transcript shows no skill use. Its verdicts (Freezed and
    package validation failed) match every other baseline API run. We judged
    the effect negligible and kept the grading as recorded rather than
    rerunning it.

  No skill-assisted run recorded a skill-set change.

## Follow-up

- Look into cost. The quality gains now hold across repeated runs, but token
  use with the skill rose to 3.1 times the baseline, and it varied more than
  threefold between runs.
- In the harness, consider rebuilding the disable list and rerunning a solver
  or judge call when `skill_set_changed` shows an incomplete list, not only
  for preflights.

## Reproducibility and limits

Fixtures, prompts, rubric, and withheld tests are unchanged and documented in
[EVALUATION.md](../EVALUATION.md). Local raw transcripts, outputs, checks,
usage records, and grades are stored under the gitignored
`eval-results/iteration-9-run1/` to `iteration-9-run3/` directories. Each
skill snapshot matches the skill and example files at commit `b958851`.

Three runs are more informative than one, but they are still a small sample.
The same model family served as solver and judge, and no human review has
been recorded.
