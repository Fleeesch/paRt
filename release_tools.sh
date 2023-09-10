#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Setup Environmental Variables
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function SetupEnvVariables() {

    ORG_DIR=$(pwd)

    REL_FOLDER="rel"
    TMP_FOLDER="tmp"
    RP_FOLDER="reapack"

    declare -ga ZOOM_LEVELS=("100" "125" "150" "175" "200" "225" "250" "300")

    GetVersion REL_TAG
    REL_TAG_V="v$REL_TAG"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Indent Text
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

IndentText() {

    local input_string="$1"

    local string_indent="$(echo "$input_string" | sed 's/^/  /')"

    echo "$string_indent"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Get Value from Key
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GetValueFromKey() {

    local file="$1"
    local keyword="$2"

    local line

    while IFS= read -r line; do

        if [[ "$line" == *"[$keyword]"* ]]; then

            # trim brackets and whitespace
            value="${line#"[$keyword]"}"
            value="${value#"${value%%[![:space:]]*}"}"

            # print value
            echo "$value"

            break
        fi
    done <"$file"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Load ReaPack Variables
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function LoadReaPackVariables() {

    # reapack folder
    local rp_folder="reapack"

    # repository path
    read -r RP_REPO <"$RP_FOLDER/repository_path"

    # description
    RP_DESC=$(<"$RP_FOLDER/description")

    # author
    RP_AUTH=$(<"$RP_FOLDER/author")

    # about
    RP_ABOUT=$(<"$RP_FOLDER/about")

    # provides
    RP_PROV=$(<"$RP_FOLDER/provides")
    
    # link
    RP_LINK=$(<"$RP_FOLDER/link")
    
    # screenshot
    RP_SSHOT=$(<"$RP_FOLDER/screenshot")
    
    # version
    RP_VER="$(echo "$REL_TAG" | sed 's/^v//')"
    
    # download link
    RP_DL=$(<"$RP_FOLDER/part_repo")/releases/download
    
    # reapack changelog
    RP_CHANGE=$(<"$REL_FOLDER/$REL_TAG/changelog/changelog_reapack.txt")
    RP_CHANGE="$(IndentText "$RP_CHANGE")"
    
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Get Version
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function GetVersion() {

    # file containing version
    read -r rel_tag <"./src/rel/version"

    # error code when no version was found
    if [ -z "$rel_tag" ]; then

        rel_tag=-1

    fi

    # pass value to first argument
    eval "$1='$rel_tag'"

    # store in global variable
    REL_TAG=$rel_tag

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Clear Release Folder
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ClearReleaseFolder() {

    echo -n Clearing release folder...

    \rm -rf "$REL_FOLDER/$REL_TAG"

    echo done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Clear Temporary Files
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ClearTempFiles() {

    echo -n Removing temporary files...

    \rm -rf "$TMP_FOLDER"

    echo done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Create Release Folders
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function CreateTempFolders() {
    
    mkdir -p "$REL_FOLDER"
    mkdir -p "$REL_FOLDER/$REL_TAG"
    mkdir -p "$REL_FOLDER/$REL_TAG/bin"
    mkdir -p "$REL_FOLDER/$REL_TAG/changelog"
    mkdir -p "$TMP_FOLDER"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Create All Changelogs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function CreateAllChangelogs() {

    CreateTempFolders

    CreateChangelog "src/rel/changelog" "rel/$REL_TAG/changelog/changelog.txt" "$rel_tag" "text"
    CreateChangelog "src/rel/changelog" "rel/$REL_TAG/changelog/changelog_reapack.txt" "$rel_tag" "reapack"
    CreateChangelog "src/rel/changelog" "rel/$REL_TAG/changelog/changelog.md" "$rel_tag" "markdown"
    CreateChangelog "src/rel/changelog" "rel/$REL_TAG/changelog/changelog_bb.txt" "$rel_tag" "boardcode"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Create Changelog
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function CreateChangelog() {

    # store data from arguments
    local input_file=$1
    local target_file=$2
    local release_tag=$3
    local format=$4

    # format can be...
    # [empty], text, boardcode, markdown

    echo -n Creating Changelog $(basename $target_file)...

    # > > > > > > > > > > > > > >
    # No format given
    if [ -z "$format" ]; then

        format="text"

    fi

    # > > > > > > > > > > > > > >
    # header

    # text
    if [ "$format" = "text" ]; then

        echo "-------------------------------------------------" >"$target_file"
        echo "  Changelog - paRt - $rel_tag" >>"$target_file"
        echo "-------------------------------------------------" >>"$target_file"

    fi

    # board message header
    if [ "$format" = "boardcode" ]; then

        echo "[code]" >"$target_file"
        echo "[b]Changelog - $rel_tag[/b]" >>"$target_file"

    fi

    # markdown header
    if [ "$format" = "markdown" ]; then
        echo -e "**$rel_tag - Changelog**" >"$target_file"
    fi

    # check if changelog file exists
    if [ -f "$input_file" ]; then

        if [ -s "$input_file" ]; then

            # > > > > > > > > > > > > > >
            # writing changes
            while IFS= read -r line; do

                # text
                if [ "$format" = "text" ]; then

                    echo "- $line"

                fi

                # boardcode
                if [ "$format" = "boardcode" ]; then

                    echo "- $line"

                fi

                # markdown
                if [ "$format" = "markdown" ]; then

                    echo "- $line"

                fi

                # reapack
                if [ "$format" = "reapack" ]; then

                    echo "- $line"

                fi

            done <"$input_file" >>"$target_file"

        else

            echo "No changes" >>"$target_file"

        fi

    fi

    # > > > > > > > > > > > > > >
    # Closing Tags

    # boardcode
    if [ "$format" = "boardcode" ]; then

        echo -e "[/code]" >>"$target_file"

    fi

    echo done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Create Binaries
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function CreateBinaries() {

    # store zip file names
    local rzip_dark="paRt - Dark.ReaperThemeZip"
    local rzip_dark_win="paRt - Dark - Windows.ReaperThemeZip"
    local rzip_light="paRt - Light.ReaperThemeZip"

    # create temporary folders
    CreateTempFolders

    # create changelogs
    CreateAllChangelogs

    # make binary temp folders
    mkdir -p "$TMP_FOLDER/rel/font"
    mkdir -p "$TMP_FOLDER/rel/splash"
    mkdir -p "$TMP_FOLDER/rel/scripts"

    echo -n Copying ReaperThemeZip files...

    # copy zips
    \cp -f "./src/zip/dark/$rzip_dark" "$REL_FOLDER/$REL_TAG/bin/$rzip_dark"
    \cp -f "./src/zip/dark_win/$rzip_dark_win" "$REL_FOLDER/$REL_TAG/bin/$rzip_dark_win"
    \cp -f "./src/zip/light/$rzip_light" "$REL_FOLDER/$REL_TAG/bin/$rzip_light"

    echo done

    echo -n Packing additional files...

    # copy extra files to temp folder
    \cp -fr "./src/font/." "$TMP_FOLDER/rel/font"
    \cp -fr "./src/scripts/." "$TMP_FOLDER/rel/scripts"
    \cp -fr "./stock/splash/rnd/." "$TMP_FOLDER/rel/splash"
    \cp -fr "./src/doc/readme.txt" "$TMP_FOLDER/rel"
    \mv -f "./rel/$REL_TAG/changelog/changelog.txt" "$TMP_FOLDER/rel"

    # change to temp folder, zip dependencies
    cd $TMP_FOLDER/rel
    zip -qq -x "*.md" "*.adoc" -r "../../$REL_FOLDER/$REL_TAG/bin/part_files.zip" *
    cd "$ORG_DIR"

    echo done

    echo -n Creating Split Theme Files...

    # store paths
    local folder_split="$TMP_FOLDER/split"
    local folder_split_sum="$folder_split/sum"
    local folder_dark="$folder_split/dark"
    local folder_dark_win="$folder_split/dark_win"
    local folder_light="$folder_split/light"

    # make folders
    mkdir -p "$folder_split"
    mkdir -p "$folder_split_sum"
    mkdir -p "$folder_dark"
    mkdir -p "$folder_dark_win"
    mkdir -p "$folder_light"

    # create temporary folders

    # go through zoom levels, copy ReaperThemeZips
    for i in "${ZOOM_LEVELS[@]}"; do
        \cp -f "./src/zip/dark/paRt - Dark - $i.ReaperThemeZip" "$folder_dark"
        \cp -f "./src/zip/dark_win/paRt - Dark - Windows - $i.ReaperThemeZip" "$folder_dark_win"
        \cp -f "./src/zip/light/paRt - Light - $i.ReaperThemeZip" "$folder_light"
    done

    # prepare zip for dark theme
    cd "$folder_dark"
    zip -qq -r "$ORG_DIR/$folder_split_sum/part_split_dark_$rel_tag.zip" *
    cd "$ORG_DIR"

    # prepare zip for dark - windows theme
    cd "$folder_dark_win"
    zip -qq -r "$ORG_DIR/$folder_split_sum/part_split_dark_win_$rel_tag.zip" *
    cd "$ORG_DIR"

    # prepare zip for light theme
    cd "$folder_light"
    zip -qq -r "$ORG_DIR/$folder_split_sum/part_split_light_$rel_tag.zip" *
    cd "$ORG_DIR"

    # collect zip folders
    cd "$folder_split_sum"
    zip -qq -r "$ORG_DIR/$REL_FOLDER/$REL_TAG/bin/part_split_themes.zip" *
    cd "$ORG_DIR"

    echo done

}
