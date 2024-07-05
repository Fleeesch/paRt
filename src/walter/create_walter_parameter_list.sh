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

#   Filtered parameters file
# --------------------------------------------

parameter_file_in="parameters.partmap"
parameter_file_defaults="parameters_def"

# filter parameters file
awk '!/banksync/ && /bank_0/ || !/banksync/ && !/bank_/' "$parameter_file_in" >"$parameter_file_defaults"
sed -i '/return {/d; /} /d' "$parameter_file_defaults"
sed -i 's/,$//' "$parameter_file_defaults"
sed -i 's/par_/DEF_/g' "$parameter_file_defaults"
sed -i 's/_bank_0//' "$parameter_file_defaults"
sed -i '/}/d' "$parameter_file_defaults"

#   Function: Replace Placeholder manually
# ------------------------------------------------------

replace_placeholder_manually() {
    local template="$1"
    local placeholder="$2"
    local replacement="$3"

    # Use parameter substitution to replace placeholder
    result="${template//$placeholder/$replacement}"

    echo "$result"
}

#   Function: Replace Placeholder dynamically
# ------------------------------------------------------

replace_placeholder_variable_lookup() {
    local input_string="$1"
    local placeholder_prefix="DEF_"

    # Extract all placeholders starting with the prefix
    placeholders=$(echo "$input_string" | grep -o "${placeholder_prefix}[a-zA-Z0-9_]*")

    # Iterate over each placeholder and replace it with its variable value or "0"
    for placeholder in $placeholders; do
        replacement="${!placeholder:-0}" # Use ":=" for default value expansion
        input_string="${input_string//$placeholder/$replacement}"
    done

    echo "$input_string"
}

#   Default Values
# --------------------------------------------

VAL_PAR_RANGE="1000"
VAL_PAR_BITMASK="1000000"

# import parameter default values
source "./$parameter_file_defaults"

#   Process
# --------------------------------------------

echo -en "${COLOR_RESET}Creating sorted WALTER parameter list..."

# define files
file_in="walter_parameter_list_dev"
file_out="out/walter_parameter_list"
output_txt=""

# update version number
release_folder="release"
version=$(<../$release_folder/version)
sed -i "/part_version/c\part_version $version" "$file_in"

# header line
echo 'adjuster_script "paRt - Theme Adjuster.lua"' >"$file_out"

version_line=$(grep 'part_version' "$file_in")
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

            line_new=$(replace_placeholder_manually "$line_new" 'VAL_PAR_RANGE' "$VAL_PAR_RANGE")
            line_new=$(replace_placeholder_manually "$line_new" 'VAL_PAR_BITMASK' "$VAL_PAR_BITMASK")
            line_new=$(replace_placeholder_variable_lookup "$line_new")
            echo "$line_new" >>"$file_out"
        fi

    done >>"$file_out"

# closing tag
echo "define_parameter paRt_end 'paRt end' 0 0 1" >>"$file_out"

rm "$parameter_file_defaults"

echo -e "${COLOR_GREEN}done${COLOR_RESET}"
