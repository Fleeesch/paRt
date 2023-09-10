#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Preparation
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

source ./release_tools.sh

SetupEnvVariables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Process
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

git_msg="Version Update $REL_TAG_V"

# - - - - - - - - - - - - - - - - - - - - - -
#   Storing Development Data
# - - - - - - - - - - - - - - - - - - - - - -

push=0

# ask for user acceptance
while true; do

    echo -
    read -p 'Push your process to dev branch? [y] ' yn
    echo -

    # raise asset-creation-flag
    case $yn in
    [Yy]*)
        push=1
        break
        ;;
    *) break ;;
    esac
done

# stop if required
if [ ! "$push" -eq "1" ]; then
    exit
fi

# get current branch
branch=$(git symbolic-ref --short HEAD)

if [ "$branch" != "dev" ]; then
    echo -
    read -p "[!] Branch is not dev, please switch to dev and try again"
    exit
fi

echo "Pushing current dev state..."

git add .
git commit -m "$git_msg"
git push

echo "Done..."

# - - - - - - - - - - - - - - - - - - - - - -
#   Pushing to staging branch
# - - - - - - - - - - - - - - - - - - - - - -

push=0

# ask for user acceptance
while true; do

    echo -
    read -p 'Merge dev into staging branch, so you can double-check? [y] ' yn
    echo -

    # raise asset-creation-flag
    case $yn in
    [Yy]*)
        push=1
        break
        ;;
    *) break ;;
    esac
done

# stop if required
if [ ! "$push" -eq "1" ]; then
    exit
fi

# :::::::::::::::
#   Git Magic

git checkout staging
git pull
git merge --no-verify --no-edit dev

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

git push --force
git checkout --force dev

# - - - - - - - - - - - - - - - - - - - - - -
#   Pushing to main branch
# - - - - - - - - - - - - - - - - - - - - - -

push=0

# ask for user acceptance
while true; do

    echo -
    read -p 'Merge staging into main branch, creating a new release? [y] ' yn
    echo -

    # raise asset-creation-flag
    case $yn in
    [Yy]*)
        push=1
        break
        ;;
    *) break ;;
    esac
done

# stop if required
if [ ! "$push" -eq "1" ]; then
    exit
fi

# :::::::::::::::
#   Git Magic

git checkout --force main
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
git tag $REL_TAG_V
git push origin $REL_TAG_V
git checkout --force dev
