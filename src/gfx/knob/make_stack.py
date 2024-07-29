#!/usr/bin/env python

import math
import cairo
import os

zoom_levels = ("100","125","150","175","200","225","250")

TEMP_FILE = "temp"

KNOB_DEGREE = 270
SPRITE_COUNT = 128 

TYPE_MCP = "mcp"
TYPE_TCP = "tcp"
TYPE_FX = "fx"

KNOBTYPE_LINE = "knobtype_line"
KNOBTYPE_STROKE_LINEAR = "knobtype_stroke_linear"
KNOBTYPE_STROKE = "knobtype_stroke"
KNOBTYPE_STROKE_BI = "knobtype_stroke_bi"
KNOBTYPE_PIE = "knobtype_pie"
KNOBTYPE_FILL = "knobtype_fill"
KNOBTYPE_BORDER = "knobtype_border"

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
        "250": 3,
    },
    "radius": {
        "100": 1.0
    },

}

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
        "100": 0.9
    },
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
        "250": 3,
    },
    "radius": {
        "100": 1.0
    },
}

KNOB_LOOKUP_SEND_MCP = {
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
        "100": 1,
        "125": 1,
        "150": 1,
        "175": 1,
        "200": 2,
        "225": 2,
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

KNOB_LOOKUP_FX_MCP = {
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
        "100": 1,
        "125": 1,
        "150": 1,
        "175": 1,
        "200": 2,
        "225": 2,
        "250": 3,
    },
    "radius": {
        "100": 0.85,
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
        "250": 3,
    },
    "radius": {
        "100": 0.93333
    },
    "offset": { 
        "100": [0,-1],
        "125": [0,-1],
        "150": [0,-1],
        "175": [0,-1],
        "200": [0,-2],
        "225": [0,-2],
        "250": [0,-2]
    }

}

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
    "line_sizes": {
        "100": 1,
    },
    "border": {
        "100": 1,
        "125": 1,
        "150": 1,
        "175": 1,
        "200": 2,
        "225": 2,
        "250": 3,
    },
    "radius": {
        "100": 0.75
    },

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
#       Get Lookup Data
# -------------------------------------------

def get_lookup_data(lookup_table: dict, scale: str):
    
    if not scale in lookup_table:
        if "100" in lookup_table:
            return lookup_table["100"]
        else:
            return 0
    else:
        return lookup_table[scale]

# -------------------------------------------
#       Class : Knob
# -------------------------------------------

