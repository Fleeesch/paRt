#!/usr/bin/env python

# --------------------------------------------------------------------------------------
#       Knob Sprite-Sheet Creation Tool
#       
#       Creates monochrome sprite-sheets that can be used with the
#       sprite-maker tool in order to create knob-stack images for Reaper.
#
#       ==> Is currently simple and messy, but it get's the job done.
# --------------------------------------------------------------------------------------

import math
import cairo
import os

# ========================================================================
#       General Settings
# ========================================================================

# available zoom levels
zoom_levels = ("100","125","150","175","200","225","250")

# name for temp file
TEMP_FILE = "temp"

# ========================================================================
#       Output Settings
# ========================================================================

# knob line range
KNOB_DEGREE = 270

# total sprites per sheet
SPRITE_COUNT = 128 

# ========================================================================
#       Constants
# ========================================================================

# knob type keywords
KNOBTYPE_LINE = "knobtype_line"
KNOBTYPE_STROKE_LINEAR = "knobtype_stroke_linear"
KNOBTYPE_STROKE = "knobtype_stroke"
KNOBTYPE_STROKE_BI = "knobtype_stroke_bi"
KNOBTYPE_PIE = "knobtype_pie"
KNOBTYPE_FILL = "knobtype_fill"
KNOBTYPE_BORDER = "knobtype_border"

# ========================================================================
#       Knob Data Lookup Tables
# ========================================================================

# -------------------------------------------
#   MCP Knobs
# -------------------------------------------

KNOB_LOOKUP_MCP = {
    "dimensions": {
        "100": 18,
        "125": 22,
        "150": 27,
        "175": 32,
        "200": 36,
        "225": 40,
        "250": 45,
    },
    "line_offset": {
        "100": 0.25
    },
    "line_range": {
        "100": 0.9
    }    ,
    "line_sizes": {
        "100": 3,
        "125": 3,
        "150": 3,
        "175": 4,
        "200": 4,
        "225": 5,
        "250": 6,
    },
    "border": {
        "100": 1,
        "125": 1,
        "150": 1,
        "175": 1,
        "200": 2,
        "225": 2,
        "250": 2,
    },
    "radius": {
        "100": 1.0
    },

}

# -------------------------------------------
#   TCP Knobs
# -------------------------------------------

KNOB_LOOKUP_TCP = {
    "dimensions": {
        "100": 14,
        "125": 18,
        "150": 21,
        "175": 24,
        "200": 28,
        "225": 32,
        "250": 35,
    },
    "line_offset": {
        "100": 0.25
    },
    "line_range": {
        "100": 0.9,
    },
    "line_sizes": {
        "100": 2.5,
        "125": 3,
        "150": 3,
        "175": 4,
        "200": 4,
        "225": 5,
        "250": 6,
    },
    "border": {
        "100": 1,
        "125": 1,
        "150": 1,
        "175": 1,
        "200": 2,
        "225": 2,
        "250": 2,
    },
    "radius": {
        "100": 1.0
    },
}

# -------------------------------------------
#   Send Knobs
# -------------------------------------------

KNOB_LOOKUP_SEND = {
    "dimensions": {
        "100": 21,
        "125": 21,
        "150": 26,
        "175": 28,
        "200": 32,
        "225": 36,
        "250": 40,
    },
    "line_offset": {
        "100": 0.25
    },
    "line_sizes": {
        "100": 2,
        "125": 3,
        "150": 3,
        "175": 4,
        "200": 4,
        "225": 5,
        "250": 6,
    },
    "border": { 
        "100": 1.5,
        "125": 1.5,
        "150": 1.5,
        "175": 1.5,
        "200": 3,
        "225": 3,
        "250": 3,
    },
    "radius": {
        "100": 0.85,
    },
    "offset": { 
        "100": [-1,1],
        "125": [-1,1],
        "150": [-1,1],
        "175": [-1,1],
        "200": [-1,2],
        "225": [-1,2],
        "250": [-1,2]
    }
}

# -------------------------------------------
#   FX Knobs
# -------------------------------------------

