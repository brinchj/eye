import math

from PIL import Image, ImageChops
from decorators import memoized, accepts, returns
from experiment import Experiment

DEFAULT_COLOR = 1
DEFAULT_DIAMETER = 16
POINT_INTENSITY = 32


@memoized
@accepts(int)
@returns(Image.Image)
def new_point(D, intensity=POINT_INTENSITY, color=DEFAULT_COLOR):
    ''' Generate a point overlay '''
    assert D > 1
    R = D / 2
    img = Image.new('RGBA', (D, D), color='white')
    # Draw in a DxD circle
    for x in xrange(0, D):
        for y in xrange(0, D):
            dist = math.sqrt((x - R) ** 2 + (y - R) ** 2)
            if dist > R:
                # not inside cirle
                continue
            q = 0
            g = int(q * intensity * color + (255 - intensity * color))
            b = int(q * intensity + (255 - intensity))
            img.putpixel((x, y), (255, g, b))
    return img


@accepts(Image.Image, Image.Image, tuple)
@returns(Image.Image)
def draw_point(img, point, (x, y)):
    ''' Draw a point overlay onto an image at position (x,y) '''
    off = point.size[0] / 2
    box = (x - off, y - off, x + off, y + off)
    crop = img.crop(box)
    img.paste(ImageChops.multiply(crop, point), box)
    return img


@accepts(tuple, tuple)
@returns(float)
def distance((x0, y0), (x1, y1)):
    ''' Compute the distance between two points '''
    return math.sqrt((x0 - x1) ** 2 + (y0 - y1) ** 2)


@accepts(Image.Image, Experiment, int, int)
@returns(Image.Image)
def draw_points(code, exp, start, length,
                line_height=23, group_size=0, start_diameter=DEFAULT_DIAMETER):
    ''' Generate a heatmap, grouped by group_size pixels '''
    xs, ys = code.size
    # Start in upper left corner
    base_x = base_y = -group_size
    base_t = start
    for eye in exp.interval(start, length):
        x, y = eye.pos()
        if not 0 <= x < xs or not 0 <= y < ys:
            continue
        scroll_pos = exp.get_scrollbar_pos(eye.timestamp())
        y += scroll_pos * line_height
        # Still inside group?
        if distance((x, y), (base_x, base_y)) > group_size:
            time_span = eye.timestamp() - base_t
            draw_point(code, new_point(group_size, color=time_span / 5),
                       (base_x, base_y))
            (base_x, base_y) = (x, y)
            base_t = eye.timestamp()
    return code
