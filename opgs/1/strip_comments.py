#!/usr/bin/env python
import sys, re


path = sys.argv[1]
code = file(sys.argv[1]).read()


if path[-3:] == '.py':
    def is_comment(line):
        return line.strip()[0] in ('#', '"', "'")
elif path[-4:] == '.sml':
    def is_comment(line):
        return line.strip()[:2] == '(*' or \
               False #line.strip() == ';'


code = '\n'.join( l for l in code.split('\n')
                  if len(l.strip()) == 0 or
                  not is_comment(l) )
code = code.replace('\n\n\n', '\n\n')

print code.strip()
