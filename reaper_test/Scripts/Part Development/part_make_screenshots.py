import subprocess
import time
import os
import subprocess
from mss import mss
import keyboard
from pynput.mouse import Controller
import tkinter as tk
import threading
import time
import argparse

#       Parsing Arguments
# -------------------------------------------------------------------

parser = argparse.ArgumentParser()
parser.add_argument("-demo", action="store_true")
parser.add_argument("-notify", action="store_true")
args = parser.parse_args()

#       Config
# -------------------------------------------------------------------

# wait times
WAIT_DPI = 5
WAIT_RESOLUTION = 4
WAIT_REAPER_FOCUS = 1
WAIT_REAPER_SETUP = 1
WAIT_REAPER_VIEW = 1
WAIT_REAPER_THEME_LOAD = 5

# notifications
SHOW_NOTIFICATIONS = False

# demo run - don't touch display values
DEMO_RUN = False

if args.demo:
    DEMO_RUN = True

if args.notify:
    SHOW_NOTIFICATIONS = True

#       Class: Display Format
# -------------------------------------------------------------------
class format():
    def __init__(self, name="", w=1920, h=1080, dpi=100, setup_index=1, setup_time_dpi = 5, setup_time_resolution= 5):
        
        # name
        self.name = name
        
        # dimensions
        self.w = w
        self.h = h

        # dpi factor
        self.dpi = dpi
        
        # reaper view layout
        self.setup_index = setup_index
        
        # wait times
        self.setup_time_dpi = setup_time_dpi
        self.setup_time_resolution = setup_time_resolution



#       Display Format Instances
# -------------------------------------------------------------------

# resolution based
format_fhd = format(name="fhd",w=1920,h=1080,dpi=100,setup_index=1, setup_time_dpi = WAIT_DPI, setup_time_resolution = WAIT_RESOLUTION)
format_qhd = format(name="qhd",w=2560,h=1440,dpi=100,setup_index=2, setup_time_dpi = WAIT_DPI, setup_time_resolution = WAIT_RESOLUTION)
format_uhd = format(name="uhd",w=3840,h=2160,dpi=150,setup_index=3, setup_time_dpi = WAIT_DPI, setup_time_resolution = WAIT_RESOLUTION)

# dpi based
format_dpi_100 = format(name="100",w=1920,h=1080,dpi=100,setup_index=4, setup_time_dpi = WAIT_DPI, setup_time_resolution = WAIT_RESOLUTION)
format_dpi_125 = format(name="125",w=1920,h=1080,dpi=125,setup_index=5, setup_time_dpi = WAIT_DPI, setup_time_resolution = WAIT_RESOLUTION)
format_dpi_150 = format(name="150",w=2560,h=1440,dpi=150,setup_index=6, setup_time_dpi = WAIT_DPI, setup_time_resolution = WAIT_RESOLUTION)
format_dpi_175 = format(name="175",w=2560,h=1440,dpi=175,setup_index=7, setup_time_dpi = WAIT_DPI, setup_time_resolution = WAIT_RESOLUTION)
format_dpi_200 = format(name="200",w=3840,h=2160,dpi=200,setup_index=8, setup_time_dpi = WAIT_DPI, setup_time_resolution = WAIT_RESOLUTION)
format_dpi_225 = format(name="225",w=3840,h=2160,dpi=225,setup_index=9, setup_time_dpi = WAIT_DPI, setup_time_resolution = WAIT_RESOLUTION)
format_dpi_250 = format(name="250",w=3840,h=2160,dpi=250,setup_index=10, setup_time_dpi = WAIT_DPI, setup_time_resolution = WAIT_RESOLUTION)

#       Themes
# -------------------------------------------------------------------

THEME_LIST = ["dark", "dimmed", "light"]

#       Keyboard Shortcuts
# -------------------------------------------------------------------

# reaper fullscreen setter
KEYBOARD_TOOLS = {
    "focus_on_reaper": "alt+f1",
    "focus_on_reaper_end": "alt+f2",
}

# reaper theme loading
KEYBOARD_THEME = {
    "dark": "alt+shift+f1",
    "dimmed": "alt+shift+f2",
    "light": "alt+shift+f3",
}

# reaper view layout loading
KEYBOARD_VIEWLAYOUT = {
    "1": "alt+1",
    "2": "alt+2",
    "3": "alt+3",
    "4": "alt+4",
    "5": "alt+5",
    "6": "alt+6",
    "7": "alt+7",
    "8": "alt+8",
    "9": "alt+9",
    "10": "alt+0",
}


#       Globals
# -------------------------------------------------------------------


# script directory
script_dir = os.path.dirname(os.path.abspath(__file__))

