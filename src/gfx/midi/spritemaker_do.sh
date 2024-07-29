#!/bin/bash

SPRITEMAKER_FILE="spritemaker.py"


if [ -f "../$SPRITEMAKER_FILE" ]; then
    python ../$SPRITEMAKER_FILE --folder "$(pwd)"
fi

source colormap_to_out.sh

python ../$SPRITEMAKER_FILE --copy-files