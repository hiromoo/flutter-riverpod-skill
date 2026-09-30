# Flutter Riverpod Skill — Iteration 6

Run on 2026-09-29 with Codex CLI 0.157.1. GPT-6 Luna (`medium`) implemented
the three tasks once with and without the skill, and GPT-6 Astra (`high`)
graded them against the unchanged rubric. The harness and fixtures are the
same as in iterations 4 and 5.

The skill under test is commit `234f3c9`, which adds two changes on top of
[iteration 5](iteration-5.md):

- Regeneration must be reproducible from a clean checkout. Resolve
  dependencies before any formatting, and verify in a copy without
  `.dart_tool` and `build`.
- Generator test stubs may be disabled with
  `--global-property apiTests=false,modelTests=false`.

This is exploratory evidence, not a statistical claim.

## Results

| Case | Condition | Functional | Skill conventions | Mechanical checks |
|---|---|---:|---:|---:|
| Feature | Without skill | 1/1 | 0/5 | 7/7 |
| Feature | With skill | 1/1 | 5/5 | 8/8 |
| OpenAPI | Without skill | 3/4 | 1/2 | 13/14 |
| OpenAPI | With skill | 4/4 | 1/2 | 13/14 |
| Refactor | Without skill | 2/2 | 0/4 | 6/8 |
| Refactor | With skill | 2/2 | 4/4 | 9/9 |
| **Total** | **Without skill** | **6/7 (85.7%)** | **1/11 (9.1%)** | **1/3 cases fully passed** |
| **Total** | **With skill** | **7/7 (100%)** | **10/11 (90.9%)** | **2/3 cases fully passed** |

Skill-assisted results across iterations:

| Metric | It. 1 | It. 2 | It. 3 | It. 4 | It. 5 | It. 6 |
|---|---:|---:|---:|---:|---:|---:|
| Functional assertions | 6/7 | 6/7 | 4/7 | 6/7 | 6/7 | 7/7 |
| Convention assertions | 3/11 | 9/11 | 11/11 | 11/11 | 11/11 | 10/11 |
| Cases passing all mechanical checks | 3/3 | 2/3 | 3/3 | 3/3 | 2/3 | 2/3 |
| Solver wall time (3 runs) | 948.9 s | 823.4 s | 782.3 s | 1,067.9 s | 1,299.8 s | 1,747.6 s |
| Solver tokens (3 runs) | 3.49 M | 2.96 M | 2.94 M | 3.76 M | 1.65 M | 4.54 M |

Iterations 1–3 used a harness without the independent regeneration check.

The targeted fix worked. The regeneration script now reproduces the delivered
package from a clean copy, and the skill-assisted runs passed every functional
assertion for the first time. However, the OpenAPI run switched serializers
without need, and that choice led to a Freezed miss and a mechanical failure.

Solver cost is 1,747.6 s and 4,541,582 tokens with the skill, against
504.9 s and 1,235,341 tokens without it. That is about 3.5 times the time and
3.7 times the tokens. Most of the increase comes from the single OpenAPI
skill run (1,261.3 s and 3,390,084 tokens). Token counts include cached input
and should not be read as billing amounts.

## Findings

- **Feature and refactor.** Both skill-assisted runs again passed every
  assertion and every mechanical check.
- **OpenAPI: clean-checkout regeneration fixed.** `tool/generate_api.sh`
  resolves the package's dependencies before building serializers and
  formatting. It disables generator test stubs through `--global-property`.
  The solver compared a regeneration in a cache-free copy, the verifier's
  independent check found no differences, and all four functional assertions
  passed.
- **OpenAPI: unneeded serializer switch.** The solver chose
  `serializationLibrary: json_serializable` only because the generator's
  documentation lists it, although the skill makes `built_value` the default
  unless a project requirement says otherwise. The generated package then did
  not resolve against the pinned SDK, and the solver spent much of the run
  investigating package versions. The final script rewrites the generated
  `pubspec.yaml` with an inline Python step: it raises the SDK lower bound,
  drops a dependency, and pins `build_runner` 2.4.13 and `analyzer` 6.4.1.
  Editing generator output through a script defeats the rule against
  hand-editing generated files.
- **OpenAPI: non-interactive build failure.** The verifier's plain
  `dart run build_runner build` in the package failed. `build_runner` 2.4.13
  asks interactively whether to delete conflicting committed outputs, and it
  crashed with a null check error in the non-interactive environment.
- **OpenAPI: Freezed regression.** The public `ReadingRecord` remained a plain
  class, although iterations 4 and 5 converted it to Freezed. The final
  self-check did not catch it.
- **Baseline.** The baseline OpenAPI run kept a plain `ReadingRecord` and
  generator stub tests, and its package analysis failed on an unused import.
  The baseline refactor again notified listeners after disposal.

## Follow-up

Candidate changes for iteration 7:

1. Require `built_value` serialization and state that listing an alternative
   in the generator documentation is not a reason to switch.
2. Treat scripted rewrites of generated files, including the generated
   `pubspec.yaml`, as hand edits. Fix resolution problems through generator
   configuration or version choice, or report them.
3. Require plain, non-interactive `dart run build_runner build` to succeed in
   a clean copy of the generated package.
4. Make the final Freezed check concrete: search touched hand-written files
   for `^class ` and confirm that every public data class is `@freezed`.

## Reproducibility and limits

Fixtures, prompts, rubric, withheld tests, and harness are unchanged from
iteration 4 and documented in [EVALUATION.md](../EVALUATION.md). Local raw
transcripts, outputs, checks, usage records, and grades are stored under the
gitignored `eval-results/iteration-6/` directory. The skill snapshot there
matches the skill files at commit `234f3c9`. All six solver runs,
verifications, and gradings completed on the first launch without retries.

Each case and condition ran once. The same model family served as solver and
judge, and no human review has been recorded.
