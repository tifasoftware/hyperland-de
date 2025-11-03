Name = "menu"
NamePretty = "Menu"
FixedOrder = true
HideFromProviderlist = true
Icon = ""

function GetEntries()
	return {
		{
			Text = "Update",
			Icon = "",
			Actions = {
				["update"] = "ghostty --class=local.floating -e update-perform",
			},
		},
		{
			Text = "Install package",
			Icon = "󰣇",
			Actions = {
				["pkg-install"] = "ghostty --class=local.floating -e pkg-install",
			},
		},
		{
			Text = "Install AUR package",
			Icon = "",
			Actions = {
				["pkg-install-aur"] = "ghostty --class=local.floating -e pkg-install-aur",
			},
		},
		{
			Text = "Remove package",
			Icon = "",
			Actions = {
				["pkg-remove"] = "ghostty --class=local.floating -e pkg-remove",
			},
		},
		{
			Text = "Change themes",
			Icon = "󰸌",
			Actions = {
				["change-themes"] = "walker --theme menus -m menus:themes --width 295 --minheight 1 --maxheight 600",
			},
		},
		{
			Text = "Capture",
			Icon = "",
			Actions = {
				["capture"] = "walker --theme menus -m menus:capture --width 295 --minheight 1 --maxheight 600",
			},
		},
		{
			Text = "Setup",
			Icon = "󰉉",
			Actions = {
				["setup"] = "walker --theme menus -m menus:setup --width 295 --minheight 1 --maxheight 600",
			},
		},
		{
			Text = "Tools",
			Icon = "",
			Actions = {
				["tools"] = "walker --theme menus -m menus:tools --width 295 --minheight 1 --maxheight 600",
			},
		},
		{
			Text = "Keybindings",
			Icon = "",
			Actions = {
				["keybindings"] = "walker --theme menus -m menus:keybindings --width 800 --minheight 1 --maxheight 600",
			},
		},
		{
			Text = "System",
			Icon = "󰐥",
			Actions = {
				["system"] = "walker --theme menus -m menus:system --width 295 --minheight 1 --maxheight 600",
			},
		},
	}
end
