#!/bin/bash

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Input Prompt
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

read -p "Input version number: " rel_tag

if [ -z "$rel_tag" ]; then
    exit
fi


echo -n "$rel_tag" >"rel/version"
