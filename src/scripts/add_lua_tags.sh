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


#   Preparation
# --------------------------------------------

release_folder="release"

# version
version=$(<../$release_folder/version)

# reapack tags
header_text="-- @version $version
-- @author Fleeesch
-- @description paRt Theme Adjuster
-- @noIndex"

header_file=$(mktemp)
echo "$header_text" > "$header_file"

#   Batch Processing
# --------------------------------------------


# lua_folderectory containing the Lua files
lua_folder="./"

echo -e "${COLOR_CYAN}=================================${COLOR_RESET}"
echo -e "${COLOR_CYAN}ReaPack Lua-Tag implementation${COLOR_RESET}"
echo -e "${COLOR_CYAN}=================================${COLOR_RESET}"

echo ""
echo -e "${COLOR_YELLOW}Updating tags for version ${COLOR_RESET}$version..."
echo ""

cd "./themeadj"

# Iterate over all Lua files
find "$lua_folder" -type f -name "*.lua" | while read -r file; do
    echo -en "  Adding tags to $file..."
    
    # remove existing tags
    sed -i '/-- *@/d' "$file"

    # add custom tag
    (cat "$header_file"; cat "$file") > "$file.tmp" && mv "$file.tmp" "$file"

    echo -e "${COLOR_GREEN}done${COLOR_RESET}"
done

rm "$header_file"