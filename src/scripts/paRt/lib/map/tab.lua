Part.Gui.Tab = {}

-- :::::::::::::::::::::::::::::::::::::::
--      Tab Header Bar
-- :::::::::::::::::::::::::::::::::::::::

Part.Cursor.stackCursor()

Part.Cursor.setCursor(0, 0, Part.Global.win_w, Part.Global.tab_height, 0, 0)

-- Tab Bar
Part.Gui.Tab.tab_top = Part.Tab.Group.TabGroup:new(nil, "Top Menu")

-- Tab Sub-Entries
Part.Gui.Tab.tab_colors = TabEntry:new(nil, Part.Gui.Tab.tab_top, "Colors")
Part.Gui.Tab.tab_transport = TabEntry:new(nil, Part.Gui.Tab.tab_top, "Transport")
Part.Gui.Tab.tab_tcp = TabEntry:new(nil, Part.Gui.Tab.tab_top, "TCP")
Part.Gui.Tab.tab_mcp = TabEntry:new(nil, Part.Gui.Tab.tab_top, "MCP")

Part.Cursor.incCursor(0, Part.Cursor.getCursorH())

-- Global
Part.Gui.Tab.tab_colors_sub = Part.Tab.Group.TabGroup:new(nil, "Global", Part.Gui.Tab.tab_colors, 1)
Part.Gui.Tab.tab_colors_themes = TabEntrySub:new(nil, Part.Gui.Tab.tab_colors_sub, "Themes / Adjustments")
Part.Gui.Tab.tab_colors_tracks = TabEntrySub:new(nil, Part.Gui.Tab.tab_colors_sub, "Track / Envelope / Meter")

-- Transport
Part.Gui.Tab.tab_transport_sub = Part.Tab.Group.TabGroup:new(nil, "Transport", Part.Gui.Tab.tab_transport, 1)

-- Tcp
Part.Gui.Tab.tab_tcp_sub = Part.Tab.Group.TabGroup:new(nil, "TCP", Part.Gui.Tab.tab_tcp, 1)
Part.Gui.Tab.tab_tcp_general = TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "General")
Part.Gui.Tab.tab_tcp_track = TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "Track")
Part.Gui.Tab.tab_tcp_envcp = TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "ENVCP")
Part.Gui.Tab.tab_tcp_master = TabEntrySub:new(nil, Part.Gui.Tab.tab_tcp_sub, "Master")

-- Mcp
Part.Gui.Tab.tab_mcp_sub = Part.Tab.Group.TabGroup:new(nil, "MCP", Part.Gui.Tab.tab_mcp, 1)
Part.Gui.Tab.tab_mcp_general = TabEntrySub:new(nil, Part.Gui.Tab.tab_mcp_sub, "General")
Part.Gui.Tab.tab_mcp_track = TabEntrySub:new(nil, Part.Gui.Tab.tab_mcp_sub, "Track")
Part.Gui.Tab.tab_mcp_master = TabEntrySub:new(nil, Part.Gui.Tab.tab_mcp_sub, "Master")

-- Bank Bar
Part.Cursor.setCursorSize(Part.Global.win_w, Part.Global.bank_bar_size)
Part.Cursor.setCursorPos(0, Part.Global.win_h - Part.Cursor.getCursorH())

-- create bank bar
Part.Cursor.stackCursor()

Part.Gui.BankBar = Part.Layout.BankBar.BankBar:new(nil, Part.Bank.Handler)

Part.Cursor.destackCursor()

-- :::::::::::::::::::::::::::::::::::::::
--      Message Handler
-- :::::::::::::::::::::::::::::::::::::::

Part.Cursor.incCursor(0, -10)
Part.Cursor.setCursorPos(0, Part.Cursor.getCursorY())
Part.Cursor.setCursorSize(Part.Global.win_w - 10, Part.Cursor.getCursorH())

Part.Gui.MessageHandler = Part.Message.Handler.MessageHandler:new()

Part.Cursor.destackCursor()
