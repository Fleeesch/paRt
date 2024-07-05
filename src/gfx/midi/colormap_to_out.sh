#!/bin/bash

themes=("dark" "dimmed" "light")

echo -en "Copying Colormaps..."

for theme in "${themes[@]}"; do

    mkdir -p "out/${theme}"
    src="ats/colormap_${theme}.png"
    
    cp -f "$src" "out/${theme}/midi_note_colormap.png"
    cp -f "$src" "out/${theme}/midi_score_colormap.png"
done

echo "done"
