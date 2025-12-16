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

#   Function : Remove Header Block
# --------------------------------------------

remove_header_block() {
    sed -e '/THEME_HEADER/,/THEME_HEADER_CLOSE/d' "$1"
}


#   Function : Remove Theme Block
# --------------------------------------------
remove_theme_blocks() {
    sed -e '/THEME_BLOCK/,/THEME_BLOCK_CLOSE/d' "$1"
}



#   Cleanup WALTER file
# --------------------------------------------

# Main script starts here
file_walter="rtconfig.txt"

# Remove Blocks
remove_header_block "$file_walter" > "temp_0.txt"
remove_theme_blocks temp_0.txt > "temp_1.txt"

# Clean up temporary files
cat "temp_1.txt" > "$file_walter"
rm temp_0.txt temp_1.txt

#   Title
# --------------------------------------------

# title
title="paRt WALTER file"

release_folder="release"

# date stamp
date_stamp=$(date +"%Y-%m-%d %H:%M:%S")

# zoom levels
zoom_levels=(100 125 150 175 200 225 250)

# version number from file
version=$(<../$release_folder/version)

# header title part a
header_content_start="\
; ::::::::::::::::::::::: THEME_HEADER :::::::::::::::::::::::::::::
;       $title
;
"

# header title part b
header_content_end="\
;       Version: $version
;       Date: $date_stamp
; ::::::::::::::::::::::: THEME_HEADER_CLOSE :::::::::::::::::::::::
"

# dynamic code block hints
hint_start=";~ ~ ~ ~ ~ ~ ~ ~ ~ ~ THEME_BLOCK ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ \n"
hint_end="\n;~ ~ ~ ~ ~ ~ ~ ~ ~ ~ THEME_BLOCK_CLOSE ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ "

#   Ressources
# --------------------------------------------

# themes
themes=("dark" "dimmed" "light")

# source files
file_readme="walter_readme.txt"
file_colors="walter_colors.txt"
file_colors_zeroline="walter_colors_zeroline.txt"
file_parameter_list="out/walter_parameter_list"

placeholder_readme="THEMEBUILDER_INSERT_README"
placeholder_colors="THEMEBUILDER_INSERT_COLORS"
placeholder_zeroline="THEMEBUILDER_INSERT_ZEROLINE"
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
    local replacement="$placeholder\n$3"

    echo "$content" | awk -v placeholder="$placeholder" -v replacement="$replacement" '
        { gsub(placeholder, replacement) }
        { print }
    '
}

# output folder must erxist
mkdir -p out

#   Create Parameter List
# --------------------------------------------

# requires the -p tag
for arg in "$@"; do
    if [ "$arg" == "-p" ]; then
        source ./create_walter_parameter_list.sh
        break
    fi
done


#   Create WALTER files for themes
# --------------------------------------------

echo ""
echo "Generating WALTER files..."

for theme in "${themes[@]}"; do

    # info message
    echo -en "\t${COLOR_RESET}Generating WALTER rtconfig.txt for $theme theme..."

    # get color block
    colors=$(filter_colors "$file_colors" "$theme")
    colors="$hint_start$(echo "$colors" | awk '{gsub(/[\/&]/,"\\\\&",$0); print}')$hint_end"

    # get zero line color block
    colors_zeroline=$(filter_colors "$file_colors_zeroline" "$theme")
    colors_zeroline="$hint_start$(echo "$colors_zeroline" | awk '{gsub(/[\/&]/,"\\\\&",$0); print}')$hint_end"    

    # create theme output folder
    mkdir -p "out/part_$theme"

    # output file
    output_file="out/part_$theme/rtconfig.txt"

    # theme parameters
    parameter_list=$(cat "$file_parameter_list")
    parameter_list="$hint_start\n$parameter_list\n$hint_end"

    # readme
    readme_content=$(cat "$file_readme")
    readme_content="$hint_start\n$readme_content\n$hint_end"

    # replace placeholders with dynamically read content
    output_content=$(cat "$file_walter")
    output_content=$(replace_placeholders "$output_content" "$placeholder_readme" "$readme_content")
    output_content=$(replace_placeholders "$output_content" "$placeholder_colors" "$colors")
    output_content=$(replace_placeholders "$output_content" "$placeholder_parameters" "$parameter_list")
    output_content=$(replace_placeholders "$output_content" "$placeholder_zeroline" "$colors_zeroline")

    # add header comment
    theme_tag=";       Theme: $theme\n"
    output_content="$header_content_start$theme_tag$header_content_end\n\n$output_content"

    # save WALTER file
    echo -e "$output_content" >"$output_file"

    echo -e "${COLOR_GREEN}done${COLOR_RESET}"

    # -------------------------------------------------------------------------
    #   optional split-layout creation (currently bypassed, possibly broken)
    # -------------------------------------------------------------------------
    
    # file containing different layout configurations
    #file_layouts="walter_rtconfig_split.txt"

    # # create split files
    # for level in "${zoom_levels[@]}"; do

    #     # strip layout section
    #     mkdir -p "out/$theme/$level"
    #     output_file_split="out/$theme/$level/rtconfig.txt"
    #     sed '/;LAYOUT_BLOCK/,/;LAYOUT_BLOCK_END/d' "$output_file" > "$output_file_split"

    #     # header
    #     echo ";   ## Layout - Split File - $level"  >> "$output_file_split"
    #     echo "; -----------------------------------------------------------------"  >> "$output_file_split"

    #     # append custom layout section
    #     start_pattern="; LAYOUT_BLOCK_${level}"
    #     end_pattern="; LAYOUT_BLOCK_${level}_END"
    #     section=$(sed -n "/${start_pattern}/,/${end_pattern}/p" "$file_layouts")
    #     echo "$section" >> "$output_file_split"

    #     sed -i -e "/${start_pattern}/d" -e "/${end_pattern}/d" "$output_file_split"

    # done

done

