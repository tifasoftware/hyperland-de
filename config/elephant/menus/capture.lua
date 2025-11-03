Name = "capture"
NamePretty = "Capture"
FixedOrder = true
HideFromProviderlist = true
Icon = ""

function GetEntries()
    return {
        {
            Text = "Screenshot",
            Icon = "",
            Actions = {
                ["screenshot"] = "walker --theme menus -m menus:screenshots --width 295 --minheight 1 --maxheight 600",
            },
        },
        {
            Text = "Record",
            Icon = "",
            Actions = {
                ["record"] = "kooha",
            },
        },
    }
end
