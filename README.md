# Linux Dot(.) Files

My configuration files for some WM's I tried to rice.

## 🚀 Quick Start (Using Chezmoi)

The easiest way to manage these dotfiles is with [chezmoi](https://www.chezmoi.io/).

### 1. Install chezmoi
```bash
# Arch Linux (Omarchy)
sudo pacman -S chezmoi
```

### 2. Initialize and Apply (Omarchy Branch)
```bash
chezmoi init --apply --branch omarchy andeen171
```

### 3. Updating
If you make changes locally:
```bash
chezmoi add ~/.config/waybar/style.css
chezmoi git add .
chezmoi git commit -- -m "feat: update waybar style"
chezmoi git push
```

To pull updates from the repo:
```bash
chezmoi update
```

---

## 🏗 Manual Installation
Just select the branch of the Window-Manager/Compositor/Desktop-Environment and clone the files inside `.config` folder.

## 🖼 Wallpapers
Wallpapers are maintained [HERE](https://github.com/andeen171/Wallpapers)

Screenshots coming soon...
