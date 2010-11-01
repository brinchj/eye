import math
import sys
import time
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
            g = b = int(q * 255)
            img.putpixel((x,y), (255,g,b))
    return img

def drawPoint(img, point, (x, y)):
    off = point.size[0]/2
    box = (x - off, y - off, x + off, y + off)
    crop = img.crop(box)
    img.paste(ImageChops.multiply(crop, point), box)

def test(code, exp, start=0, length=0):
    def lt(N):
        def f(e):
            t = float(e['Timestamp'])/1000
            t = exp.get_time_absolute(t)
            return t < N
        return f
    list(takeWhile(lt(start), exp))

    point = newPoint(24)

    X,Y = code.size
    print time.time(), 'draw'
    #m = [ [ pxs[x,y] for y in xrange(Y) ] for x in xrange(X) ]
    for i,line in enumerate(takeWhile(lt(start+length),exp)):
        if not line['GazePointX']: continue
        t = float(line['Timestamp'])/1000
        x = int(line['GazePointX']) - 9
        y = int(line['GazePointY']) - 9
        if 0 <= x < X and 0 <= y < Y:
            #print exp.get_time_absolute(t),x,y
            drawPoint(code, point, (x,y))
        print i
    print time.time(), 'done'


if __name__ == '__main__':
    code = Image.open(sys.argv[1]).convert('RGBA')
    exp  = experiment.Experiment(sys.argv[2])
    test(code, exp, start=1287472298, length=10)
    code.show()
