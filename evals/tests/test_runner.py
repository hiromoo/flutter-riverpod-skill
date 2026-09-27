import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest

SPEC = importlib.util.spec_from_file_location('runner', Path(__file__).resolve().parents[2]/'scripts/run_evals.py')
runner = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(runner)


class RunnerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.addCleanup(self.temp.cleanup)
        self.config = runner.read(runner.ROOT/'evals/evals.json')

    def test_configuration_and_paired_inputs(self):
        runner.validate(self.config)
        for case in self.config['evals']:
            a,b=self.root/(case['id']+'a'),self.root/(case['id']+'b')
            runner.prepare(case,a)
            runner.prepare(case,b)
            self.assertEqual(runner.hashes(a),runner.hashes(b))
        self.assertFalse(any(name.startswith('tests/') for name in runner.definition_hashes()))

    def test_explicit_models_and_isolation(self):
        for role,expected in [('solver','gpt-6-luna'),('judge','gpt-6-astra')]:
            cmd=runner.codex_args(self.config[role],self.root,self.root/'last',schema=self.root/'schema' if role=='judge' else None)
            self.assertEqual(cmd[cmd.index('-m')+1],expected)
            self.assertIn('--ignore-user-config',cmd)
            self.assertIn('skip_host_skill_discovery',cmd)
            self.assertIn('project_doc_max_bytes=0',cmd)
            self.assertTrue(any(x.startswith('skills.config=') for x in cmd))
            self.assertNotIn('--dangerously-bypass-approvals-and-sandbox',cmd)

    def test_timeout_and_nonzero_exit(self):
        result=runner.command([sys.executable,'-c','import time; time.sleep(10)'],self.root,self.root/'timeout.log',timeout=.05)
        self.assertEqual(result['status'],'timeout')
        result=runner.command([sys.executable,'-c','raise SystemExit(7)'],self.root,self.root/'fail.log')
        self.assertEqual(result['status'],'failed')
        self.assertEqual(result['exit_code'],7)

    def test_usage_missing_and_subsets(self):
        log=self.root/'events'
        log.write_text('warning\n{}\n')
        self.assertIsNone(runner.usage(log))
        log.write_text(json.dumps({'type':'turn.completed','usage':{'input_tokens':100,'output_tokens':20,'cached_input_tokens':50,'reasoning_output_tokens':10}}))
        self.assertEqual(runner.usage(log)['total_tokens'],120)

    def test_only_usage_limit_failures_are_resumable(self):
        run = self.root/'run'
        runner.save(run/'solve.json', {'status':'failed'})
        (run/'transcript.jsonl').write_text('{"type":"error","message":"You’ve hit your usage limit."}\n')
        self.assertTrue(runner.usage_limited(run, 'solver'))
        (run/'transcript.jsonl').write_text('{"type":"error","message":"compile failed"}\n')
        self.assertFalse(runner.usage_limited(run, 'solver'))

    def test_resumed_solver_archives_downstream_results(self):
        run = self.root/'run'
        runner.save(run/'verification.json', {'checks':[]})
        runner.save(run/'judge.json', {'status':'failed'})
        (run/'checks').mkdir()
        (run/'checks'/'analysis.log').write_text('old')
        runner.archive_downstream(run)
        self.assertFalse((run/'verification.json').exists())
        self.assertFalse((run/'judge.json').exists())
        self.assertTrue((run/'downstream-attempt-1/verification.json').exists())
        self.assertTrue((run/'downstream-attempt-1/checks/analysis.log').exists())

    def test_grade_requires_all_ids_once(self):
        case=self.config['evals'][0]
        grade={'assertions':[{'id':a['id'],'status':'pass','evidence':'lib/file.dart:1'} for a in case['assertions']]}
        self.assertTrue(runner.valid_grade(grade,case))
        grade['assertions'][-1]=grade['assertions'][0]
        self.assertFalse(runner.valid_grade(grade,case))

    def test_ungraded_is_not_pass_and_mechanical_failure_stays(self):
        case=self.config['evals'][0]
        run=self.root/case['id']/'with_skill'
        runner.save(run/'solve.json',{'status':'completed'})
        runner.save(run/'judge.json',{'status':'completed'})
        runner.save(run/'grading.json',{'assertions':[{'id':a['id'],'status':'pass','evidence':'x'} for a in case['assertions']]})
        runner.save(run/'verification.json',{'checks':[{'id':'analysis','status':'failed'}]})
        results=runner.aggregate(self.config,self.root)
        current=next(r for r in results if r['case']==case['id'] and r['condition']=='with_skill')
        self.assertFalse(current['mechanical_all_passed'])
        absent=next(r for r in results if r['case']=='api')
        self.assertEqual(absent['scores']['functional']['passed'],0)
        self.assertEqual(absent['scores']['functional']['graded'],0)


if __name__=='__main__':
    unittest.main()