KNOB_LOOKUP_FX = {
    "dimensions": {
        "100": 21,
        "125": 21,
        "150": 26,
        "175": 28,
        "200": 32,
        "225": 36,
        "250": 40,
    },
    "line_offset": {
        "100": 0.25
    },
    "line_sizes": {
        "100": 3,
        "125": 3,
        "150": 3,
        "175": 3,
        "200": 5,
        "225": 5,
        "250": 7,
    },
    "border": {
        "100": 2,
        "125": 2,
        "150": 2,
        "175": 2,
        "200": 4,
        "225": 4,
        "250": 4,
    },
    "radius": {
        "100": 0.75,
    },
    "offset": { 
        "100": [1,1],
        "125": [1,1],
        "150": [1,1],
        "175": [1,1],
        "200": [1,1],
        "225": [1,1],
        "250": [1,1]
    }
}

# -------------------------------------------
#   Item Knobs
# -------------------------------------------

KNOB_LOOKUP_ITEM = {
    "dimensions": {
        "100": 15,
        "125": 15,
        "150": 15,
        "175": 15,
        "200": 30,
        "225": 30,
        "250": 30,
    },
    "line_offset": {
        "100": 0.25
    },
    "line_sizes": {
        "100": 2,
    },
    "border": {
        "100": 1,
        "125": 1,
        "150": 2,
        "175": 2,
        "200": 2,
        "225": 2,
        "250": 2,
    },
    "radius": {
        "100": 0.93333
    },
    "offset": { 
        "100": [0,0],
        "125": [0,0],
        "150": [0,0],
        "175": [0,0],
        "200": [0,0],
        "225": [0,0],
        "250": [0,0]
    }

}

# -------------------------------------------
#   Transport Knobs
# -------------------------------------------

KNOB_LOOKUP_TRANSPORT = {
    "dimensions": {
        "100": 18,
        "125": 22,
        "150": 27,
        "175": 32,
        "200": 36,
        "225": 40,
        "250": 45,
    },
    "line_offset": {
        "100": 0.25
    },
    "line_range": {
        "100": 1
    },
    "line_sizes": {
        "100": 2,
        "125": 3,
        "150": 3,
        "175": 3,
        "200": 4,
        "225": 5,
        "250": 6,
    },
    "border": {
        "100": 1,
        "125": 1,
        "150": 1,
        "175": 1,
        "200": 2,
        "225": 2,
        "250": 2,
    },
    "radius": {
        "100": 0.8
    },

}


# ========================================================================
#       Helper Functions
# ========================================================================


#       Remove Temp File
# -------------------------------------------

def remove_temp_file():
    if os.path.exists(TEMP_FILE):
        os.remove(TEMP_FILE)
        

#       Rescale
# -------------------------------------------

# rescale a value based in input and output range

def rescale(x:float, in_min:float, in_max:float, out_min:float, out_max:float):
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min


#       Get Lookup Data
# -------------------------------------------

def get_lookup_data(lookup_table: dict, scale: str):
    
    # use 100 scale as fallback
    if not scale in lookup_table:
        if "100" in lookup_table:
            return lookup_table["100"]
        else:
            return 0
    else:
        return lookup_table[scale]

# ========================================================================
#       Knob Class
# ========================================================================

