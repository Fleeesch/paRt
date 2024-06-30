#!/bin/bash

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


#   Process
# --------------------------------------------

echo -en "${COLOR_RESET}Creating sorted WALTER parameter list..."

# define files
file_in="walter_parameter_list_dev.txt"
file_out="out/walter_parameter_list.txt"
output_txt=""

# header line
echo 'adjuster_script "part_theme-adjuster.lua"' >"$file_out"

version_line=$(grep -E 'part_version [0-9]+\.[0-9]+' "$file_in")
version=$(echo "$version_line" | awk '{print $2}')
echo "define_parameter part_version 'paRt Theme v$version' 0 0 0" >>"$file_out"

# go through lines, skipping empty lines and full comment lines
grep -v '^\s*;' "$file_in" | grep -v '^\s*$' | sort |
    while IFS= read -r line; do

        # trim leading whitepsace
        line="${line#"${line%%[![:space:]]*}"}"

        # remove redundant spaces
        line=$(echo "$line" | tr -s ' ')

        # Editor Exception
        if [[ $line == *"part_version"* ]]; then
            continue
        else
            # output line
            line_new="define_parameter par_$(echo "$line" | sed 's/;.*//')"
            echo "$line_new" >>"$file_out"
        fi

    done >>"$file_out"

# closing tag
echo "define_parameter paRt_end 'paRt end' 0 0 1" >>"$file_out"

echo -e "${COLOR_GREEN}done${COLOR_RESET}"
