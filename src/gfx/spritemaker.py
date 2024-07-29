import sys
import os
from PIL import Image, ImageEnhance, ImageChops, ImageDraw, ImageOps
import shutil
import yaml
import re
import shlex

# ------------------------------------------------------------------
#   Globals
# ------------------------------------------------------------------

# filter command
command_list = [
    "folder",
    "dummy",
    "copy-toolbar-icons",
    "copy",
    "clear-output-folder",
    "fill",
]


default_copy_info = [[["out/dark", 0], "/root/int/development/reaper/theming/paRt/reaper/ColorThemes/paRt_dark"]]
default_copy_on = False

spritemaker_file = "spritemaker_do"
color_file = 'spritemaker_lookup'

available_zoom_levels = (100, 125, 150, 175, 200, 225, 250)
zoom_levels = list(available_zoom_levels)

themes = ("dark", "dimmed", "light")


# filter
filter_rotation=Image.BICUBIC

# color palette template
color_palette = {
    "dark":{},
    "dimmed":{},
    "light":{}
}


# ------------------------------------------------------------------
#   Method : Show Help
# ------------------------------------------------------------------

def show_help():
    print("""
    paRt bitmap creation utility
---------------------------------------------

i/o files:
    --out                   output files
    --images                layered input files (left to right -> bottom to top)
    --frame                 pink frame (can be 2 for top-left, bottom-right)
    --folder                process a "spritemaker_do" file of a folder

processing:
    --fill                  creates a filled bitmap using [palette, w, h]
    --button                horizontally stacked button
    --vertical              stack sprites vertically
    --dummy                 dummy bitmap (1x1 fully transparent)
    --single-level          use only a single specific zoom level
    --rotate                rotate by degree
    --flip-vertical         flip vertically
    --flip-horizontal       flip horizontally
    --crop                  image chain used as a crop-out
    --crop-template         prepared image used for individual layer cut-outs
    --toolbar               adjustments for default toolbar buttons
    --toolbar-icon          define toolbar overlay icon
    --copy-toolbar-icons    transfers all the v3 icons
    --mask-template         template for masking individual layers
    --mask                  mask all layers using constructed image
    --quit                  aborts folder processing
    --frame-make            creates a pink frame, arguments = attachement -> left, top, right, bottom
    --spritesheet           creates a spritesheet (3 frames default, argument changes number)
    --copy-files-to         copy output files to an additional target folder
    --copy-files            copy output files to the folders declared in the spritemaker lookup file

image attributes:
    -tint                   fill image with palette color
    -colorize               colorize image with palette color
    -alpha                  alpha factor
    -border                 border formatting
    -rotate                 rotate layer by degree
    -flip-v                 flip layer vertically
    -flip-h                 flip layer horizontally
    -frame                  limit image to specific frame range in spritesheet (always use 2 values)
    -crop                   use crop-template image file as a cut-out mask
    -mask                   mask used from mask-template
    -fit                    auto adjusts pink frame corners

file operation / helpers:
    --copy                  copy "source" to "target1" "target2" ...
    --clear-output-folder   clear output directory if available
    --show-palette          how available colors
    --print-arguments       prints the formatted arguments

variables:
    $var_name wildcards can be used as placeholders

- - - - - - - -
    usage
- - - - - - - -

--button --out output_file --frame frame_file --images bitmap1 -alpha 0.5 bitmap2 bitmap3 -border

          """)

    sys.exit(1)

# ------------------------------------------------------------------
#   Method : Argument
# ------------------------------------------------------------------

def print_argument_str(data):
    CYAN = '\033[36m'
    END = '\033[0m'
    print(f"{CYAN}Arguments --> {data}{END}")


# ------------------------------------------------------------------
#   Method : Print Starting Message
# ------------------------------------------------------------------

def print_starting_message():

    pathname = os.path.basename(os.getcwd())

    YELLOW = '\033[33m'
    ORANGE = '\033[38;5;208m'
    END = '\033[0m'
    print(f"{YELLOW}     paRt sprite making utility")
    print("--------------------------------------")
    print("")
    print(f"processing {ORANGE}[{pathname}]")
    print(f"{END}")


# ------------------------------------------------------------------
#   Method : Print Error String
# ------------------------------------------------------------------

def print_error_str(message):

    global creation_in_progress

    if creation_in_progress:
        print()
        creation_in_progress = False

    RED = '\033[91m'
    END = '\033[0m'
    print(f"{RED}Error: {message}{END}")


# ------------------------------------------------------------------
#   Method : Print Clear Output Folder
# ------------------------------------------------------------------

def print_clear_output():
    global creation_in_progress
    creation_in_progress= True

    print(f"Clearing Output Folder...",end='',flush=True)

# ------------------------------------------------------------------
#   Method : Print Copy Info
# ------------------------------------------------------------------

