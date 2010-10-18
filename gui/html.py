import re

def add_lines_to_html(html):
    match = re.match(r'(.*)<pre>(.*)</pre>(.*)', html, re.DOTALL)
    header, pre, footer = match.groups()
    lines = '\n'.join( '%3i  %s' % (i,l)
                       for i,l in enumerate(pre.strip().split('\n')) )
    return '%s<pre>%s</pre>%s' % (header, lines, footer)

def code_process_html(path):
    return add_lines_to_html(file(path).read())
