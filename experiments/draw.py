import Image, sys, time
import experiment


def take(n,l):
    for i,e in enumerate(l):
        if i == n: return
        yield e
def takeWhile(f,l):
    for e in l:
        if not f(e): return
        yield e

def drawPoint(img, X, Y, cx, cy):
    R  = 25
    R2 = R**2
    for x in xrange(max(0,cx-R), min(X,cx+R)):
        for y in xrange(max(0,cy-R), min(Y,cy+R)):
            xd = (x-cx)**2
            yd = (y-cy)**2
            if not xd+yd <= R2:
                continue
            r,g,b = img[y*X+x]
            q = 0.05*(1-((xd + yd)/float(R2)))
            r = ((1-q)*r+q*255)
            g = (1-q)*g
            b = (1-q)*b
            img[y*X+x] = (int(r),int(g),int(b))

def test(code, exp, start=0, length=0):
    def lt(N):
        def f(e):
            t = float(e['Timestamp'])/1000
            t = exp.get_time_absolute(t)
            return t < N
        return f
    list(takeWhile(lt(start), exp))

    X,Y = code.size
    print time.time(), 'copy'
    im = code.getdata()
    il = zip(im.getband(0), im.getband(1), im.getband(2))
    print time.time(), 'draw'
    #m = [ [ pxs[x,y] for y in xrange(Y) ] for x in xrange(X) ]
    for line in takeWhile(lt(start+length),exp):
        if not line['GazePointX']: continue
        t = float(line['Timestamp'])/1000
        x = int(line['GazePointX']) - 9
        y = int(line['GazePointY']) - 9
        if 0 <= x < X and 0 <= y < Y:
            #print exp.get_time_absolute(t),x,y
            drawPoint(il, X, Y, x, y)
    print time.time(), 'put'
    im.putdata(il)
    print time.time(), 'done'


if __name__ == '__main__':
    code = Image.open(sys.argv[1])
    exp  = experiment.Experiment(sys.argv[2])
    test(code, exp, start=1287472298, length=10)
    #code.show()
