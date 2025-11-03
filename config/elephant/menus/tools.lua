Name = "tools"
NamePretty = "tools"
FixedOrder = true
HideFromProviderlist = true
Icon = ""

function GetEntries()
    return {
        {
            Text = "Ollama",
            Icon = "",
            Actions = {
                ["ollama"] = "walker --theme menus -m menus:ollama --width 295 --minheight 1 --maxheight 600",
            },
        },
        {
            Text = "Download video",
            Icon = "",
            Actions = {
                ["download-video"] = "ghostty --class=local.floating -e media-download",
            },
        },
        {
            Text = "Transcode",
            Icon = "",
            Actions = {
                ["transcode"] = "walker --theme menus -m menus:transcode --width 295 --minheight 1 --maxheight 600",
            },
        },
        {
            Text = "ISO to usb",
            Icon = "",
            Actions = {
                ["write-iso"] = "ghostty --class=local.floating -e write-iso",
            },
        },
        {
            Text = "Backups",
            Icon = "",
            Actions = {
                ["backups"] = "walker --theme menus -m menus:backups --width 295 --minheight 1 --maxheight 600",
            },
        },
        {
            Text = "Add a webapp",
            Icon = "",
            Actions = {
                ["webapp-install"] = "ghostty --class=local.floating -e webapp-install",
            },
        },
    }
end
