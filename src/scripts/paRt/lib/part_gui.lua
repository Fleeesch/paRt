-- load theme-relevant data to ensure using the right colors

Part.Gui.Theme.checkCurrentTheme()

Part.Gui.Macros = require("lib.map.macros")

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Tab Header
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require("lib.map.tab")

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Map : Global
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require("lib.map.colors.adjustments")
require("lib.map.colors.track")

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Map : Transport
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require("lib.map.transport.transport")

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Map : TCP
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require("lib.map.tcp.general")
require("lib.map.tcp.track")
require("lib.map.tcp.envcp")
require("lib.map.tcp.master")

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--      Map : MCP
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require("lib.map.mcp.general")
require("lib.map.mcp.track")
require("lib.map.mcp.master")
