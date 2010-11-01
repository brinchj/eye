import math
from PIL import Image, ImageChops


POINT_INTENSITY = 8


def new_point(D):
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


def draw_point(img, point, (x, y)):
    ''' Draw a point overlay onto an image at position (x,y) '''
    off = point.size[0] / 2
    box = (x - off, y - off, x + off, y + off)
    crop = img.crop(box)
    img.paste(ImageChops.multiply(crop, point), box)


def draw_points(code, exp, start, length, line_height=23):
    ''' Generate a test heatmap '''
    xs, ys = code.size
    point = new_point(16)
    # Extract interval (start; start+length)
    interval = (elem for elem in exp
                if start < elem.timestamp() < start + length
                and elem.pos() != None)
    # Plot eye positions in interval
    for eye in interval:
        x, y = eye.pos()
        if not 0 <= x < xs or not 0 <= y < ys:
            continue
        scroll_pos = exp.get_scrollbar_pos(eye.timestamp())
        offset_y = scroll_pos * line_height
        draw_point(code, point, (x, y + offset_y))
    return code
