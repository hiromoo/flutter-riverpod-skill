# Flutter Riverpod Skill — Iteration 8

Run on 2026-09-29 with Codex CLI 0.157.1. GPT-6 Luna (`medium`) implemented
the three tasks once with and without the skill, and GPT-6 Astra (`high`)
graded them against the unchanged rubric. The harness and fixtures are the
same as in iterations 4–7.

The skill under test is commit `ae44f28`, which adds one change on top of
[iteration 7](iteration-7.md). Plain `dart analyze` must exit 0 in the
generated API package. Generator-only diagnostics are suppressed rule by rule
in a package-local `analysis_options.yaml` protected by
`.openapi-generator-ignore`, never with weakening flags such as
`--no-fatal-warnings`. This is exploratory evidence, not a statistical claim.

## Results

| Case | Condition | Functional | Skill conventions | Mechanical checks |
|---|---|---:|---:|---:|
| Feature | Without skill | 1/1 | 0/5 | 7/7 |
| Feature | With skill | 1/1 | 5/5 | 8/8 |
| OpenAPI | Without skill | 3/4 | 1/2 | 13/14 |
| OpenAPI | With skill | 4/4 | 2/2 | 14/14 |
| Refactor | Without skill | 2/2 | 0/4 | 6/8 |
| Refactor | With skill | 2/2 | 4/4 | 9/9 |
| **Total** | **Without skill** | **6/7 (85.7%)** | **1/11 (9.1%)** | **1/3 cases fully passed** |
| **Total** | **With skill** | **7/7 (100%)** | **11/11 (100%)** | **3/3 cases fully passed** |

Skill-assisted results across iterations:

| Metric | It. 1 | It. 2 | It. 3 | It. 4 | It. 5 | It. 6 | It. 7 | It. 8 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Functional assertions | 6/7 | 6/7 | 4/7 | 6/7 | 6/7 | 7/7 | 6/7 | 7/7 |
| Convention assertions | 3/11 | 9/11 | 11/11 | 11/11 | 11/11 | 10/11 | 11/11 | 11/11 |
| Cases passing all mechanical checks | 3/3 | 2/3 | 3/3 | 3/3 | 2/3 | 2/3 | 2/3 | 3/3 |
| Solver wall time (3 runs) | 948.9 s | 823.4 s | 782.3 s | 1,067.9 s | 1,299.8 s | 1,747.6 s | 1,598.6 s | 729.9 s |
| Solver tokens (3 runs) | 3.49 M | 2.96 M | 2.94 M | 3.76 M | 1.65 M | 4.54 M | 2.17 M | 2.26 M |

Iterations 1–3 used a harness without the independent regeneration check.

This is the first iteration in which the skill-assisted runs pass every
functional assertion, every convention assertion, and every mechanical check.

It is also the cheapest skill-assisted iteration so far. Solver cost is
729.9 s and 2,256,085 tokens with the skill, against 586.9 s and 1,321,941
tokens without it: about 1.2 times the time and 1.7 times the tokens.
Iterations 4–7 took 2.2 to 3.5 times the baseline's time. The OpenAPI skill
run took 348.3 s, down from more than 1,200 s in iterations 6 and 7. Token
counts include cached input and should not be read as billing amounts.

## Findings

- **Feature and refactor.** Both skill-assisted runs passed every assertion
  and every mechanical check for the fifth iteration in a row.
- **OpenAPI: analysis fixed.** The generated package has a package-local
  `analysis_options.yaml` that ignores only `unused_import`, with a comment
  naming the OpenAPI Generator 7.25.0 cause. Plain `dart analyze` passed, and
  all 14 mechanical checks, 4 functional assertions, and 2 convention
  assertions passed. The earlier fixes held: `built_value` serialization, no
  scripted edits of generated files, clean-checkout regeneration, hand-written
  package tests, and a Freezed `ReadingRecord`.
- **Baseline.** Without the skill, the OpenAPI run again failed package
  analysis on the generator's unused import, left generator stub tests, and
  kept a plain `ReadingRecord`. The refactor again notified listeners after
  disposal. As in every iteration, all three baseline runs kept remote state
  in widgets or a `ChangeNotifier`, switched strings with locale checks, and
  used no typed routes.

## Harness incident

The first launch stopped at the isolation preflight before any task ran. The
solver's preflight listed `plugin-creator` as an available skill; the judge's
reported none. The cause is a race in the harness:

1. The runner built the list of standard skills to disable just before the
   solver's preflight started.
2. That Codex process then re-extracted the system skills under
   `~/.codex/skills/.system/`, adding `plugin-creator`.
3. The solver's disable list therefore had 10 entries without
   `plugin-creator`, and the model saw it as enabled.
4. The judge's list was built after extraction, had 12 entries, and passed.

The isolation check caught the problem as designed. The failed records are
kept in `eval-results/iteration-8/preflight-attempt-1/`. A second launch
failed immediately because the runner was started from the wrong working
directory; no model was called. The third launch passed both preflights with
`NO_SKILLS` and completed all six runs without retries.

## Follow-up

- Remove the preflight race: have Codex finish extracting system skills
  before the runner builds its disable list.
- Repeat this skill version several times to see whether the full pass is
  stable, since each iteration so far ran each case and condition once.

## Reproducibility and limits

Fixtures, prompts, rubric, withheld tests, and harness are unchanged from
iteration 4 and documented in [EVALUATION.md](../EVALUATION.md). Local raw
transcripts, outputs, checks, usage records, and grades are stored under the
gitignored `eval-results/iteration-8/` directory. The skill snapshot there
matches the skill files at commit `ae44f28`.

Each case and condition ran once, so a single full pass does not show that
the result is stable. The same model family served as solver and judge, and
no human review has been recorded.
