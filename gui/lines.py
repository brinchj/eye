#!/usr/bin/env python

import sys, re

html = file(sys.argv[1]).read()

match = re.match('(.*)<pre>(.*)</pre>(.*)', html, re.DOTALL)
header, pre, footer = match.groups()


lines = '\n'.join( '%2i %s' % (i,l) for i,l in enumerate(pre.strip().split('\n')) )

print header
print '<pre>'
print lines
print '</pre>'
print footer