class classKnob:

    base_color = (1,1,1)

    #   Constructor
    # ----------------------------------------
    def __init__(self,lookup:dict, scale:str = "100"):
        self.lookup = lookup
        self.scale = scale
        self.size = max(get_lookup_data(self.lookup["dimensions"],self.scale),1)
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
        
        if "offset" in self.lookup:
            x_offset = get_lookup_data(self.lookup["offset"],self.scale)[0]
            y_offset = get_lookup_data(self.lookup["offset"],self.scale)[1]

        total_height = self.size * len(self.sprite)

        spritesheet = cairo.SVGSurface(TEMP_FILE, self.size, total_height)
        context = cairo.Context(spritesheet)

        for index, surface in enumerate(self.sprite):
            context.save()
            context.rectangle(0, index * self.size, self.size, self.size)
            context.clip()
            context.set_source_surface(surface, x_offset, index * self.size + y_offset)
            context.paint()

            context.restore()

        spritesheet.write_to_png(filename)

    #   Copy last Sprite
    # ----------------------------------------
    
    def copy_last_sprite(self):
        index_last = len(self.sprite) - 2
        index_current = len(self.sprite) - 1
        
        if index_last < 0:
            return
        
        self.sprite[index_current] = self.sprite[index_last]
        self.current_sprite = self.sprite[index_current]


    #   Draw Line
    # ----------------------------------------

    def draw_line(self,angle,offset:float = 0.25, length:float = 0.5,thickness:int = 0,is_border:bool = False ):

        context = cairo.Context(self.current_sprite)

        center_x = self.size / 2
        center_y = self.size / 2

        angle_radians = math.radians(angle)

        thickness_abs = 1

        if thickness == 0:
            thickness_abs = get_lookup_data(self.lookup["line_sizes"],self.scale)
        else:
            thickness_abs = thickness

        border_size = get_lookup_data(self.lookup["border"],self.scale)

        if is_border:
            thickness_abs += border_size * 2

        context.set_line_width(thickness_abs)

        remaining_length = self.size / 2

        radius_start = remaining_length * offset
        radius_end = remaining_length * length - border_size


        offset_x = center_x + radius_start * math.cos(angle_radians)
        offset_y = center_y + radius_start * math.sin(angle_radians)
        end_x = center_x + radius_end * math.cos(angle_radians)
        end_y = center_x + radius_end * math.sin(angle_radians)

        context.move_to(offset_x, offset_y)
        context.line_to(end_x, end_y)

        context.set_source_rgb(self.base_color[0],self.base_color[1],self.base_color[2])

        context.set_line_cap(cairo.LINE_CAP_ROUND)
        context.stroke()

    #   Draw Arc
    # ----------------------------------------

    def draw_arc(self,angle_start:int,angle_end:int,radius:float = 0.5,thickness:int = 0,is_border:bool = False ):

        context = cairo.Context(self.current_sprite)

        center_x = self.size / 2
        center_y = self.size / 2

        thickness_abs = thickness

        border_size = get_lookup_data(self.lookup["border"],self.scale)

        if thickness == 0:
            thickness_abs = get_lookup_data(self.lookup["line_sizes"],self.scale)
        
        if is_border:
            context.set_line_width(thickness_abs + border_size * 2)
        else:
            context.set_line_width(thickness_abs)
            
        radius_abs = (self.size / 2) * radius - thickness_abs / 2 - border_size
        
        if is_border:  
            angle_start -= border_size * 0.05
            angle_end += border_size * 0.05

        start_radians = math.radians(angle_start)
        end_radians = math.radians(angle_end)


        context.set_source_rgb(self.base_color[0],self.base_color[1],self.base_color[2])
        context.set_line_cap(cairo.LINE_CAP_SQUARE)

        
            

        context.arc(center_x, center_y, radius_abs, start_radians, end_radians)
        context.stroke()

    #   Draw Pie
    # ----------------------------------------

    def draw_pie(self,angle_start:int,angle_end:int,radius:float = 0.5):


        context = cairo.Context(self.current_sprite)

        center_x = self.size / 2
        center_y = self.size / 2

        context.set_line_width(0)

        border_size = get_lookup_data(self.lookup["border"],self.scale)
        radius = (self.size / 2) * radius - border_size

        start_radians = math.radians(angle_start)
        end_radians = math.radians(angle_end)

        context.set_source_rgb(self.base_color[0],self.base_color[1],self.base_color[2])
        context.line_to(center_x,center_y)
        context.arc(center_x,center_y, radius, start_radians, end_radians)
        context.fill()
        context.close_path()

    #   Draw Border
    # ----------------------------------------

    def draw_border(self,radius:float = 0.5,thickness:int = 0):

        context = cairo.Context(self.current_sprite)

        center_x = self.size / 2
        center_y = self.size / 2

        thickness_abs = thickness

        if thickness == 0:
            thickness_abs = get_lookup_data(self.lookup["border"],self.scale)

        context.set_line_width(thickness_abs)

        radius = (self.size / 2) * radius - thickness_abs / 2

        context.set_source_rgb(self.base_color[0],self.base_color[1],self.base_color[2])

        context.arc(center_x, center_y, radius, 0, 360)
        context.stroke()

    #   Draw Fill
    # ----------------------------------------

    def draw_fill(self,radius:float = 0.5,include_border:bool = False):

        context = cairo.Context(self.current_sprite)

        center_x = self.size / 2
        center_y = self.size / 2

        border_size = get_lookup_data(self.lookup["border"],self.scale)

        if include_border:
            radius = (self.size / 2) * radius - border_size
        else:
            radius = (self.size / 2) * radius

        context.set_source_rgb(self.base_color[0],self.base_color[1],self.base_color[2])

        context.arc(center_x, center_y, radius, 0, 360)
        context.fill()

