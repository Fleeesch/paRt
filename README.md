# paRT - plain adapting Reaper theme

A custom Reaper theme with a strong focus on functionality.

## Features

- Support for zoom factors 100%, 125%, 150%, 175%, 200%, 225%, 250%
- 3 Theme files covering different brightness levels
- Support for all Reaper V7 assets
- Custom Theme Adjuster
    - 200+ parameters to adjust colors, TCP, MCP, ENVCP
    - Banking of parameters selectively toggle between differen settings
    - Save and recall settings
    - Synchronization of parameter settings between theme files

## Requirements

- Reaper 7.0+ (7.17 recommended)
- js_ReaScriptAPI

### js_ReaScriptAPI
This extension is used for file-dialog. Saving and loading external user setting files is disabled in the Theme Adjuster when the js_ReaScriptAPI is missing

## Installation

### Using ReaPack

Import the repository into your ReaPack instance using the following link within ReaPack's repository manager:

`https://raw.githubusercontent.com/Fleeesch/ReaPack-Fleeesch/master/index.xml`

### Manual Installation

Download the `part_manual_install\*.zip` from the release section of this resporitory and extract the contents into your Reaper ressource folder.

If you want to locate your Reaper ressource folder, look for the action `Options > Show REAPER resource path in explorer/finder...` located in the top menu of Reaper.

**You must keep the folder structure intact.** Any changes in the folder structure will likeley result in malfunction of the Theme Adjuster.

Import ***.lua** scripts within `Scripts/Fleeesch/Themes/paRt` into the Reaper action list. You can open Reaper's action list using the `Actions > Show action list...` command located in the top menu. Then look at for the `New action button` and use its `Load Rescript...` action in order to load the LUA files. You can select all the files at once per import. Check if the scripts have been loaded successfully by typing "paRt" in the `Filter` box.

## Links

- [Manual](doc/part_documentation.adoc)
- [Reaper Forum Thread](https://forum.cockos.com/showthread.php?t=282545)