class classKnob:

    # default color
    base_color = (1,1,1)

    #   Constructor
    # ----------------------------------------
    def __init__(self,lookup:dict, scale:str = "100"):
        
        # knob character lookup
        self.lookup = lookup

        # zoom level
        self.scale = scale

        # get dimensions from lookup table
        self.size = max(get_lookup_data(self.lookup["dimensions"],self.scale),1)
        
        # sprites
        self.sprite:cairo.SVGSurface = []
        
        # spritesheet canvas
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
        
        # gather position offset data
        if "offset" in self.lookup:
            x_offset = get_lookup_data(self.lookup["offset"],self.scale)[0]
            y_offset = get_lookup_data(self.lookup["offset"],self.scale)[1]

        # base height on sprite count
        total_height = self.size * len(self.sprite)

        # create draving canvas
        spritesheet = cairo.SVGSurface(TEMP_FILE, self.size, total_height)
        context = cairo.Context(spritesheet)

        # itearte sprites
        for index, surface in enumerate(self.sprite):
            
            # print to canvas
            context.save()
            context.rectangle(0, index * self.size, self.size, self.size)
            context.clip()
            context.set_source_surface(surface, x_offset, index * self.size + y_offset)
            context.paint()
            context.restore()

        # wirte output file
        spritesheet.write_to_png(filename)

    #   Copy last Sprite
    # ----------------------------------------
    
    def copy_last_sprite(self):
        index_last = len(self.sprite) - 2
        index_current = len(self.sprite) - 1
        
        # ignore first sprite since there's nothing to get
        if index_last < 0:
            return
        
        self.sprite[index_current] = self.sprite[index_last]
        self.current_sprite = self.sprite[index_current]


    #   Draw Line
    # ----------------------------------------

    def draw_line(self,angle,offset:float = 0.25, length:float = 0.5,thickness:int = 0,is_border:bool = False ):

        # get sprite
        context = cairo.Context(self.current_sprite)

        # center position
        center_x = self.size / 2
        center_y = self.size / 2

        # radius from angle
        angle_radians = math.radians(angle)

        # default thickness
        thickness_abs = 1

        # try to get thickness from lookup table
        if thickness == 0:
            thickness_abs = get_lookup_data(self.lookup["line_sizes"],self.scale)
        else:
            thickness_abs = thickness

        # try to get border size from looku data
        border_size = get_lookup_data(self.lookup["border"],self.scale)

        # apply border to thickness if we're dealing with a border
        if is_border:
            thickness_abs += border_size * 2

        # set line width
        context.set_line_width(thickness_abs)

        # calculate length
        remaining_length = self.size / 2

        # start and end radius
        radius_start = remaining_length * offset
        radius_end = remaining_length * length - border_size
        
        # calculate target positions
        offset_x = center_x + radius_start * math.cos(angle_radians)
        offset_y = center_y + radius_start * math.sin(angle_radians)
        end_x = center_x + radius_end * math.cos(angle_radians)
        end_y = center_x + radius_end * math.sin(angle_radians)

        # set line position
        context.move_to(offset_x, offset_y)
        context.line_to(end_x, end_y)

        # set line color
        context.set_source_rgb(self.base_color[0],self.base_color[1],self.base_color[2])

        # set line cap character
        context.set_line_cap(cairo.LINE_CAP_ROUND)

        # draw line
        context.stroke()

    #   Draw Arc
    # ----------------------------------------

    def draw_arc(self,angle_start:int,angle_end:int,radius:float = 0.5,thickness:int = 0,is_border:bool = False ):
        
        # get sprite
        context = cairo.Context(self.current_sprite)

        # get center oposition
        center_x = self.size / 2
        center_y = self.size / 2

        # get thickness
        thickness_abs = thickness

        # get border size from tlookup table
        border_size = get_lookup_data(self.lookup["border"],self.scale)

        # custom thickness from lookup table
        if thickness == 0:
            thickness_abs = get_lookup_data(self.lookup["line_sizes"],self.scale)
        
        # apply border to thickness if we're dealing with a border
        if is_border:
            context.set_line_width(thickness_abs + border_size * 2)
        else:
            context.set_line_width(thickness_abs)
        
        # calculate radius
        radius_abs = (self.size / 2) * radius - thickness_abs / 2 - border_size
        
        # extend range if it's a border
        if is_border:  
            angle_start -= border_size * 0.05
            angle_end += border_size * 0.05

        # target radians
        start_radians = math.radians(angle_start)
        end_radians = math.radians(angle_end)

        # target color
        context.set_source_rgb(self.base_color[0],self.base_color[1],self.base_color[2])

        # set cap shape
        context.set_line_cap(cairo.LINE_CAP_SQUARE)

        # make the ark
        context.arc(center_x, center_y, radius_abs, start_radians, end_radians)

        # draw the ark
        context.stroke()

    #   Draw Pie
    # ----------------------------------------

    def draw_pie(self,angle_start:int,angle_end:int,radius:float = 0.5, include_border:bool = False):

        # get sprite
        context = cairo.Context(self.current_sprite)

        # center position
        center_x = self.size / 2
        center_y = self.size / 2

        # start without line
        context.set_line_width(0)

        # optionally use border
        if not include_border:
            border_size = 0
        else:        
            border_size = get_lookup_data(self.lookup["border"],self.scale)

        # get radius
        radius = (self.size / 2) * radius - border_size

        # radians
        start_radians = math.radians(angle_start)
        end_radians = math.radians(angle_end)

        # set color
        context.set_source_rgb(self.base_color[0],self.base_color[1],self.base_color[2])

        # draw line
        context.line_to(center_x,center_y)

        # draw arc
        context.arc(center_x,center_y, radius, start_radians, end_radians)

        # fill the pie
        context.fill()

        # draw
        context.close_path()

    #   Draw Border
    # ----------------------------------------

    def draw_border(self,radius:float = 0.5,thickness:int = 0):

        # get sprite
        context = cairo.Context(self.current_sprite)

        # get center position
        center_x = self.size / 2
        center_y = self.size / 2

        # apply thickness
        thickness_abs = thickness

        # optionally use thickness from lookup table
        if thickness == 0:
            thickness_abs = get_lookup_data(self.lookup["border"],self.scale)

        # set line width
        context.set_line_width(thickness_abs)

        # calculate radius
        radius = (self.size / 2) * radius - thickness_abs / 2

        # set color
        context.set_source_rgb(self.base_color[0],self.base_color[1],self.base_color[2])

        # draw the border line
        context.arc(center_x, center_y, radius, 0, 360)
        context.stroke()

    #   Draw Fill
    # ----------------------------------------

    def draw_fill(self,radius:float = 0.5,include_border:bool = False):

        # get sprite
        context = cairo.Context(self.current_sprite)

        # get center position
        center_x = self.size / 2
        center_y = self.size / 2

        # get border size from lookup table
        border_size = get_lookup_data(self.lookup["border"],self.scale)

        # calculate radius depending on border setting
        if include_border:
            radius = (self.size / 2) * radius - border_size
        else:
            radius = (self.size / 2) * radius

        # set color
        context.set_source_rgb(self.base_color[0],self.base_color[1],self.base_color[2])

        # draw the line
        context.arc(center_x, center_y, radius, 0, 360)
        context.fill()


