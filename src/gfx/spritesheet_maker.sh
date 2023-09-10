#!/bin/bash

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Globals
#- - - - - - - - - - - - - - - - - - - - - - - - -

declare -ga zoom_levels=("100" "125" "150" "175" "200" "225" "250" "300")
declare -ga zoom_levels_toolbar=("100" "125" "150" "175" "200" "225" "250" "300")

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Init Making
#- - - - - - - - - - - - - - - - - - - - - - - - -

function InitMake {
  #rm -f -r "./out"
  :
}

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     End Making
#- - - - - - - - - - - - - - - - - - - - - - - - -

function EndMake {
  echo Set Done!
}

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Copy Graphics
#- - - - - - - - - - - - - - - - - - - - - - - - -

function Copy {
  
  #--- Passing Arguments ---
  
  file1="${1/$'\r'/}" # input file name (minus size suffix)
  file2="${2/$'\r'/}" # output file name (minus size suffix)

  #--- Initiation ---

  # escape if there is no asset folder
  if [ ! -d "./ats" ]; then
    return
  fi

  echo -n Copying $file1 to $file2...

  for sub in ./ats/*/; do

    out_name=$(basename $sub) # output folder name

    #--- Copy Process ---

    # go through all the sizes
    #for i in 100 125 150 175 200 250 300 350; do
    for i in "${zoom_levels[@]}"; do

      # generate input/output filenames
      in="./out/$out_name/$i/$file1.png"
      out="./out/$out_name/$i/$file2.png"

      # correct output folder for 100
      if [ "$i" -eq "100" ]; then
        in="./out/$out_name/$file1.png"
        out="./out/$out_name/$file2.png"
      else
        mkdir -p "./out/$out_name/$i"
      fi

      # copy file if source file exists
      if [ -f $in ]; then
        rm -f $out
        cp $in $out 2>/dev/null
      fi

    done
  done

  echo done

}

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Create Dummy
#- - - - - - - - - - - - - - - - - - - - - - - - -

function CreateDummy {

  #--- Passing Arguments ---

  dir="${1/$'\r'/}"      # specific target folder
  file_out="${2/$'\r'/}" # output file name (minus size suffix)

  #--- Initiation ---

  # escape if there is no asset folder
  if [ ! -d "./ats" ]; then
    return
  fi

  echo -n Creating $file_out ...

  dir_look="./ats/*/" # default lookup path are all sub-directories

  # look in specific directory if tasked to
  if [ ! -z "$dir" ]; then
    dir_look="./ats/$dir/"
  fi

  # go through sub directories / specific directory
  for sub in $dir_look; do

    # skip common folder if no specific target folder is given
    if [ -z "$dir" ] && [[ "$sub" == *"common"* ]]; then
      continue
    fi

    out_name=$(basename $sub) # output folder name

    #--- Mapping Process ---

    # go through all the sizes
    #for i in 100 125 150 175 200 250 300 350; do
    for i in "${zoom_levels[@]}"; do

      mkdir -p "./out/$out_name" # generate output folder

      # generate input/output filenames
      out="./out/$out_name/$i/$file_out.png"

      # correct output folder for 100
      if [ "$i" -eq "100" ]; then
        out="./out/$out_name/$file_out.png"
      else
        mkdir -p "./out/$out_name/$i"
      fi

      # create dummy sprite
      convert -quiet -size 1x1 canvas:none -background none "$out"

    done

  done

  echo done

}

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Create Button Set (1)
#- - - - - - - - - - - - - - - - - - - - - - - - -

