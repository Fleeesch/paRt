from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageOps
import os
import shutil
import re

# Console Output
YELLOW = "\033[33m"
GREEN = "\033[32m"
RESET = "\033[0m"

def printProgressStart(message):
    print(f"{RESET}{message}...{RESET}", end='', flush=True)

def printProgressEnd():
    print(f"{GREEN}done{RESET}")

# pixels trimmed of the top depending on the filename
trim_values = {
    "100" : 20,
    "125" : 25,
    "150" : 30,
    "175" : 34,
    "200" : 39,
    "225" : 44,
    "250" : 49,
    
}

# dpi values of resolution
trim_values_resolution = {
    "fhd" : 100,
    "qhd" : 125,
    "uhd" : 150,
}

#   Function : Change Alpha of Image
# --------------------------------------------------
def change_alpha(image, alpha_level):
    if image.mode != 'RGBA':
        return image

    r, g, b, a = image.split()
    a = a.point(lambda p: int(p * alpha_level))
    new_image = Image.merge('RGBA', (r, g, b, a))
    
    return new_image


#   Function : Fill Image with Color
# --------------------------------------------------

def fill_image(img, color):

    if img.mode != "RGBA":
        img = img.convert("RGBA")
        
    r, g, b = color[:3]
    
    # create a solid color image with same size
    color_img = Image.new("RGBA", img.size, (r, g, b, 255))
    
    # copy original alpha
    color_img.putalpha(img.getchannel("A"))
    
    return color_img

#   Function : Adjust Image Alpha
# --------------------------------------------------

def adjust_image_alpha(img, alpha):

    r, g, b, a = img.split()
    new_alpha = a.point(lambda i: i * alpha)
    return Image.merge("RGBA", (r, g, b, new_alpha))

#   Function : Add Drop Shadow to an Image
# --------------------------------------------------

def add_shadow(input_path, output_path, offset=(0, 4), shadow_color=(0, 0, 0, 200), blur_radius=4):
    
    # Load the original image
    original = Image.open(input_path).convert("RGBA")
    
    # extended size
    new_size = (original.width + abs(offset[0]) + blur_radius*4, 
                original.height + abs(offset[1]) + blur_radius*4)

    # shadow
    shadow = Image.new("RGBA",new_size)
    shadow.paste(original,(offset[0] + blur_radius*2,offset[1] + blur_radius*2),original)
    shadow = shadow.filter(ImageFilter.GaussianBlur(blur_radius))
    shadow = fill_image(shadow,shadow_color)
    shadow = adjust_image_alpha(shadow,shadow_color[3] / 255)

    # output image
    output = Image.new("RGBA", new_size)
    output.paste(shadow,(0,0),shadow)
    output.paste(original,(blur_radius*2,blur_radius*2),original)

    output.save(output_path, format="PNG")

#   Function : Trim Screenshots
# --------------------------------------------------

def trim_screenshots():

    # iterate screenshots
    for file_name in os.listdir(sshot_folder):
        # screenshot
        img_sshot = Image.open(f"{sshot_folder}/{file_name}").convert("RGBA")

        # get trim value
        trim = 0
        
        pick_dpi = True

        # try to find dpi of resolution
        for lookup_name in trim_values_resolution:
            if lookup_name in file_name:
                dpi = str(trim_values_resolution[lookup_name])
                if trim_values[dpi] is not None:
                    trim =  trim_values[dpi]
                    pick_dpi = False

        # try to find dpi directly
        if pick_dpi:
            for lookup_name in trim_values:
                if lookup_name in file_name:
                    trim = int(trim_values[lookup_name])
        
        # crop screenshot
        left = 0
        right = img_sshot.width
        top = trim
        bottom = img_sshot.height
        
        img_sshot = img_sshot.crop((left, top, right, bottom))
        
        img_sshot.save(os.path.join(sshot_out_folder, file_name))


#   Function : Create Board Thumbnail
# --------------------------------------------------

