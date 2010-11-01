import sys
import Image


def copyline((imgTo,yTo), (imgFrom,yFrom), X):
    pt = imgTo.load()
    pf = imgFrom.load()
    for x in xrange(X):
        pt[x,yTo] = pf[x,yFrom]

def getline(img, y, X):
    return [ img.getpixel((x,y)) for x in xrange(X) ]

def join(img0, img1):
    # Same width
    assert img0.size[0] == img1.size[0]
    # Copy img0
    X,Y = img0.size
    img = Image.new('RGB', (X, Y+img1.size[1]))
    img.paste(img0, (0,0,X,Y))
    # Find match with img1
    line = getline(img, Y-1, X)
    for ty in xrange(0,Y):
        if line == getline(img1, ty, X):
            break
    # Copy img1
    newY = Y-ty-1
    maxY = newY+img1.size[1]
    img.paste(img1, (0,newY,X,maxY))
    return img.crop((0,0,X,maxY))

if __name__ == '__main__':
    imgs = map(Image.open, sys.argv[1:])
    img = imgs[0]
    for i in imgs[1:]:
        img = join(img, i)
    img.save('all-merged.png', 'PNG')
