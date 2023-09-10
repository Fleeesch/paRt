#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Preparation
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

source ./release_tools.sh

SetupEnvVariables
LoadReaPackVariables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Process
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# --------------------------------------
#   Update ReaPack Repository
# --------------------------------------

# store paths
theme_file_name="part.theme"
reapack_folder="$TMP_FOLDER/rp"
reapack_theme_file="$reapack_folder/$theme_file_name"
reapack_prov_file="./$RP_FOLDER/provides"
script_path="./src/scripts"
theme_scripts_name="paRt Scripts"
reapack_release_folder="$REL_FOLDER/$REL_TAG/reapack"

update_repo=0

while true; do

    echo -
    read -p 'Update the ReaPack Repository files? [y] ' yn
    echo -

    case $yn in
    [Yy]*)
        update_repo=1
        break
        ;;
    *) break ;;
    esac
done

# quit if no repository was found
if [ ! -d "$RP_REPO" ]; then
    echo -
    echo "No ReaPack Repository folder found, aborting..."
    read -p ""
    exit

fi

# quit if repository isn't about to be updated
if [ ! "$update_repo" -eq "1" ]; then
    exit
fi

# switch to staging branch
cd $RP_REPO
git checkout --force staging
git reset --hard HEAD

# get current branch
branch=$(git symbolic-ref --short HEAD)

if [ "$branch" != "staging" ]; then
    echo -
    read -p "[!] Branch is not staging, please switch to dev and try again"
    cd $ORG_DIR
    exit
fi

cd $ORG_DIR

echo -n Updating repository...

# update script folder
mkdir -p "$RP_REPO/themes"

\cp -f "$reapack_release_folder/$theme_file_name" "$RP_REPO/themes/$theme_file_name"
\rm -rf "$RP_REPO/themes/$theme_scripts_name"
\cp -rf "$script_path/" "$RP_REPO/themes/$theme_scripts_name"
\cp -rf "$script_path/" "$reapack_release_folder/$theme_scripts_name"

echo done

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Update Git
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ask if package index should be updated
update_package=0

while true; do

    echo -
    read -p 'Push current data to staging branch, so you can double-check? [y] ' yn
    echo -

    case $yn in
    [Yy]*)
        update_package=1
        break
        ;;
    *) break ;;
    esac
done

# update package index
if [ "$update_package" -eq "1" ]; then

    # go to repository folder
    cd $RP_REPO

    # :::::::::::::::
    #   Git Magic

    git_msg="Version Update $REL_TAG_V"

    # -- Push --
    git add .
    git commit -m "$git_msg"
    git push --force

    # push to main, publish release ?
    while true; do

        echo -
        read -p 'Merge staging into main, publishing the release? [y] ' yn
        echo -

        case $yn in
        [Yy]*)
            git checkout --force master
            git pull

            # --- Merge ---
            git merge --no-verify --no-edit staging

            if [ $? -ne 0 ]; then
                echo -
                echo "[!] Got a merge conflict. Please fix it, then press any key to continue..."
                read -p ""
                echo -
                git add .
                git commit -m "$git_msg"
            else
                git commit --amend -m "$git_msg"
            fi

            # --- Push ---
            git push --force
            git checkout --force staging

            break
            ;;
        *) break ;;
        esac
    done

fi