def create_board_thumb(sshot,out_name,label,FitScreenshot=True):
    
    # screenshot
    img_sshot = Image.open(sshot).convert("RGBA")

    # resize screenshot
    if FitScreenshot:
        aspect_ratio = img_sshot.height / img_sshot.width
        new_width = img_thumb_header_bg.width
        new_height = int(new_width * aspect_ratio)
        img_sshot = img_sshot.resize((new_width, new_height), Image.LANCZOS)
        
    # crop screenshot
    left = 0
    right = img_thumb_header_bg.width
    top = 0
    bottom = img_thumb_header_bg.height

    if FitScreenshot:
        left = 0
        right = min(img_sshot.width, img_thumb_header_bg.width)
        top = max(img_sshot.height - img_thumb_header_bg.height, 0)
        bottom = top + img_thumb_header_bg.height
    
    img_sshot = img_sshot.crop((left, top, right, bottom))
    
    # combine sprites
    sprite = Image.new('RGBA', img_thumb_header_bg.size, (255,255,255,0))
    sprite.paste(img_sshot, (0, 0), img_thumb_sshot_mask)
    sprite = Image.alpha_composite(sprite,img_thumb_header_bg)

    # top label
    label_image = Image.new('RGBA', sprite.size,LABEL_FONT_COLOR)
    label_text = Image.new('L', sprite.size,0)
    draw = ImageDraw.Draw(label_text)

    # label font
    try:
        font = ImageFont.truetype("c/windows/fonts/calibril.ttf", LABEL_FONT_SIZE) 
    except IOError:
        font = ImageFont.load_default()

        
    # label position
    bbox = draw.textbbox((0, 0), label, font=font)
    text_width = bbox[2] - bbox[0]
    text_x = (label_text.width - text_width) // 2
    text_y = 7

    # draw and paste font
    draw.text((text_x, text_y), label, fill=255, font=font)        
    label_image.putalpha(label_text)
    
    sprite = Image.alpha_composite(sprite,label_image)

    # paste border on top
    sprite = Image.alpha_composite(sprite,img_thumb_border)
    
    # output
    out_name = out_name.replace("part_","part_bb_")
    
    out_path = output_folder + "/bb"

    if not os.path.exists(out_path):
        os.makedirs(out_path)

    out_filename = os.path.join(out_path, out_name)
    sprite.save(out_filename)
    add_shadow(out_filename,out_filename)

#   Function : Create large Board Thumbnail
# --------------------------------------------------

def create_board_thumb_large(sshot,out_name):
    
    # resizing
    img_sshot = Image.open(sshot).convert("RGBA")

    aspect_ratio = img_sshot.height / img_sshot.width
    new_width = 900
    new_height = int(new_width * aspect_ratio)
    img_sshot = img_sshot.resize((new_width, new_height), Image.LANCZOS)
    
    # frame data
    size_factor = 10
    corner_radius = 8*size_factor
    border_width=15

    # rounded mask
    frame_mask = Image.new("L", (img_sshot.width*size_factor,img_sshot.height*size_factor), 0)
    frame_draw = ImageDraw.Draw(frame_mask)
    frame_draw.rounded_rectangle([0, 0, frame_mask.size[0], frame_mask.size[1]], radius=corner_radius, fill=255)    
    frame_mask = frame_mask.resize((img_sshot.width, img_sshot.height), Image.LANCZOS)

    border_img = Image.new("RGBA", (img_sshot.width*size_factor,img_sshot.height*size_factor), 0)
    border_draw = ImageDraw.Draw(border_img)
    border_draw.rounded_rectangle([0, 0, border_img.size[0], border_img.size[1]], radius=corner_radius, fill=None,outline=BORDER_COLOR, width=border_width)
    border_img = border_img.resize((img_sshot.width, img_sshot.height), Image.LANCZOS)

    # setup sprite
    sprite = Image.new('RGBA', img_sshot.size)
    sprite.paste(img_sshot, (0, 0), frame_mask)
    sprite = Image.alpha_composite(sprite,border_img)

    # output
    out_name = out_name.replace("part_","part_bb_")
    
    out_path = output_folder + "/bb"

    if not os.path.exists(out_path):
        os.makedirs(out_path)

    out_filename = os.path.join(out_path, out_name)
    
    sprite.save(out_filename)

    add_shadow(out_filename,out_filename)


#   Function : Create Web Thumbnail
# --------------------------------------------------

