import math
import sys
#import time
#import json
from PIL import Image, ImageChops

from experiment import Experiment


def take(count, lst):
    ''' Take the first count elements of iterable lst '''
    for i, elem in enumerate(lst):
        if i == count:
            return
        yield elem


def takeWhile(fun, lst):
    ''' Take until fun(elem) == False '''
    for elem in lst:
        if not fun(elem):
            return
        yield elem

POINT_INTENSITY = 8


def newPoint(D):
    ''' Generate a point overlay '''
    R = D / 2
    img = Image.new('RGBA', (D, D), color='white')
    # Draw in a DxD circle
    for x in xrange(0, D):
        for y in xrange(0, D):
            dist = math.sqrt((x - R) ** 2 + (y - R) ** 2)
            if dist > R:
                # not inside cirle
                continue
            q = dist / float(R)
            g = b = int(q * POINT_INTENSITY) + (255 - POINT_INTENSITY)
            img.putpixel((x, y), (255, g, b))
    return img


def drawPoint(img, point, (x, y)):
    ''' Draw a point overlay onto an image at position (x,y) '''
    off = point.size[0] / 2
    box = (x - off, y - off, x + off, y + off)
    crop = img.crop(box)
    img.paste(ImageChops.multiply(crop, point), box)


LINE_HEIGHT = 23  # pixels


def test(code, exp, start, length):
    ''' Generate a test heatmap '''

    list(takeWhile(lambda e: e.timestamp() < start, exp))

    point = newPoint(16)
    pointCount = 0

    X, Y = code.size
    for eye in takeWhile(lambda elem: elem.timestamp() < (start + length),
                         exp):
        if eye.pos_x() == None:
            continue
        t = eye.timestamp()
        x = eye.pos_x() - 9
        y = eye.pos_y() - 9
        scroll_pos = exp.get_scrollbar_pos(t)
        if 0 <= x < X and 0 <= y < Y:
            pointCount += 1
            drawPoint(code, point, (x, scroll_pos * LINE_HEIGHT + y))
    print 'points:', pointCount


def main():
    if len(sys.argv) != 4:
        print 'Usage: %s code.png eye.csv scroll.log' % sys.argv[0]
        sys.exit()
    code = Image.open(sys.argv[1]).convert('RGBA')
    exp = Experiment(sys.argv[2], sys.argv[3])
    test(code, exp, 1287472092.9, 3600)
    code.save('out/output.png')

if __name__ == '__main__':
    main()
