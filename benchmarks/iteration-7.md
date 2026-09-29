# Flutter Riverpod Skill — Iteration 7

Run on 2026-09-29 with Codex CLI 0.157.1. GPT-6 Luna (`medium`) implemented
the three tasks once with and without the skill, and GPT-6 Astra (`high`)
graded them against the unchanged rubric. The harness and fixtures are the
same as in iterations 4–6.

The skill under test is commit `75aeb27`, which adds four changes on top of
[iteration 6](iteration-6.md):

- Default `built_value` serialization is required. An option listed in the
  generator documentation is not a reason to switch.
- Scripted rewrites of generated files, including the generated
  `pubspec.yaml`, count as hand edits.
- Plain, non-interactive `dart pub get` and `dart run build_runner build`
  must succeed in a clean copy of the generated package.
- The final Freezed check greps touched hand-written files for `^class `.

This is exploratory evidence, not a statistical claim.

## Results

| Case | Condition | Functional | Skill conventions | Mechanical checks |
|---|---|---:|---:|---:|
| Feature | Without skill | 1/1 | 0/5 | 7/7 |
| Feature | With skill | 1/1 | 5/5 | 8/8 |
| OpenAPI | Without skill | 3/4 | 1/2 | 13/14 |
| OpenAPI | With skill | 3/4 | 2/2 | 13/14 |
| Refactor | Without skill | 2/2 | 0/4 | 6/8 |
| Refactor | With skill | 2/2 | 4/4 | 9/9 |
| **Total** | **Without skill** | **6/7 (85.7%)** | **1/11 (9.1%)** | **1/3 cases fully passed** |
| **Total** | **With skill** | **6/7 (85.7%)** | **11/11 (100%)** | **2/3 cases fully passed** |

Skill-assisted results across iterations:

| Metric | It. 1 | It. 2 | It. 3 | It. 4 | It. 5 | It. 6 | It. 7 |
|---|---:|---:|---:|---:|---:|---:|---:|
| Functional assertions | 6/7 | 6/7 | 4/7 | 6/7 | 6/7 | 7/7 | 6/7 |
| Convention assertions | 3/11 | 9/11 | 11/11 | 11/11 | 11/11 | 10/11 | 11/11 |
| Cases passing all mechanical checks | 3/3 | 2/3 | 3/3 | 3/3 | 2/3 | 2/3 | 2/3 |
| Solver wall time (3 runs) | 948.9 s | 823.4 s | 782.3 s | 1,067.9 s | 1,299.8 s | 1,747.6 s | 1,598.6 s |
| Solver tokens (3 runs) | 3.49 M | 2.96 M | 2.94 M | 3.76 M | 1.65 M | 4.54 M | 2.17 M |

Iterations 1–3 used a harness without the independent regeneration check.

All four targeted fixes took effect, and conventions returned to 11/11. The
one remaining skill-assisted miss is a warning in the generated package's
static analysis. The baseline has failed on the same warning in every
iteration since iteration 3.

Solver cost is 1,598.6 s and 2,168,042 tokens with the skill, against
475.9 s and 1,336,696 tokens without it. That is about 3.4 times the time and
1.6 times the tokens. The OpenAPI skill run alone took 1,233.9 s; we did not
investigate where that time went. Token counts include cached input and
should not be read as billing amounts.

## Findings

- **Feature and refactor.** Both skill-assisted runs again passed every
  assertion and every mechanical check.
- **OpenAPI: iteration-6 issues fixed.** The run kept `built_value`, did not
  rewrite the generated `pubspec.yaml`, and passed both the package's
  non-interactive `build_runner` check and the independent regeneration
  check. `ReadingRecord` became a `@freezed` class, so both convention
  assertions passed. The package carries its own serializer tests.
- **OpenAPI: generator warning left fatal.** OpenAPI Generator 7.25.0 emits an
  unused `package:built_value/json_object.dart` import in `default_api.dart`.
  The package's plain `dart analyze` exits with code 2 on it, so package
  validation failed. Iterations 3–5 handled this by adding
  `unused_import: ignore` to a package-local `analysis_options.yaml` and
  protecting that file through `.openapi-generator-ignore`. This run instead
  kept the generator's default analysis options and documented
  `dart analyze --no-fatal-warnings` in the package README. The judge ruled
  that a weakened command does not satisfy validation.
- **Baseline.** The baseline OpenAPI run failed on the same unused import,
  kept a plain `ReadingRecord`, and left generator stub tests. The baseline
  refactor again notified listeners after disposal.

## Follow-up

Candidate changes for iteration 8, in the OpenAPI checklist row and
`references/api-client.md`:

1. Plain `dart analyze` with no flags must exit 0 in the generated package.
   Weakening it with `--no-fatal-warnings` or similar flags is not allowed.
2. Suppress generator-only diagnostics, such as the 7.25.0 unused import,
   rule by rule in a package-local `analysis_options.yaml`. List that file in
   `.openapi-generator-ignore` so that regeneration keeps it.

## Reproducibility and limits

Fixtures, prompts, rubric, withheld tests, and harness are unchanged from
iteration 4 and documented in [EVALUATION.md](../EVALUATION.md). Local raw
transcripts, outputs, checks, usage records, and grades are stored under the
gitignored `eval-results/iteration-7/` directory. The skill snapshot there
matches the skill files at commit `75aeb27`. All six solver runs,
verifications, and gradings completed on the first launch without retries.

Each case and condition ran once. The same model family served as solver and
judge, and no human review has been recorded.
