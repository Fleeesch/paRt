# paRt - plain adapting Reaper theme

A custom Reaper theme with a heavy focus on functionality.
  
* 3 theme variants with different brightness levels and parameter synchronization
* Full support for zoom factors 100%, 125%, 150%, 175%, 200%, 225%, 250%
* Complete coverage of all Reaper V7 UI elements
* Custom Theme Adjuster with extensive configuration options

## Requirements

- Reaper 7.55+

## Installation

### Using ReaPack

- Import this repository into your ReaPack instance using the following link within ReaPack's repository manager:

`https://raw.githubusercontent.com/Fleeesch/ReaPack-Fleeesch/master/index.xml`

- Inside ReaPack, use the filter and look for "paRt" und select it for installtion.

### Manual Installation

- Download a `part_manual_install[version-nr].zip` from the release section of this resporitory
- extract the contents into the `ColorThemes` folder in your Reaper ressource folder [^1]
- Import all LUA scripts within `Scripts/Fleeesch/Themes/paRt` using the Reaper action list [^2]


**You must keep the folder structure intact.** Any changes in the folder structure will likeley result in malfunction of the Theme Adjuster.


## Links

- [User Guide](doc/part_documentation.adoc)
- [Reaper Forum Thread](https://forum.cockos.com/showthread.php?t=282545)



[^1]: ressource folder can be open with `Options > Show REAPER resource path in explorer/finder...`

[^2]: scripts can be imported manually under `Actions > Show action list...`