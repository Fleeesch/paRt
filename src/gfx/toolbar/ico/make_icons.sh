#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Function : Sharpen Image
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function SharpenImage {
    
    out=$1
    sharpness=$2
    
    if [ "$sharpness" -le "0" ]; then
        return
    fi

    convert "${out}" -unsharp "0x${sharpness}" +repage "${out}"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Function : Convert Icon Set
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ConvertIconSet {
    
    # arguments
    mode=$1
    dir=$2
    size_source=$3
    dir_out=$4
    size_out=$5
    sharpen=$6
    
    #  base neutral color
    clr='#FFFFFF'
    
    # theme specific neutral colors
    if [ $mode = "dark" ]; then
        clr='#E6E6E6'
    else
        clr='#FFFFFF'
    fi
    
    # size calculation (double width)
    wid=$size_source
    wid2=$(expr $size_source '*' 2)
    
    widout=$size_out
    widout2=$(expr $size_out '*' 2)
    
    #- - - - - - - - - - - - - - - -
    #       V6
    #- - - - - - - - - - - - - - - -
    
    for pic in ./original/v6/$dir/*.png; do
        
        echo -n Making $(basename -- "$pic") at $mode-$dir_out ...
        
        # skip blank image
        if [[ "$pic" == *"blank"* ]]; then
            continue
        fi
        
        # output file path
        out="./$mode/v6/$dir_out/$(basename -- "$pic")"
        
        # skip if file exists
        if [ -f "${out}" ]; then
            echo done
            continue
        fi
        
        # default sprite position for sheet
        pic_pos=0
        
        # on files use the the last sprite
        if [[ "$pic" == *"_on.png" ]] || [[ "$pic" == *"_one.png" ]] || [[ "$pic" == *"_all.png" ]]; then
            pic_pos=2
        fi
        
        # crop sprite
        case $pic_pos in
        0) convert "${pic}" -crop ${wid}x${wid}+0+0 +repage "${out}" ;;
        1) convert "${pic}" -crop ${wid}x${wid}+${wid}+0 +repage "${out}" ;;
        2) convert "${pic}" -crop ${wid}x${wid}+${wid2}+0 +repage "${out}" ;;
        esac
        
        # remove border if necessary
        if [[ "$pic" == *"toolbar_midi_mode_"* ]] || [[ "$pic" == *"toolbar_ex_tempo_match_"* ]]; then
            
            # size 100
            if [ "$dir" -eq "100" ]; then
                convert "${out}" -background none -gravity center -shave 3x3 -bordercolor none -border 3 "${out}"
            fi
            # size 150
            if [ "$dir" -eq "150" ]; then
                convert "${out}" -background none -gravity center -shave 5x5 -bordercolor none -border 5 "${out}"
            fi
            # size 200
            if [ "$dir" -eq "200" ]; then
                convert "${out}" -background none -gravity center -shave 8x8 -bordercolor none -border 8 "${out}"
            fi
        fi
        
        # resizing
        convert "${out}" -resize ${widout}x${widout} +repage "${out}"
        
        # sharpen image
        SharpenImage "${out}" "${sharpen}"
        
        # create sprite sheet
        convert +append "${out}" "${out}" "${out}" "${out}"
        
        # colorize
        convert "${out}" -define png:color-type=6 -fill $clr -colorize 100 "${out}"
        
        # context sensitive darkening
        if [[ "$pic" == *"_on.png" ]] || [[ "$pic" == *"_one.png" ]] || [[ "$pic" == *"_all.png" ]]; then
            # on button, all black
            convert "${out}" -define png:color-type=6 -fill black -colorize 100 "${out}"
        elif [[ "$pic" == *"midi_events_mode"* ]] || [[ "$pic" == *"midi_step"* ]] || [[ "$pic" == *"midi_mode"* ]]; then
            # ordinary off / off / on pattern, last sprite black
            convert "${out}" \( +clone -crop ${widout}x${widout} +repage -fill black -colorize 100 \) -gravity east -compose copy -composite "${out}"
        fi
        
        echo done
    
    done
    
    #- - - - - - - - - - - - - - - -
    #       V3
    #- - - - - - - - - - - - - - - -
    
    for pic in ./original/v3/$dir/*.png; do
        
        echo -n Making $(basename -- "$pic") at $mode-$dir_out ...
        
        # skip blank template
        if [[ "$pic" == *"blank"* ]]; then
            continue
        fi
        
        # store output file path
        out="./$mode/v3/$dir_out/$(basename -- "$pic")"
        
        # skip if file exists
        if [ -f "${out}" ]; then
            echo done
            continue
        fi

        # crop first sprite
        convert "${pic}" -crop ${wid}x${wid}+0+0 +repage "${out}"
        
        # resizing
        convert "${out}" -resize ${widout}x${widout} +repage "${out}"
        
        # sharpen image
        SharpenImage "${out}" "${sharpen}"
        
        # create sprite sheet and colorize it
        convert +append "${out}" "${out}" "${out}" "${out}"
        convert "${out}" -define png:color-type=6 -fill $clr -colorize 100 "${out}"
        
        # make last sprite dark
        convert "${out}" \( +clone -crop ${widout}x${widout} +repage -fill black -colorize 100 \) -gravity east -compose copy -composite "${out}" # last sprite black
        
        echo done
    
    done

}

# sort v6 files
#source sort_v6_files.sh

echo
echo - - - - - - - - - - - - - - - - - - - 
echo Creating Icons...
echo - - - - - - - - - - - - - - - - - - - 
echo


# optionally clear folders
#rm -r dark
#rm -r light

# ------------------------
# Create Dark Folders

mkdir -p dark/v3/100
mkdir -p dark/v3/125
mkdir -p dark/v3/150
mkdir -p dark/v3/175
mkdir -p dark/v3/200
mkdir -p dark/v3/225
mkdir -p dark/v3/250
mkdir -p dark/v3/275
mkdir -p dark/v3/300
mkdir -p dark/v3/350

mkdir -p dark/v6/100
mkdir -p dark/v6/125
mkdir -p dark/v6/150
mkdir -p dark/v6/175
mkdir -p dark/v6/200
mkdir -p dark/v6/225
mkdir -p dark/v6/250
mkdir -p dark/v6/275
mkdir -p dark/v6/300
mkdir -p dark/v6/350

# ------------------------
# Create Light Folders

mkdir -p light/v3/100
mkdir -p light/v3/125
mkdir -p light/v3/150
mkdir -p light/v3/175
mkdir -p light/v3/200
mkdir -p light/v3/225
mkdir -p light/v3/250
mkdir -p light/v3/275
mkdir -p light/v3/300
mkdir -p light/v3/350

mkdir -p light/v6/100
mkdir -p light/v6/125
mkdir -p light/v6/150
mkdir -p light/v6/175
mkdir -p light/v6/200
mkdir -p light/v6/225
mkdir -p light/v6/250
mkdir -p light/v6/275
mkdir -p light/v6/300
mkdir -p light/v6/350

# ------------------------
# Create Icons

ConvertIconSet "dark" 100 30 100 30 0
ConvertIconSet "dark" 150 45 125 35 2
ConvertIconSet "dark" 150 45 150 45 0
ConvertIconSet "dark" 200 60 175 49 2
ConvertIconSet "dark" 200 60 200 60 0
ConvertIconSet "dark" 200 60 225 63 2
ConvertIconSet "dark" 200 60 250 75 2
ConvertIconSet "dark" 200 60 275 77 2
ConvertIconSet "dark" 200 60 300 90 3
ConvertIconSet "dark" 200 60 350 105 3

ConvertIconSet "light" 100 30 100 30 0
ConvertIconSet "light" 150 45 125 35 2
ConvertIconSet "light" 150 45 150 45 0
ConvertIconSet "light" 200 60 175 49 2
ConvertIconSet "light" 200 60 200 60 0
ConvertIconSet "light" 200 60 225 63 2
ConvertIconSet "light" 200 60 250 75 2
ConvertIconSet "light" 200 60 275 77 2
ConvertIconSet "light" 200 60 300 90 3
ConvertIconSet "light" 200 60 350 105 3


echo
echo - - - - - - - - - - - - - - - - - - - 
echo Done!
echo - - - - - - - - - - - - - - - - - - - 
