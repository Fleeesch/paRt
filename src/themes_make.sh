#!/bin/bash

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Globals
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -ga zoom_levels=("100" "125" "150" "175" "200" "225" "250" "300")

folder_zip="zip"
folder_build="build"

org_path=$(pwd)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Function : Create Header File
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function CreateHeaderFile() {
  
  # store data from arguments
  file=$1
  version=$2
  title=$3
  subtitle=$4
  info=$5
  
  # comment snippets
  line=";"
  bar_double=";= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = "
  bar_single=";- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
  offset=";      "
  
  # write version file
  >"$file"
  echo "$bar_double" >>"$file"
  echo "$bar_single" >>"$file"
  echo "$line" >>"$file"
  echo "$offset$3: $version" >>"$file"
  echo "$offset$subtitle" >>"$file"
  
  # no info given? use replacment text
  if [ ! -z "$info" ]; then

    echo "$line" >>"$file"
    echo "$offset$info" >>"$file"

  fi

  # finish block
  echo "$line" >>"$file"
  echo "$bar_single" >>"$file"
  echo "$bar_double" >>"$file"
  echo "" >>"$file"

}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Function : Create ThemeSet
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function CreateThemeSet {

  # store values
  folder_in=$1
  folder_out=$2
  name=$3
  rtconfig=$4
  clr_name=$5
  zip_name=$6
  
  # info text
  echo
  echo Creating $zip_name theme...

  # create temporary folders for fixed sizes
  for i in "${zoom_levels[@]}"; do
    mkdir -p "$folder_in/$i"
  done

  # path to reapertheme file
  theme_file="./thm/$zip_name.ReaperTheme"
  
  echo -en "\tPreparing Theme Files..."
  
  # create empty theme file, append name header
  >"$theme_file"
  cat "./thm/hdr_$clr_name.txt" >>"$theme_file"
  cat "./thm/clr_$clr_name.txt" >>"$theme_file"
  cat "./thm/img_$clr_name.txt" >>"$theme_file"
  cat "./thm/font.txt" >>"$theme_file"
  
  # copy ReaperTheme file to omni folder
  \cp -f "./thm/$zip_name.ReaperTheme" "$folder_in/omni"
  
  echo done
  
  # :::::::::::::::::::::::::::::::::::::::::
  #   Size Specific Processing
  # :::::::::::::::::::::::::::::::::::::::::
  
  # go through all the sizes
  # for i in 100 125 150 175 200 250 300 350; do
  for i in "${zoom_levels[@]}"; do
    
    echo -en "\tProcessing size $i..."
    
    # copy ReaperTheme file from omni folder to size folder
    rsync -qazir --include='*.ReaperTheme*' --exclude='*' "$folder_in/omni/" "$folder_in/$i"
    
    # copy assets from omni folder to size folder
    rsync -qazir --exclude='*/' "$folder_in/omni/$name/" "$folder_in/$i/$name"
    
    # copy assets from size sub-folder instead of root folder if size is not 100
    if [ "$i" -gt "100" ]; then
      rsync -qazir --exclude='toolbar*' --exclude='gen_*' --exclude='*/' "$folder_in/omni/$name/$i/" "$folder_in/$i/$name/"
    fi
    
    # always copy toolbar and generic images of its size to an extra folder
    # -> increases size opposes potentional errors
    
    if [ "$i" -gt "100" ]; then
      rsync -qazir --include='toolbar*' --include='gen_*' --exclude='*' "$folder_in/omni/$name/$i/" "$folder_in/$i/$name/$i"
    fi
    
    # copy toolbar and generic graphics if size is greater or equal than 200
    # -> this one's a fail-safe when reaper has trouble with decision-making
    
    if [ "$i" -ge "200" ]; then
      rsync -qazir --include='toolbar*' --include='gen_*' --exclude='*' "$folder_in/omni/$name/200/" "$folder_in/$i/$name/200"
    
    # copy toolbar and generic graphics if size is greater or equal than 150
    elif [ "$i" -ge "150" ]; then
      rsync -qazir --include='toolbar*' --include='gen_*' --exclude='*' "$folder_in/omni/$name/150/" "$folder_in/$i/$name/150"
    fi
    
    # construct theme specific rtconfig
    >$folder_in/$i/$name/rtconfig.txt
    cat "./wlt/hdr_$clr_name.txt" >>"$folder_in/$i/$name/rtconfig.txt"
    cat "./wlt/clr_$clr_name.txt" >>"$folder_in/$i/$name/rtconfig.txt"
    cat "./wlt/rtconfig.txt" >>"$folder_in/$i/$name/rtconfig.txt"
    cat "./wlt/scale_$i.txt" >>"$folder_in/$i/$name/rtconfig.txt"
    
    # create zip folder
    mkdir -p "$org_path/$folder_out"
    
    # create ReperThemeZip
    pushd "$folder_in/$i" >/dev/null
    zip -qq -r "$org_path/$folder_out/$zip_name - $i.ReaperThemeZip" .
    popd >/dev/null
    
    echo done
  
  done
  
  # :::::::::::::::::::::::::::::::::::::::::
  # -> END : Size Specific Processing
  # :::::::::::::::::::::::::::::::::::::::::
  
  echo -en "\tCopying large assets..."
  
  # copy largest assets for omni theme
  rsync -qaziru --exclude='item_bg*' --include='item_*' --exclude='*' "$folder_in/omni/$name/300/" "$folder_in/omni/$name"
  rsync -qaziru --include='*inline*' --exclude='*' "$folder_in/omni/$name/300/" "$folder_in/omni/$name"
  
  echo done
  
  echo -en "\tConstructing Walter Files..."
  
  # construct rtconfig for omni theme
  >$folder_in/omni/$name/rtconfig.txt
  cat wlt/hdr_$clr_name.txt >>$folder_in/omni/$name/rtconfig.txt
  cat wlt/clr_$clr_name.txt >>$folder_in/omni/$name/rtconfig.txt
  cat wlt/rtconfig.txt >>$folder_in/omni/$name/rtconfig.txt
  cat wlt/scale_omni.txt >>$folder_in/omni/$name/rtconfig.txt
  
  echo done
  
  echo -en "\tCreating ReaperThemeZip..."
  
  # create omni theme ReaperThemeZip
  pushd "$folder_in/omni" >/dev/null
  zip -qq -r "$org_path/$folder_out/$zip_name.ReaperThemeZip" .
  popd >/dev/null
  
  echo done
  
  echo -en "\tCleanup..."
  
  echo done

}

