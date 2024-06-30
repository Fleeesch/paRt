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
print_prompt_line() {
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

# creation-flags
create_assets=0
create_themefiles=0

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

#   Recreate Assets
# -------------------------------

recreate_assets=false
if [ "$unattended" = false ]; then

    print_prompt_line "Recreate Assets?"
    read -n 1 choice
    echo ""

    case "$choice" in
    y | Y) recreate_assets=true ;;
    *) recreate_assets=false ;;
    esac

    if [ "$recreate_assets" = true ]; then
        cd "./src"
        source make_themes.sh
        cd "$ORG_DIR"
    fi

fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Release Creation
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

while true; do

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

    if [ "$local_release" = true ]; then

        #   Binaries
        # ------------------------------

        print_process_start "Creating Theme Binaries"

        # clear release folder
        version=$(<./src/rel/version)
        rm -rf "./rel/current" >/dev/null 2>&1
        rm -rf "./rel/$version" >/dev/null 2>&1

        # create release folders
        mkdir -p "./rel/$version/bin"
        mkdir -p "./rel/$version/changelog"
        mkdir -p "./rel/$version/reapack"

        # add binaries
        rsync -aq --include="*.ReaperThemeZip" --exclude="*" "./src/build/"/ "./rel/$version/bin"

        print_done

        #   Changelog
        # ------------------------------

        print_process_start "Creating Changelog"

        changelog_file_in="./src/rel/changelog"

        # Reapack
        changelog_file_out="./rel/$version/changelog/changelog_reapack.txt"

        echo "@changelog" >"$changelog_file_out"
        while IFS= read -r line; do
            echo "  $line" >>"$changelog_file_out"
        done <"$changelog_file_in"

        # Markdown
        changelog_file_out="./rel/$version/changelog/changelog.md"

        echo "**$version - Changelog**" >"$changelog_file_out"
        while IFS= read -r line; do
            echo "- $line" >>"$changelog_file_out"
        done <"$changelog_file_in"

        # Boardcode
        changelog_file_out="./rel/$version/changelog/changelog_bb.txt"

        echo "[code]" >"$changelog_file_out"
        echo "[b]Changelog - $version[/b]" >>"$changelog_file_out"
        while IFS= read -r line; do
            echo "- $line" >>"$changelog_file_out"
        done <"$changelog_file_in"
        echo "[/code]" >>"$changelog_file_out"

        print_done

        #   Reapack Theme File
        # ------------------------------

        print_process_start "Creating ReaPack Data"

        changelog_file="./rel/$version/changelog/changelog_reapack.txt"
        reapack_file_in="reapack/reapack_info"
        reapack_file_out="./rel/$version/reapack/part.theme"

        cat "$reapack_file_in" >"$reapack_file_out"
        echo "" >>"$reapack_file_out"
        cat "$changelog_file" >>"$reapack_file_out"

        print_done

        #   Theme Adjuster Files
        # ------------------------------

        print_process_start "Copying ReaScript Files"

        rsync -aq --exclude="\.*" --exclude="conf/*" "./src/scripts/" "./rel/$version/reapack/"

        cd "./src/scripts"
        zip_file="$ORG_DIR/rel/$version/bin/paRt - Theme Adjuster.zip"
        zip -qrFS "$zip_file" .
        cd "$ORG_DIR"

        print_done

        #   Github Rename
        # ------------------------------

        if [ "$github" = true ]; then
            mv "./rel/$version" "./rel/current" >/dev/null 2>&1
        fi

    fi

    break

    #     # ask for theme file creation
    #     print_prompt_line 'Make a local Release? [y] ' yn

    #     # raise asset-creation-flag
    #     case $yn in
    #     [Yy]*)

    #         # return to original working directory
    #         cd $original_dir

    #         # make source and release

    #         # > > > > > > > > > > > > > > > > > > > > >
    #         #   Uploading to Github
    #         # > > > > > > > > > > > > > > > > > > > > >
    #         while true; do

    #             # ask for theme file creation
    #             echo -
    #             read -p 'Push Release to Github? [y] ' yn

    #             # raise asset-creation-flag
    #             case $yn in
    #             [Yy]*)

    #                 # return to original working directory
    #                 cd $original_dir

    #                 # make source and release
    #                 StoreStep "Pushing Release to Github"
    #                 ./update_github.sh
    #                 StoreStep "Pushing Release to Github - Done"

    #                 # > > > > > > > > > > > > > > > > > > > > >
    #                 #   Update ReaPack
    #                 # > > > > > > > > > > > > > > > > > > > > >
    #                 while true; do

    #                     # ask for theme file creation
    #                     echo -
    #                     read -p 'Update ReaPack Index? [y] ' yn

    #                     # raise asset-creation-flag
    #                     case $yn in
    #                     [Yy]*)

    #                         # return to original working directory
    #                         cd $original_dir

    #                         # make source and release
    #                         StoreStep "Updating Reapack Repository"
    #                         ./update_reapack.sh
    #                         StoreStep "Updating Reapack Repository - Done"

    #                         break
    #                         ;;
    #                     *) break ;;
    #                     esac
    #                 done

    #                 break
    #                 ;;
    #             *) break ;;
    #             esac
    #         done

    #         break
    #         ;;
    #     *) break ;;
    #     esac
done

# echo -
# echo Done. Press any key to exit...
# read -p ""
