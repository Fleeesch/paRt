#!/bin/bash
SPRITEMAKER_FILE="spritemaker.py"
if [ -f "../$SPRITEMAKER_FILE" ]; then
    python ../$SPRITEMAKER_FILE --folder "$(pwd)"
fi

python make_spritesheet.py

#!/bin/bash

# Define source and target directories
SOURCE_DIR="out_sheet/*"
themeadj_src="../../scripts/themeadj/lib/res/icon"
themeadj_dev="../../../reaper/scripts/fleeesch/themes/part/lib/res/icon"

# Function to clean and copy files if target directory exists
clean_and_copy() {
    local target_dir="$1"

    # Check if the target directory exists
    if [ -d "$target_dir" ]; then
        # Delete the contents of the target directory
        rm -rf "$target_dir"/*

        # Copy files from source to target directory
        cp -r $SOURCE_DIR "$target_dir/"
    fi
}

# Global status message
echo -en "\033[0;37mCopying files...\033[0m"  # Neutral text color (light gray)
clean_and_copy "$themeadj_src"
clean_and_copy "$themeadj_dev"
echo -e "\033[0;32mdone\033[0m"  # Green text for "done"