# - - - - - - - - - - - - - - - - - - - - -
#   User Choices
# - - - - - - - - - - - - - - - - - - - - -

# flush previoulsy used building ressources
flush_res=0

# ask if ressources should be flushed
if [ -z "$1" ]; then

  # type 'y' to accept
  while true; do
    read -p 'Remove previous resources? [y] ' yn
    case $yn in
    [Yy]*)
      flush_res=1
      break
      ;;
    *) break ;;
    esac
  done

fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Header Files
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo -n Creating Version Header Files...

# load version from version file
read -r release_tag <"rel/version"

# use version 1.0 if no version is given
if [ -z "$release_tag" ]; then
  release_tag="1.0"
fi

# create header files for theme files
CreateHeaderFile "./thm/hdr_dark.txt" "$release_tag" "paRt" "Dark"
CreateHeaderFile "./thm/hdr_dark_win.txt" "$release_tag" "paRt" "Dark - Windows"
CreateHeaderFile "./thm/hdr_light.txt" "$release_tag" "paRt" "Light"

# create header files for walter files
CreateHeaderFile "./wlt/hdr_dark.txt" "$release_tag" "paRt" "Dark"
CreateHeaderFile "./wlt/hdr_dark_win.txt" "$release_tag" "paRt" "Dark - Windows"
CreateHeaderFile "./wlt/hdr_light.txt" "$release_tag" "paRt" "Light"

echo done

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Preparing Assets
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# formatting theme meta files
cd "./thm"

./format_templates.sh
./create_win_dark_files.sh

cd ..

echo -n Clearing Folders...

# store paths
f_dark="./$folder_build/dark/omni/paRt_Dark"
f_dark_win="./$folder_build/dark_win/omni/paRt_Dark_Win"
f_light="./$folder_build/light/omni/paRt_Light"

# clear zip folder
\rm -rf "./$folder_zip/"

# optional -> clear build folder
if [ "$flush_res" -ne "0" ]; then
  \rm -rf "./$folder_build/"
fi

# create theme folders
mkdir -p "$f_dark"
mkdir -p "$f_dark_win"
mkdir -p "$f_light"

echo done

echo -n Copying Common Files...

# copy common files
find . -type d -wholename "*/out/common" | while read fname; do
  rsync -qau --include='*/' --include='*.png' --exclude='*' "$fname/" "$f_dark"
  rsync -qau --include='*/' --include='*.png' --exclude='*' "$fname/" "$f_dark_win"
  rsync -qau --include='*/' --include='*.png' --exclude='*' "$fname/" "$f_light"
done

echo done

echo -n Copying Dark Theme Files...

# copy dark theme files
find . -type d -wholename "*/out/dark" | while read fname; do
  rsync -qau --include='*/' --include='*.png' --exclude='*' "$fname/" "$f_dark"
  rsync -qau --include='*/' --include='*.png' --exclude='*' "$fname/" "$f_dark_win"
done

echo done

echo -n Copying Dark Theme - Windows Files...

# copy dark theme (windows) files, dark light assets
find . -type d -wholename "*/generic/out/light" | while read fname; do
  rsync -qau --include='*/' --include='*.png' --exclude='*' "$fname/" "$f_dark_win"
done

# copy dark theme (windows) files, special assets
find . -type d -wholename "*/out/dark_win" | while read fname; do
  rsync -qau --include='*/' --include='*.png' --exclude='*' "$fname/" "$f_dark_win"
done

echo done

echo -n Copying Light Theme Files...

# copy light theme files
find . -type d -wholename "*/out/light" | while read fname; do
  rsync -qau --include='*/' --include='*.png' --exclude='*' "$fname/" $f_light
done

echo done

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Creating Themes
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# create ReaperThemeZips for all themes
CreateThemeSet "./$folder_build/dark" "$folder_zip/dark" "paRt_Dark" "rtconfig_dark.txt" "dark" "paRt - Dark"
CreateThemeSet "./$folder_build/dark_win" "$folder_zip/dark_win" "paRt_Dark_Win" "rtconfig_dark_win.txt" "dark_win" "paRt - Dark - Windows"
CreateThemeSet "./$folder_build/light" "$folder_zip/light" "paRt_Light" "rtconfig_light.txt" "light" "paRt - Light"