# nircmd executable (activates window)
EXE_NIRCMD = os.path.join(script_dir, "sw/nircmd/nircmdc.exe")

# setdpi executable (sets dpi)
EXE_SETDPI = os.path.join(script_dir,  "sw/setdpi/SetDpi.exe")

# screenshot path
SCREENSHOT_PATH = os.path.join(script_dir,  "sshot")

#       Mouse
# -------------------------------------------------------------------

# mouse controller
mouse_controller = Controller()

# move mouse into corner
def move_mouse_in_corner():
    mouse_controller.position = (10000, 10000)  # move to top-left

#       Notification
# -------------------------------------------------------------------

# limit notification to one instance
current_notification = None
current_notification_header = ""

def show_notification(message, duration=None):
    """
    Display a small top-most Tkinter toast.
    If duration is None, it stays until manually closed.
    """
    
    global current_notification

    # skip if not allowed
    if not SHOW_NOTIFICATIONS:
        return
    

    def _notificaiton():
        close_notification()
        global current_notification
        
        # tk window
        current_notification = tk.Tk()
        current_notification.overrideredirect(True)
        current_notification.attributes("-topmost", True)
        current_notification.geometry("+20+20")

        # create a frame to act as the border
        border_width = 2
        frame = tk.Frame(current_notification, bg="white", bd=border_width)
        frame.pack(padx=0, pady=0)

        # label inside the frame
        label = tk.Label(frame, text=f'{current_notification_header} - {message}', bg="black", fg="white", font=("Segoe UI", 10))
        label.pack(ipadx=10, ipady=5)

        # optional auto-close
        if duration:
            current_notification.after(int(duration*1000), current_notification.destroy)
        
        # open window
        current_notification.mainloop()

    # tk daemon for background usage
    threading.Thread(target=_notificaiton, daemon=True).start()

#       Close Notification
# -------------------------------------------------------------------

def close_notification():
    global current_notification

    # skip if not allowed
    if not SHOW_NOTIFICATIONS:
        return

    # close notification if it exists
    if current_notification:
        current_notification.after(0, current_notification.destroy)
        current_notification = None
        time.sleep(0.1)

#       Set Resolution
# -------------------------------------------------------------------

def set_resolution(width, height, depth=32, wait=5):
    show_notification(f'{info}Setting Resolution')
    # use nircmd to change resolution
    if not DEMO_RUN:
        subprocess.run([EXE_NIRCMD, "setdisplay", str(width), str(height), str(depth)])
    
    # wait for resolution to settle
    time.sleep(wait)
    
    # mouse in corner
    move_mouse_in_corner()

#       Set DPI
# -------------------------------------------------------------------

def set_dpi(percent, wait=5):
    show_notification(f'Setting dpi')
    
    # use setdpi for updating the dpi setting
    if not DEMO_RUN:
        subprocess.run([EXE_SETDPI, str(percent)])
    
    # give the explorer some time
    time.sleep(wait)
    
    # mouse in corner
    move_mouse_in_corner()
    

#       Make Screenshot
# -------------------------------------------------------------------

def make_screenshot(name):
    show_notification(f'Making Screenshot')
    # mouse in corner
    move_mouse_in_corner()

    # get rid of notifications
    

    # short timeout
    time.sleep(0.1)

    # output filename and path
    filename = f'{name}.png'
    filepath = os.path.join(SCREENSHOT_PATH, filename)
    
    # make screenshot
    if not DEMO_RUN:
        with mss() as sct:
            sct.shot(output=filepath)
    
    # wait for a short time, disable reaper fullscreen
    time.sleep(1)
    keyboard.send(KEYBOARD_TOOLS["focus_on_reaper_end"])
    
#       Focus Reaper Window
# -------------------------------------------------------------------

def focus_reaper(view_index):
    show_notification(f'Focussing on Reaper')
    # use nircmd to focus on reaper
    subprocess.run([EXE_NIRCMD, "win", "activate", "ititle", "Reaper"])
    time.sleep(WAIT_REAPER_FOCUS)    
    
    # trigger fullscreen
    keyboard.send(KEYBOARD_TOOLS["focus_on_reaper"])
    time.sleep(WAIT_REAPER_SETUP)
    
    # load stored view layout
    if KEYBOARD_VIEWLAYOUT[str(view_index)]:
        keyboard.send(KEYBOARD_VIEWLAYOUT[str(view_index)])    
    time.sleep(WAIT_REAPER_VIEW)
            
    
#       Load Reaper Theme
# -------------------------------------------------------------------