# --------------------------------------------------
#       Method : Draw Sprite - Line
# --------------------------------------------------

def draw_sprite_line(sprite_count:int, index:int, zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    is_border = "is_border" in data and data["is_border"]

    if not "angle" in data or data["angle"] is None:
        data["angle"] = 270 - KNOB_DEGREE / 2

    knob.draw_line(data["angle"],get_lookup_data(lookup["line_offset"],zoom),get_lookup_data(lookup["line_range"],zoom),0,is_border)

    data["angle"] += KNOB_DEGREE / (sprite_count - 1)

# --------------------------------------------------
#       Method : Draw Sprite - Stroke Linear
# --------------------------------------------------

def draw_sprite_stroke_linear(sprite_count:int, index:int, zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    is_border = "is_border" in data and data["is_border"]

    if not "angle_start" in data or data["angle_start"] is None:
        data["angle_start"] = -90 - (KNOB_DEGREE / 2)

    if not "angle" in data or data["angle"] is None:
        data["angle"] = data["angle_start"] + 1

    angle_step = (KNOB_DEGREE - 1) / (sprite_count - 1)

    knob.draw_arc(data["angle_start"], data["angle"],get_lookup_data(lookup["radius"],zoom),0,is_border)
    data["angle"] += angle_step

# --------------------------------------------------
#       Method : Draw Sprite - Stroke
# --------------------------------------------------

def draw_sprite_stroke(sprite_count:int, index:int, zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    is_border = "is_border" in data and data["is_border"]

    min_angle = 3

    if not "angle" in data or data["angle"] is None:
        data["angle"] = -90

    if not "angle_start" in data or data["angle_start"] is None:
        data["angle_start"] = -90 - (KNOB_DEGREE / 2)

    angle_step = KNOB_DEGREE / (sprite_count - 1)

    if index == sprite_count // 2:
        data["angle"] = -90

    arc_angle_end = data["angle"] + min_angle
    arc_angle_start = data["angle_start"] - min_angle

    knob.draw_arc(arc_angle_start, arc_angle_end,get_lookup_data(lookup["radius"],zoom),0,is_border)

    if index < sprite_count // 2:
        data["angle_start"] += angle_step
    else:        
        data["angle"] += angle_step


# --------------------------------------------------
#       Method : Draw Sprite - Bi Stroke
# --------------------------------------------------

def draw_sprite_stroke_bi(sprite_count:int, index:int,zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    is_border = "is_border" in data and data["is_border"]

    if not "angle_start" in data or data["angle_start"] is None:
        data["angle_start"] = -90 - KNOB_DEGREE / 2

    if not "angle" in data or data["angle"] is None:
        data["angle"] = data["angle_start"] + KNOB_DEGREE

    angle_step = KNOB_DEGREE / (sprite_count-1)

    if index < sprite_count // 2:
        knob.draw_arc(data["angle_start"], data["angle"],get_lookup_data(lookup["radius"],zoom),0,is_border)
        data["angle_start"] += angle_step
        data["angle"] -= angle_step
    else:
        knob.draw_arc(data["angle_start"] , data["angle"],get_lookup_data(lookup["radius"],zoom),0,is_border)
        data["angle_start"] -= angle_step
        data["angle"] += angle_step

# --------------------------------------------------
#       Method : Draw Sprite - Pie
# --------------------------------------------------

def draw_sprite_pie(sprite_count:int, index:int,zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    if not "angle_start" in data or data["angle_start"] is None:
        data["angle_start"] = -90

    if not "angle" in data or data["angle"] is None:
        data["angle"] = -90

    angle_step = 360 / (sprite_count - 1)

    knob.draw_pie(data["angle_start"], data["angle"],get_lookup_data(lookup["radius"],zoom))

    data["angle"] += angle_step

# --------------------------------------------------
#       Method : Draw Sprite - Border
# --------------------------------------------------

def draw_sprite_border(sprite_count:int, index:int,zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    knob.draw_border(get_lookup_data(lookup["radius"],zoom))

# --------------------------------------------------
#       Method : Draw Sprite - Fill
# --------------------------------------------------

def draw_sprite_fill(sprite_count:int, index:int,zoom:str, knob:classKnob,lookup:dict,data:dict = {}):

    include_border = "is_border" in data and data["is_border"]

    radius = get_lookup_data(lookup["radius"],zoom)

    if "radius_multiplier" in data:
        radius *= data["radius_multiplier"]

    #knob.draw_fill(radius,include_border)
    knob.draw_fill(radius,False)


# --------------------------------------------------
#       Method : Create Spritesheet
# --------------------------------------------------

def create_spritesheet(lookup:dict, filename:str,data:dict):

    print(f"Creating {filename}...",end='',flush=True)

    if lookup is None:
        return
    
    for zoom in zoom_levels:

        knob = classKnob(lookup,zoom)

        sprite_count = SPRITE_COUNT

        iteration_count = 1

        if "iterations" in data and data["iterations"] > 1:
            iteration_count = round(data["iterations"])

        multiplier = 1

        if "sprite_count_multiplier" in data and data["sprite_count_multiplier"] > 1:
            multiplier = data["sprite_count_multiplier"]
            sprite_count = round(sprite_count * multiplier)

        sprite_count = round(sprite_count / iteration_count + 0.5)

        if sprite_count % 2 == 0:
            sprite_count += 1

        sprite_count = max(sprite_count, 9)

        total_index = 0

        total_sprites = sprite_count * iteration_count

        for iteration in range(iteration_count):

            data["angle"] = None
            data["angle_start"] = None

            for i in range(sprite_count):

                knob.add_sprite()

                pos_sprite = total_index / total_sprites

                if "tone_curve" in data:
                    curve_low = data["tone_curve"][0]
                    curve_high = data["tone_curve"][1]
                    tone_level = rescale(pos_sprite,0,1,curve_low,curve_high)
                    knob.base_color = (tone_level,tone_level,tone_level)


                draw = True

                if "sprite_start" in data and "sprite_end" in data:
                    if pos_sprite < data["sprite_start"]:
                        draw = False
                    
                    if pos_sprite > data["sprite_end"]:
                        draw = False
                        if "freeze_end" in data and data["freeze_end"]:
                            knob.copy_last_sprite()

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

                total_index += 1

        knob.make_sheet(f"{filename}_{zoom}.png")
    print("done")

# ----------------------------------------
#   Main Process
# ----------------------------------------

# main knob stacks
data_inner = { "type": KNOBTYPE_FILL, "is_border": True }
data_volume = { "type": KNOBTYPE_LINE }
data_volume_border = { "type": KNOBTYPE_LINE, "is_border": True }
data_pan = { "type": KNOBTYPE_STROKE }
data_pan_border = { "type": KNOBTYPE_STROKE, "is_border": True }
data_width = { "type": KNOBTYPE_STROKE_BI }
data_width_border = { "type": KNOBTYPE_STROKE_BI, "is_border": True }
data_width_dot = { "type": KNOBTYPE_FILL, "radius_multiplier": 0.35, "sprite_start": 0, "sprite_end": 0.5, "is_border": True}
data_width_dot_border = { "type": KNOBTYPE_FILL, "radius_multiplier": 0.35, "sprite_start": 0, "sprite_end": 0.5}
data_envcp = { "type": KNOBTYPE_STROKE_LINEAR }
data_envcp_border = { "type": KNOBTYPE_STROKE_LINEAR, "is_border": True }

create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_mask_inner", data_inner)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_line_border", data_volume_border)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_line", data_volume)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_border", data_pan_border)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke", data_pan)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_bi_border", data_width_border)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_bi", data_width)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_dot", data_width_dot)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_dot_border", data_width_dot_border)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_lin_border", data_envcp_border)
create_spritesheet(KNOB_LOOKUP_MCP,"./ats/stack_mcp_stroke_lin", data_envcp)

create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_mask_inner", data_inner)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_line_border", data_volume_border)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_line", data_volume)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_border", data_pan_border)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke", data_pan)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_bi_border", data_width_border)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_bi", data_width)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_dot", data_width_dot)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_dot_border", data_width_dot_border)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_lin_border", data_envcp_border)
create_spritesheet(KNOB_LOOKUP_TCP,"./ats/stack_tcp_stroke_lin", data_envcp)

