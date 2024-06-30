import os
import glob
from PIL import Image, ImageEnhance, ImageChops, ImageOps
import fnmatch
import shutil
import yaml
import math

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Globals
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

path_to_lookup="../../../"
color_file="spritemaker_lookup.yml"

# console output
print_group_message=True
print_icon_message=False

# available elements
zoom_levels = (100,125,150,175,200,225, 250)
themes = ("dark", "dimmed", "light")
versions = ("v3", "v6")

# hover modulation
hover_brightness=1.2
hover_contrast=0.8

# resize filter
resize_filter=Image.BILINEAR

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Load Configuration data
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def load_config_data():

    global color_palette
    global variables
    global settings
    global default_copy_theme_folder
    global default_copy_source
    global default_copy_on

    # script_folder = os.path.dirname(os.path.abspath(__file__))
    script_folder = path_to_lookup

    # potential file candidates
    file_list = [
        f"{script_folder}/{color_file}.yml",
        f"{script_folder}/{color_file}.yaml",
        f"{script_folder}/{color_file}"
    ]

    # load file
    for file_path in file_list:
        if os.path.exists(file_path):
            with open(file_path, 'r') as file:

                data = yaml.safe_load(file)

                if "variables" in data:
                    variables = data["variables"]

                if "settings" in data:
                    settings = data["settings"]

                # convert rgb to tuples
                for group in data:
                    for section in data[group]:

                        if section != "rgb":
                            continue

                        for entry in data[group][section]:
                            data[group][section][entry] = tuple(data[group][section][entry])


                if "universal" in data:
                    color_palette = data["universal"]

                # theme palettes
                if "dark" in data:
                    color_palette["dark"] = data["dark"]
                if "dimmed" in data:
                    color_palette["dimmed"] = data["dimmed"]
                if "light" in data:
                    color_palette["light"] = data["light"]

            return

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#       Rescale
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def rescale(x:float, in_min:float, in_max:float, out_min:float, out_max:float):
    return min(max((x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min,out_min),out_max)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Method : Pick Color
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def pick_color(theme,color):

    # hex code
    if color.startswith("0x"):

        #pre-formatting
        color = color[2:]

        # padding
        color = color.ljust(6, '0')

        # values
        r = int(color[0:2], 16)
        g = int(color[2:4], 16)
        b = int(color[4:6], 16)
        a = int(color[6:8], 16) if len(color) >= 8 else 255

        return (r,g,b,a)


    rgba = ()

    # pick a color from theme / global palette
    if theme and color in color_palette[theme]["rgb"]:
        rgba =  color_palette[theme]["rgb"][color]
    elif color in color_palette["rgb"]:
        rgba =  color_palette["rgb"][color]

    # add remaining colors
    rgba = rgba + (0,) *  (max(0, 3 - len(rgba)))

    # default alpha to 1
    if len(rgba)<4:
        rgba = rgba + (255,)
    elif rgba[3]<=1:
        rgba = (rgba[0],rgba[1],rgba[2],int(rgba[3] * 255))


    return rgba

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Method : Adjust Image Alpha
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def adjust_image_alpha(img, alpha):
    r, g, b, a = img.split()
    new_alpha = a.point(lambda i: i * alpha)
    return Image.merge("RGBA", (r, g, b, new_alpha))

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Lists
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# colors
color_palette = {
    "off":(220,220,220),
    "on":(0,0,0),
    "red":(200,80,80)
}

color_palette["dark"]={}
color_palette["dimmed"]={}
color_palette["light"]={}

# icon sizes
sprite_size_lookup={
    100:30,
    125:35,
    150:45,
    175:49,
    200:60,
    225:63,
    250:75, 
}

color_filter_lookup={
    "record_button_off":((126,58,42),0.75,0),    
    "record_button_on": ((187,37,0),0.75,0),
    "red": ((163,82,109),0.1,0),
    "recarm": ((134,60,43),0.1,0.9),
    "solo_yellow": ((191,191,0),0.5,0),
    "solo_red": ((163,82,109),0.1,0),
    "solo_pink": ((168,57,150),0.1,0),
    "env_read": ((0,255,128),0.5,0),
    "env_latch": ((176,64,255),0.5,0),
    "env_preview": ((0,42,255),0.5,0),
    "env_touch": ((255,191,0),0.5,0),
    "env_write": ((255,0,0),0.5,0)
}

# neutral icon colors
sprite_neutral=[
    "toolbar_audio_waveform_properties*",
    "toolbar_ex_insert_open*",
    "toolbar_load*",
    "toolbar_new*",
    "toolbar_projprop*",
    "toolbar_redo*",
    "toolbar_save*",
    "toolbar_undo*",
    "toolbar_revert*",
    "toolbar_add*",
    "toolbar_delete*",
]

# off state buttons
sprite_off=[
    "*_off.png"
]

# on state buttons
sprite_on=[
    "*_on.png",
    "*ripple_all.png",
    "*ripple_one.png"
]

# v3 buttons
sprite_v3=[
    "*v3*"
]

# use last sprite as base
sprite_use_last=[
 "*_on.png",
 "*_one.png",
 "*_all.png",
 "*_record.png"
]

# remove original border
sprite_border_remove=[
    "toolbar_midi_mode_*",
    "toolbar_ex_tempo_match_*"
]

# clear dummy bitmap
filter_blank= [
    "toolbar_blank.png"
]

# force normal filter (no red)
filter_normal= [
    "toolbar_color_item_selected.png",
    "toolbar_color_take_lane.png",
]

# automation icons
filter_envelope = [
    "toolbar_env_auto*",
]

# color icons (rainbow)
filter_color = [
    "toolbar_color*",
]

# solo icons
filter_solo = [
    "toolbar_solo*",
]

# record icons
filter_rec_off = [
    "toolbar_record.png"
]

filter_rec_on = [
    "toolbar_record_on.png"
]

filter_rec = [
    "*record*"
]



# pixels for border removal
border_shave = {
    100:3,
    150:5,
    200:8
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Pattern Match
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def pattern_match(word, pattern_list):
    return any(fnmatch.fnmatch(word, pattern) for pattern in pattern_list)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Get Color Distance
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def color_distance(c1, c2):
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(c1, c2)))

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Combine Images
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def combine_images(image1, image2):
    
    # Resize image2 to match image1 if they are not the same size
    if image1.size != image2.size:
        image2 = image2.resize(image1.size, Image.ANTIALIAS)

    # Create a new image with transparency
    new_image = Image.new("RGBA", image1.size)

    # Composite image2 on top of image1 respecting alpha transparency
    new_image = Image.alpha_composite(new_image, image1)
    new_image = Image.alpha_composite(new_image, image2)

    return new_image

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Cut out Image
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def cut_out(image,image_cut):
    alpha1 = image.split()[3]
    alpha2 = image_cut.split()[3]
    combined_alpha = ImageChops.subtract(alpha1, alpha2)
    image.putalpha(combined_alpha)
    return image

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Filter Color
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def color_filter(image, target_color, tolerance, threshold):
    
    # Load the image
    pixels = image.load()

    # Create two new images for the filtered and non-filtered parts
    image_filtered = Image.new("RGBA", image.size)
    image_remains = image.convert("RGBA")
    filtered_pixels = image_filtered.load()

    # Process each pixel
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, a = pixels[x, y]
            
            # Calculate the distance to the target color
            distance = color_distance((r, g, b), target_color)

            # Calculate the maximum possible distance (255 for each channel)
            max_distance = color_distance((0, 0, 0), (255, 255, 255))
            
            distance = rescale(distance,0,255 - threshold * 255,0,255)
            
            # Normalize the distance and adjust alpha
            if distance < tolerance * max_distance and a > 0:
                new_alpha = int(a * (1 - distance / (tolerance * max_distance)))
                filtered_pixels[x, y] = (r, g, b, new_alpha)
                
            else:
                filtered_pixels[x, y] = (0, 0, 0, 0)
                
      
    image_remains = cut_out(image_remains,image_filtered)

    return image_filtered, image_remains

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Create Dummy
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def create_dummy(out_file,size):
    spritesheet = Image.new("RGBA", (size*3,size), (0, 0, 0, 0))
    spritesheet.save(out_file)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Create Spritesheet
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def create_spritesheet(theme,filename,base_sprite):

    # init spritesheet
    spritesheet = Image.new("RGBA", (base_sprite.width*3,base_sprite.height), (0, 0, 0, 0))

    filter="red"
    base_colors = [pick_color(theme,"toolbar_button_symbol_off"),pick_color(theme,"toolbar_button_symbol_off"),pick_color(theme,"toolbar_button_symbol_on")]

    if pattern_match(filename,sprite_neutral):
        base_colors = [pick_color(theme,"toolbar_button_symbol_off"),pick_color(theme,"toolbar_button_symbol_off"),pick_color(theme,"toolbar_button_symbol_off")]

    if pattern_match(filename,sprite_on):
        base_colors = [pick_color(theme,"toolbar_button_symbol_on"),pick_color(theme,"toolbar_button_symbol_on"),pick_color(theme,"toolbar_button_symbol_off")]

    if pattern_match(filename,sprite_v3):
        base_colors = [pick_color(theme,"toolbar_button_symbol_off"),pick_color(theme,"toolbar_button_symbol_off"),pick_color(theme,"toolbar_button_symbol_on")]

    if pattern_match(filename,filter_color):
        filter="color"

    if pattern_match(filename,filter_solo):
         base_colors = [pick_color(theme,"toolbar_button_symbol_off"),pick_color(theme,"toolbar_button_symbol_off"),pick_color(theme,"toolbar_button_symbol_on")]
         filter="solo"

    if pattern_match(filename,filter_envelope):
        filter="env"


    if pattern_match(filename,filter_rec):
        filter="rec"

    if pattern_match(filename,filter_rec_off):
         filter="rec_off"
         base_colors = [pick_color(theme,"toolbar_button_symbol_off"),pick_color(theme,"toolbar_button_symbol_off"),pick_color(theme,"toolbar_button_symbol_off")]

    if pattern_match(filename,filter_rec_on):
         filter="rec_on"
         base_colors = [pick_color(theme,"toolbar_button_symbol_on"),pick_color(theme,"toolbar_button_symbol_on"),pick_color(theme,"toolbar_button_symbol_on")]


    # color overlay
    color_img = None

    sprites = [base_sprite,base_sprite,base_sprite]

    # record icon
    if filter=="rec_off" :
        sprite_filter, sprite_rest = color_filter(base_sprite,color_filter_lookup["record_button_off"][0],color_filter_lookup["record_button_off"][1],color_filter_lookup["record_button_off"][2])
        sprite_filter = tint_image(sprite_filter,pick_color(theme, "color_red"))
        
        sprites[0] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[0]))
        sprites[1] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[1]))
        sprites[2] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[2]))

    # record icon on
    if filter=="rec_on" :
        sprite_filter, sprite_rest = color_filter(base_sprite,color_filter_lookup["record_button_on"][0],color_filter_lookup["record_button_on"][1],color_filter_lookup["record_button_on"][2])
        sprite_filter = tint_image(sprite_filter,pick_color(theme, "color_red"))
        
        sprites[0] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[0]))
        sprites[1] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[1]))
        sprites[2] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[2]))        

    # record
    if filter=="rec" :
        sprite_filter, sprite_rest = color_filter(base_sprite,color_filter_lookup["recarm"][0],color_filter_lookup["recarm"][1],color_filter_lookup["recarm"][2])
        sprite_filter = tint_image(sprite_filter,pick_color(theme, "color_red"))
        
        sprites[0] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[0]))
        sprites[1] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[1]))
        sprites[2] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[2]))        

    # universal filer
    if not filter :
        sprites[0] = tint_image(base_sprite,base_colors[0])
        sprites[1] = tint_image(base_sprite,base_colors[1])
        sprites[2] = tint_image(base_sprite,base_colors[2])

    # red filter
    if filter=="red" :
        sprite_filter, sprite_rest = color_filter(base_sprite,color_filter_lookup["red"][0],color_filter_lookup["red"][1],color_filter_lookup["red"][2])
        sprite_filter = tint_image(sprite_filter,pick_color(theme, "color_red"))
        
        sprites[0] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[0]))
        sprites[1] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[1]))
        sprites[2] = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[2]))

    # automation icons
    if filter=="env" :

        # top/bottom split
        w = base_sprite.width
        y_top = round(0.65 * base_sprite.height)
        y_bot = base_sprite.height

        img_top = base_sprite.crop((0,0,w,y_top))
        img_bot = base_sprite.crop((0,y_top,w,y_bot))

        sprite_filter = Image.new("RGBA",base_sprite.size,(0,0,0,0)) 
        sprite_rest = base_sprite.copy()

        if "read" in filename:
            sprite_filter, sprite_rest = color_filter(img_top,color_filter_lookup["env_read"][0],color_filter_lookup["env_read"][1],color_filter_lookup["env_read"][2])
            sprite_filter = tint_image(sprite_filter,pick_color(theme, "color_blue"))

        if "latch" in filename:
            sprite_filter, sprite_rest = color_filter(img_top,color_filter_lookup["env_latch"][0],color_filter_lookup["env_latch"][1],color_filter_lookup["env_latch"][2])
            sprite_filter = tint_image(sprite_filter,pick_color(theme, "color_yellow"))

        if "preview" in filename:
            sprite_filter, sprite_rest = color_filter(img_top,color_filter_lookup["env_preview"][0],color_filter_lookup["env_preview"][1],color_filter_lookup["env_preview"][2])
            sprite_filter = tint_image(sprite_filter,pick_color(theme, "color_yellow"))

        if "touch" in filename:
            sprite_filter, sprite_rest = color_filter(img_top,color_filter_lookup["env_touch"][0],color_filter_lookup["env_touch"][1],color_filter_lookup["env_touch"][2])
            sprite_filter = tint_image(sprite_filter,pick_color(theme, "color_violet"))

        if "write" in filename:
            sprite_filter, sprite_rest = color_filter(img_top,color_filter_lookup["env_write"][0],color_filter_lookup["env_write"][1],color_filter_lookup["env_write"][2])
            sprite_filter = tint_image(sprite_filter,pick_color(theme, "color_red"))
        
        sprite_rest = sprite_rest.convert("LA")
        sprite_rest = sprite_rest.convert("RGBA")
        img_top_0 = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[0]))
        img_top_1 = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[1]))
        img_top_2 = combine_images(sprite_filter,tint_image(sprite_rest,base_colors[2]))
                
        img_bot = adjust_alpha_contrast(img_bot,1.5,0.5)
        img_bot_0 = tint_image(img_bot,base_colors[0])
        img_bot_1 = tint_image(img_bot,base_colors[1])
        img_bot_2 = tint_image(img_bot,base_colors[2])

        sprite_out = Image.new("RGBA",base_sprite.size,(0,0,0,0))
        sprites[0] = sprite_out.copy()
        sprites[1] = sprite_out.copy()
        sprites[2] = sprite_out.copy()

        sprites[0].paste(img_top_0,(0,0),img_top_0)
        sprites[1].paste(img_top_1,(0,0),img_top_1)
        sprites[2].paste(img_top_2,(0,0),img_top_2)

        sprites[0].paste(img_bot_0,(0,y_top),img_bot_0)
        sprites[1].paste(img_bot_1,(0,y_top),img_bot_1)
        sprites[2].paste(img_bot_2,(0,y_top),img_bot_2)

    # color related icons
    if filter=="color":
        base_sprite, color_img = hsl_filter_image(base_sprite,127,1)
        sprites[0] = tint_image(color_img,base_colors[0])
        sprites[1] = tint_image(color_img,base_colors[1])
        sprites[2] = tint_image(color_img,base_colors[2])
        sprites[0] = Image.alpha_composite(sprites[0],base_sprite)
        sprites[1] = Image.alpha_composite(sprites[1],base_sprite)
        sprites[2] = Image.alpha_composite(sprites[2],base_sprite)

    # solo icons
    if filter=="solo":
        sprite_yellow, sprite_rest = color_filter(base_sprite,color_filter_lookup["solo_yellow"][0],color_filter_lookup["solo_yellow"][1],color_filter_lookup["solo_yellow"][2])
        sprite_red, sprite_rest = color_filter(base_sprite,color_filter_lookup["solo_red"][0],color_filter_lookup["solo_red"][1],color_filter_lookup["solo_red"][2])
        sprite_pink, sprite_rest = color_filter(base_sprite,color_filter_lookup["solo_pink"][0],color_filter_lookup["solo_pink"][1],color_filter_lookup["solo_pink"][2])
        sprite_red = tint_image(sprite_red,pick_color(theme, "color_red"))
        sprite_pink = tint_image(sprite_pink,pick_color(theme, "color_red"))
        
        sprite_colors = combine_images(sprite_pink,sprite_red)
        sprite_rest = cut_out(base_sprite, sprite_yellow)
        sprite_rest = cut_out(sprite_rest, sprite_colors)
        
        sprites[0] = combine_images(sprite_colors, tint_image(sprite_rest,base_colors[0]))
        sprites[1] = combine_images(sprite_colors, tint_image(sprite_rest,base_colors[1]))
        sprites[2] = combine_images(sprite_colors, tint_image(sprite_rest,base_colors[2]))

    # alpha modifier
    for idx, sprite in enumerate(sprites):        
        sprites[idx] = adjust_image_alpha(sprite, base_colors[idx][3]/255 )

    # construct spritesheet
    pos_1 = (0,0)
    pos_2 = (base_sprite.width,0)
    pos_3 = (2 * base_sprite.width,0)
    spritesheet.paste(sprites[0], pos_1)
    spritesheet.paste(sprites[1], pos_2)
    spritesheet.paste(sprites[2], pos_3)

    return spritesheet

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Get Color
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def get_color(theme,color):

    # check various palettes for available color
    if theme in color_palette and color in color_palette[theme]:
        return color_palette[theme][color]
    elif color in color_palette:
        return color_palette[color]
    else:
        return (0,0,0)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Add Color
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def color_add(color,add):
    r = min(max(color[0]+add,0),255)
    g = min(max(color[1]+add,0),255)
    b = min(max(color[2]+add,0),255)

    return (r,g,b)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Modify Alpha
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def mod_alpha(image, factor):

    # multiply alpha by factor
    img_rgba = image.convert("RGBA")
    r,g,b,a = image.split()

    a = a.point(lambda i: i * factor)

    return Image.merge("RGBA",(r,g,b,a))


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Modify HSL
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def mod_hsl(image, mod_h,mod_s,mod_l):

    # Separate channels
    r,g,b,a = image.split()
    img_hsl = image.convert('HSV')
    h, s, l = img_hsl.split()

    # Apply Hue shift
    h = h.point(lambda i: (i + mod_h ) % 256)

    # Apply Saturation and Lightness factors
    s = s.point(lambda i: i * mod_s)
    l = l.point(lambda i: i * mod_l)

    # Merge channels back
    img_hsl = Image.merge('HSV', (h, s, l))

    # Convert back to RGB mode
    image = img_hsl.convert('RGBA')
    image.putalpha(a)

    return image

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Apply Curve to Pixel
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def apply_curve_to_pixel(value, curve_factor):
    return int(255 * (value / 255) ** curve_factor)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Modify Alpha Contrast
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def adjust_alpha_contrast(image, contrast_factor=1, curve_factor=1):
    # Ensure the image has an alpha channel
    if image.mode != 'RGBA':
        raise ValueError("Image must be in RGBA mode")

    # Split the image into its component channels
    r, g, b, alpha = image.split()

    # Apply curve adjustment to the alpha channel
    alpha = alpha.point(lambda p: apply_curve_to_pixel(p, curve_factor))

    # Enhance the contrast of the alpha channel
    enhancer = ImageEnhance.Contrast(alpha)
    alpha_enhanced = enhancer.enhance(contrast_factor)

    # Recombine the channels back into an RGBA image
    adjusted_image = Image.merge("RGBA", (r, g, b, alpha_enhanced))

    return adjusted_image

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Modify Brightness / Contrastt
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def brightness_contrast(image,brightness,contrast):
    enhanced_image = ImageEnhance.Brightness(image).enhance(brightness)
    enhanced_image = ImageEnhance.Contrast(enhanced_image).enhance(contrast)

    return enhanced_image

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Check for Color Amount
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def check_for_color_amount(image, hue_center,hue_range,threshold=0.001):

    # conversion
    search_hsv = image.convert("HSV")

    # range and counters
    lower_hue = hue_center - hue_range
    upper_hue = hue_center + hue_range
    overshoot = 0
    pixel_count = 0

    # collect pixels
    for pixel in search_hsv.getdata():
        if lower_hue <= pixel[0] + overshoot <= upper_hue:
            pixel_count += 1

    # calculate color amount
    percentage = pixel_count/(search_hsv.width*search_hsv.height)

    return percentage > threshold


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Color Filter Image
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def hsl_filter_image(image, hue_center,hue_range):

    # copy and convert
    image = image.copy()
    search_hsv = image.convert("HSV")
    color_img = Image.new("RGBA",image.size, (0,0,0,0))

    # iterate pixels
    for y in range(image.height):
        for x in range(image.width):

            # get rgba and hsl pixel
            r,g,b, alpha = image.getpixel((x, y))
            hue, saturation, value = search_hsv.getpixel((x, y))

            # calculate hue distance
            hue_distance = abs(hue-hue_center)

            # check if color is valid
            if alpha > 0 and hue_distance<hue_range:

                # calculate alpha based on distance
                distance_factor = 1 - (hue_distance/hue_range)
                a1 = round(alpha*distance_factor)
                a2 = round(alpha*(1-distance_factor))

                # change pixel of filtered and original image
                color_img.putpixel((x, y), (r,g,b,a1))
                image.putpixel((x, y), (r,g,b,a2))
            else:
                color_img.putpixel((x, y), (0, 0,0,0))

    return image, color_img

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Tint Image
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def tint_image(image,color):
    filled_image = Image.new('RGBA', image.size, color)
    filled_image.putalpha(image.split()[3])
    return filled_image

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Colorize Image
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def colorize_image(img, theme, tint):
    
    # grab alpha, make grayscale
    r,g,b,a = img.split()
    img = img.convert("L")
    
    # target color
    mid_color = pick_color(theme,tint)

    # colorize
    img = ImageOps.colorize(img, (0,0,0),(255,255,255), mid=mid_color, blackpoint=0, whitepoint=255, midpoint=127)
    img = img.convert("RGBA")
    img.putalpha(a)
    
    return img


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Method : Create Icons
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def create_icons(theme,zoom,version):

    # base zoom level
    source_zoom = 100

    if zoom>100:
        source_zoom = 150
    if zoom>150:
        source_zoom = 200

    # get source path
    org_path = f"{os.getcwd()}/original/{version}/{source_zoom}/*.png"

    # go through original bitmaps
    for org_file in glob.glob(org_path):

        # paths
        filename = os.path.basename(org_file)

        out_path = f"{os.getcwd()}/{theme}/{version}/{zoom}/"    

        out_file = f"{out_path}/{filename}"

        # info message
        if print_icon_message:
            print(f"Creating {zoom} - {theme} - {filename}...", end='',flush=True)

        # special options
        use_last = pattern_match(filename,sprite_use_last)
        remove_border = pattern_match(filename,sprite_border_remove)
        is_blank = pattern_match(filename,filter_blank)

        # dummy graphic
        if is_blank:
            create_dummy(out_file,sprite_size)
            continue

        # init bitmap
        sprite_size = sprite_size_lookup[zoom]

        spritesheet = Image.open(org_file)
        spritesheet = spritesheet.convert('RGBA')

        sprite_width = spritesheet.width // 3
        sprite_height = spritesheet.height

        # pick base sprite
        if not use_last:
            base_sprite = spritesheet.crop((0, 0, sprite_width, sprite_height))
        else:
            base_sprite = spritesheet.crop((sprite_width*2 , 0, sprite_width*2+sprite_width, sprite_height))

        # crop border
        if remove_border:
            border = border_shave[source_zoom]
            w = base_sprite.width-border
            h = base_sprite.height-border
            crop_img = base_sprite.crop((border,border,w,h))
            base_sprite = Image.new("RGBA", base_sprite.size, (0, 0, 0, 0))
            base_sprite.paste(crop_img, (border,border),crop_img)

        # create graphic
        spritesheet = create_spritesheet(theme,filename,base_sprite)

        # resize
        if sprite_size != sprite_width:
            spritesheet = spritesheet.resize((sprite_size*3,sprite_size), resize_filter)

        # output
        spritesheet.save(out_file)

        if print_icon_message:
            print("done")

    pass

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#           Processing
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# load spritemaker config
load_config_data()

for theme in themes:
    
    base_path = f"{os.getcwd()}/{theme}/"
    
    if os.path.exists(base_path):
        shutil.rmtree(base_path)

    for zoom in zoom_levels:

        # info message
        if print_group_message:
            print(f"Creating toolbar icons for {zoom} - {theme}...",end='',flush=True)

        for version in versions:

            # create directories
            
            path = f"{base_path}/{version}/{zoom}"

            if not os.path.exists(path):
                os.makedirs(path)

            create_icons(theme,zoom,version)

        if print_group_message:
            print("done")

