#!/usr/bin/env python

import math
import cairo
import os

zoom_levels = ("100","125","150","175","200","225","250")

TEMP_FILE = "temp"

TARGET_DIR = "./ats/animation"

SPRITE_COUNT = 25

TOOLBAR_SIZE = {
    "100": 30,
    "125": 35,
    "150": 45,
    "175": 49,
    "200": 60,
    "225": 63,
    "250": 75
}

BORDER = {
    "100": 1,
    "125": 1,
    "150": 1,
    "175": 1,
    "200": 2,
    "225": 2,
    "250": 3
}

OFFSET = {
    "100": 1,
    "125": 2,
    "150": 2,
    "175": 2,
    "200": 4,
    "225": 4,
    "250": 6
}

# -------------------------------------------
#       Remove Temp File
# -------------------------------------------

def remove_temp_file():
    if os.path.exists(TEMP_FILE):
        os.remove(TEMP_FILE)
        
# -------------------------------------------
#       Rescale
# -------------------------------------------

def rescale(x:float, in_min:float, in_max:float, out_min:float, out_max:float):
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

# -------------------------------------------
#       Class : Animation
# -------------------------------------------

class classAnimation:
    
    base_color = (1,1,1)

    #   Constructor
    # ----------------------------------------
    def __init__(self, scale:str = "100"):
        
        self.scale = scale
        self.size = TOOLBAR_SIZE[scale]
        self.sprite:cairo.SVGSurface = []
        self.current_sprite:cairo.SVGSurface

    #   Add Sprite
    # ----------------------------------------
    def add_sprite(self):
        self.sprite.append(cairo.SVGSurface(TEMP_FILE, self.size,self.size))
        self.current_sprite = self.sprite[len(self.sprite)-1]

    #   Draw Sprite
    # ----------------------------------------

    def make_sheet(self,filename:str = "out.png"):

        x_offset = 0
        y_offset = 0

        total_height = self.size * len(self.sprite)

        spritesheet = cairo.SVGSurface(TEMP_FILE, self.size, total_height)
        context = cairo.Context(spritesheet)

        for index, surface in enumerate(self.sprite):
            context.save()
            context.rectangle(0, index * self.size, self.size, self.size)
            context.clip()
            context.set_source_surface(surface, x_offset, index * self.size + y_offset)
            context.paint()

            context.restore()  # Restore the context to the previous state

        spritesheet.write_to_png(filename)


# -------------------------------------------
#       Create Folder
# -------------------------------------------

os.makedirs(TARGET_DIR, exist_ok=True)

# -------------------------------------------
#       Animation : Pulse Fill
# -------------------------------------------


print(f"Creating Pulse Animation...",end='',flush=True)

for zoom in zoom_levels:

    spritesheet = classAnimation(zoom)
    
    sprite_count_half = SPRITE_COUNT // 2

    for i in range(0,SPRITE_COUNT):
        spritesheet.add_sprite()

        context = cairo.Context(spritesheet.current_sprite)

        context.set_line_width(BORDER[zoom])

        box_offset = OFFSET[zoom]
        box_size = TOOLBAR_SIZE[zoom] - box_offset * 2

        context.rectangle(box_offset,box_offset, box_size,box_size)

        if i < sprite_count_half:
            alpha = rescale(i,0,sprite_count_half,0,1)
        else:
            alpha = rescale(i,sprite_count_half,SPRITE_COUNT,1,0)

        context.set_source_rgba(1,1,1,alpha)

        context.fill()

        pass

    spritesheet.make_sheet(f"{TARGET_DIR}/animation_pulse_fill_{zoom}.png")

print("done")

# -------------------------------------------
#       Animation : Pulse Inner
# -------------------------------------------

print(f"Creating Glow Animation...",end='',flush=True)

for zoom in zoom_levels:

    spritesheet = classAnimation(zoom)
    
    sprite_count_half = SPRITE_COUNT // 2

    for i in range(0,SPRITE_COUNT):
        spritesheet.add_sprite()

        context = cairo.Context(spritesheet.current_sprite)

        context.set_line_width(BORDER[zoom])
        
        box_offset = OFFSET[zoom] + BORDER[zoom]
        box_size = TOOLBAR_SIZE[zoom] - box_offset * 2

        context.rectangle(box_offset,box_offset, box_size,box_size)

        if i < sprite_count_half:
            alpha = rescale(i,0,sprite_count_half,0,1)
        else:
            alpha = rescale(i,sprite_count_half,SPRITE_COUNT,1,0)

        context.set_source_rgba(1,1,1,alpha)

        context.fill()

        pass

    spritesheet.make_sheet(f"{TARGET_DIR}/animation_pulse_inner_{zoom}.png")

print("done")

remove_temp_file()