function CreateButtonSet_1 {

  #--- Passing Arguments ---

  dir="${1/$'\r'/}"      # specific target folder
  file_in="${2/$'\r'/}"  # input file name (minus size suffix)
  file_out="${3/$'\r'/}" # output file name (minus size suffix)
  frame_a="${4/$'\r'/}"  # frame (top-left)
  frame_b="${5/$'\r'/}"  # frame (bottom-right)
  opacity="${6/$'\r'/}"

  #--- Initiation ---

  # escape if there is no asset folder
  if [ ! -d "./ats" ]; then
    return
  fi

  echo -n Creating $file_out ...

  dir_look="./ats/*/" # default lookup path are all sub-directories

  # look in specific directory if tasked to
  if [ ! -z "$dir" ]; then
    dir_look="./ats/$dir/"
  fi

  # go through sub directories / specific directory
  for sub in $dir_look; do

    # skip common folder if no specific target folder is given
    if [ -z "$dir" ] && [[ "$sub" == *"common"* ]]; then
      continue
    fi

    out_name=$(basename $sub) # output folder name

    #--- Mapping Process ---

    # go through all the sizes
    #for i in 100 125 150 175 200 250 300 350; do
    for i in "${zoom_levels[@]}"; do

      mkdir -p "./out/$out_name" # generate output folder

      # generate input/output filenames
      in="./ats/$out_name/$file_in $i.png"
      out="./out/$out_name/$i/$file_out.png"

      # correct output folder for 100
      if [ "$i" -eq "100" ]; then
        out="./out/$out_name/$file_out.png"
      else
        mkdir -p "./out/$out_name/$i"
      fi

      # create single sprite
      convert -quiet "$in" "$out"

      # change opacity if tasked
      if ! [ -z "$opacity" ]; then
        convert -quiet "$out" -alpha set -background none -channel A -evaluate multiply $opacity +channel "$out"
      fi

      # generate overlay filenames
      fr1="./ats/common/$frame_a $i.png"
      fr2="./ats/common/$frame_b $i.png"

      # extend and apply frame 1 if available
      if [ -f "$fr1" ]; then
        convert -quiet "$out" -background none -gravity center -bordercolor none -border 1 -define png:color-type=6 "$out"
        convert -quiet -gravity northwest -composite "$out" "$fr1" "$out"
      fi

      # apply frame 2 if available
      if [ -f "$fr2" ]; then
        convert -quiet -gravity southeast -composite "$out" "$fr2" "$out"
      fi

    done

  done

  echo done

}

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Create Button Set (1 - Fixed Size)
#- - - - - - - - - - - - - - - - - - - - - - - - -

function CreateButtonSet_1_FixedSize {

  #--- Passing Arguments ---

  dir="${1/$'\r'/}"      # specific target folder
  src_size="${2/$'\r'/}" # source size
  file_in="${3/$'\r'/}"  # input file name (minus size suffix)
  file_out="${4/$'\r'/}" # output file name (minus size suffix)
  frame_a="${5/$'\r'/}"  # frame (top-left)
  frame_b="${6/$'\r'/}"  # frame (bottom-right)
  opacity="${7/$'\r'/}"

  #--- Initiation ---

  # escape if there is no asset folder
  if [ ! -d "./ats" ]; then
    return
  fi

  echo -n Creating $file_out ...

  dir_look="./ats/*/" # default lookup path are all sub-directories

  # look in specific directory if tasked to
  if ! [ -z "$dir" ]; then
    dir_look="./ats/$dir/"
  fi

  # go through sub directories / specific directory
  for sub in $dir_look; do

    # skip common folder if no specific target folder is given
    if [ -z "$dir" ] && [[ "$sub" == *"common"* ]]; then
      continue
    fi

    out_name=$(basename $sub) # output folder name

    #--- Mapping Process ---

    mkdir -p "./out/$out_name" # generate output folder

    # generate input/output filenames

    if [ ! -z "$src_size" ]; then
      in="./ats/$out_name/$file_in $src_size.png"
    else
      in="./ats/$out_name/$file_in.png"
    fi

    out="./out/$out_name/$file_out.png"

    # create sprite sheet
    convert -quiet "$in" -define png:color-type=6 "$out"

    # change opacity if tasked
    if ! [ -z "$opacity" ]; then
      convert -quiet "$out" -alpha set -background none -channel A -evaluate multiply $opacity +channel "$out"
    fi

    # generate frame filenames
    if [ ! -z "$src_size" ]; then
      fr1="./ats/common/$frame_a $src_size.png"
      fr2="./ats/common/$frame_b $src_size.png"
    else
      fr1="./ats/common/$frame_a.png"
      fr2="./ats/common/$frame_b.png"
    fi

    # extend and apply frame 1 if available
    if [ -f "$fr1" ]; then
      convert -quiet "$out" -background none -gravity center -bordercolor none -border 1 -define png:color-type=6 "$out"
      convert -quiet -gravity northwest -composite "$out" "$fr1" "$out"
    fi

    # apply frame 2 if available
    if [ -f "$fr2" ]; then
      convert -quiet -gravity southeast -composite "$out" "$fr2" "$out"
    fi

  done

  echo done

}

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Create Button Set (3 - Horizontal)
#- - - - - - - - - - - - - - - - - - - - - - - - -

