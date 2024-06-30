#!/bin/bash

# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#   paRt Reaper Theme File creation utility
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#   Colors
# --------------------------------------------

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_BLUE='\033[0;34m'
COLOR_MAGENTA='\033[0;35m'
COLOR_CYAN='\033[0;36m'
COLOR_WHITE='\033[0;37m'
COLOR_ORANGE='\033[0;33m'
COLOR_RESET='\033[0m'

#   Ressources
# --------------------------------------------

# themes
themes=("dark" "dimmed" "light")

# source files
file_colors="theme_colors.txt"
file_font="theme_font.txt"
file_img="theme_img_paths.txt"

#   Function : Capitalize
# --------------------------------------------

capitalize() {
    echo "$1" | awk '{print toupper(substr($0, 1, 1)) tolower(substr($0, 2))}'
}

#   Function : Filter Color Blocks
# --------------------------------------------

filter_colors() {
    local file="$1"
    local tag="$2"
    
    awk -v tag="$tag" '
        BEGIN {
            result = ""
            in_block = 0
        }
        $1 == "Colors" && $2 == tag { in_block = 1; next }
        $1 == "EndColors" { in_block = 0; next }
        in_block == 1 && /^/ { result = result $0 "\n" }
        END {
            printf "%s", result
        }
    ' "$file"
}

# output folder must erxist
mkdir -p out

#   Create WALTER files for themes
# --------------------------------------------

echo -e "${COLOR_RESET}Generating Reaper Theme files...${COLOR_RESET}"

source "theme_img_paths.txt"

for theme in "${themes[@]}"; do

    # info message
    echo -en "\t${COLOR_RESET}Generating Theme File for $theme theme..."

    # get color block
    colors=$(filter_colors "$file_colors" "$theme")
    
    # create theme output folder
    mkdir -p "out"

    # output file
    output_file="out/paRt_$theme.ReaperTheme"
    output_content="[color theme]\n$colors\n\n"
    output_content+="[REAPER]\n"

    imagefolder_var="imagefolder_${theme}"
    output_content+="ui_img=${!imagefolder_var}\n"

    output_content+=$(cat "$file_font")

    # save WALTER file
    echo -e "$output_content" >"$output_file"

    echo -e "${COLOR_GREEN}done${COLOR_RESET}"

done