def create_web_thumb(sshot,out_name,FitScreenshot=True):
    
    # screenshot
    img_sshot = Image.open(sshot).convert("RGBA")

    # target_width = img_thumb_header_bg.width * 2
    # target_height = img_thumb_header_bg.height * 2
    target_width = 1280
    target_height= 720

    # resize screenshot
    if FitScreenshot:
        aspect_ratio = img_sshot.height / img_sshot.width
        new_width = target_width
        new_height = int(new_width * aspect_ratio)
        img_sshot = img_sshot.resize((new_width, new_height), Image.LANCZOS)

    # crop screenshot
    left = 0
    right = target_width
    top = 0
    bottom = target_height

    if FitScreenshot:
        left = 0
        right = min(img_sshot.width, target_width)
        top = max(img_sshot.height - target_height, 0)
        bottom = top + target_height
    
    img_sshot = img_sshot.crop((left, top, right, bottom))
    
    # combine sprites
    sprite = Image.new('RGBA', (target_width,target_height))
    sprite.paste(img_sshot, (0, 0))

    # output
    out_name = out_name.replace("part_","part_web_")
    
    out_path = output_folder + "/web"

    if not os.path.exists(out_path):
        os.makedirs(out_path)

    sprite.save(os.path.join(out_path, out_name))

    pass


#   Function : Create Graphics
# --------------------------------------------------

def create_graphics():
        
    # iterate screenshots
    for file_name in os.listdir(sshot_out_folder):

        # resolution images
        if "part_res" in file_name:
            label = "-"
            
            for lookup_name in labels_resolution:
                if lookup_name in file_name:
                    label = labels_resolution[lookup_name]
                    break
            
            create_board_thumb(f"{sshot_out_folder}/{file_name}",f"{file_name}",label,True)
            create_web_thumb(f"{sshot_out_folder}/{file_name}",f"{file_name}",True)

            if "dimmed" in file_name and "res" in file_name and "fhd" in file_name:
                create_board_thumb_large(f"{sshot_out_folder}/{file_name}","part_preview.png")

        # dpi images
        if "part_dpi" in file_name:
            label = "-"
            
            match = re.search(r'\d+', file_name)
            if match:
                label = match.group(0) + " %"
            
            create_board_thumb(f"{sshot_out_folder}/{file_name}",f"{file_name}",label,False)
            create_web_thumb(f"{sshot_out_folder}/{file_name}",f"{file_name}",False)


#   Main Process
# --------------------------------------------------

# Define colors
class Colors:
    NEUTRAL = '\033[0m'
    GREEN = '\033[32m'


# paths
ressource_folder = 'res'
sshot_folder = f'{ressource_folder}/sshot'
sshot_out_folder = f'out/sshot'
file_thumb_header_bg = f'{ressource_folder}/thumb_header_bg.png'
file_thumb_sshot_mask = f'{ressource_folder}/thumb_image_mask.png'
file_thumb_border = f'{ressource_folder}/thumb_border.png'
output_folder = 'out'

# label font settings
LABEL_FONT_SIZE = 18
LABEL_FONT_COLOR = (255,255,255)

# alpha settings
HEADER_BG_ALPHA = 0.9
BORDER_ALPHA = 1

# colors
HEADER_BG_COLOR = (40,40,40)
BORDER_COLOR = (20,20,20)


# label lookup texts
labels_resolution = {
    "fhd" : "FullHD / 1080p",
    "qhd" : "2K / QHD / 1440p",
    "uhd" : "4K / UHD / 2160p",
}

# clear and create output path
printProgressStart("Preparing output folders")
if os.path.exists(output_folder):
    shutil.rmtree(output_folder)
    
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

if not os.path.exists(sshot_out_folder):
    os.makedirs(sshot_out_folder)

printProgressEnd()

# created trimmed versions of screenshots
printProgressStart("Trimming Screenshots")
trim_screenshots()
printProgressEnd()

# base graphics
img_thumb_header_bg = Image.open(file_thumb_header_bg).convert("RGBA")
img_thumb_sshot_mask = Image.open(file_thumb_sshot_mask).convert("RGBA")
img_thumb_border = Image.open(file_thumb_border).convert("RGBA")

# alpha adjustments
img_thumb_border = change_alpha(img_thumb_border,BORDER_ALPHA)

# colorization
img_thumb_header_bg = fill_image(img_thumb_header_bg,HEADER_BG_COLOR)
img_thumb_border = fill_image(img_thumb_border,BORDER_COLOR)

# create all the graphics
printProgressStart("Creating Graphics")
create_graphics()

# theme adjuster
#add_shadow("res/theme_adj.png","out/theme_adj.png")

# logo
add_shadow("res/banner_logo.png","out/banner_logo.png")

printProgressEnd()