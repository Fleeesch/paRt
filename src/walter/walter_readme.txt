;
;   ==============================================
;       paRt WALTER File Readme
;   ==============================================
;
;   This file contains all the custom layouts provided by Reaper’s theming layout engine.
;   Since the theme offers a high amount of user customization, this file is pretty large and challenging to maintain or even modify.
;   This guide gives you a quick overview of what’s going on in here.
;   
;   -----------------------------------
;       Formatting
;   -----------------------------------
;
;   WALTER doesn’t enforce any formatting rules.
;   Still, to keep things readable this file relies heavily on line breaks
;   and follows a somewhat consistent visual layout:
;
;       set TargetVariable                                      \\
;           ?condition                                          \\
;               >> value if condition is true <<                \\
;               >> value if condition is false <<
;
;   This increases the linecount, but you avoids overly long lines most of the time.
;
;   -----------------------------------
;       Variable Names
;   -----------------------------------
;
;   WALTER doesn’t have variable types, but to keep things organized
;   this file uses a simple naming scheme:
;
;       "VAL_..."       ->  pre-computed semi-constants meant for repeated use later
;       "CUR_..."       ->  cursor values that keep getting updated while drawing
;       "VARIABLE"      ->  plain uppercase names are reserved for macro arguments
;
;   -----------------------------------
;       "THEMEBUILDER" Blocks
;   -----------------------------------
;
;    Several comment lines in this file contain the word "THEMEBUILDER".
;    They sometimes come with matching opening and closing comment markers.
;
;    These are placeholders that get dynamically replaced with content from other files
;    during the theme-building process whenever a new release is created.
;    They include things like the WALTER parameter list or static color values reserved for each theme file.
;
;    Best to leave them as they are. If you're modifying the theme, it's recommended to replace them with
;    the content from newer official paRt releases. An incomplete or altered parameter list, for example,
;    can easily make the Theme Adjuster crash.
;
;   -----------------------------------
;       [BOOKMARKS]
;   -----------------------------------
;
;    There are several comment lines in this file that contain hints written like [THIS].
;    They’re basically little bookmarks that point to edge cases, exceptions, and other important events.
;    Here’s a quick overview:
;
;    [LINUX OS FIX]      - exception for Linux operating systems
;    [MAC OS FIX]        - exception for Apple operating systems
;    [DRAW]              - marks a command that tells Reaper to actually place an object somewhere
;    [ROUND]             - marks calculations that use a pseudo-rounding algorithm
;    [SHARED]            - inserts a macro that’s also used elsewhere
;    [DEV]               - development tools (these blocks should be commented out for release)
;
;   -----------------------------------
;       Macros
;   -----------------------------------
;
;    This theme file uses macros extensively to streamline repeated code.
;    All macros start with "MAC_..." so they are easy to identify.
;
;    "Shared" Macro Concept:
;        Some macros end with "..._SharedCode_Open" or "..._SharedCode_Close".
;        These exist to reduce redundancy by covering sections shared across multiple elements.
;        You don't need to duplicate these sections manually.
;
;        Here's an abstract example:
;
;            MAC_drawContents_SharedCode_Open
;                >> code applied to all track types before individual track code <<
;            endmacro
                ;
;            MAC_drawContents_SharedCode_Close
;                >> code applied to all track types after individual track code <<
;            endmacro
;
;            MAC_drawContentsOfMasterTrack
;                MAC_drawContents_SharedCode_Open
;                >> code specific to the master track <<
;                MAC_drawContents_SharedCode_Close
;            endmacro
;
;            MAC_drawContentsOfArrangeTrack
;                MAC_drawContents_SharedCode_Open
;                >> code applied to all non-master tracks <<
;                MAC_drawContents_SharedCode_Close
;            endmacro
;