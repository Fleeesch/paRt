import os
import shutil
from PIL import Image

print("\033[0;37mCreating spritesheet...\033[0m", end='', flush=True)

# Define the output directory and DPI scales
out_sheet_dir = 'out_sheet'
themes = ["dark", "dimmed", "light"]
dpi_scales = [100, 125, 150, 175, 200, 225, 250]

# Create the output directory if it does not exist
if not os.path.exists(out_sheet_dir):
    os.makedirs(out_sheet_dir)

def get_image_list(directory):
    return [os.path.join(directory, img) for img in os.listdir(directory) if img.endswith('.png')]

# Collect images by theme and DPI scale
theme_images = {theme: {dpi: [] for dpi in dpi_scales} for theme in themes}

# Load images from each theme directory and DPI scale
for theme in themes:
    # Add images for 100% DPI (directly in the theme folder)
    theme_images[theme][100] = get_image_list(f'out/{theme}')
    
    # Add images for other DPI scales (inside respective subfolders)
    for dpi in dpi_scales[1:]:
        dpi_dir = f'out/{theme}/{dpi}'
        if os.path.exists(dpi_dir):
            theme_images[theme][dpi] = get_image_list(dpi_dir)

# Initialize dictionaries to store widths and heights
theme_widths = {theme: {dpi: 0 for dpi in dpi_scales} for theme in themes}
theme_heights = {theme: {dpi: 0 for dpi in dpi_scales} for theme in themes}

# Load images and calculate dimensions
loaded_images = {theme: {dpi: [] for dpi in dpi_scales} for theme in themes}
for theme in themes:
    for dpi in dpi_scales:
        img_paths = theme_images[theme][dpi]
        if img_paths:
            loaded_images[theme][dpi] = [Image.open(img) for img in img_paths]
            theme_widths[theme][dpi] = max(img.width for img in loaded_images[theme][dpi])
            theme_heights[theme][dpi] = sum(img.height for img in loaded_images[theme][dpi])

# Calculate total width and max height for the final spritesheet
total_width = sum(theme_widths[theme][dpi] for dpi in dpi_scales for theme in themes)
max_height = max(theme_heights[theme][dpi] for dpi in dpi_scales for theme in themes)

# Create a new blank image for the final spritesheet
final_spritesheet = Image.new('RGBA', (total_width, max_height))

# Metadata dictionary to store info about each sprite
metadata = {theme: {dpi: {} for dpi in dpi_scales} for theme in themes}

# Paste each theme's sprites vertically stacked into the final spritesheet
x_offset = 0

for dpi in dpi_scales:
    for theme in themes:
        y_offset = 0
        for img_path in theme_images[theme][dpi]:
            img = Image.open(img_path)
            final_spritesheet.paste(img, (x_offset, y_offset))
            
            # Strip the .png extension from the name
            name = os.path.basename(img_path).replace('.png', '')

            # Collect metadata
            metadata[theme][dpi][name] = {
                'width': img.width,
                'height': img.height,
                'x': x_offset,
                'y': y_offset
            }
            
            y_offset += img.height
        x_offset += theme_widths[theme][dpi]

# Save the final spritesheet
final_spritesheet.save(f'{out_sheet_dir}/themeadj_sprites.png')

# Create Lua file
lua_file_path = f'{out_sheet_dir}/themeadj_sprites.lua'
with open(lua_file_path, 'w') as lua_file:
    lua_file.write('return {\n')
    for theme, dpi_data in metadata.items():
        lua_file.write(f'  {theme} = {{\n')
        for dpi, sprites in dpi_data.items():
            lua_file.write(f'    [{dpi}] = {{\n')
            for name, data in sprites.items():
                lua_file.write(f"      {name} = {{ width = {data['width']}, height = {data['height']}, x = {data['x']}, y = {data['y']} }},\n")
            lua_file.write('    },\n')
        lua_file.write('  },\n')
    lua_file.write('}\n')

print("\033[0;32mdone\033[0m")