# ========================================================================
#       Drawing Functions
# ========================================================================

#       Draw Sprite - Line
# --------------------------------------------------

# A simple linear pointer.

def draw_sprite_line(sprite_count:int, index:int, zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    # check if we're dealing with a border
    is_border = "is_border" in data and data["is_border"]

    # use default angle if there's no data
    if not "angle" in data or data["angle"] is None:
        data["angle"] = 270 - KNOB_DEGREE / 2
    
    # draw the line
    knob.draw_line(data["angle"],get_lookup_data(lookup["line_offset"],zoom),get_lookup_data(lookup["line_range"],zoom),0,is_border)

    # increment the angle
    data["angle"] += KNOB_DEGREE / (sprite_count - 1)


#       Draw Sprite - Stroke Linear
# --------------------------------------------------

# A stroke that goes from left to right around the knob's edge.

def draw_sprite_stroke_linear(sprite_count:int, index:int, zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    # check if we're dealing with a border
    is_border = "is_border" in data and data["is_border"]
    
    # use default start angle if there's no direct input
    if not "angle_start" in data or data["angle_start"] is None:
        data["angle_start"] = -90 - (KNOB_DEGREE / 2)

    # use default end angle if there's no direct input
    if not "angle" in data or data["angle"] is None:
        data["angle"] = data["angle_start"] + 1

    # calculate angle increment
    angle_step = (KNOB_DEGREE - 1) / (sprite_count - 1)

    # draw the stroke
    knob.draw_arc(data["angle_start"], data["angle"],get_lookup_data(lookup["radius"],zoom),0,is_border)
    
    # increment the angle
    data["angle"] += angle_step


#       Draw Sprite - Stroke
# --------------------------------------------------

# A stroke that is centered in the middle and extends either to the left or to the right.
# Usually used for Pan-Knobs.

def draw_sprite_stroke(sprite_count:int, index:int, zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    # check if we're dealing with a border
    is_border = "is_border" in data and data["is_border"]

    # minimal angle spread
    min_angle = 3

    # default angle
    if not "angle" in data or data["angle"] is None:
        data["angle"] = -90

    # default angle start
    if not "angle_start" in data or data["angle_start"] is None:
        data["angle_start"] = -90 - (KNOB_DEGREE / 2)

    # calculate angle increment
    angle_step = KNOB_DEGREE / (sprite_count - 1)

    # reset angle in the middle of the spritesheet
    if index == sprite_count // 2:
        data["angle"] = -90

    # angle start and end positions
    arc_angle_end = data["angle"] + min_angle
    arc_angle_start = data["angle_start"] - min_angle
    
    # optional center line overwrite
    #   => ignores previous angle data and simply draws a little center blob
    if "center_line" in data and data["center_line"]:
        arc_angle_start = -90 -0.05
        arc_angle_end = -90 + 0.05

    # draw the line
    knob.draw_arc(arc_angle_start, arc_angle_end,get_lookup_data(lookup["radius"],zoom),0,is_border)

    # increment angle depending on the position
    if index < sprite_count // 2:
        data["angle_start"] += angle_step
    else:        
        data["angle"] += angle_step



#       Draw Sprite - Bi Stroke
# --------------------------------------------------

# A stroke that expends to both left and right sides at the same time.

def draw_sprite_stroke_bi(sprite_count:int, index:int,zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    # check if we're dealing with a border
    is_border = "is_border" in data and data["is_border"]

    # get start angle
    if not "angle_start" in data or data["angle_start"] is None:
        data["angle_start"] = -90 - KNOB_DEGREE / 2

    # get end angle
    if not "angle" in data or data["angle"] is None:
        data["angle"] = data["angle_start"] + KNOB_DEGREE

    # calculate angle increment
    angle_step = KNOB_DEGREE / (sprite_count-1)

    # draw arc and increment angle depending on the sprite position
    #   => the direction is reversed in the middle, creating a back-and-forth animation
    if index < sprite_count // 2:
        knob.draw_arc(data["angle_start"], data["angle"],get_lookup_data(lookup["radius"],zoom),0,is_border)
        data["angle_start"] += angle_step
        data["angle"] -= angle_step
    else:
        knob.draw_arc(data["angle_start"] , data["angle"],get_lookup_data(lookup["radius"],zoom),0,is_border)
        data["angle_start"] -= angle_step
        data["angle"] += angle_step


#       Draw Sprite - Pie
# --------------------------------------------------

# Draws a pie-chart knob.

def draw_sprite_pie(sprite_count:int, index:int,zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    # starting angle
    if not "angle_start" in data or data["angle_start"] is None:
        data["angle_start"] = 90

    # end angle
    if not "angle" in data or data["angle"] is None:
        data["angle"] = 90

    # calculate angle increment
    angle_step = 360 / (sprite_count - 1)

    # check if we're dealing with a border
    is_border = "is_border" in data and data["is_border"]

    # draw the pie
    knob.draw_pie(data["angle_start"], data["angle"],get_lookup_data(lookup["radius"],zoom), is_border)

    # increment the angle
    data["angle"] += angle_step


#       Draw Sprite - Border
# --------------------------------------------------

# Simple stroke around a circle.

def draw_sprite_border(sprite_count:int, index:int,zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    knob.draw_border(get_lookup_data(lookup["radius"],zoom))


#       Draw Sprite - Fill
# --------------------------------------------------

# Filled circle

def draw_sprite_fill(sprite_count:int, index:int,zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    #get radius
    radius = get_lookup_data(lookup["radius"],zoom)

    # increment radius with optional multiplier
    if "radius_multiplier" in data:
        radius *= data["radius_multiplier"]

    # draw circle
    knob.draw_fill(radius,False)


#       Create Spritesheet
# --------------------------------------------------

# Creates a complete spritesheet using instruction-data-tables

def create_spritesheet(lookup:dict, filename:str,data:dict):

    # info message
    print(f"Creating {filename}...",end='',flush=True)

    # needs the lookup table
    if lookup is None:
        return
    
    # iterate zoom levels
    for zoom in zoom_levels:

        # create a knob
        knob = classKnob(lookup,zoom)

        # number of sprites
        sprite_count = SPRITE_COUNT

        # default iterations
        iteration_count = 1

        # optionally get custom iterations
        if "iterations" in data and data["iterations"] > 1:
            iteration_count = round(data["iterations"])

        # default sprite count multiplier
        multiplier = 1

        # optionally get custom sprite count multiplier
        if "sprite_count_multiplier" in data and data["sprite_count_multiplier"] > 1:
            multiplier = data["sprite_count_multiplier"]
            sprite_count = round(sprite_count * multiplier)

        # make sure the sprite count matches the iterations
        sprite_count = round(sprite_count / iteration_count + 0.5)

        if sprite_count % 2 == 0:
            sprite_count += 1

        # require at least 9 sprites
        sprite_count = max(sprite_count, 9)

        # sprite counter
        total_index = 0

        # total sprite count
        total_sprites = sprite_count * iteration_count

        # optionally deal with multiple iterations
        for iteration in range(iteration_count):
            
            # reset angle data
            data["angle"] = None
            data["angle_start"] = None

            # iterate sprites
            for i in range(sprite_count):
                
                # create sprite
                knob.add_sprite()

                # calculate sprite position float number
                pos_sprite = total_index / total_sprites

                # get optional tonal curve from data
                if "tone_curve" in data:
                    curve_low = data["tone_curve"][0]
                    curve_high = data["tone_curve"][1]
                    tone_level = rescale(pos_sprite,0,1,curve_low,curve_high)
                    knob.base_color = (tone_level,tone_level,tone_level)

                # always draw sprite by default
                draw = True

                # make sure to respect sprite range instructions
                if "sprite_start" in data and "sprite_end" in data:
                    if pos_sprite < data["sprite_start"]:
                        draw = False
                    
                    if pos_sprite > data["sprite_end"]:
                        draw = False
                        if "freeze_end" in data and data["freeze_end"]:
                            knob.copy_last_sprite()

                # pick a drawing method when drawing is allowed
                if draw:
                    if "type" in data and data["type"] == KNOBTYPE_LINE:
                        draw_sprite_line(sprite_count, i,zoom, knob,lookup,data)

                    if "type" in data and data["type"] == KNOBTYPE_STROKE_LINEAR:
                        draw_sprite_stroke_linear(sprite_count, i,zoom, knob,lookup,data)

                    if "type" in data and data["type"] == KNOBTYPE_STROKE:
                        draw_sprite_stroke(sprite_count, i,zoom, knob,lookup,data)

                    if "type" in data and data["type"] == KNOBTYPE_STROKE_BI:
                        draw_sprite_stroke_bi(sprite_count, i,zoom, knob,lookup,data)

                    if "type" in data and data["type"] == KNOBTYPE_PIE:
                        draw_sprite_pie(sprite_count, i,zoom, knob,lookup,data)

                    if "type" in data and data["type"] == KNOBTYPE_FILL:
                        draw_sprite_fill(sprite_count, i,zoom, knob,lookup,data)
                    
                    if "type" in data and data["type"] == KNOBTYPE_BORDER:
                        draw_sprite_border(sprite_count, i,zoom, knob,lookup,data)

                # increment sprite index
                total_index += 1

        # render the sheet
        knob.make_sheet(f"{filename}_{zoom}.png")
    
    # info
    print("done")

# ========================================================================
#       Main Process
# ========================================================================

#       Knob Data
# --------------------------------------------------

# central knob fill + border padding
knobdata_mask_inner = {
    "type": KNOBTYPE_FILL, 
    "is_border": True
    }

# central knob fill + border padding + 2 iterations
knobdata_mask_inner_2nd = {
    "type": KNOBTYPE_FILL, 
    "is_border": True,
    "iterations": 2
    }
    
# straight line
knobdata_line = {
    "type": KNOBTYPE_LINE
    }

# straight line + border padding
knobdata_line_border = {
    "type": KNOBTYPE_LINE,
    "is_border": True
    }

# pan-style center dot
knobdata_pan_centerdot = {
    "type": KNOBTYPE_STROKE,
    "center_line": True
    }

# pan-style stroke
knobdata_pan_stroke = {
    "type": KNOBTYPE_STROKE
    }

# pan-style stroke + border padding
knobdata_stroke_border = {
    "type": KNOBTYPE_STROKE,
    "is_border": True
    }

# width-style stroke
knobdata_stroke_bi = { 
    "type": KNOBTYPE_STROKE_BI
    }

# width-style stroke + border padding
knobdata_stroke_bi_border = {
     "type": KNOBTYPE_STROKE_BI,
     "is_border": True 
     }

# dot drawn post half of spritesheet
knobdata_posthalf_dot = {
     "type": KNOBTYPE_FILL,
     "radius_multiplier": 0.35,
     "sprite_start": 0,
     "sprite_end": 0.5,
     "is_border": True
     }

# dot drawn post half of spritesheet + border padding
knobdata_posthalf_dot_border = {
     "type": KNOBTYPE_FILL,
     "radius_multiplier": 0.35,
     "sprite_start": 0,
     "sprite_end": 0.5
     }

# linear stroke
knobdata_stroke_linear = {
     "type": KNOBTYPE_STROKE_LINEAR 
     }

# linear stroke + border
knobdata_stroke_linear_border = {
     "type": KNOBTYPE_STROKE_LINEAR,
     "is_border": True 
     }


# sends pie - first round
knobdata_sends_pie_a = {
    "type": KNOBTYPE_PIE,
    "iterations": 2,
    "sprite_start": 0,
    "sprite_end": 0.495,
    "freeze_end": True,
    "is_border": True
}

# sends pie - second round
knobdata_sends_pie_b = {
    "type": KNOBTYPE_PIE,
    "iterations": 2,
    "sprite_start": 0.5,
    "sprite_end": 1,
    "is_border": True
}

# sends background
knobdata_sends_bg = {
    "type": KNOBTYPE_FILL,
    "iterations": 2
    }

# sends border
knobdata_sends_border = {
    "type": KNOBTYPE_BORDER,
    "iterations": 2
    }

# volume stroke - first round
knobdata_vol_stroke_a = {
    "type": KNOBTYPE_STROKE_LINEAR,
    "iterations": 2,
    "sprite_start": 0,
    "sprite_end": 0.5 - (1/SPRITE_COUNT),
    "freeze_end": True
    }

# volume stroke - first round + border padding
knobdata_vol_stroke_a_border = {
    "type": KNOBTYPE_STROKE_LINEAR,
    "is_border": True ,
    "iterations": 2,
    "sprite_start": 0,
    "sprite_end": 0.5 - (1/SPRITE_COUNT),
    "freeze_end": True
    }

# volume stroke - second round
knobdata_vol_stroke_b = {
    "type": KNOBTYPE_STROKE_LINEAR,
    "iterations": 2,
    "sprite_start": 0.5,
    "sprite_end": 1
    }

# volume stroke - second round + border padding
knobdata_vol_stroke_b_border = {
    "type": KNOBTYPE_STROKE_LINEAR,
    "is_border": True ,
    "iterations": 2,
    "sprite_start": 0.5,
    "sprite_end": 1
    }

# fx paramter - value pie
knobdata_fx_value_pie = {
    "type": KNOBTYPE_PIE
    }

# fx paramter - fill
knobdata_fx_fill = {
    "type": KNOBTYPE_FILL
    }

# fx paramter - border
knobdata_fx_border = {
    "type": KNOBTYPE_BORDER
    }

# item pie - first round
knobdata_item_pie_a = {
    "type": KNOBTYPE_PIE,
    "iterations": 2,
    "sprite_start": 0,
    "sprite_end": 0.495,
    "freeze_end": True,
    }

# item pie - second round
knobdata_item_pie_b = {
    "type": KNOBTYPE_PIE,
    "iterations": 2,
    "sprite_start": 0.5,
    "sprite_end": 1,
    }

# item background
knobdata_item_bg = {
    "type": KNOBTYPE_FILL,
    "iterations": 2 
    }

# item border
knobdata_item_border = {
    "type": KNOBTYPE_BORDER,
    "iterations": 2
    }

# transport fill
knobdata_transport_fill = {
    "type": KNOBTYPE_FILL,
    "is_border": True
    }

# transport border
knobdata_transport_stroke = {
    "type": KNOBTYPE_BORDER
    }

# transport line
knobdata_transport_stroke_border = {
    "type": KNOBTYPE_STROKE
    }

# transport line + border padding
data_trans_line_border = {
    "type": KNOBTYPE_STROKE,
    "is_border": True
    }

# transport center dort
data_trans_line_centerdot = {
    "type": KNOBTYPE_STROKE,
    "is_border": True,
    "center_line": True
    }    

#       Spritesheets
# --------------------------------------------------

# inner mask
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_mask_inner", knobdata_mask_inner)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_mask_inner", knobdata_mask_inner)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_mask_inner_2nd", knobdata_mask_inner_2nd)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_mask_inner_2nd", knobdata_mask_inner_2nd)

# line
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_line", knobdata_line)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_line_border", knobdata_line_border)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_line", knobdata_line)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_line_border", knobdata_line_border)

# stroke
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke", knobdata_pan_stroke)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_border", knobdata_stroke_border)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_center", knobdata_pan_centerdot)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke", knobdata_pan_stroke)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_border", knobdata_stroke_border)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_center", knobdata_pan_centerdot)

