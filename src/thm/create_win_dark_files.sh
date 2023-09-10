#!/bin/bash

# define files
color_dark="clr_dark.txt"
color_light="clr_light.txt"
color_dark_win="clr_dark_win_overwrite.txt"
keys_filter="win_dark_keys.txt"
keys_filter_win="win_dark_keys_overwrite.txt"
out="clr_dark_win.txt"

echo -n Creating Dark Windows Theme...

# - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Grab Data from Light Theme Colors
# - - - - - - - - - - - - - - - - - - - - - - - - - -

# read the keys required from light theme
keys=()
while IFS= read -r line || [[ -n "$line" ]]; do
  keys+=("$line")
done < "$keys_filter"

# create output file from dark theme
cp -f "$color_dark" "$out"

# merge light theme with dark theme
while IFS= read -r line || [[ -n "$line" ]]; do
  
  # grab key and value
  key="${line%=*}"
  value="${line#*=}"
  
  # check if key matches filter
  if [[ "${keys[*]}" =~ "$key " ]]; then
    
    # update the value in the output file
    sed -i "s/^$key=.*/$key=$value/" "$out"
  fi

done < "$color_light"

# - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Grab Data from Dark Windows Theme Colors
# - - - - - - - - - - - - - - - - - - - - - - - - - -

# read the keys required from light theme
keys=()
while IFS= read -r line || [[ -n "$line" ]]; do
  keys+=("$line")
done < "$keys_filter_win"

# create output file from dark theme
# cp -f "$color_dark" "$out"

# merge light theme with dark theme
while IFS= read -r line || [[ -n "$line" ]]; do
  
  # grab key and value
  key="${line%=*}"
  value="${line#*=}"
  
  # check if key matches filter
  if [[ "${keys[*]}" =~ "$key " ]]; then
    
    # update the value in the output file
    sed -i "s/^$key=.*/$key=$value/" "$out"
  fi

done < "$color_dark_win"

echo done