import sys
import Image

from draw import draw_points
from experiment import Experiment


def main():
    if len(sys.argv) != 4:
        print 'Usage: %s code.png eye.csv scroll.log' % sys.argv[0]
        sys.exit()
    code = Image.open(sys.argv[1]).convert('RGBA')
    exp = Experiment(sys.argv[2], sys.argv[3], (9, 9))
    draw_points(code, exp, 1287472092.9, 3600)
    code.save('out/output.png')

if __name__ == '__main__':
    main()
