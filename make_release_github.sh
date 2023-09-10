#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Preparation
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

source ./release_tools.sh

SetupEnvVariables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Process
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# print header
echo - - - - - - - - - - - - - - - - - - - - -
echo Creating Release Files

# clear previous stuff
ClearReleaseFolder
ClearTempFiles

# create binaries
CreateBinaries

# cp contents from release folder to central folder
\rm -rf "./rel/current"
mkdir -p "./rel/current"
\cp -rf "./rel/$REL_TAG/." "./rel/current/"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Cleanup
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ClearTempFiles