def load_reaper_theme(theme):
    # info message
    theme_title = f'{theme.capitalize()} Theme'
    show_notification(f'Loading {theme_title}')
    
    time.sleep(0.1)

    # focus on reaper
    subprocess.run([EXE_NIRCMD, "win", "activate", "ititle", "Reaper"])
    time.sleep(WAIT_REAPER_FOCUS)

    # load theme
    if theme == "dark":
        keyboard.send(KEYBOARD_THEME["dark"])
    elif theme == "dimmed":
        keyboard.send(KEYBOARD_THEME["dimmed"])
    elif theme == "light":
        keyboard.send(KEYBOARD_THEME["light"])
    
    time.sleep(WAIT_REAPER_THEME_LOAD)
    

#       Setup Display Format
# -------------------------------------------------------------------

def setup_display_format(format):
    
    # resolution
    set_resolution(format.w,format.h,wait=format.setup_time_resolution)    
    
    # dpi
    set_dpi(format.dpi,wait=format.setup_time_dpi)    
    
    # focus on reaper
    focus_reaper(format.setup_index)

#       Reset Display Format
# -------------------------------------------------------------------

def reset_display_format():
    show_notification(f'{info}Resetting Display')
    # qhd, 100 %
    if not DEMO_RUN:
        set_resolution(format_qhd.w,format_qhd.h,wait=format_qhd.setup_time_resolution)    
        set_dpi(format_qhd.dpi,wait=format_qhd.setup_time_dpi)    

# =========================================================
#       Main Process
# =========================================================

# ask for confirmation at the beginning
commit = input('Process takes about 15 minutes. Proceed with (y/dark/dimmed/light/dpi): ')

# in case there's nothing to do, quit
if not commit.lower() == "dpi" and not commit.lower() in THEME_LIST and not commit.lower() == "y":
    print("Exiting...")
    time.sleep(1)
    exit()

# always process dpi by default
process_dpi = True

# limit to theme or dpi
if commit.lower() == "dark":
    THEME_LIST =["dark"]
    process_dpi = False
if commit.lower() == "dimmed":
    THEME_LIST =["dimmed"]
    process_dpi = False
if commit.lower() == "light":
    THEME_LIST =["light"]
    process_dpi = False
if commit.lower() == "dpi":
    THEME_LIST = []

# store mous epos
current_mousepos = mouse_controller.position

# notification line start
info = f'Automated Screenshot Process - '

#       Theme Resolution Capture
# =====================================
for theme in THEME_LIST:

    # title
    theme_title = f'{theme.capitalize()} Theme'
    
    # load theme
    load_reaper_theme(theme)

    # FHD
    current_notification_header = f'{info}{theme_title} - FHD'
    setup_display_format(format_fhd)
    make_screenshot(f'part_res_fhd_{theme}')
    
    # QHD
    current_notification_header = f'{info}{theme_title} - QHD'
    setup_display_format(format_qhd)
    make_screenshot(f'part_res_qhd_{theme}')
    
    # UHD
    current_notification_header = f'{info}{theme_title} - UHD'
    setup_display_format(format_uhd)
    make_screenshot(f'part_res_uhd_{theme}')

#       DPI Capture
# =====================================
if process_dpi:
    
    # use dimmed theme
    theme = "dimmed"
    theme_title = f'{theme.capitalize()} Theme'
    load_reaper_theme(theme)

    # 100 %
    current_notification_header = f'{info}dpi 100'
    setup_display_format(format_dpi_100)
    make_screenshot(f'part_dpi_100')

    # 125 %
    current_notification_header = f'{info}dpi 125'
    setup_display_format(format_dpi_125)
    make_screenshot(f'part_dpi_125')

    # 150 %
    current_notification_header = f'{info}dpi 150'
    setup_display_format(format_dpi_150)
    make_screenshot(f'part_dpi_150')

    # 175 %
    current_notification_header = f'{info}dpi 175'
    setup_display_format(format_dpi_175)
    make_screenshot(f'part_dpi_175')

    # 200 %
    current_notification_header = f'{info}dpi 200'
    setup_display_format(format_dpi_200)
    make_screenshot(f'part_dpi_200')

    # 225 %
    current_notification_header = f'{info}dpi 225'
    setup_display_format(format_dpi_225)
    make_screenshot(f'part_dpi_225')

    # 250 %
    current_notification_header = f'{info}dpi 250'
    setup_display_format(format_dpi_250)
    make_screenshot(f'part_dpi_250')

#       Finish
# =====================================

# reset mouse position
mouse_controller.position = current_mousepos

# reset display
current_notification_header = f'{info}Done'
reset_display_format()

# finish with info
print("Done!")
show_notification(f'Automated Screenshot Creation Done!')
time.sleep(2)
close_notification()
