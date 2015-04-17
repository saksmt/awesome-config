return {
    terminal           = 'xterm',                     -- | Terminal
    editor             = os.getenv('EDITOR') or 'vi', -- | Editor
    isTitlebarsEnabled = false,                       -- | Whether to use titlebars for clients
    modkey             = 'Mod4',                      -- | "Super"-key
    onlyOneTray        = true                         -- | Spawn tray only at first screen
}
