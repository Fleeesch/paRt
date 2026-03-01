#!/bin/bash

#   Constants
# --------------------------------------------

BYPASS_COPY_FILE="bypass_copy"

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

#   Function : Capitalize
# --------------------------------------------

capitalize() {
    echo "$1" | awk '{print toupper(substr($0, 1, 1)) tolower(substr($0, 2))}'
}

#   Functions : Print
# --------------------------------------------

# header line
print_header_line() {
    echo -e "${COLOR_CYAN}$1${COLOR_RESET}"
}

# info line
print_info_line() {
    echo -e "${COLOR_ORANGE}$1${COLOR_RESET}"
}

# prompt line
print_prompt_line() {
    echo -e "${COLOR_YELLOW}$1${COLOR_RESET} (y) "
}

# starting line
print_starting_line() {
    echo -en "${COLOR_RESET}$1..."
}

# done
print_done() {
    echo -e "${COLOR_GREEN}done${COLOR_RESET}"
}

#   Function : Get Theme Folder
# --------------------------------------------

get_theme_folder() {

    source "$script_themefile_folder/theme_img_paths.txt"

    theme_name=$1
    case $theme_name in
    ${themes[0]}) echo $imagefolder_dark ;;
    ${themes[1]}) echo $imagefolder_dimmed ;;
    ${themes[2]}) echo $imagefolder_light ;;
    esac
}

#   Preparation
# --------------------------------------------

org_path=$(pwd)

# theme list
themes=("dark" "dimmed" "light")
zoom_levels=(100 125 150 175 200 225 250)

release_folder="release"
version=$(<./$release_folder/version)

# reaper development folder
reaper_theme_folder="$(pwd)/../reaper/dev/ColorThemes"

# files and folders
script_version_set="version_set.sh"
script_changelog_set="changelog_set.sh"

script_walter_folder="$(pwd)/walter"
script_walter_create="create_walter.sh -p"

script_themefile_folder="$(pwd)/theme"
script_themefile_create="create_theme.sh"

script_lua_folder="$(pwd)/scripts/themeadj/"
themeadj_icon_path="$script_lua_folder/lib/res/icon"
script_lua_copy_themeadj="copy_theme_adj.sh"
script_lua_copy_themeadj_post="copy_theme_adj.sh -p"
script_lua_add_tags="add_lua_tags.sh"

#   Introduction
# --------------------------------------------

print_header_line "==============================="
print_header_line "  paRt Theme Creation Utility"
print_header_line "==============================="

# check for unattended mode
unattended=false
while getopts "u" opt; do
    case $opt in
    u)
        unattended=true
        ;;
    *) ;;
    esac
done

#   User Prompts
# --------------------------------------------

# ask for build folder clearing
rebuild_assets=false
clear_build_folder=true
copy_reaperthemefiles=false
copy_reaperthemezip=true
update_themeadj=false
update_themeadj_post=false

if [ "$unattended" = false ]; then

    echo ""

    # rebuild assets
    print_prompt_line "Rebuild all assets?"
    read -n 1 choice
    echo ""

    case "$choice" in
    y | Y) rebuild_assets=true ;;
    *) rebuild_assets=false ;;
    esac

    if [ "$rebuild_assets" == false ]; then
        # clear build folder
        print_prompt_line "Clear Build Folder?"
        read -n 1 choice
        echo ""

        case "$choice" in
        y | Y) clear_build_folder=true ;;
        *) clear_build_folder=false ;;
        esac
    else
        clear_build_folder=true
    fi

    # copy reaper theme files
    print_prompt_line "Copy ReaperTheme files?"
    read -n 1 choice
    echo ""

    case "$choice" in
    y | Y) copy_reaperthemefiles=true ;;
    *) copy_reaperthemefiles=false ;;
    esac

    # copy reaper theme zip files
    # print_prompt_line "Copy ReaperThemeZip files?"
    # read -n 1 choice
    # echo ""

    # case "$choice" in
    # y | Y) copy_reaperthemezip=true ;;
    # *) copy_reaperthemezip=false ;;
    # esac

    # skip copying reaperthemezip files (get's messy in development)
    copy_reaperthemezip=false

    # get theme adjuster from development folder
    print_prompt_line "Grab Theme Adjuster from development folder?"
    read -n 1 choice
    echo ""

    case "$choice" in
    y | Y) update_themeadj=true ;;
    *) update_themeadj=false ;;
    esac

    # update theme adjuster in development folder
    # print_prompt_line "Update Theme Adjuster in development folder?"
    # read -n 1 choice
    # echo ""

    # case "$choice" in
    # y | Y) update_themeadj_post=true ;;
    # *) update_themeadj_post=false ;;
    # esac

    # never offer to update development edition of theme adjuster (high potential for unnecessary data loss)
    update_themeadj_post=false

fi

#   Version / Changelog
# --------------------------------------------

