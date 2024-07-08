#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Colors
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_BLUE='\033[0;34m'
COLOR_MAGENTA='\033[0;35m'
COLOR_CYAN='\033[0;36m'
COLOR_WHITE='\033[0;37m'
COLOR_ORANGE='\033[0;33m'
COLOR_RESET='\033[0m'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Print Functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# header text
function print_header_text() {
    echo -e "${COLOR_CYAN}$1${COLOR_RESET}"
}

# info
function print_info() {
    echo -e "${COLOR_YELLOW}$1${COLOR_RESET}"
}

# process start
function print_process_start() {
    echo -en "${COLOR_RESET}$1..."
}

# print done
function print_done() {
    echo -e "${COLOR_GREEN}done${COLOR_RESET}"
}

# prompt line
function print_prompt_line() {
    echo -e "${COLOR_YELLOW}$1${COLOR_RESET} (y) "
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Main Process
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#   Introduction
# -------------------------------

ORG_DIR=$(pwd)

# store original working directory
original_dir=$(pwd)

dir_src="src"

release_folder="release"

# check for unattended mode
github=false
unattended=false

while getopts ":gu" opt; do
    case $opt in
    g)
        github=true
        ;;
    u)
        unattended=true
        ;;
    esac
done

print_header_text "=============================="
print_header_text " paRt Release Building Tool"
print_header_text "=============================="
echo ""
echo -e "${COLOR_MAGENTA}-u     unattended run"${COLOR_RESET}
echo -e "${COLOR_MAGENTA}-g     create release for GitHub Actions VM"${COLOR_RESET}
echo ""

#   Recreate Theme
# -------------------------------

recreate_themes=false
if [ "$unattended" = false ]; then

    print_prompt_line "Recreate Themes?"
    read -n 1 choice
    echo ""

    case "$choice" in
    y | Y) recreate_themes=true ;;
    *) recreate_themes=false ;;
    esac

fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Release Creation
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#   Local Release
# -------------------------------

local_release=true

if [ "$unattended" = false ]; then

    print_prompt_line "Create local Release?"
    read -n 1 choice
    echo ""

    case "$choice" in
    y | Y) local_release=true ;;
    *) local_release=false ;;
    esac

fi

# theme recreation
if [ "$recreate_themes" = true ]; then
    cd "./src"
    source make_themes.sh
    cd "$ORG_DIR"
fi

if [ "$local_release" = true ]; then

    #   Binaries
    # ------------------------------

    print_process_start "Creating Theme Binaries"

    # clear release folder
    version=$(<./src/$release_folder/version)
    rm -rf "./$release_folder/current" >/dev/null 2>&1
    rm -rf "./$release_folder/$version" >/dev/null 2>&1

    # create release folders
    mkdir -p "./$release_folder/$version/bin"
    mkdir -p "./$release_folder/$version/changelog"
    mkdir -p "./$release_folder/$version/reapack"

    # add binaries
    rsync -aq --include="*.ReaperThemeZip" --exclude="*" "./src/build/" "./$release_folder/$version/bin/"

    # manual installation folder
    mkdir -p "./$release_folder/$version/bin/manual/ColorThemes"
    mkdir -p "./$release_folder/$version/bin/manual/Scripts/Fleeesch/Themes/paRt"

    rsync -aq --include="*.ReaperThemeZip" --exclude="*" "./$release_folder/$version/bin/" "./$release_folder/$version/bin/manual/ColorThemes"

    print_done

    #   Changelog
    # ------------------------------

    print_process_start "Creating Changelog"

    changelog_file_in="./src/$release_folder/changelog"

    # Reapack
    changelog_file_out="./$release_folder/$version/changelog/changelog_reapack.txt"

    echo "@changelog" >"$changelog_file_out"
    while IFS= read -r line; do
        echo "  $line" >>"$changelog_file_out"
    done <"$changelog_file_in"

    # Markdown
    changelog_file_out="./$release_folder/$version/changelog/changelog.md"

    echo "**$version - Changelog**" >"$changelog_file_out"
    while IFS= read -r line; do
        echo "- $line" >>"$changelog_file_out"
    done <"$changelog_file_in"

    # Boardcode
    changelog_file_out="./$release_folder/$version/changelog/changelog_bb.txt"

    echo "[code]" >"$changelog_file_out"
    echo "[b]Changelog - $version[/b]" >>"$changelog_file_out"
    while IFS= read -r line; do
        echo "- $line" >>"$changelog_file_out"
    done <"$changelog_file_in"
    echo "[/code]" >>"$changelog_file_out"

    print_done

    #   Reapack Package File
    # ------------------------------

    print_process_start "Creating ReaPack Data"

    changelog_file="./$release_folder/$version/changelog/changelog_reapack.txt"
    reapack_file_in="reapack/reapack_info"
    reapack_file_out="./$release_folder/$version/reapack/part.theme"

    echo "@version $version" >"$reapack_file_out"
    cat "$reapack_file_in" >>"$reapack_file_out"
    echo "" >>"$reapack_file_out"
    cat "$changelog_file" >>"$reapack_file_out"


    print_done

    #   Theme Adjuster Files
    # ------------------------------

    print_process_start "Copying ReaScript Files"

    rsync -aq --mkpath --exclude="conf/last_theme.partmap" --exclude="conf/parameters.partmap" --exclude "add_lua_tags.sh" "$ORG_DIR/src/scripts/themeadj/" "$ORG_DIR/$release_folder/$version/reapack/paRt"
    rsync -aq --mkpath "$ORG_DIR/$release_folder/$version/reapack/paRt/" "$ORG_DIR/$release_folder/$version/bin/manual/Scripts/Fleeesch/themes/paRt/"

    print_done


    #   Manual-Installation Release
    # --------------------------------

    print_process_start "Creating Manual-Installation"

    zip_file="$ORG_DIR/$release_folder/$version/bin/part_manual_install_v$version.zip"

    cd "$ORG_DIR/$release_folder/$version/bin/manual/"
    zip -9 -qrFS "$zip_file" .

    cd "$ORG_DIR"

    rm -rf "./$release_folder/$version/bin/manual" >/dev/null 2>&1

    print_done

    #   Github Rename
    # ------------------------------

    if [ "$github" = true ]; then
        mv "./$release_folder/$version" "./$release_folder/current" >/dev/null 2>&1
    fi

fi
