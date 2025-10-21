# Dotfiles for Hyprland on Arch Linux

[![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793D1?logo=arch-linux&logoColor=white)](https://archlinux.org/)

Dotfiles setup heavily based on [Omarchy](https://omarchy.org/), with static and dynamic themes and plenty of useful scripts.

[Credits - read here please](#credits)

<table>
  <tr>
    <td><img src="demo/1.png" width="400"/></td>
    <td><img src="demo/6.png" width="400"/></td>
  </tr>
  <tr>
    <td><img src="demo/4.png" width="400"/></td>
    <td><img src="demo/2.png" width="400"/></td>
  </tr>
  <tr>
    <td><img src="demo/7.png" width="400"/></td>
    <td><img src="demo/3.png" width="400"/></td>
  </tr>
</table>


## Table of Contents

- [Features](#features)
- [Installation](#installation)
  - [Automatic installer](#automatic-installer)
  - [Manual installation](#manual-installation)
- [Screenshots & Videos](#screenshots--videos)
- [Keybinds](#keybinds)
- [Theming & Customization](#theming--customization)
  - [Changing Themes](#changing-themes)
  - [Customizing Configs](#customizing-configs)
- [Credits](#credits)

---

## Features

- **Dynamic Theming System** - Switch between static themes or use dynamic theming with Matugen and Pywal
- **Utility Scripts** - Interactive package management; theming; setup of Postgres & database backup and restoration, Docker, Node.js; video download (with yt-dlp), video and image transcoding (using handbrakecli and imagemagick), interactive backups with fzf
- **Modular ZSH Config** - Zsh setup with some nice custom functions like `cp2c` (copy file content to clipboard - c2pc <file_path>) and `c2f` (clipboard content to file c2f <file_path>)
- **Application Configs** - Configs for Ghostty, Waybar, Walker, Elephant, lazyvim and more

---

## Installation

### Automatic installer

```bash
curl -fsSL https://raw.githubusercontent.com/Maciejonos/dotfiles/master/setup.sh | bash
```

**⚠️ Important Notes:**
- This is specifically for **Arch Linux with Hyprland**
- I've tested the installer on both fresh installs and configured desktops, but ideally you should **know what you're doing**, make sure to backup manually just in case
- Everything that will be changed is backed up first

**What the installer does:**

<details>
<summary><b>Backup</b></summary>

- Backs up everything that will be changed ([backup script](install/lib/backup.sh))
  - Files in `~/.config`
  - `pacman.conf`
  - Ly display manager configuration
  - ZSH and LazyVim configs
  - Everything else that gets modified
- Creates a backup folder in your Home directory with:
  - A text file listing all changed files
  - Commands to quickly revert everything
  - A [rollback script](install/lib/rollback.sh) for easy restoration
</details>

<details>
<summary><b>Package Installation</b></summary>

- Installs [packages](install/pkgs.txt) from official repos and AUR
</details>

<details>
<summary><b>Hardware Detection</b></summary>

The installer [detects your hardware](install/setup-by-hardware):
- **Laptop/Desktop** - Uses brightnessctl or ddcutil respectively, applies proper Hyprland keybinding profiles
- **Monitor Configuration** - Checks your monitor's highest resolution and refresh rate with `hyprctl monitors` and creates appropriate `monitors.conf`
- **Nvidia GPUs** - Detects Nvidia cards and applies [Nvidia-specific setup](install/setup-nvidia) with proper Hyprland env configs
</details>

<details>
<summary><b>Configuration & Theming</b></summary>

- Replaces configuration files in `~/.config` with the [config](config) directory contents
- Sets up static and dynamic themes via [theme setup](install/setup-theme)
- Configures symlinks for theme management
- Some files live in the [default](default) directory - these are git synced and will get overwritten with updates
</details>

<details>
<summary><b>Scripts</b></summary>

A big collection of scripts, mainly used with Walker & Elephant. If installing manually make sure to add the scripts folder to path:
- **Theme Management** - Switch themes, cycle backgrounds, apply dynamic theming
- **Development** - PostgreSQL setup/backup/restore, Docker setup, Node.js setup
- **Package Management** - Install/remove packages interactively
- **Media Tools** - Video downloads (yt-dlp), transcoding (ffmpeg, handbrake-cli)
- **System Utils** - Backup/restore files, keybinds, screenshots menu and video recording
- Most scripts are accessible interactively through Walker or Elephant
</details>

<details>
<summary><b>System Configuration</b></summary>

- [System setup](install/setup-system) configures:
  - Git configuration
  - Ly display manager
  - Pacman configuration
  - UFW firewall
- Full [ZSH setup](default/zshrc) with modular configuration
</details>

### Manual installation

You can manually use the dotfiles without the installer:
1. Clone the repository
2. Copy desired configs from `config/` to `~/.config/` (some configs live in [default](default) directory. Also everything relies on the scripts folder being in path)
3. Copy scripts from `bin/` to your preferred location
4. You can use some install scripts for partial setup if you want

---

## Screenshots & videos

### Waybar themes
Omarchy waybar
![Waybar1](demo/waybar-omarchy.png)
Eli dotfiles waybar
![Waybar2](demo/waybar-eli.png)
Modern waybar config
![Waybar3](demo/waybar-modern.png)

### Lazyvim
![Lazyvim](demo/lazyvim.png)

### Menu overview

### Dynamic Theming

### Application Launcher - Walker
![Walker](demo/walker.png)

### Desktop Overview
<table>
  <tr>
    <td><img src="demo/1.png" width="400"/></td>
    <td><img src="demo/6.png" width="400"/></td>
  </tr>
  <tr>
    <td><img src="demo/4.png" width="400"/></td>
    <td><img src="demo/2.png" width="400"/></td>
  </tr>
  <tr>
    <td><img src="demo/7.png" width="400"/></td>
    <td><img src="demo/3.png" width="400"/></td>
  </tr>
</table>

---

## Keybinds

Most important ones:
- SUPER + Q	= Open Terminal 
- SUPER + W = Close window
- SUPER + R = Open Walker
- SUPER + E = File manager
- SUPER + V = Clipboard
- SUPER + ALT + Space = Menu
- SUPER + CTRL + W = Open Waypaper (to trigger dynamic color update - theme must be set to Matugen or Pywal)


Full configuration can be found in [default/hypr/conf/](default/hypr/conf/)

Walker bindings - `ctrl + x` to go back from submenu

---

## Theming & Customization

### Changing Themes

The setup includes both static and dynamic theming:
 - Open walker and select a theme you like, you can pick between static ones or Matugen/Pywal
 - Also, you can pick 3 different waybar themes and 2 fastfetch presets

### Customizing Configs

- You can modify everything in [config](config) easily, it is not git synced and will not get overwritten
- Configs in [default](default) are git synced and will get overwritten with updates

---

## Credits

By no means am I claiming I created all of this myself - I've taken the whole theming system & a lot of scripts from [Omarchy](https://omarchy.org) - of course a lot are my own or heavily changed. I wanted something more of my own, that I can customize more easily without installing a full distro. Omarchy is an awesome project, and if you haven't heard of it, you should definitely check it out!

Other projects that I really like:
- https://github.com/mylinuxforwork
- https://github.com/elifouts/Dotfiles
