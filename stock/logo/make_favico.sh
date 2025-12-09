#!/bin/sh

BASE="./rnd/part_logo_web"   # folder or prefix path, e.g. /path/to/icons/web
# expects files like: ${BASE}_16x16.png, ${BASE}_32x32.png, ...

sizes="16 32 64 128"

magick $(for s in $sizes; do printf "%s_%sx%s.png " "$BASE" "$s" "$s"; done) \
    "favico/part_favico.ico"