# insert sends
data_send_a = {
    "type": KNOBTYPE_PIE,
    "iterations": 2,
    "sprite_start": 0,
    "sprite_end": 0.495,
    "freeze_end": True
}

data_send_b = {
    "type": KNOBTYPE_PIE,
    "iterations": 2,
    "sprite_start": 0.5,
    "sprite_end": 1,
}

data_send_bg = { "type": KNOBTYPE_FILL, "iterations": 2 }
data_send_border = { "type": KNOBTYPE_BORDER, "iterations": 2 }

create_spritesheet(KNOB_LOOKUP_SEND_MCP,"./ats/stack_mcp_send_a", data_send_a)
create_spritesheet(KNOB_LOOKUP_SEND_MCP,"./ats/stack_mcp_send_b", data_send_b)
create_spritesheet(KNOB_LOOKUP_SEND_MCP,"./ats/stack_mcp_send_bg", data_send_bg)
create_spritesheet(KNOB_LOOKUP_SEND_MCP,"./ats/stack_mcp_send_border", data_send_border)

# insert fx
data_fx_value = {"type": KNOBTYPE_PIE}
data_fx_bg = {"type": KNOBTYPE_FILL}
data_fx_border = {"type": KNOBTYPE_BORDER}

create_spritesheet(KNOB_LOOKUP_FX_MCP,"./ats/stack_mcp_fx_value", data_fx_value)
create_spritesheet(KNOB_LOOKUP_FX_MCP,"./ats/stack_mcp_fx_border", data_fx_border)
create_spritesheet(KNOB_LOOKUP_FX_MCP,"./ats/stack_mcp_fx_bg", data_fx_bg)