function CreateButtonSet_3 {

  #--- Passing Arguments ---

  dir="${1/$'\r'/}"      # specific target folder
  file_in="${2/$'\r'/}"  # input file name (minus size suffix)
  file_out="${3/$'\r'/}" # output file name (minus size suffix)
  hover="${4/$'\r'/}"    # hover overlay (minus size suffix)
  click="${5/$'\r'/}"    # click overlay (minus size suffix)
  frame_a="${6/$'\r'/}"  # frame (top-left)
  frame_b="${7/$'\r'/}"  # frame (bottom-right)
  opacity="${8/$'\r'/}"
  shadow="${9/$'\r'/}"
  shadow_alpha_1="${10/$'\r'/}"
  shadow_alpha_2="${11/$'\r'/}"
  shadow_alpha_3="${12/$'\r'/}"

  #--- Initiation ---

  # escape if there is no asset folder
  if [ ! -d "./ats" ]; then
    return
  fi

  echo -n Creating $file_out ...

  dir_look="./ats/*/" # default lookup path are all sub-directories

  # look in specific directory if tasked to
  if ! [ -z "$dir" ]; then
    dir_look="./ats/$dir/"
  fi

  # go through sub directories / specific directory
  for sub in $dir_look; do

    # skip common folder if no specific target folder is given
    if [ -z "$dir" ] && [[ "$sub" == *"common"* ]]; then
      continue
    fi

    out_name=$(basename $sub) # output folder name

    #--- Mapping Process ---

    # go through all the sizes
    #for i in 100 125 150 175 200 250 300 350; do
    for i in "${zoom_levels[@]}"; do

      mkdir -p "./out/$out_name" # generate output folder

      # generate input/output filenames
      in="./ats/$out_name/$file_in $i.png"
      out="./out/$out_name/$i/$file_out.png"

      # correct output folder for 100
      if [ "$i" -eq "100" ]; then
        out="./out/$out_name/$file_out.png"
      else
        mkdir -p "./out/$out_name/$i"
      fi

      # create sprite sheet
      convert -quiet +append "$in" "$in" "$in" -define png:color-type=6 "$out"

      # change opacity if tasked
      if ! [ -z "$opacity" ]; then
        convert -quiet "$out" -alpha set -background none -channel A -evaluate multiply $opacity +channel "$out"
      fi

      # generate overlay filenames
      ol1="./ats/common/$hover $i.png"
      ol2="./ats/common/$click $i.png"

      # apply overlay 1 if available
      if [ -f "$ol1" ]; then
        convert -quiet -compose overlay -gravity center -composite "$out" "$ol1" "$out"
      fi

      # apply overlay 2 if available
      if [ -f "$ol2" ]; then
        convert -quiet -compose overlay -gravity east -composite "$out" "$ol2" "$out"
      fi

      # draw shadow
      if ! [ -z "$shadow" ]; then

        # generate shadow filenames
        sh="./ats/common/$shadow $i.png"

        # apply shadow if available
        if [ -f "$sh" ]; then

          sh_tmp_1="./$file_out shadow_tmp_1.png"
          sh_tmp_2="./$file_out shadow_tmp_2.png"
          sh_tmp_3="./$file_out shadow_tmp_3.png"

          convert -quiet "$sh" -alpha set -background none -channel A -evaluate multiply $shadow_alpha_1 +channel "$sh_tmp_1"
          convert -quiet "$sh" -alpha set -background none -channel A -evaluate multiply $shadow_alpha_2 +channel "$sh_tmp_2"
          convert -quiet "$sh" -alpha set -background none -channel A -evaluate multiply $shadow_alpha_3 +channel "$sh_tmp_3"

          convert -quiet -compose overlay -gravity west -composite "$out" "$sh_tmp_1" "$out"
          convert -quiet -compose overlay -gravity center -composite "$out" "$sh_tmp_2" "$out"
          convert -quiet -compose overlay -gravity east -composite "$out" "$sh_tmp_3" "$out"

          \rm -f "$sh_tmp_1"
          \rm -f "$sh_tmp_2"
          \rm -f "$sh_tmp_3"

        fi

      fi

      # generate frame filenames
      fr1="./ats/common/$frame_a $i.png"
      fr2="./ats/common/$frame_b $i.png"

      # extend and apply frame 1 if available
      if [ -f "$fr1" ]; then
        convert -quiet "$out" -background none -gravity center -bordercolor none -border 1 -define png:color-type=6 "$out"
        convert -quiet -gravity northwest -composite "$out" "$fr1" "$out"
      fi

      # apply frame 2 if available
      if [ -f "$fr2" ]; then
        convert -quiet -gravity southeast -composite "$out" "$fr2" "$out"
      fi

    done

  done

  echo done

}

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Create Button Set (3 - Item)
#- - - - - - - - - - - - - - - - - - - - - - - - -

