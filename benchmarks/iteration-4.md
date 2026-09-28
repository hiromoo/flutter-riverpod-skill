# Flutter Riverpod Skill — Iteration 4

Run on 2026-09-28 with Codex CLI 0.157.1. GPT-6 Luna (`medium`) implemented
the three tasks once with and without the skill, and GPT-6 Astra (`high`)
graded them against the unchanged rubric. The skill under test is commit
`cc7567f`, which adds two changes on top of [iteration 3](iteration-3.md):

- One guarded path for every async entry point, preferring provider families
  keyed by request parameters.
- Retry that resends exactly the parameters of the failed request.

This iteration also changes the harness (commit `6c81cd2`). The API task now
requires a `tool/generate_api.sh` entry point. The verifier runs it on a
clean copy and diffs the regenerated package. The change applies to both
conditions. It adds two mechanical checks to the API case (12 → 14), so the
regeneration assertion is not comparable with iterations 1–3. This is
exploratory evidence, not a statistical claim.

## Results

| Case | Condition | Functional | Skill conventions | Mechanical checks |
|---|---|---:|---:|---:|
| Feature | Without skill | 1/1 | 0/5 | 7/7 |
| Feature | With skill | 1/1 | 5/5 | 8/8 |
| OpenAPI | Without skill | 3/4 | 1/2 | 13/14 |
| OpenAPI | With skill | 3/4 | 2/2 | 14/14 |
| Refactor | Without skill | 2/2 | 0/4 | 6/8 |
| Refactor | With skill | 2/2 | 4/4 | 9/9 |
| **Total** | **Without skill** | **6/7 (85.7%)** | **1/11 (9.1%)** | **1/3 cases fully passed** |
| **Total** | **With skill** | **6/7 (85.7%)** | **11/11 (100%)** | **3/3 cases fully passed** |

Skill-assisted results across iterations:

| Metric | Iteration 1 | Iteration 2 | Iteration 3 | Iteration 4 |
|---|---:|---:|---:|---:|
| Functional assertions | 6/7 | 6/7 | 4/7 | 6/7 |
| Convention assertions | 3/11 | 9/11 | 11/11 | 11/11 |
| Cases passing all mechanical checks | 3/3 | 2/3 | 3/3 | 3/3 |
| Solver wall time (3 runs) | 948.9 s | 823.4 s | 782.3 s | 1,067.9 s |
| Solver tokens (3 runs) | 3,494,589 | 2,955,605 | 2,938,454 | 3,764,163 |

This is the first iteration in which the skill-assisted runs pass every
convention and every mechanical check while matching the best functional
result so far. Both iteration-3 functional defects were fixed. The one
remaining skill-assisted miss is package-level test quality in the OpenAPI
case.

The functional scores of the two conditions are tied at 6/7. The skill's
advantage lies in conventions (11/11 against 1/11) and in mechanical checks
(3/3 against 1/3 cases).

Solver cost rose again: 1,067.9 s and 3,764,163 tokens with the skill,
against 487.4 s and 1,011,164 tokens without it. That is about 2.2 times
the time and 3.7 times the tokens. Token counts include cached input and
should not be read as billing amounts.

## Findings

- **Feature: retry fixed.** Search results and details are autoDispose
  `FutureProvider` families keyed by query and book id. Retry invalidates the
  failed family key, so it always resends the failed query. The solver added
  a test that retries the failed search term. All six assertions passed.
- **Refactor: race fixed.** Search state is a
  `FutureProvider.autoDispose.family` keyed by query, and the screen switches
  its subscription when the query changes. Old requests therefore cannot
  overwrite newer results. The solver's tests cover both a stale initial
  response and a stale failure. All six assertions and all nine mechanical
  checks passed.

  Both cases adopted the provider-family pattern that the updated skill
  recommends. Neither needed a hand-written request-id guard.
- **OpenAPI: regeneration now verified.** Both conditions provided
  `tool/generate_api.sh`. The verifier's clean-copy regeneration produced no
  differences, and the judge cited `checks/api_regeneration_diff.log` to pass
  the regeneration assertion in both conditions. This assertion had been
  unverified in every earlier iteration.
- **OpenAPI: package tests left as stubs (skill-assisted).** Serializer and
  contract tests were written only at the app root
  (`test/reading_client_test.dart`). Inside `packages/reading_api/test/`, only
  the generator's TODO stubs remained, so package validation failed. The
  iteration-3 skill run had written real package-level serializer tests. The
  new regeneration entry point may have led the solver to treat the package's
  `test/` directory as generator-owned.
- **Baseline.** The baseline OpenAPI run also left TODO stub tests, and its
  standalone analysis failed on an unused import. It again kept a plain
  `ReadingRecord` class. The baseline refactor again notified listeners after
  disposal.

## Follow-up

Candidate change for iteration 5: the OpenAPI checklist row and
`references/api-client.md` should require three things.

1. List the generator's test stubs in `.openapi-generator-ignore`, so they
   are not produced.
2. Put hand-written serializer and contract tests in the generated package's
   `test/` directory. Cover omitted, `null`, and string notes on responses,
   and explicit `null` and string notes on updates.
3. Confirm that regeneration keeps those tests. The verifier's diff check
   already detects hand-written files that regeneration deletes.

## Reproducibility and limits

Fixtures and the harness changed as described above. Prompts, rubric, and
withheld tests are unchanged and documented in
[EVALUATION.md](../EVALUATION.md). Local raw transcripts, outputs, checks,
usage records, and grades are stored under the gitignored
`eval-results/iteration-4/` directory. The skill snapshot there matches the
skill files at commit `cc7567f`. All six solver runs, verifications, and
gradings completed on the first launch without retries.

Each case and condition ran once. The baseline functional score rose from 5/7
to 6/7 because its regeneration assertion now passes under the new check, not
because its implementation improved. The same model family served as solver
and judge, and no human review has been recorded.
