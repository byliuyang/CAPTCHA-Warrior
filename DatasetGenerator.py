import base64
import colorsys
import csv
import os
from hashlib import md5
from io import StringIO

from PIL import Image, ImageFont, ImageDraw
from flask import send_file

## Globals
DATA_SIZE = 1000
FONT = ImageFont.truetype(
    os.path.join(os.path.dirname(os.path.realpath(__file__)), 'fonts', 'ArchivoBlack-Regular.ttf'),
    size=24)


def calc_hash(string):
    m = md5()
    m.update(string.encode('utf-8'))
    return m.hexdigest()


ALPHANUM = 'abcdefghijklmnopqrstuvwxyz0123456789'
IMAGE_SIZE = 100


def image_solution(h):
    result = ''
    for i in range(4):
        result += ALPHANUM[int(h[4 * i:4 * i + 4], 16) % 36]
    return result


def real_image_solution(username, name):
    image_hash = calc_hash(username + name)
    return image_solution(image_hash)


def hsv_to_better_color(hsv):
    a, b, c = colorsys.hsv_to_rgb(*hsv)
    return (int(a * 256), int(b * 256), int(c * 256))


def random_color(string):
    x = int(string, 16)
    y = float(x) / 16 ** len(string)
    hsv1 = (y, 1.0, 0.7)
    return hsv_to_better_color(hsv1)


def render_letter(letter):
    size = FONT.getsize(letter)
    txt = Image.new('L', size)
    d = ImageDraw.Draw(txt)
    d.text((0, 0), letter, font=FONT, fill=255)
    return txt


LETTER_CACHE = {}


def rotate_letter(letter_img, angle):
    return letter_img.rotate(angle, expand=1)


for letter in ALPHANUM:
    letter_img = render_letter(letter)
    for angle in range(361):
        k = (letter, angle)
        LETTER_CACHE[k] = rotate_letter(letter_img, angle)


def draw_rotated(draw, angle, letter, color, coordinate):
    k = (letter, angle)
    t = LETTER_CACHE.get(k)
    if not t:
        t = render_letter(letter)
        t = rotate_letter(t, angle)
        LETTER_CACHE[k] = t
    draw.bitmap(coordinate, t, fill=color)


def generate_image_base(username):
    user_hash = calc_hash(username)
    img = Image.new('RGB', (IMAGE_SIZE, 50))
    draw = ImageDraw.Draw(img)
    for i in range(4):
        a = random_color(user_hash[5 + 2 * i:9 + 2 * i])
        draw.rectangle(((i * IMAGE_SIZE / 4, 0), ((i + 1) * IMAGE_SIZE / 4, 50)), fill=a)
    r = int(user_hash, 16)
    for i in range(4):
        color = (255, 255, 255)
        r /= 2
        start_loc = (r % (IMAGE_SIZE / 4), (r / 64) % 50)
        r /= 256
        end_loc = ((r % (IMAGE_SIZE / 4)) + 3 * IMAGE_SIZE / 4, (r / 64) % 50)
        r /= 256
        draw.line((start_loc, end_loc), fill=color, width=2)
    return img


def generate_image(base, username, name):
    img = base.copy()
    image_hash = calc_hash(username + name)
    solution = image_solution(image_hash)
    draw = ImageDraw.Draw(img)
    rip = int(image_hash, 16)
    for i, letter in enumerate(solution):
        offset_x = rip % ((IMAGE_SIZE / 4 - 10) if i != 3 else 5)
        rip /= 64
        offset_y = rip % 20
        rip /= 64
        rotation = (rip % 60) - 30
        rip /= 64
        draw_rotated(draw, rotation, letter, (250, 250, 250), (i * IMAGE_SIZE / 4 + offset_x, offset_y))
    return img


def random_image_from_base(base, username):
    name = os.urandom(16).hex()
    return generate_image(base, username, name), name


def random_image(username):
    base = generate_image_base(username)
    return random_image_from_base(base, username)


def serve_pil_image(pil_img):
    img_io = StringIO()
    pil_img.save(img_io, 'JPEG', quality=50)
    img_io.seek(0)
    return send_file(img_io, mimetype='image/jpeg')


def pil_to_base64(pil_img):
    img_io = StringIO()
    pil_img.save(img_io, format='JPEG', quality=50)

    img_io.getvalue()
    return base64.b64encode(img_io.getvalue())


def main():
    username = "TEst_Username_Hello WorLd"
    base = generate_image_base(username)
    names = {}

    for file in os.listdir('images'):
        os.remove(os.path.join('images', file))

    for i in range(DATA_SIZE):
        image, name = random_image_from_base(base, username)
        label = real_image_solution(username, name)

        names[name + '.jpg'] = label

        image.save(os.path.join('images', name + '.jpg'))

    with open('hash_to_label.csv', 'w') as f:
        writer = csv.writer(f)
        for i in names:
            writer.writerow([i, names[i]])


if __name__ == "__main__":
    main()
