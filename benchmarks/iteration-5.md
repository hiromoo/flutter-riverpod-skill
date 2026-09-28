# Flutter Riverpod Skill — Iteration 5

Run on 2026-09-28 with Codex CLI 0.157.1. GPT-6 Luna (`medium`) implemented
the three tasks once with and without the skill, and GPT-6 Astra (`high`)
graded them against the unchanged rubric. The harness and fixtures are the
same as in [iteration 4](iteration-4.md), including the independent
regeneration check.

The skill under test is commit `be4912b`, which adds one change on top of
iteration 4. The generated API package's `test/` directory is hand-owned:
`test/**` goes into `.openapi-generator-ignore`, and real serializer and
contract tests go into the package. This is exploratory evidence, not a
statistical claim.

## Results

| Case | Condition | Functional | Skill conventions | Mechanical checks |
|---|---|---:|---:|---:|
| Feature | Without skill | 1/1 | 0/5 | 7/7 |
| Feature | With skill | 1/1 | 5/5 | 8/8 |
| OpenAPI | Without skill | 3/4 | 1/2 | 14/14 |
| OpenAPI | With skill | 3/4 | 2/2 | 13/14 |
| Refactor | Without skill | 2/2 | 0/4 | 6/8 |
| Refactor | With skill | 2/2 | 4/4 | 9/9 |
| **Total** | **Without skill** | **6/7 (85.7%)** | **1/11 (9.1%)** | **2/3 cases fully passed** |
| **Total** | **With skill** | **6/7 (85.7%)** | **11/11 (100%)** | **2/3 cases fully passed** |

Skill-assisted results across iterations:

| Metric | Iteration 1 | Iteration 2 | Iteration 3 | Iteration 4 | Iteration 5 |
|---|---:|---:|---:|---:|---:|
| Functional assertions | 6/7 | 6/7 | 4/7 | 6/7 | 6/7 |
| Convention assertions | 3/11 | 9/11 | 11/11 | 11/11 | 11/11 |
| Cases passing all mechanical checks | 3/3 | 2/3 | 3/3 | 3/3 | 2/3 |
| Solver wall time (3 runs) | 948.9 s | 823.4 s | 782.3 s | 1,067.9 s | 1,299.8 s |
| Solver tokens (3 runs) | 3,494,589 | 2,955,605 | 2,938,454 | 3,764,163 | 1,650,822 |

Iterations 1–3 used a harness without the independent regeneration check.

The targeted fix worked: the skill-assisted API package now carries a real
serializer test and passes package validation. A different API assertion
failed instead. The regeneration script was not reproducible from a clean
checkout, and the independent regeneration check caught it.

Solver cost is 1,299.8 s and 1,650,822 tokens with the skill, against
532.3 s and 1,151,999 tokens without it. That is about 2.4 times the time
and 1.4 times the tokens. Token use fell by more than half compared with
iteration 4, while wall time rose. Token counts include cached input and
should not be read as billing amounts.

## Findings

- **Feature and refactor.** Both skill-assisted runs passed every assertion
  and every mechanical check again, using provider families keyed by
  request parameters.
- **OpenAPI: package tests fixed.** `packages/reading_api/test/` contained
  only a hand-written `reading_serialization_test.dart`, with no generator
  TODO stubs, and package validation passed. The baseline again left only
  generator stubs and failed this assertion.
- **OpenAPI: regeneration not reproducible from a clean checkout.** The
  verifier's clean-copy regeneration differed from the delivered package in
  12 generated files. Every difference was `dart format` style: one-line
  parameter lists versus the tall style with one parameter per line. The
  cause is the order of steps in the solver's `tool/generate_api.sh`.
  - The script formats files during generation through
    `DART_POST_PROCESS_FILE` and runs `dart pub get` only afterwards.
  - `dart format` picks its style from the package's language version, which
    it reads from `.dart_tool/package_config.json`.
  - In the solver's workspace that file already existed. Files were formatted
    in the short style of the package's `>=2.18.0` SDK constraint, and the
    solver's own before-and-after diff passed.
  - The verifier's clean copy has no `.dart_tool`. The formatter fell back to
    the latest language version and produced the tall style.

  We reproduced this: formatting a delivered file without a package config
  changes it, and formatting it after `dart pub get` leaves it unchanged. A
  fresh clone in CI would show the same drift, so this is a genuine
  reproducibility defect, not a harness artifact.
- **Baseline.** The baseline OpenAPI run passed the regeneration check but
  kept a plain `ReadingRecord` and stub package tests. The baseline refactor
  again notified listeners after disposal.

## Follow-up

Candidate changes for iteration 6, in the OpenAPI checklist row and
`references/api-client.md`:

1. Regeneration scripts must produce identical output from a clean checkout.
   Run `dart pub get` in the generated package before any formatting, or
   format as a separate step after dependency resolution.
2. Check stability against a clean copy that excludes `.dart_tool`, rather
   than only rerunning in the working tree.
3. Consider pinning the generated package's SDK lower bound so that the
   formatter's style does not depend on the environment.

## Reproducibility and limits

Fixtures, prompts, rubric, withheld tests, and harness are unchanged from
iteration 4 and documented in [EVALUATION.md](../EVALUATION.md). Local raw
transcripts, outputs, checks, usage records, and grades are stored under the
gitignored `eval-results/iteration-5/` directory. The skill snapshot there
matches the skill files at commit `be4912b`. All six solver runs,
verifications, and gradings completed on the first launch without retries.

Each case and condition ran once. The same model family served as solver and
judge, and no human review has been recorded.