# item volume
data_itemvol_a = {
    "type": KNOBTYPE_PIE,
    "iterations": 2,
    "sprite_start": 0,
    "sprite_end": 0.495,
    "freeze_end": True
}

data_itemvol_b = {
    "type": KNOBTYPE_PIE,
    "iterations": 2,
    "sprite_start": 0.5,
    "sprite_end": 1,
}

data_itemvol_bg = { "type": KNOBTYPE_FILL, "iterations": 2 }
data_itemvol_border = { "type": KNOBTYPE_BORDER, "iterations": 2 }

create_spritesheet(KNOB_LOOKUP_ITEM,"./ats/stack_item_bg", data_itemvol_bg)
create_spritesheet(KNOB_LOOKUP_ITEM,"./ats/stack_item_border", data_itemvol_border)
create_spritesheet(KNOB_LOOKUP_ITEM,"./ats/stack_item_fill_a", data_itemvol_a)
create_spritesheet(KNOB_LOOKUP_ITEM,"./ats/stack_item_fill_b", data_itemvol_b)

data_trans_inner = { "type": KNOBTYPE_FILL, "is_border": True }
data_trans_border = { "type": KNOBTYPE_BORDER}
data_trans_line = { "type": KNOBTYPE_STROKE }
data_trans_line_border = { "type": KNOBTYPE_STROKE, "is_border": True }

create_spritesheet(KNOB_LOOKUP_TRANSPORT,"./ats/stack_trans_bg", data_trans_inner)
create_spritesheet(KNOB_LOOKUP_TRANSPORT,"./ats/stack_trans_border", data_trans_border)
create_spritesheet(KNOB_LOOKUP_TRANSPORT,"./ats/stack_trans_line", data_trans_line)
create_spritesheet(KNOB_LOOKUP_TRANSPORT,"./ats/stack_trans_line_border", data_trans_line_border)

remove_temp_file()

