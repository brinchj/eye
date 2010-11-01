import sys
import Image


def copy_row((dest_img, dest_y), (src_img, src_y), X):
    ''' Copy image row from src to dest  '''
    pt = dest_img.load()
    pf = src_img.load()
    for x in xrange(X):
        pt[x, dest_y] = pf[x, src_y]


def get_row(img, y, X):
    ''' Extract the yth row from image '''
    return [img.getpixel((x, y)) for x in xrange(X)]


def join(img_top, img_bot):
    ''' Join two images that overlap at bottom/top '''
    # Extract sizes
    top_xs, top_ys = img_top.size
    bot_xs, bot_ys = img_bot.size
    # Width must be equal
    assert top_xs == bot_xs
    # Create new combined canvas
    img = Image.new('RGB', (top_xs, top_ys + bot_ys))
    # Copy top image
    img.paste(img_top, (0, 0, top_xs, top_ys))
    # Find match with bottom image
    row = get_row(img_top, top_ys - 1, top_xs)
    for y in xrange(0, bot_ys):
        if row == get_row(img_bot, y, top_xs):
            break
    # Copy img1
    from_y = top_ys - y - 1
    to_y = from_y + bot_ys
    img.paste(img_bot, (0, from_y, bot_xs, to_y))
    return img.crop((0, 0, top_xs, to_y))

if __name__ == '__main__':
    if len(sys.argv) == 1:
        print 'Usage: %s img0.png img1.png img2.png ... imgN.png' % sys.argv[0]
        sys.exit()
    imgs = map(Image.open, sys.argv[1:])
    img = imgs[0]
    for i in imgs[1:]:
        img = join(img, i)
    img.save('all-merged.png', 'PNG')