function CreateButtonSet_3_Item {

  #--- Passing Arguments ---

  dir="${1/$'\r'/}"      # specific target folder
  tgt_size="${2/$'\r'/}" # target size
  file_in="${3/$'\r'/}"  # input file name (minus size suffix)
  file_out="${4/$'\r'/}" # output file name (minus size suffix)
  hover="${5/$'\r'/}"    # hover overlay (minus size suffix)
  click="${6/$'\r'/}"    # click overlay (minus size suffix)
  frame_a="${7/$'\r'/}"  # frame (top-left)
  frame_b="${8/$'\r'/}"  # frame (bottom-right)
  opacity="${9/$'\r'/}"

  #--- Initiation ---

  # escape if there is no asset folder
  if [ ! -d "./ats" ]; then
    return
  fi

  echo -n Creating $file_out ...

  dir_look="./ats/*/" # default lookup path are all sub-directories

  # look in specific directory if tasked to
  if ! [ -z "$dir" ]; then
    dir_look="./ats/$dir/"
  fi

  # go through sub directories / specific directory
  for sub in $dir_look; do

    # skip common folder if no specific target folder is given
    if [ -z "$dir" ] && [[ "$sub" == *"common"* ]]; then
      continue
    fi

    out_name=$(basename $sub) # output folder name

    #--- Mapping Process ---

    mkdir -p "./out/$out_name" # generate output folder

    # generate input/output filenames
    in="./ats/$out_name/$file_in $tgt_size.png"
    out="./out/$out_name/$file_out.png"

    # create sprite sheet
    convert -quiet +append "$in" "$in" "$in" -define png:color-type=6 "$out"

    # change opacity if tasked
    if ! [ -z "$opacity" ]; then
      convert -quiet "$out" -alpha set -background none -channel A -evaluate multiply $opacity +channel "$out"
    fi

    # generate overlay filenames
    ol1="./ats/common/$hover $i.png"
    ol2="./ats/common/$click $i.png"

    # apply overlay 1 if available
    if [ -f "$ol1" ]; then
      convert -quiet -compose overlay -gravity center -composite "$out" "$ol1" "$out"
    fi

    # apply overlay 2 if available
    if [ -f "$ol2" ]; then
      convert -quiet -compose overlay -gravity east -composite "$out" "$ol2" "$out"
    fi

    # generate frame filenames
    fr1="./ats/common/$frame_a $i.png"
    fr2="./ats/common/$frame_b $i.png"

    # extend and apply frame 1 if available
    if [ -f "$fr1" ]; then
      convert -quiet "$out" -background none -gravity center -bordercolor none -border 1 -define png:color-type=6 "$out"
      convert -quiet -gravity northwest -composite "$out" "$fr1" "$out"
    fi

    # apply frame 2 if available
    if [ -f "$fr2" ]; then
      convert -quiet -gravity southeast -composite "$out" "$fr2" "$out"
    fi

  done

  echo done

}

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Create Button Set (3 - ExtMixer)
#- - - - - - - - - - - - - - - - - - - - - - - - -

