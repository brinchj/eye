import math
import sys
import time
import json
from PIL import Image, ImageOps, ImageChops

import experiment


def take(n,l):
    for i,e in enumerate(l):
        if i == n: return
        yield e
def takeWhile(f,l):
    for e in l:
        if not f(e): return
        yield e

POINT_INTENSITY = 8
def newPoint(D):
    R = D/2
    img = Image.new('RGBA', (D,D), color='white')
    for x in xrange(0, D):
        for y in xrange(0, D):
            dist = math.sqrt((x - R)**2 + (y - R)**2)
            if dist > R:
                # not inside cirle
                continue
            q = dist / float(R)
            g = b = int(q * POINT_INTENSITY) + (255 - POINT_INTENSITY)
            img.putpixel((x,y), (255,g,b))
    return img

def drawPoint(img, point, (x, y)):
    off = point.size[0]/2
    box = (x - off, y - off, x + off, y + off)
    crop = img.crop(box)
    img.paste(ImageChops.multiply(crop, point), box)

LINE_HEIGHT = 23 # pixels
def test(code, exp, start, length):
    def lt(N):
        def f(e):
            return e.timestamp() < N
        return f
    list(takeWhile(lt(start), exp))

    point = newPoint(16)
    pointCount = 0

    X,Y = code.size
    for i,eye in enumerate(takeWhile(lt(start+length),exp)):
        if eye.x() == None:
            continue
        t = eye.timestamp()
        x = eye.x() - 9
        y = eye.y() - 9
        scrollPos = exp.scroll_pos(t)
        if 0 <= x < X and 0 <= y < Y:
            pointCount += 1
            drawPoint(code, point, (x,scrollPos*LINE_HEIGHT + y))
    print 'points:', pointCount

if __name__ == '__main__':
    code = Image.open(sys.argv[1]).convert('RGBA')
    exp  = experiment.Experiment(sys.argv[2], sys.argv[3])
    test(code, exp, 1287472092.9, 3600)
    code.save('out/output.png')
