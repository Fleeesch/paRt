#!/bin/bash

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Globals
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -ga zoom_levels=("100" "125" "150" "175" "200" "225" "250" "300")

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Function : Copy Omnni Theme
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function CopyOmniTheme {
    
    name=$1
    folder=$2
    
    if [ ! -f "../reaper/ColorThemes/$name.ReaperTheme" ]; then
        rsync -quiet --include="$name.ReaperThemeZip" -az "./zip/$folder/" "../reaper/ColorThemes/"
    fi

}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Process
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

org_dir=$(pwd)

cd ..
cd ..

find -type f -maxdepth 1 -name 'paRt*.ReaperThemeZip' -delete 2>/dev/null

cd $org_dir

echo -n "Copying Omni Themes..."

CopyOmniTheme "paRt - Dark" "dark"
CopyOmniTheme "paRt - Dark - Windows" "dark_win"
CopyOmniTheme "paRt - Light" "light"

echo done

for i in "${zoom_levels[@]}"; do
    
    echo -n "Copying Size $i..."
    rsync -quiet --exclude="paRt - Dark.ReaperThemeZip" --include="*$i" -az "./zip/dark/" "../reaper/ColorThemes/"
    rsync -quiet --exclude="paRt - Dark - Windows.ReaperThemeZip" --include="*$i" -az "./zip/dark_win/" "../reaper/ColorThemes/"
    rsync -quiet --exclude="paRt - Light.ReaperThemeZip" --include="*$i" -az "./zip/light/" "../reaper/ColorThemes/"
    echo done

done

echo done
