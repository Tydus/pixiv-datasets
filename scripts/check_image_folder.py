#!/usr/bin/python

from PIL import Image
import os
import sys
import numpy as np

if len(sys.argv) == 1:
    print "Remove grayscale, too long or corrupted images in a folder"
    print "%s [-do] dir"
    exit(-1)

if sys.argv[1] == "-do":
    do = True
    base_path = sys.argv[2]
else:
    do = False
    base_path = sys.argv[1]

backup_path = os.path.join(base_path, '.backup')
if not os.path.exists(backup_path):
    os.mkdir(backup_path)

for fn in os.listdir(base_path):
    if not fn.endswith('jpg'): continue

    path = os.path.join(base_path, fn)

    try:
        im = Image.open(path)
        if im.mode not in ['RGB', 'RGBA']:
            raise Exception("Not RGB")
        s = np.asarray(im.convert('HSV'), dtype='float32')[..., 1]/255.
        if np.mean(s) < 0.03:
            raise Exception("Sat %.3f" % np.mean(s))

    except Exception as e:
        print path, e
        if do: os.rename(path, os.path.join(backup_path, fn))