# stroke - bi
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_bi", knobdata_stroke_bi)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_bi_border", knobdata_stroke_bi_border)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_bi", knobdata_stroke_bi)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_bi_border", knobdata_stroke_bi_border)

# stroke - linear
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_lin", knobdata_stroke_linear)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_lin_border", knobdata_stroke_linear_border)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_lin", knobdata_stroke_linear)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_lin_border", knobdata_stroke_linear_border)

# stroke - linear - phase 1
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_lin_phase_1", knobdata_vol_stroke_a)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_lin_border_phase_1", knobdata_vol_stroke_a_border)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_lin_phase_1", knobdata_vol_stroke_a)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_lin_border_phase_1", knobdata_vol_stroke_a_border)

# stroke - linear - phase 2
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_lin_phase_2", knobdata_vol_stroke_b)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_lin_border_phase_2", knobdata_vol_stroke_b_border)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_lin_phase_2", knobdata_vol_stroke_b)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_lin_border_phase_2", knobdata_vol_stroke_b_border)

# sends
create_spritesheet(KNOB_LOOKUP_SEND,"./ats/stack_send_a", knobdata_sends_pie_a)
create_spritesheet(KNOB_LOOKUP_SEND,"./ats/stack_send_b", knobdata_sends_pie_b)
create_spritesheet(KNOB_LOOKUP_SEND,"./ats/stack_send_bg", knobdata_sends_bg)
create_spritesheet(KNOB_LOOKUP_SEND,"./ats/stack_send_border", knobdata_sends_border)