# version and changleog
if [ "$unattended" = false ]; then

    cd "./$release_folder"

    echo ""
    source $script_version_set
    echo ""
    source $script_changelog_set

    print_header_line ""
    print_header_line "------------------------------------"
    print_header_line "    Initiating Theme Creation..."
    print_header_line "------------------------------------"
    print_header_line ""

    cd "$org_path"
fi

#   Rebuilding of Assets
# --------------------------------------------

if [ "$rebuild_assets" = true ]; then

    # create a file that informs the spritemaker that copying shall by bypassed
    touch "$BYPASS_COPY_FILE"

    print_info_line "Rebuilding all assets..."

    base_dir="./gfx"

    cd "$base_dir/toolbar/ats/ico"

    source make_icons.sh

    cd "$org_path"

    for dir in "$base_dir"/*/; do
        if [ -f "$dir/spritemaker_do.sh" ]; then
            (cd "$dir" && ./spritemaker_do.sh)
            echo ""
        fi
    done
    cd "$org_path"

    # remove copy blocking file
    rm -f "$BYPASS_COPY_FILE"

fi

#   Walter / Theme Files
# --------------------------------------------

# walter file
cd $script_walter_folder
source $script_walter_create
cd "$org_path"

echo ""

# theme file
cd $script_themefile_folder
source $script_themefile_create
cd "$org_path"




#   Pre-Cleaning
# --------------------------------------------

# clearing the build folder
if [ "$clear_build_folder" = true ]; then
    echo ""
    print_starting_line "Clearing build folder"
    rm -rf "build"
    rm -rf $themeadj_icon_path
    print_done
fi

#   Copy Assets
# --------------------------------------------

echo ""
print_info_line "Copying assets..."

# iterate gfx output folders
find ./gfx -type d -name "out" | while read -r out_dir; do

    print_starting_line "\tCollecting assets from $out_dir"

    # iterate themes
    for ((i = 0; i < ${#themes[@]}; i++)); do

        theme=${themes[$i]}

        # get folders
        folder=$(get_theme_folder $theme)
        source_dir="$out_dir/$theme"
        target_dir="./build/$folder"

        # skip theme adjuster icons
        if echo "$out_dir" | grep -q "/themeadj/"; then
            continue
        fi

        # create target folder
        mkdir -p "$target_dir"

        # copy files
        if [ -d "$source_dir" ]; then
            rsync -aq --ignore-existing "$source_dir"/ "$target_dir"
        fi

    done

    # theme adjuster icons
    rsync -aq "./gfx/themeadj/out_sheet/" "$themeadj_icon_path"

    print_done

done

#   Reascript Files
# --------------------------------------------

# from dev folder
if [ "$update_themeadj" = true ]; then
    cd $script_lua_folder
    cd ".."
    source $script_lua_copy_themeadj
    cd $org_path
fi

cd $script_lua_folder
cd ".."
source $script_lua_add_tags
cd $org_path

# to dev folder
if [ "$update_themeadj_post" = true ]; then
    cd $script_lua_folder
    cd ".."
    source $script_lua_copy_themeadj_post
    cd $org_path
fi

#   Copy Theme / WALTER files
# --------------------------------------------

echo ""
print_starting_line "Copying WALTER and ReaperTheme files"

# iterate themes
for ((i = 0; i < ${#themes[@]}; i++)); do
    theme=${themes[$i]}

    # walter file
    walter_source_file="$script_walter_folder/out/part_$theme/rtconfig.txt"

    folder=$(get_theme_folder $theme)
    target_dir="./build/$folder"

    rsync -aq --ignore-existing "$walter_source_file" "$target_dir"

    # theme file
    theme_source_file="$script_themefile_folder/out/part_"$theme"_unpacked.ReaperTheme"
    target_dir="./build"

    rsync -aq --ignore-existing "$theme_source_file" "$target_dir"

    if [ "$copy_reaperthemefiles" = true ]; then
        rm -rf "$reaper_theme_folder/$folder"
        rm -rf "$reaper_theme_folder/part_"$theme"_unpacked.ReaperTheme"
        rsync -aq "$theme_source_file" "$reaper_theme_folder/part_"$theme"_unpacked.ReaperTheme"
        rsync -aq "$target_dir/$folder" "$reaper_theme_folder/"
    fi

done

print_done

#   Creating Reaper Theme Zips
# --------------------------------------------

echo ""
print_starting_line "Creating ReaperThemeZip files"

cd "build"

# iterate themes
for ((i = 0; i < ${#themes[@]}; i++)); do
    theme=${themes[$i]}

    source_folder="./$(get_theme_folder $theme)"
    source_themefile="./part_"$theme"_unpacked.ReaperTheme"

    # create ReaperThemeZip
    zip_file="part_$theme.ReaperThemeZip"
    zip -9 -qrFS "$zip_file" "$source_folder" "$source_themefile"

    if [ "$copy_reaperthemezip" = true ]; then
        rm -rf "$reaper_theme_folder/$zip_file"
        rsync -aq "$zip_file" "$reaper_theme_folder/$zip_file"
    fi

done

cd ..

print_done

