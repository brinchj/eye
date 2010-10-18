import sys,keyword,re

words = keyword.kwlist

code = file(sys.argv[1]).read()

code = '\n'.join( l for l in code.split('\n')
                  if len(l.strip()) == 0 or
                  not l.strip()[0] in ('#','"',"'") )

sort = sorted(( (w, len(re.findall(r'[^\w]%s[^\w]' % w, code))) for w in words),
                key=lambda p: -p[1])

print '\n'.join('%s: %s' % (w.rjust(10), c) for w,c in sort)