# fx
create_spritesheet(KNOB_LOOKUP_FX,"./ats/stack_fx_value", knobdata_fx_value_pie)
create_spritesheet(KNOB_LOOKUP_FX,"./ats/stack_fx_border", knobdata_fx_border)
create_spritesheet(KNOB_LOOKUP_FX,"./ats/stack_fx_bg", knobdata_fx_fill)

# item
create_spritesheet(KNOB_LOOKUP_ITEM,"./ats/stack_item_bg", knobdata_item_bg)
create_spritesheet(KNOB_LOOKUP_ITEM,"./ats/stack_item_border", knobdata_item_border)
create_spritesheet(KNOB_LOOKUP_ITEM,"./ats/stack_item_fill_a", knobdata_item_pie_a)
create_spritesheet(KNOB_LOOKUP_ITEM,"./ats/stack_item_fill_b", knobdata_item_pie_b)

# transport
create_spritesheet(KNOB_LOOKUP_TRANSPORT,"./ats/stack_trans_bg", knobdata_transport_fill)
create_spritesheet(KNOB_LOOKUP_TRANSPORT,"./ats/stack_trans_border", knobdata_transport_stroke)
create_spritesheet(KNOB_LOOKUP_TRANSPORT,"./ats/stack_trans_line", knobdata_transport_stroke_border)
create_spritesheet(KNOB_LOOKUP_TRANSPORT,"./ats/stack_trans_line_border", data_trans_line_border)

#       Cleanup
# --------------------------------------------------

# remove temporary file
remove_temp_file()

