#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Preparation
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ORG_DIR=$(pwd)
LOGFILE="$ORG_DIR/make.log"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# --------------------------------------
#   Initialze Step Log
# --------------------------------------
function InitStep() {
    echo >>"$LOGFILE"
    echo ------------------------------------------------ >>"$LOGFILE"
    echo Starting at $(date) >>"$LOGFILE"
    echo ------------------------------------------------ >>"$LOGFILE"
    echo >>"$LOGFILE"
}

# --------------------------------------
#   Append Step to Log
# --------------------------------------
function StoreStep() {

    echo "$1" >>"$LOGFILE"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Store Data
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# store original working directory
original_dir=$(pwd)

dir_src="src"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Input Prompts
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# creation-flags
create_assets=0
create_themefiles=0

echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
echo -e '      paRt - Automatic Release-Creation Tool'
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

echo
echo Tool for automating the Process of Theme and Release Creation
echo

# :::::::::::::::::::::::::::::
# Recreation of Assets

while true; do

    # ask for assets recreation
    read -p 'Recreate Assets? [y] ' yn

    # raise asset-creation-flag
    case $yn in
    [Yy]*)
        create_assets=1
        break
        ;;
    *) break ;;
    esac
done

# :::::::::::::::::::::::::::::
# Recreation of Theme Files

while true; do

    # ask for theme file creation
    read -p 'Recreate Theme files? [y] ' yn

    # raise asset-creation-flag
    case $yn in
    [Yy]*)
        create_themefiles=1
        break
        ;;
    *) break ;;
    esac
done

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Versioning
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

InitStep

# change to source directory
cd $dir_src

# setting version
StoreStep "Setting Version"
./version_set.sh
StoreStep "Setting Version - Done"

# updating changelog
StoreStep "Updating Changelog"
./changelog_set.sh
StoreStep "Updating Changelog - Done"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Asset Creation
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# optional -> create assets
if [ "$create_assets" -eq "1" ]; then

    cd "gfx"

    StoreStep "Recreation of Assets"
    ./make_all_sprites.sh
    StoreStep "Recreation of Assets - Done"
    cd ..

fi

# optional -> create theme files
if [ "$create_themefiles" -eq "1" ]; then
    
    StoreStep "Making Theme Files"
    ./themes_make.sh
    StoreStep "Making Theme Files - Done"

fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Making a Release
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# > > > > > > > > > > > > > > > > > > > > >
#   Making a Release
# > > > > > > > > > > > > > > > > > > > > >
while true; do

    # ask for theme file creation
    echo -
    read -p 'Make a local Release? [y] ' yn
    echo -

    # raise asset-creation-flag
    case $yn in
    [Yy]*)

        # return to original working directory
        cd $original_dir

        # make source and release
        StoreStep "Making local Release"
        ./make_release_local.sh
        StoreStep "Making local Release - Done"

        # > > > > > > > > > > > > > > > > > > > > >
        #   Uploading to Github
        # > > > > > > > > > > > > > > > > > > > > >
        while true; do

            # ask for theme file creation
            echo -
            read -p 'Push Release to Github? [y] ' yn

            # raise asset-creation-flag
            case $yn in
            [Yy]*)

                # return to original working directory
                cd $original_dir

                # make source and release
                StoreStep "Pushing Release to Github"
                ./update_github.sh
                StoreStep "Pushing Release to Github - Done"

                # > > > > > > > > > > > > > > > > > > > > >
                #   Update ReaPack
                # > > > > > > > > > > > > > > > > > > > > >
                while true; do

                    # ask for theme file creation
                    echo -
                    read -p 'Update ReaPack Index? [y] ' yn

                    # raise asset-creation-flag
                    case $yn in
                    [Yy]*)

                        # return to original working directory
                        cd $original_dir

                        # make source and release
                        StoreStep "Updating Reapack Repository"
                        ./update_reapack.sh
                        StoreStep "Updating Reapack Repository - Done"

                        break
                        ;;
                    *) break ;;
                    esac
                done

                break
                ;;
            *) break ;;
            esac
        done

        break
        ;;
    *) break ;;
    esac
done

echo -
echo Done. Press any key to exit...
read -p ""
