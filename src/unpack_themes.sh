#!/bin/bash

function UnpackTheme {

    folder=$1
    zip_name=$2
    unzip_name=$3

    echo -n Unpacking $zip_name...

    \rm -rf "./tmp"

    mkdir -p "./tmp/$zip_name"

    unzip -qq "$folder/$zip_name.ReaperThemeZip" -d "./tmp/$unzip_name"
    
    rsync -quiet -az "./tmp/$unzip_name/" "../reaper/ColorThemes/"
    
    \rm -rf "./tmp"
    
    echo done

}

\rm -rf "../reaper/ColorThemes/paRt_Dark"
\rm -rf "../reaper/ColorThemes/paRt_Dark_Win"
\rm -rf "../reaper/ColorThemes/paRt_Light"
\rm -rf "../reaper/ColorThemes/paRt - Dark.ReaperTheme"
\rm -rf "../reaper/ColorThemes/paRt - Dark - Windows.ReaperTheme"
\rm -rf "../reaper/ColorThemes/paRt - Light.ReaperTheme"

UnpackTheme "./zip/dark/" "paRt - Dark" "paRt_Dark"
UnpackTheme "./zip/dark_win/" "paRt - Dark - Windows" "paRt_Dark_Win"
UnpackTheme "./zip/light/" "paRt - Light" "paRt_Light"
