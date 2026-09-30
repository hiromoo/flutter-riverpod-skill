# Flutter Riverpod Skill — Iteration 3

Run on 2026-09-28 with Codex CLI 0.157.1, the same CLI as
[iteration 2](iteration-2.md). GPT-6 Luna (`medium`) implemented the same three
tasks once with and without the skill, and GPT-6 Astra (`high`) graded them
against the unchanged rubric. The skill under test is commit `00c859b`, which
adds three changes on top of iteration 2: `ref.mounted` checks with a
completion-after-dispose test, Freezed for rewritten public models via a
signature-preserving `const factory`, and a recorded second generator run.
This is exploratory evidence, not a statistical claim.

## Results

| Case | Condition | Functional | Skill conventions | Mechanical checks |
|---|---|---:|---:|---:|
| Feature | Without skill | 1/1 | 0/5 | 7/7 |
| Feature | With skill | 0/1 | 5/5 | 8/8 |
| OpenAPI | Without skill | 2/4 | 1/2 | 10/12 |
| OpenAPI | With skill | 3/4 | 2/2 | 12/12 |
| Refactor | Without skill | 2/2 | 0/4 | 6/8 |
| Refactor | With skill | 1/2 | 4/4 | 9/9 |
| **Total** | **Without skill** | **5/7 (71.4%)** | **1/11 (9.1%)** | **1/3 cases fully passed** |
| **Total** | **With skill** | **4/7 (57.1%)** | **11/11 (100%)** | **3/3 cases fully passed** |

Skill-assisted results across iterations:

| Metric | Iteration 1 | Iteration 2 | Iteration 3 |
|---|---:|---:|---:|
| Functional assertions | 6/7 | 6/7 | 4/7 |
| Convention assertions | 3/11 | 9/11 | 11/11 |
| Cases passing all mechanical checks | 3/3 | 2/3 | 3/3 |
| Solver wall time (3 runs) | 948.9 s | 823.4 s | 782.3 s |
| Solver tokens (3 runs) | 3,494,589 | 2,955,605 | 2,938,454 |

All three targeted fixes took effect. Every convention assertion passed, and
all skill-assisted outputs passed the withheld mechanical checks. The
functional pass rate fell below the baseline for the first time. The two new
failures are real defects that the withheld tests did not exercise; the judge
found them by reading the code.

Solver cost is 782.3 s and 2,938,454 tokens with the skill, against
1,103.1 s and 1,887,184 tokens without it. The baseline's wall time is
dominated by a single 734.0 s feature run. Token counts include cached input
and should not be read as billing amounts.

## Findings

- **Targeted fixes.**
  - The refactor notifier now checks `ref.mounted` after each `await`, and the
    completion-after-dispose check passed (mechanical 7/9 → 9/9).
  - The OpenAPI `ReadingRecord` became a Freezed class while keeping its
    public constructor signature (conventions 1/2 → 2/2).
  - The OpenAPI run compared generator output before and after regeneration
    and reported that all directories matched. The regeneration assertion is
    still unverified, because the judge accepts only log evidence and the
    verifier does not rerun OpenAPI Generator.
- **Feature: retry uses the wrong query (functional 1/1 → 0/1).** The retry
  button calls `search(controller.text)`, so it replays whatever is currently
  in the input field rather than the query that failed. If the user edits the
  field after a failure and then taps Retry, a different search runs. The
  fixture README requires retry to repeat the failed query. The solver's tests
  did not cover an edited input before retry.
- **Refactor: race guard skips the initial load (functional 2/2 → 1/2).**
  `search()` checks the request id and `ref.mounted`, but `build()` loads
  through a separate `_load()` that neither catches errors nor applies the
  request-id check on failure. If the initial load is still pending when a
  later search succeeds, and the initial load then fails, the error replaces
  the latest results. The solver's race test started only after the initial
  load had completed.
- **Baseline.** Without the skill, the OpenAPI package failed standalone
  analysis because of an unused import and had no tests (mechanical 10/12).
  The refactor again notified listeners after disposal. As in earlier
  iterations, all three baseline runs kept remote state in widgets or a
  `ChangeNotifier` and switched strings with locale `if` branches.

## Follow-up

Candidate changes for iteration 4:

1. **Retry replays the failed request.** Retry commands live in the notifier,
   which keeps the parameters of the failed request and resends them rather
   than reading UI input again. Tests edit the input after a failure and then
   retry.
2. **One guarded path for every async entry point.** `build()` and command
   methods go through a shared helper that applies the request id,
   `ref.mounted`, and error handling. Tests start a new request while the
   initial load is pending and check both success-then-failure and
   failure-then-success orderings.
3. **Harness: verify regeneration directly.** Have the verifier rerun
   OpenAPI Generator and diff the output, so that the regeneration assertion
   can be judged on evidence rather than the solver's report. This changes the
   harness, so results after it are not directly comparable to iterations 1–3.

## Reproducibility and limits

Fixtures, prompts, rubric, withheld tests, and runner are unchanged and are
documented in [EVALUATION.md](../EVALUATION.md). Local raw transcripts,
outputs, checks, usage records, and grades are stored under the gitignored
`eval-results/iteration-3/` directory. The skill snapshot there matches the
skill files at commit `00c859b`. All six solver runs, verifications, and
gradings completed on the first launch without retries.

Each case and condition ran once. The swing in functional results between
iterations 2 and 3 may reflect run-to-run variance as much as the skill change,
since neither new defect relates to the three rules that changed. The withheld
tests do not cover retry after an edited query or failure of the initial load
during a race, so the mechanical column overstates functional correctness in
this iteration. The same model family served as solver and judge, and no human
review has been recorded.
