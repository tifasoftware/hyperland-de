Name = "themes"
NamePretty = "Themes"
FixedOrder = true
HideFromProviderlist = true
Icon = "󰸌"

function GetEntries()
    return {
        {
            Text = "System theme",
            Icon = "󰸌",
            Actions = {
                ["change-theme"] =
                "walker --theme menus -m menus:system-themes --width 295 --minheight 1 --maxheight 600",
            },
        },
        {
            Text = "Waybar theme",
            Icon = "󰸌",
            Actions = {
                ["change-waybar"] =
                "walker --theme menus -m menus:waybar-themes --width 295 --minheight 1 --maxheight 600",
            },
        },
        {
            Text = "Fastfetch theme",
            Icon = "󰸌",
            Actions = {
                ["change-fastfetch"] =
                "walker --theme menus -m menus:fastfetch-themes --width 295 --minheight 1 --maxheight 600",
            },
        },
        {
            Text = "Starship theme",
            Icon = "󰸌",
            Actions = {
                ["change-starship"] =
                "walker --theme menus -m menus:starship-themes --width 295 --minheight 1 --maxheight 600",
            },
        },
    }
end
