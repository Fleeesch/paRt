#!/bin/bash

# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#   paRt WALTER file creation utility
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

#   Title
# --------------------------------------------

# title
title="paRt WALTER file"

# date stamp
date_stamp=$(date +"%Y-%m-%d %H:%M:%S")

# version number from file
version=$(<../rel/version)

# header title part a
header_content_start="\
; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;       $title
;
"

# header title part b
header_content_end="\
;       Version: $version
;       Date: $date_stamp
; :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
"

# dynamic code block hints
hint_start=";~ ~ ~ ~ ~ ~ ~ ~ ~ ~ programmatically created Block ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ \n"
hint_end="\n;~ ~ ~ ~ ~ ~ ~ ~ ~ ~ End of programmatically created Block ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ "

#   Ressources
# --------------------------------------------

# themes
themes=("dark" "dimmed" "light")

# source files
file_colors="walter_colors.txt"
file_walter="walter_rtconfig.txt"
file_parameter_list="out/walter_parameter_list.txt"

placeholder_colors="THEMEBUILDER_INSERT_COLORS"
placeholder_parameters="THEMEBUILDER_INSERT_PARAMETERS"

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

#   Function : Replace Placeholders
# --------------------------------------------

replace_placeholders() {
    local content="$1"
    local placeholder="$2"
    local replacement="$3"

    echo "$content" | awk -v placeholder="$placeholder" -v replacement="$replacement" '
        { gsub(placeholder, replacement) }
        { print }
    '
}

# output folder must erxist
mkdir -p out

#   Create Parameter List
# --------------------------------------------

source ./create_walter_parameter_list.sh

#   Create WALTER files for themes
# --------------------------------------------

echo ""
echo "Generating WALTER files..."

for theme in "${themes[@]}"; do

    # info message
    echo -en "\t${COLOR_RESET}Generating WALTER rtconfig.txt for $theme theme..."

    # get color block
    colors=$(filter_colors "$file_colors" "$theme")

    # create theme output folder
    mkdir -p "out/$theme"

    # output file
    output_file="out/$theme/rtconfig.txt"

    # theme parameters
    parameter_list=$(cat "$file_parameter_list")
    parameter_list="$hint_start\n$parameter_list\n$hint_end"

    # replace placeholders with dynamically read content
    output_content=$(cat "$file_walter")
    output_content=$(replace_placeholders "$output_content" "$placeholder_colors" "$(echo "$colors" | awk '{gsub(/[\/&]/,"\\\\&",$0); print}')")
    output_content=$(replace_placeholders "$output_content" "$placeholder_parameters" "$parameter_list")

    # add header comment
    theme_tag=";       Theme: $theme\n"
    output_content="$header_content_start$theme_tag$header_content_end\n\n$output_content"

    # save WALTER file
    echo -e "$output_content" >"$output_file"

    echo -e "${COLOR_GREEN}done${COLOR_RESET}"

done