function CreateButtonSet_3_ExtMixer {

  #--- Passing Arguments ---

  dir="${1/$'\r'/}"       # specific target folder
  file_in_1="${2/$'\r'/}" # input file name (minus size suffix)
  file_in_2="${3/$'\r'/}" # input file name (minus size suffix)
  file_in_3="${4/$'\r'/}" # input file name (minus size suffix)
  file_out="${5/$'\r'/}"  # output file name (minus size suffix)
  hover="${6/$'\r'/}"     # hover overlay (minus size suffix)
  click="${7/$'\r'/}"     # click overlay (minus size suffix)
  frame_a="${8/$'\r'/}"   # frame (top-left)
  frame_b="${9/$'\r'/}"   # frame (bottom-right)
  opacity="${10/$'\r'/}"

  #--- Initiation ---

  # escape if there is no asset folder
  if [ ! -d "./ats" ]; then
    return
  fi

  echo -n Creating $file_out ...

  dir_look="./ats/*/" # default lookup path are all sub-directories

  # look in specific directory if tasked to
  if ! [ -z "$dir" ]; then
    dir_look="./ats/$dir/"
  fi

  # go through sub directories / specific directory
  for sub in $dir_look; do

    # skip common folder if no specific target folder is given
    if [ -z "$dir" ] && [[ "$sub" == *"common"* ]]; then
      continue
    fi

    out_name=$(basename $sub) # output folder name

    #--- Mapping Process ---

    # go through all the sizes
    #for i in 100 125 150 175 200 250 300 350; do
    for i in "${zoom_levels[@]}"; do

      mkdir -p "./out/$out_name" # generate output folder

      # generate input/output filenames
      in_1="./ats/$out_name/$file_in_1 $i.png"
      in_2="./ats/$out_name/$file_in_2 $i.png"
      in_3="./ats/$out_name/$file_in_3 $i.png"
      out="./out/$out_name/$i/$file_out.png"

      # correct output folder for 100
      if [ "$i" -eq "100" ]; then
        out="./out/$out_name/$file_out.png"
      else
        mkdir -p "./out/$out_name/$i"
      fi

      # create sprite sheet
      convert -quiet -append "$in_1" "$in_2" "$in_3" -define png:color-type=6 "$out"

      # change opacity if tasked
      if ! [ -z "$opacity" ]; then
        convert -quiet "$out" -alpha set -background none -channel A -evaluate multiply $opacity +channel "$out"
      fi

      # generate overlay filenames
      ol1="./ats/common/$hover $i.png"
      ol2="./ats/common/$click $i.png"

      # apply overlay 1 if available
      if [ -f "$ol1" ]; then
        convert -quiet -compose overlay -gravity center -composite "$out" "$ol1" "$out"
      fi

      # apply overlay 2 if available
      if [ -f "$ol2" ]; then
        convert -quiet -compose overlay -gravity south -composite "$out" "$ol2" "$out"
      fi

      # generate frame filenames
      fr1="./ats/common/$frame_a $i.png"
      fr2="./ats/common/$frame_b $i.png"

      # extend and apply frame 1 if available
      if [ -f "$fr1" ]; then
        convert -quiet "$out" -background none -gravity center -bordercolor none -border 1 -define png:color-type=6 "$out"
        convert -quiet -gravity northwest -composite "$out" "$fr1" "$out"
      fi

      # apply frame 2 if available
      if [ -f "$fr2" ]; then
        convert -quiet -gravity southeast -composite "$out" "$fr2" "$out"
      fi

    done

  done

  echo done

}

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Create Button Set (3 - Selective)
#- - - - - - - - - - - - - - - - - - - - - - - - -

