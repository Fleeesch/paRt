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

#   Function : Extract Theme Data
# --------------------------------------------

extract_theme_data() {
    # Array of input files
    input_tags=("dark" "dimmed" "light")

    # Check if all files exist
    for tag in "${input_tags[@]}"; do
        input_file="part_${tag}_unpacked.ReaperTheme"
        if [[ ! -f "$input_file" ]]; then
            return 1
        fi
    done

    # Output file
    local color_file="theme_colors.txt"
    local font_file="theme_font.txt"

    # Clear the output file if it already exists
    >"$color_file"

    # Loop through each file
    for tag in "${input_tags[@]}"; do

        input_file="part_${tag}_unpacked.ReaperTheme"

        # Extract [color theme] block
        local color_theme
        color_theme=$(sed -n '/^\[color theme\]/,/^\[/p' "$input_file" | sed '1d;$d')

        # color file
        {
            echo "Colors $tag"
            echo "$color_theme"
            echo ""
            echo "EndColors"
            echo ""
        } >>"$color_file"

    done

    input_file="part_${input_tags[0]}_unpacked.ReaperTheme"

    local reaper_block
    reaper_block=$(sed -n '/^\[REAPER\]/,/^\[/p' "$input_file" | sed '1d;$d' | grep -v '^ui_img=')

    echo "$reaper_block">"$font_file"
}

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

# output folder must exist
mkdir -p out

#   Extract color data from existing Theme Files
# -------------------------------------------------

extract_theme_data

#   Create Reaper Theme Files
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
    output_file="out/part_${theme}_unpacked.ReaperTheme"
    output_content="[color theme]\n$colors\n\n"
    output_content+="[REAPER]\n"

    imagefolder_var="imagefolder_${theme}"
    output_content+="ui_img=${!imagefolder_var}\n"

    output_content+=$(cat "$file_font")

    # save WALTER file
    echo -e "$output_content" >"$output_file"

    echo -e "${COLOR_GREEN}done${COLOR_RESET}"

done
