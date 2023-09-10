#!/bin/bash

cd "$(dirname $0)"

source ../spritesheet_maker.sh

InitMake

while read parameters
do
    eval "$parameters"
done < $(basename "$0").list

EndMake