function CreateButtonSet_3_Selective {

  #--- Passing Arguments ---

  dir="${1/$'\r'/}"       # specific target folder
  file_in_1="${2/$'\r'/}" # input file name (minus size suffix)
  file_in_2="${3/$'\r'/}" # input file name (minus size suffix)
  file_in_3="${4/$'\r'/}" # input file name (minus size suffix)
  file_out="${5/$'\r'/}"  # output file name (minus size suffix)
  hover="${6/$'\r'/}"     # hover overlay (minus size suffix)
  click="${7/$'\r'/}"     # click overlay (minus size suffix)
  frame_a="${8/$'\r'/}"   # frame (top-left)
  frame_b="${9/$'\r'/}"   # frame (bottom-right)
  opacity="${10/$'\r'/}"

  #--- Initiation ---

  # escape if there is no asset folder
  if [ ! -d "./ats" ]; then
    return
  fi

  echo -n Creating $file_out ...

  dir_look="./ats/*/" # default lookup path are all sub-directories

  # look in specific directory if tasked to
  if ! [ -z "$dir" ]; then
    dir_look="./ats/$dir/"
  fi

  # go through sub directories / specific directory
  for sub in $dir_look; do

    # skip common folder if no specific target folder is given
    if [ -z "$dir" ] && [[ "$sub" == *"common"* ]]; then
      continue
    fi

    out_name=$(basename $sub) # output folder name

    #--- Mapping Process ---

    # go through all the sizes
    #for i in 100 125 150 175 200 250 300 350; do
    for i in "${zoom_levels[@]}"; do

      mkdir -p "./out/$out_name" # generate output folder

      # generate input/output filenames
      in_1="./ats/$out_name/$file_in_1 $i.png"
      in_2="./ats/$out_name/$file_in_2 $i.png"
      in_3="./ats/$out_name/$file_in_3 $i.png"
      out="./out/$out_name/$i/$file_out.png"

      # correct output folder for 100
      if [ "$i" -eq "100" ]; then
        out="./out/$out_name/$file_out.png"
      else
        mkdir -p "./out/$out_name/$i"
      fi

      # create sprite sheet
      convert -quiet +append "$in_1" "$in_2" "$in_3" -define png:color-type=6 "$out"

      # change opacity if tasked
      if ! [ -z "$opacity" ]; then
        convert -quiet "$out" -alpha set -background none -channel A -evaluate multiply $opacity +channel "$out"
      fi

      # generate overlay filenames
      ol1="./ats/common/$hover $i.png"
      ol2="./ats/common/$click $i.png"

      # apply overlay 1 if available
      if [ -f "$ol1" ]; then
        convert -quiet -compose overlay -gravity center -composite "$out" "$ol1" "$out"
      fi

      # apply overlay 2 if available
      if [ -f "$ol2" ]; then
        convert -quiet -compose overlay -gravity east -composite "$out" "$ol2" "$out"
      fi

      # generate frame filenames
      fr1="./ats/common/$frame_a $i.png"
      fr2="./ats/common/$frame_b $i.png"

      # extend and apply frame 1 if available
      if [ -f "$fr1" ]; then
        convert -quiet "$out" -background none -gravity center -bordercolor none -border 1 -define png:color-type=6 "$out"
        convert -quiet -gravity northwest -composite "$out" "$fr1" "$out"
      fi

      # apply frame 2 if available
      if [ -f "$fr2" ]; then
        convert -quiet -gravity southeast -composite "$out" "$fr2" "$out"
      fi

    done

  done

  echo done

}

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Create Button Set (3 - Toolbar)
#- - - - - - - - - - - - - - - - - - - - - - - - -

