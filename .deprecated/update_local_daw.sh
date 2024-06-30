#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - -v
#   Moves files to my actual Reaper Instance
# - - - - - - - - - - - - - - - - - - - - - - - - - - -v

# Copy ReaderThemeZips to local DAW color theme folder
\cp -f "./src/zip/dark/paRt - Dark.ReaperThemeZip" "c:/root/int/software/audio/daw/reaper/run/ColorThemes/"
\cp -f "./src/zip/dark_win/paRt - Dark - Windows.ReaperThemeZip" "c:/root/int/software/audio/daw/reaper/run/ColorThemes/"
\cp -f "./src/zip/light/paRt - Light.ReaperThemeZip" "c:/root/int/software/audio/daw/reaper/run/ColorThemes/"

# Copy Scripts
mkdir -p "c:/root/int/software/audio/daw/reaper/run/Scripts/Fleeesch/paRt"
\cp -fr "./src/scripts/"* "c:/root/int/software/audio/daw/reaper/run/Scripts/Fleeesch/paRt/"

# Move splash image
\cp -f "./stock/splash/rnd/splash_dark.png" "c:/root/int/software/audio/daw/reaper/run/"
