#!/bin/bash
SPRITEMAKER_FILE="spritemaker.py"
if [ -f "../$SPRITEMAKER_FILE" ]; then
    python ../$SPRITEMAKER_FILE --folder "$(pwd)"
fi