function CreateButtonSet_3_Toolbar {

  #--- Passing Arguments ---

  dir="${1/$'\r'/}"       # specific target folder
  file_in_1="${2/$'\r'/}" # input file name - toolbar background (minus size suffix)
  file_in_2="${3/$'\r'/}" # input file name - toolbar background (minus size suffix)
  file_in_3="${4/$'\r'/}" # input file name - toolbar background (minus size suffix)
  file_out="${5/$'\r'/}"  # output file name (minus size suffix)
  hover="${6/$'\r'/}"     # hover overlay (minus size suffix)
  click="${7/$'\r'/}"     # click overlay (minus size suffix)
  frame_a="${8/$'\r'/}"   # frame (top-left)
  frame_b="${9/$'\r'/}"   # frame (bottom-right)
  shadow="${10/$'\r'/}"
  shadow_alpha_1="${11/$'\r'/}"
  shadow_alpha_2="${12/$'\r'/}"
  shadow_alpha_3="${13/$'\r'/}"

  #--- Initiation ---

  # escape if there is no asset folder
  if [ ! -d "./ats" ]; then
    return
  fi

  echo -n Creating $file_out ...

  dir_look="./ats/*/" # default lookup path are all sub-directories
  
  # look in specific directory if tasked to
  if ! [ -z "$dir" ]; then
    dir_look="./ats/$dir/"
  fi

  # go through sub directories / specific directory
  for sub in $dir_look; do

    # skip common folder if no specific target folder is given
    if [ -z "$dir" ] && [[ "$sub" == *"common"* ]]; then
      continue
    fi

    out_name=$(basename $sub) # output folder name

    #--- Mapping Process ---

    # go through all the sizes
    #for i in 100 150 200; do
    for i in "${zoom_levels_toolbar[@]}"; do
      
      # generate input/output filenames
      in_1="./ats/$out_name/$file_in_1 $i.png"
      in_2="./ats/$out_name/$file_in_2 $i.png"
      in_3="./ats/$out_name/$file_in_3 $i.png"
      in_ico="./ico/$out_name/v6/$i/$file_out.png"
      out="./out/$out_name/$i/$file_out.png"

      # correct output folder for 100
      if [ "$i" -eq "100" ]; then
        out="./out/$out_name/$file_out.png"
        mkdir -p "./out/$out_name" # generate output folder
      else
        mkdir -p "./out/$out_name/$i"
      fi

      # create sprite sheet
      convert -quiet +append "$in_1" "$in_2" "$in_3" -define png:color-type=6 "$out"

      # generate overlay filenames
      ol1="./ats/common/$hover $i.png"
      ol2="./ats/common/$click $i.png"

      # apply overlay 1 if available
      if [ -f "$ol1" ]; then
        convert -quiet -compose overlay -gravity center -composite "$out" "$ol1" "$out"
      fi

      # apply overlay 2 if available
      if [ -f "$ol2" ]; then
        convert -quiet -compose overlay -gravity east -composite "$out" "$ol2" "$out"
      fi

      # overlay icon
      if [ -f "$in_ico" ]; then
        convert -quiet -compose over -gravity center -composite "$out" "$in_ico" "$out"
      fi

      # generate shadow filenames
      sh="./ats/common/$shadow $i.png"

      # apply shadow if available
      if [ -f "$sh" ]; then

        sh_tmp_1="./$file_out shadow_tmp_1.png"
        sh_tmp_2="./$file_out shadow_tmp_2.png"
        sh_tmp_3="./$file_out shadow_tmp_3.png"

        convert -quiet "$sh" -alpha set -background none -channel A -evaluate multiply $shadow_alpha_1 +channel "$sh_tmp_1"
        convert -quiet "$sh" -alpha set -background none -channel A -evaluate multiply $shadow_alpha_2 +channel "$sh_tmp_2"
        convert -quiet "$sh" -alpha set -background none -channel A -evaluate multiply $shadow_alpha_3 +channel "$sh_tmp_3"

        convert -quiet -compose overlay -gravity west -composite "$out" "$sh_tmp_1" "$out"
        convert -quiet -compose overlay -gravity center -composite "$out" "$sh_tmp_2" "$out"
        convert -quiet -compose overlay -gravity east -composite "$out" "$sh_tmp_3" "$out"

        \rm -f "$sh_tmp_1"
        \rm -f "$sh_tmp_2"
        \rm -f "$sh_tmp_3"

      fi

      # generate frame filenames
      fr1="./ats/common/$frame_a $i.png"
      fr2="./ats/common/$frame_b $i.png"

      # extend and apply frame 1 if available
      if [ -f "$fr1" ]; then
        convert -quiet "$out" -background none -gravity center -bordercolor none -border 1 -define png:color-type=6 "$out"
        convert -quiet -gravity northwest -composite "$out" "$fr1" "$out"
      fi

      # apply frame 2 if available
      if [ -f "$fr2" ]; then
        convert -quiet -gravity southeast -composite "$out" "$fr2" "$out"
      fi

    done

  done

  echo done

}

#- - - - - - - - - - - - - - - - - - - - - - - - -
#     Grap Toolbar Icons
#- - - - - - - - - - - - - - - - - - - - - - - - -

function GrapToolbarIcons {

  echo -n Copying v3 icons...
  
  # go through icon folders
  for sub in ./ico/*/; do
    
    # skip original icons
    if [[ "$sub" == *"original"* ]]; then
      continue
    fi
    
    out_name=$(basename $sub) # output folder name
    
    # go through zoom levels
    for i in "${zoom_levels_toolbar[@]}"; do
      
      mkdir -p "./out/$out_name/"
      
      # copy icons
      if [ "$i" -eq "100" ]; then
        rsync -q -au "$sub/v3/$i/" "./out/$out_name/"
      elif [ -d "$sub/v3/$i" ]; then  
        rsync -q -au "$sub/v3/$i/" "./out/$out_name/$i"
      fi
    
    done
  
  done
  
  echo done

}
