#!/bin/bash

function FormatTemplate() {

    file=$1
    lineskip=$2
    
    tmp="tmp.txt"
    
    # skip first line
    if [ "$lineskip" ]; then
        head -n 1 "$file" >"$tmp"
    fi
    
    # sort alphabetically
    tail -n +2 "$file" | sort >>"$tmp"
    
    # remove empty lines
    sed -i '/^[[:space:]]*$/d' "$tmp"
    
    # overwrite original file with template file
    mv "$tmp" "$file"

}

echo -n "Formatting Theme Color Templates..."

# format the color templates
FormatTemplate "clr_dark.txt" 1
FormatTemplate "clr_light.txt" 1

# format font
FormatTemplate "font.txt" 0

# format images
FormatTemplate "img_dark.txt" 1
FormatTemplate "img_dark_win.txt" 1
FormatTemplate "img_light.txt" 1

# format keys
FormatTemplate "win_dark_keys.txt" 0

echo done
