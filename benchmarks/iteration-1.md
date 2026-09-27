# Flutter Riverpod Skill — Initial Evaluation

Run on 2026-09-28 with Codex CLI 0.155.0-alpha.16.3. GPT-6 Luna (`medium`)
implemented three tasks once with and without the skill; GPT-6 Astra (`high`)
graded the fixed rubric. This is exploratory evidence, not a statistical claim.

## Results

| Case | Condition | Functional | Skill conventions | Mechanical checks |
|---|---|---:|---:|---:|
| Feature | Without skill | 1/1 | 0/5 | 7/7 |
| Feature | With skill | 1/1 | 1/5 | 8/8 |
| OpenAPI | Without skill | 2/4 | 1/2 | 11/12 |
| OpenAPI | With skill | 3/4 | 1/2 | 12/12 |
| Refactor | Without skill | 2/2 | 0/4 | 6/8 |
| Refactor | With skill | 2/2 | 1/4 | 8/8 |
| **Total** | **Without skill** | **5/7 (71.4%)** | **1/11 (9.1%)** | **1/3 cases fully passed** |
| **Total** | **With skill** | **6/7 (85.7%)** | **3/11 (27.3%)** | **3/3 cases fully passed** |

The skill improved the functional assertion rate by 14.3 percentage points and
the convention assertion rate by 18.2 points. The strongest evidence is the
mechanical result: all three skill-assisted outputs compiled and passed their
independent checks. Without the skill, the generated API package retained an
analyzer warning, and the refactor notified listeners after disposal.

The added guidance was expensive in this sample. Solver wall time rose from
440.7 to 948.9 seconds, and measured solver tokens rose from 989,296 to
3,494,589. Token counts include cached input as part of input tokens and should
not be read as direct billing amounts.

## Findings

- The feature case gained Riverpod-owned remote state while preserving behavior.
- The OpenAPI case gained standalone package analysis and serializer tests. Both
  conditions used generated code, preserved the domain boundary, and handled
  the nullable note contract. Neither run supplied enough retained evidence to
  prove complete regeneration reproducibility.
- The refactor case gained Riverpod state and passed the disposal safety check.
  Both conditions handled reversed search completion, but the baseline failed
  when a request completed after controller disposal.
- Both conditions frequently omitted the skill's broader conventions. The skill
  runs still leaked transport maps into UI/domain, did not adopt Freezed domain
  models, did not use `context.l`, and did not use typed `go_router` routes.
  The refactor also retained a `StatefulWidget` text controller rather than
  `flutter_hooks`.

These misses suggest that the skill's broad mandatory rules are not reliably
translated into a concrete completion checklist by Luna. The next iteration
should make its workflow require a short pre-implementation compliance map and
a final check against only the conventions relevant to the task. It should also
clarify when a small existing-app change warrants Freezed and typed routing, so
the instructions do not force needless structure while still remaining
testable.

## Reproducibility and limits

The fixed cases, rubric, fixtures, withheld tests, runner, and isolation details
are documented in [EVALUATION.md](../EVALUATION.md). Local raw transcripts,
outputs, checks, usage records, and evidence-backed grades are stored under the
gitignored `eval-results/iteration-1/` directory.

The initial run hit the account usage limit after the first pair. Failed quota
attempts and the first infrastructure setup attempt were retained locally. The
five affected runs were resumed after the limit reset; stale downstream checks
were archived and all current outputs were verified and graded again. Harness
tests now cover this resumption behavior.

The same model family served as solver and judge, and no human review has been
recorded. Results do not establish behavior on another model, repeated-run
stability, skill routing quality, or new-project setup quality.