def print_copy_to(folder_from,folder_to):
    global creation_in_progress
    creation_in_progress= True
    
    ORANGE = '\033[38;5;208m'
    END = '\033[0m'

    print(f"Copying output files from {ORANGE}{os.path.basename(folder_from)}{END} to {ORANGE}{os.path.basename(folder_to)}{END}...",end='',flush=True)

# ------------------------------------------------------------------
#   Method : Print Creation String
# ------------------------------------------------------------------

def print_creation_str(list,message=""):

    global creation_in_progress
    creation_in_progress= True

    if message:
        print(f"{message}",end='',flush=True)
        return

    element_str = ""

    for idx, entry in enumerate(list):
        element_str += str(entry["n"])

        if idx < len(list) - 1:
            element_str += ", "


    print(f"Creating {element_str}...",end='',flush=True)

# ------------------------------------------------------------------
#   Method : Print Done String
# ------------------------------------------------------------------

def print_done_str():
    global creation_in_progress

    if not creation_in_progress:
        return

    creation_in_progress= False

    GREEN = '\033[92m'
    END = '\033[0m'
    print(f"{GREEN}{"done"}{END}")


# ------------------------------------------------------------------
#   Method : Show Palette
# ------------------------------------------------------------------

def show_palette():

    print(" - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
    print("     Available colors")
    print("     Normal / Dark / Dimmed / Light")
    print(" - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
    print()

    color_w=2

    for color in color_palette["rgb"]:

        if not isinstance(color_palette["rgb"][color], tuple):
            continue

        # base color
        color_str = ""

        r = color_palette["rgb"][color][0]
        g = color_palette["rgb"][color][1]
        b = color_palette["rgb"][color][2]

        color_str_basic = f"\033[38;2;{r};{g};{b}m\u2588\033[0m"

        for i in range(color_w):
            color_str += color_str_basic

        color_str += " "

        # themed colors
        for idx,theme in enumerate(themes):
            if not color in color_palette[theme]["rgb"]:
                for i in range(color_w):
                    color_str += " "
                color_str += " "
                continue

            r = color_palette[theme]["rgb"][color][0]
            g = color_palette[theme]["rgb"][color][1]
            b = color_palette[theme]["rgb"][color][2]

            for i in range(color_w):
                color_str += f"\033[38;2;{r};{g};{b}m\u2588\033[0m"

            color_str += " "

        # color name
        print(f"{color_str}{color}\n")


# ------------------------------------------------------------------
#   Method : Clear Output
# ------------------------------------------------------------------

def clear_output():

    print_clear_output()

    out_path = f"{os.getcwd()}/out"

    if os.path.exists(out_path):
        shutil.rmtree(out_path)

    print_done_str()


# ------------------------------------------------------------------
#   Method : Load Configuration Data
# ------------------------------------------------------------------

def load_config_data():

    global color_palette
    global variables
    global settings
    global default_copy_info
    global default_copy_on

    script_folder = os.path.dirname(os.path.abspath(__file__))

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

                    if "copy_dev_info" in settings:
                        default_copy_info = settings["copy_dev_info"]
                    
                    if "copy_dev_on" in settings and settings["copy_dev_on"] == True:
                        default_copy_on = True

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

# ------------------------------------------------------------------
#   Method : Parse Arguments
# ------------------------------------------------------------------

def parse_arguments(line=""):

    global variables

    # argument limits
    arg_list = {
        "-tint": 1,
        "-colorize": 1,
        "-border": 0,
        "-alpha": 1,
        "-rotate": 1,
        "-flip-v": 0,
        "-flip-h": 0,
        "-frame": 2,
        "-crop": 0,
        "-mask": 0,
        "-fit": 0
    }

    def get_tag_limit(tag):
        if tag in arg_list:
            return arg_list[tag]
        return 0

    if not line:
        arguments = sys.argv[1:]
    else:
        arguments = shlex.split(line)

    if variables is not None:

        for idx, arg in enumerate(arguments):

            wildcards = re.findall(r'\$(\w+)', arg)

            for var_str in wildcards:

                if var_str in variables:
                    var_val = variables[var_str]
                    arg = arg.replace(f"${var_str}", str(var_val))
                else:
                    arg = "0"

            arguments[idx] = arg


    data = {}

    current_option=None
    current_tag=None
    tag_limit=0

    for entry in arguments:

        # option
        if entry.startswith("--"):

            option = entry[2:]

            if not option in data:
                data[option] = []

            current_option = data[option]

            current_tag = None


        # sub-option / tag
        elif entry.startswith("-"):

            tag = entry[1:]

            tag_limit=get_tag_limit(entry)

            current_tag = tag
            current_option[len(current_option)-1][current_tag] = []

            # no argument limit
            if tag_limit==0 and current_option is not None:
                current_tag = None

        else:


            # option
            if current_option is not None:

                # tag
                if current_tag is not None:

                    current_option[len(current_option)-1][current_tag].append(entry)

                    tag_limit -= 1
                    if tag_limit <=0 :
                        current_tag = None

                else:
                    current_option.append({"n":entry})


            # base entry
            else:
                data[entry] = {}
                current_option = None


    return data



# ------------------------------------------------------------------
#   Method : Adjust Image Alpha
# ------------------------------------------------------------------

def adjust_image_alpha(img, alpha):

    r, g, b, a = img.split()
    new_alpha = a.point(lambda i: i * alpha)
    return Image.merge("RGBA", (r, g, b, new_alpha))


# ------------------------------------------------------------------
#   Method : Multiply Image
# ------------------------------------------------------------------

def multiply_image(factor):
    r, g, b, a = img.split()

    r = r.point(lambda i: i * factor)
    g = g.point(lambda i: i * factor)
    b = b.point(lambda i: i * factor)

    img = Image.merge("RGBA", (r, g, b, a))

# ------------------------------------------------------------------
#   Method : Pick Mod
# ------------------------------------------------------------------

def pick_mod(theme,mod):

    if theme and mod in color_palette[theme]["mod"]:
        return color_palette[theme]["mod"][mod]
    elif mod in color_palette["mod"]:
        return color_palette["mod"][mod]

    return (1,1,1,1)

# ------------------------------------------------------------------
#   Method : Pick Color
# ------------------------------------------------------------------

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

    return rgba


# ------------------------------------------------------------------
#   Method : Colorize Image
# ------------------------------------------------------------------

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


# ------------------------------------------------------------------
#   Method : Fill Image
# ------------------------------------------------------------------

def fill_image(img, theme, tint):

    rgb = pick_color(theme,tint)
    
    # fill image with solid color
    if rgb is not None:
        rgb = rgb[:3]
        color_img = Image.new("RGB", img.size, rgb)
        color_img.putalpha(img.getchannel('A'))
        return color_img

    return img

# ------------------------------------------------------------------
#   Method : Fill Image - RGB
# ------------------------------------------------------------------

def fill_image_rgb(img, tint, alpha_thres=0):

    color_img = Image.new("RGB", img.size, tint)

    a = img.getchannel('A')

    if alpha_thres > 0 :
        a = a.point(lambda p: p if p >= min(alpha_thres,255) else 0)

    color_img.putalpha(a)

    return color_img

# ------------------------------------------------------------------
#   Method : Create Pink Frame
# ------------------------------------------------------------------

def apply_pink_frame_draw(sprite_sheet, args, attachement=(0,0,0,0)):

    w = sprite_sheet.width + 1
    h = sprite_sheet.height + 1

    if "spritesheet" in args:
        if "vertical" in args:
            h = h // 3
        else:
            w = w // 3

    img_tl = Image.new("RGBA",(w,h),(0,0,0,0))
    img_br = Image.new("RGBA",(w,h),(0,0,0,0))

    frame_color = (255, 0, 255)

    # corner pixels
    img_tl.putpixel((0,0), frame_color)
    img_br.putpixel((w-1,h-1), frame_color)

    # edge attachement
    if attachement[0] == 1:
        draw = ImageDraw.Draw(img_tl)
        draw.line([(0, 0), (w, 0)], fill=frame_color, width=1)

    if attachement[1] == 1:
        draw = ImageDraw.Draw(img_tl)
        draw.line([(0, 0), (0, h)], fill=frame_color, width=1)
    
    if attachement[2] == 1:
        draw = ImageDraw.Draw(img_br)
        draw.line([(0, h-1), (w, h-1)], fill=frame_color, width=1)

    if attachement[3] == 1:
        draw = ImageDraw.Draw(img_br)
        draw.line([(w-1, 0), (w-1, h)], fill=frame_color, width=1)


    new_width = sprite_sheet.width + 2
    new_height = sprite_sheet.height + 2

    # compositing
    framed_sprite_sheet = Image.new("RGBA", (new_width, new_height), (0, 0, 0, 0))
    framed_sprite_sheet.paste(sprite_sheet, (1, 1))

    pos_tl = (0, 0)
    pos_br = (framed_sprite_sheet.width - img_br.width, framed_sprite_sheet.height - img_br.height)

    framed_sprite_sheet.paste(img_tl, pos_tl, img_tl)
    framed_sprite_sheet.paste(img_br, pos_br, img_br)

    return framed_sprite_sheet


# ------------------------------------------------------------------
#   Method : Apply Pink Frame
# ------------------------------------------------------------------


def apply_pink_frame(args, sprite_sheet, zoom):

    # artificial pink frame
    if "frame-make" in args:

        frame_args = args["frame-make"]
        frame_args.extend([0] * (4 - len(frame_args)))
        frame_attach=(int(frame_args[0]["n"]),int(frame_args[1]["n"]),int(frame_args[2]["n"]),int(frame_args[3]["n"]))

        return apply_pink_frame_draw(sprite_sheet, args, frame_attach)

    # skip if no frame defined
    if not "frame" in args:
        return sprite_sheet

    # frame specific arguments
    frame_args = args["frame"]

    # gather transformation
    frame_rotate = [0,0]
    frame_flip_h = [0,0]
    frame_flip_v = [0,0]
    frame_tint = [0,0]

    for i in range(len(frame_args)):
        if "tint" in frame_args[i]:
            frame_tint[i] = 1
        if "rotate" in frame_args[i]:
            frame_rotate[i] = int(frame_args[i]["rotate"][0])
        if "flip-v" in frame_args[i]:
            frame_flip_v[i] = 1
        if "flip-h" in frame_args[i]:
            frame_flip_h[i] = 1

    # single image frame
    if len(frame_args) == 1:

        # paths
        frame_paths = [
            f"{os.getcwd()}/ats/frame/{frame_args[0]["n"]}_{zoom}.png",
            f"{os.getcwd()}/ats/frame/{frame_args[0]["n"]}.png",
            f"{os.getcwd()}/frame/{frame_args[0]["n"]}_{zoom}.png",
            f"{os.getcwd()}/frame/{frame_args[0]["n"]}.png",
        ]

        # add pink lines
        for frame_path in frame_paths:

            if os.path.isfile(frame_path):

                img_fr = Image.open(frame_path)

                # force fill with pink
                if frame_tint[0]:
                    img_fr = fill_image_rgb(img_fr,(255,0,255),255)

                # flip
                if frame_flip_h[0]:
                    img_fr = img_fr.transpose(Image.FLIP_LEFT_RIGHT)
                if frame_flip_v[0]:
                    img_fr = img_fr.transpose(Image.FLIP_TOP_BOTTOM)

                # rotate
                if frame_rotate[0]:
                    degree = int(round(frame_rotate[0] / 90.0)) * 90
                    img_fr = img_fr.rotate(degree,expand=True)

                
                new_width = sprite_sheet.width + 2
                new_height = sprite_sheet.height + 2

                framed_sprite_sheet = Image.new("RGBA", (new_width, new_height), (0, 0, 0, 0))
                framed_sprite_sheet.paste(sprite_sheet, (1, 1))
                
                # split frame if not covering the full image area
                if "fit" in frame_args[0]:
                    
                    w = img_fr.width
                    h = img_fr.height

                    fr_tl = img_fr.crop((0, 0, w-1, h-1))
                    fr_br = img_fr.crop((1, 1, w, h))

                    framed_sprite_sheet.paste(fr_tl, (0, 0),fr_tl)
                    framed_sprite_sheet.paste(fr_br, (new_width-w+1, new_height-h+1),fr_br)
                    
                else:

                    framed_sprite_sheet.paste(img_fr, (0, 0),img_fr)

                return framed_sprite_sheet

    # frame set covering each corner
    elif len(frame_args) >= 2:

        # paths
        frame_a_paths = [
            f"{os.getcwd()}/ats/frame/{frame_args[0]["n"]}_{zoom}.png",
            f"{os.getcwd()}/ats/frame/{frame_args[0]["n"]}.png",
            f"{os.getcwd()}/ats/{frame_args[0]["n"]}_{zoom}.png",
            f"{os.getcwd()}/ats/{frame_args[0]["n"]}.png",
        ]

        frame_b_paths = [
            f"{os.getcwd()}/ats/frame/{frame_args[1]["n"]}_{zoom}.png",
            f"{os.getcwd()}/ats/frame/{frame_args[1]["n"]}.png",
            f"{os.getcwd()}/ats/{frame_args[1]["n"]}_{zoom}.png",
            f"{os.getcwd()}/ats/{frame_args[1]["n"]}.png",
        ]

        # path check
        path_tl = None
        path_br = None

        for frame_path in frame_a_paths:
            if os.path.isfile(frame_path):
                path_tl = frame_path
                break

        for frame_path in frame_b_paths:

            if os.path.isfile(frame_path):
                path_br = frame_path
                break

        # add pink lines
        if path_tl is not None and path_br is not None:
            img_tl = Image.open(path_tl)
            img_br = Image.open(path_br)

            # colorize
            if frame_tint[0]:
                img_tl = fill_image_rgb(img_tl,(255,0,255),255)
            if frame_tint[1]:
                img_br = fill_image_rgb(img_br,(255,0,255),255)

            # flip
            if frame_flip_h[0]:
                img_tl = img_tl.transpose(Image.FLIP_LEFT_RIGHT)
            if frame_flip_h[1]:
                img_tl = img_tl.transpose(Image.FLIP_LEFT_RIGHT)
            if frame_flip_v[0]:
                img_br = img_br.transpose(Image.FLIP_TOP_BOTTOM)
            if frame_flip_v[1]:
                img_br = img_br.transpose(Image.FLIP_TOP_BOTTOM)

            # rotate
            if frame_rotate[0]:
                degree = int(round(frame_rotate[0] / 90.0)) * 90
                img_tl = img_tl.rotate(degree,expand=True)
            if frame_rotate[1]:
                degree = int(round(frame_rotate[1] / 90.0)) * 90
                img_br = img_br.rotate(degree,expand=True)

            new_width = sprite_sheet.width + 2
            new_height = sprite_sheet.height + 2

            framed_sprite_sheet = Image.new("RGBA", (new_width, new_height), (0, 0, 0, 0))
            framed_sprite_sheet.paste(sprite_sheet, (1, 1))

            pos_tl = (0, 0)
            pos_br = (framed_sprite_sheet.width - img_br.width, framed_sprite_sheet.height - img_br.height)

            framed_sprite_sheet.paste(img_tl, pos_tl, img_tl)
            framed_sprite_sheet.paste(img_br, pos_br, img_br)

            return framed_sprite_sheet

    return sprite_sheet


# ------------------------------------------------------------------
#   Method : Get Toolbar Icon
# ------------------------------------------------------------------

def get_toolbar_icon(image, theme, zoom):

    # prioritized lookup list
    path_lookup = {
        f"{os.getcwd()}/ats/ico/{theme}/v3/{zoom}/{image["n"]}.png",
        f"{os.getcwd()}/ats/ico/{theme}/v6/{zoom}/{image["n"]}.png",
        f"{os.getcwd()}/ico/{theme}/v3/{zoom}/{image["n"]}.png",
        f"{os.getcwd()}/ico/{theme}/v6/{zoom}/{image["n"]}.png",
    }

    # return path and type on success
    for path in path_lookup:
        if os.path.isfile(path):
            return path

    raise FileExistsError(f"Couldn't find assets for {image["n"]}")

# ------------------------------------------------------------------
#   Method : Get Image
# ------------------------------------------------------------------

def get_image(image, theme, zoom):

    # prioritized lookup list
    path_lookup = {
        f"{os.getcwd()}/ats/{theme}/{image["n"]}_{zoom}.png",
        f"{os.getcwd()}/ats/{image["n"]}_{zoom}.png",
        f"{os.getcwd()}/ats/{theme}/{image["n"]}.png",
        f"{os.getcwd()}/ats/{image["n"]}.png"
    }

    # return path and type on success
    for path in path_lookup:
        if os.path.isfile(path):
            return path

    raise FileExistsError(f"Couldn't find assets for {image["n"]}")


# ------------------------------------------------------------------
#   Method : Layered Sprite
# ------------------------------------------------------------------

def create_layered_sprite(theme,zoom, images,frame=-1,crop_img=None, mask_img=None):

    image_list = []

    # collect available images
    for image in images:
        try:
            img_path = get_image(image, theme, zoom)

            image_list.append({"path": img_path,"args": image})

        except FileExistsError as fe:
            print_error_str(fe)


    # get maximum dimensions
    max_width, max_height = 0, 0

    for loaded_image in image_list:

        img = Image.open(loaded_image["path"])

        width, height = img.size

        max_width = max(max_width, width)
        max_height = max(max_height, height)

    # base layer for merged image
    merged_image = Image.new(
        "RGBA", (max_width, max_height), (0, 0, 0, 0))

    # image merging
    for loaded_image in image_list:

        # frame skip
        if frame >= 0 and "frame" in loaded_image["args"] and \
        (frame < int(loaded_image["args"]["frame"][0]) or frame > int(loaded_image["args"]["frame"][1])):
            continue

        # full-size fill / base image
        if "fill" in loaded_image["args"]:
            img = Image.new("RGBA",(1,1),(0,0,0,0))
        else:
            img = Image.open(loaded_image["path"])
            img = img.convert("RGBA")


        # tint
        if "tint" in loaded_image["args"]:
            
            rgb = pick_color(theme, loaded_image["args"]["tint"][0])
            img = fill_image(img, theme, loaded_image["args"]["tint"][0])

            # alpha adjustment in color
            if len(rgb)>2 and rgb[3] <= 1:
                img = adjust_image_alpha(img, rgb[3])

        if "colorize" in loaded_image["args"]:
            img = colorize_image(img, theme, loaded_image["args"]["colorize"][0])

        # border
        if "border" in loaded_image["args"]:
            img = adjust_image_alpha(img, pick_mod(theme,"border_alpha")[0] )

        # alpha
        if "alpha" in loaded_image["args"]:
            img = adjust_image_alpha(img, float(loaded_image["args"]["alpha"][0]))

        # crop-out
        if "crop" in loaded_image["args"] and crop_img is not None:
                crop_alpha = crop_img.split()[3]
                r,g,b,a = Image.new("RGBA", img.size, (0,0,0,0)).split()
                img_crop = Image.merge("RGBA", (r,g,b) + (crop_alpha,))
                img = ImageChops.subtract(img, img_crop)

        # mask
        if "mask" in loaded_image["args"] and mask_img is not None:
                alpha_inv = ImageChops.invert(mask_img.split()[3])
                r,g,b,a = Image.new("RGBA", img.size, (0,0,0,0)).split()
                img_mask = Image.merge("RGBA", (r,g,b) + (alpha_inv,))
                img = ImageChops.subtract(img, img_mask)

        # image transformation
        if "rotate" in loaded_image["args"]:
            rotation = loaded_image["args"]["rotate"][0]
            img = img.rotate(int(rotation),expand=False,resample=filter_rotation)
        if "flip-v" in loaded_image["args"]:
            img = img.transpose(Image.FLIP_TOP_BOTTOM)
        if "flip-h" in loaded_image["args"]:
            img = img.transpose(Image.FLIP_LEFT_RIGHT)

        # center
        if img.width < max_width or img.height < max_height:

            x_offset = (max_width - img.width) // 2
            y_offset = (max_height - img.height) // 2

            img_resize = Image.new("RGBA",(max_width, max_height),(0,0,0,0))
            img_resize.paste(img,(x_offset,y_offset))
            img = img_resize

        # merge image
        merged_image = Image.alpha_composite(merged_image, img)


    return merged_image

# ------------------------------------------------------------------
#   Method : Create Dummy
# ------------------------------------------------------------------

def create_dummy(args):

    print_creation_str(args["out"])

    for theme in themes:
        img = Image.new('RGBA', (1, 1), (0, 0, 0, 0))

        output_path = f"{os.getcwd()}/out/{theme}"

        os.makedirs(output_path, exist_ok=True)

        for out_file in args["out"]:
            img.save(f"{output_path}/{out_file["n"]}.png")

    print_done_str()

# ------------------------------------------------------------------
#   Method : Create Fill
# ------------------------------------------------------------------

def create_fill(args):

    print_creation_str(args["out"])

    for theme in themes:

        r,g,b,a = (0,0,0,0)
        w = 1
        h = 1

        if len(args["fill"])>=1:
            r,g,b,a = pick_color(theme,args["fill"][0]["n"])

        if len(args["fill"])>=3:
            w = int(args["fill"][1]["n"])
            h = int(args["fill"][2]["n"])

        # alpha fix
        if a<1:
            a = int(a*255)
            
        img = Image.new('RGBA', (w, h), (r, g, b, a))

        output_path = f"{os.getcwd()}/out/{theme}"

        os.makedirs(output_path, exist_ok=True)

        for out_file in args["out"]:
            img.save(f"{output_path}/{out_file["n"]}.png")

    print_done_str()

# ------------------------------------------------------------------
#   Method : Create Sprite
# ------------------------------------------------------------------

def create_sprite(args):

    global zoom_levels


    sprite_count = 1

    toolbar = "toolbar" in args
    toolbar_icon = "toolbar-icon" in args
    button = "button" in args
    create_spritesheet = "spritesheet" in args

    vertical = "vertical" in args
    crop_template = "crop-template" in args
    mask_template = "mask-template" in args

    if create_spritesheet:

        sprite_count = 3

        if len(args["spritesheet"]) > 0 and not button:
            sprite_count = max(int(args["spritesheet"][0]["n"]),1)


    print_creation_str(args["out"])

    # go through thems and zoom levels
    for theme in themes:
        for zoom in zoom_levels:

            # create base set
            img_set = []


            for i in range(sprite_count):

                crop_template_img = None
                mask_template_img = None

                if crop_template:
                    crop_template_img = create_layered_sprite(theme,zoom, args["crop-template"],i)

                if mask_template:
                    mask_template_img = create_layered_sprite(theme,zoom, args["mask-template"],i)

                img_set.append(create_layered_sprite(theme,zoom, args["images"],i,crop_template_img,mask_template_img))

            # sprite creation
            for idx,img in enumerate(img_set) :

                # crop-out
                if "crop" in args:
                        crop_alpha = create_layered_sprite(theme,zoom, args["crop"],0).split()[3]
                        r,g,b,a = Image.new("RGBA", img.size, (0,0,0,0)).split()
                        img_crop = Image.merge("RGBA", (r,g,b) + (crop_alpha,))
                        img = ImageChops.subtract(img, img_crop)

                # mask
                if "mask" in args:
                        img_mask = create_layered_sprite(theme,zoom, args["mask"],0)
                        alpha_inv = ImageChops.invert(img_mask.split()[3])
                        r,g,b,a = Image.new("RGBA", img.size, (0,0,0,0)).split()
                        img_mask = Image.merge("RGBA", (r,g,b) + (alpha_inv,))
                        img = ImageChops.subtract(img, img_mask)

                # image transformation
                if "rotate" in args:
                    rotation = args["rotate"][0]["n"]
                    img = img.rotate(int(rotation),expand=True,resample=filter_rotation)
                if "flip-vertical" in args:
                    img = img.transpose(Image.FLIP_TOP_BOTTOM)
                if "flip-horizontal" in args:
                    img = img.transpose(Image.FLIP_LEFT_RIGHT)

                img_set[idx] = img
            
            # toolbar icon formatting
            if toolbar_icon:
                try:

                    ico_path = get_toolbar_icon(args["toolbar-icon"][0], theme, zoom)
                    ico_img = Image.open(ico_path)

                    w = img_set[0].width
                    h = img_set[0].height

                    ico = []
                    ico.append(ico_img.crop((0, 0, w, h)))
                    ico.append(ico_img.crop((w, 0, 2 * w, h)))
                    ico.append(ico_img.crop((2 * w, 0, 3 * w, h)))

                    img_set[0] = Image.alpha_composite(img_set[0], ico[0])
                    img_set[1] = Image.alpha_composite(img_set[1], ico[1])
                    img_set[2] = Image.alpha_composite(img_set[2], ico[2])

                except FileExistsError as fe:
                    print_error_str(fe)


            # button brightness mod
            if create_spritesheet and button:

                hover_mod = pick_mod(theme,"hover")
                click_mod = pick_mod(theme,"click")
                img_set[1] = ImageEnhance.Brightness(img_set[1]).enhance(hover_mod[0])
                img_set[1] = ImageEnhance.Contrast(img_set[1]).enhance(hover_mod[1])

                if not toolbar:
                    img_set[2] = ImageEnhance.Brightness(img_set[2]).enhance(click_mod[0])
                    img_set[2] = ImageEnhance.Contrast(img_set[2]).enhance(click_mod[1])

            # spritesheet
            if not vertical:
                spritesheet_width = img_set[0].width * len(img_set)
                spritesheet_height = img_set[0].height
            else:
                spritesheet_width = img_set[0].width
                spritesheet_height = img_set[0].height * len(img_set)

            spritesheet = Image.new("RGBA", (spritesheet_width, spritesheet_height))

            offset = [0,0]

            for idx, img in enumerate(img_set):
                spritesheet.paste(img, (offset[0], offset[1]))

                if not vertical:
                    offset[0] += img.width
                else:
                    offset[1] += img.height

            # pink frame
            spritesheet = apply_pink_frame(args, spritesheet, zoom)

            # output
            if zoom == 100 or "single-level" in args:
                output_path = f"{os.getcwd()}/out/{theme}"
            else:
                output_path = f"{os.getcwd()}/out/{theme}/{zoom}"

            os.makedirs(output_path, exist_ok=True)

            for out_file in args["out"]:
                spritesheet.save(f"{output_path}/{out_file["n"]}.png")

    print_done_str()

# ------------------------------------------------------------------
#   Method : Copy Toolbar Icons
# ------------------------------------------------------------------

def copy_toolbar_icons():


    # grab v3 icons
    for theme in themes:

        for zoom in zoom_levels:

            print_creation_str(None,f"Copying v3 toolbar icons for {theme} - {zoom}...")

            ico_path = f"{os.getcwd()}/ats/ico/{theme}/v3/{zoom}/"

            # skip if path not extists
            if not os.path.exists(ico_path):

                ico_path = f"{os.getcwd()}/ico/{theme}/v3/{zoom}/"

                if not os.path.exists(ico_path):
                    print_error_str(f"Missing folder for v3 - {zoom} - {theme} icons")
                    continue

            # destination path
            dest_path = f"{os.getcwd()}/out/{theme}/"

            if zoom != 100:
                dest_path += f"{zoom}/"

            # handle pngs
            for filename in os.listdir(ico_path):
                if not filename.lower().endswith('.png'):
                    continue

                # open file
                spritesheet = Image.open(f"{ico_path}/{filename}")
                width, height = spritesheet.size
                sprite_width = width // 3

                # split sprites
                sprite1 = spritesheet.crop((0, 0, sprite_width, height))
                sprite2 = spritesheet.crop((sprite_width, 0, 2 * sprite_width, height))
                sprite3 = spritesheet.crop((2 * sprite_width, 0, width, height))

                # hover brightness adjustment
                hover_mod = pick_mod(theme,"hover")
                sprite2 = ImageEnhance.Brightness(sprite2).enhance(hover_mod[0])
                sprite2 = ImageEnhance.Contrast(sprite2).enhance(hover_mod[1])

                # merge
                new_spritesheet = Image.new('RGBA', (width, height))
                new_spritesheet.paste(sprite1, (0, 0))
                new_spritesheet.paste(sprite2, (sprite_width, 0))
                new_spritesheet.paste(sprite3, (2 * sprite_width, 0))

                # save
                if not os.path.exists(dest_path):
                    os.makedirs(dest_path)

                new_spritesheet.save(f"{dest_path}{filename}")

            print_done_str()

# ------------------------------------------------------------------
#   Method : Copy Image
# ------------------------------------------------------------------

def copy_image(args):

    print_creation_str(None,f"Copying {args["copy"][0]["n"]}...")

    for theme in themes:

        for zoom in zoom_levels:

            for idx, image in enumerate(args["copy"]):

                if idx == 0:
                    source_img = image["n"]
                    continue

                # get path
                if zoom == 100:

                    path = f"{os.getcwd()}/out/{theme}/"
                else:
                    path = f"{os.getcwd()}/out/{theme}/{zoom}/"

                filepath = f"{path}/{source_img}.png"

                # copy file of source is available
                if os.path.isfile(filepath):
                    outpath = f"{path}/{image["n"]}.png"

                    img = Image.open(filepath)

                    used_transform = False

                    # transformations
                    if "rotate" in args:
                        rotation = args["rotate"][0]["n"]
                        img = img.rotate(int(rotation),expand=True,resample=filter_rotation)
                        used_transform = True
                    if "flip-vertical" in args:
                        img = img.transpose(Image.FLIP_TOP_BOTTOM)
                        used_transform = True
                    if "flip-horizontal" in args:
                        img = img.transpose(Image.FLIP_LEFT_RIGHT)
                        used_transform = True

                    if used_transform:
                        img.save(outpath)
                    else:
                        shutil.copy2(filepath, outpath)
    
    print_done_str()

# ------------------------------------------------------------------
#   Method : Copy Output Files to 
# ------------------------------------------------------------------

def copy_files_to(path_from, use_recursion, path_to):

    recursion_ok = False

    # parse recursion string into bool
    try:
        recursion_ok = int(use_recursion)>0
    except:
        pass

    # path formatting
    path_from = path_from.strip('"')
    path_to = path_to.strip('"')

    # place source path relative to working directory
    path_from = f"{os.getcwd()}/{path_from}"

    # source path check
    if not os.path.exists(path_from):
        print_error_str(f"Can't copy from {os.path.basename(path_from)}")
        return

    # target path check
    if not os.path.exists(path_to):
        print_error_str(f"Can't copy to {os.path.basename(path_to)}")
        return

    # copy message
    print_copy_to(path_from,path_to)

   # Ensure the destination directory exists
    os.makedirs(path_to, exist_ok=True)
    
    # copy items
    for item in os.listdir(path_from):
       src_path = os.path.join(path_from, item)
       dst_path = os.path.join(path_to, item)

       if os.path.isdir(src_path):
           if recursion_ok:
                shutil.copytree(src_path, dst_path, dirs_exist_ok=True)
           else:
               continue
       else:
           shutil.copy2(src_path, dst_path)

    # done message
    print_done_str()



# ------------------------------------------------------------------
#   Method : Process Folder
# ------------------------------------------------------------------

def process_folder(args):

    for folder_entry in args["folder"]:
        file_path = f"{folder_entry["n"]}"
        file_path_abs = f"{file_path}/{spritemaker_file}"

        # check if spritemaker file exists
        if os.path.exists(file_path_abs):

            # change working dir
            os.chdir(file_path)

            # process lines
            with open(file_path_abs, 'r') as file:

                current_statement = ""

                for line in file:

                    stripped_line = line.strip()
                    
                    # skip lines
                    if not stripped_line or stripped_line.startswith('#'):
                        continue
                    
                    # linebreak
                    if stripped_line.endswith('\\'):
                        current_statement += stripped_line[:-1]
                        continue
                        
                    current_statement += stripped_line
                    process_direct(current_statement)
                    current_statement = ""
                            
        else:
            print_error_str(f"Couldn't find '{spritemaker_file}' file in {folder_entry["n"]}")


# ------------------------------------------------------------------
#   Method : Process Direct
# ------------------------------------------------------------------

def process_direct(args=""):

    global zoom_levels, available_zoom_levels, creation_in_progress

    creation_in_progress = False

    args = parse_arguments(args)

    command = None
    for entry in command_list:

        if entry in args:
            command = entry
            break

    # abort
    if "quit" in args:
        exit()

    # copy to target folder
    if "copy-files-to" in args:
        copy_files_to(args["copy-files-to"][0]["n"],args["copy-files-to"][1]["n"],args["copy-files-to"][2]["n"])
        return
    
    # copy files using defaults
    if "copy-files" in args:
        if default_copy_on:
            for copy_info in default_copy_info:
                copy_files_to(copy_info[0][0],copy_info[0][1],copy_info[1])
        return    

    # print arguments
    if "print-arguments" in args:
        print_argument_str(args)

    # iterate folder
    if command == "folder":
        process_folder(args)
        return

    # show help
    if "h" in args or "help" in args:
        show_help()
        return


    # show palette
    if "show-palette" in args:
        show_palette()
        return

    # clear output folder
    if command == "clear-output-folder":
        clear_output()
        return

    # single level

    if "single-level" in args and int(args["single-level"][0]["n"]) in available_zoom_levels:
        zoom_levels = [int(args["single-level"][0]["n"])]

    # copy toolbar icons
    if command == "copy-toolbar-icons":
        copy_toolbar_icons()
        return

    # 1x1px dummy bitmap
    if command == "dummy":
        if not "out" in args:
            print_error_str("Missing output files")
            return
        create_dummy(args)
        return

    # 1x1 dummy bitmap
    if command == "fill":
        if not "out" in args:
            print_error_str("Missing output files")
            return
        create_fill(args)
        return

    # copy to multiple targets
    if command == "copy":
        copy_image(args)
        return

    if not "out" in args:
        print_error_str("Missing output files")
        return

    # create sprite
    create_sprite(args)

# ------------------------------------------------------------------
#   Main Process
# ------------------------------------------------------------------

load_config_data()
print_starting_message()
process_direct()

