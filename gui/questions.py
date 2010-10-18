# -*- encoding: utf-8 -*-

import json, re


HTML = unicode(\
'''<br/>
%s
<br/><br/>
Hints: Se linje %i.
''', 'utf-8')

def to_html(code, qs):
    code = code.split('\n')
    for q in qs:
        question = q['question']
        r = q['line']
        # find line number
        line = re.compile(r)
        match = filter(lambda l: line.match(l.strip()), code)[0]
        n = code.index(match)
        # generate html
        yield (HTML % (question, n), 'answer' in q and q['answer'] or '')


def load(code, path):
    return to_html(code, json.loads(file(path).read()))
