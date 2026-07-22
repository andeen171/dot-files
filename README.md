# Linux Dot(.) Files

My configuration files for some WM's I tried to rice.

## 🚀 Quick Start (Using Chezmoi)

The easiest way to manage these dotfiles is with [chezmoi](https://www.chezmoi.io/).

### 1. Install chezmoi
```bash
# Arch Linux (Omarchy)
sudo pacman -S chezmoi
```

### 2. Initialize and Apply (Chezmoi Branch)
```bash
chezmoi init --apply --branch chezmoi andeen171/dot-files
```

> Note: the `omarchy` branch keeps the old plain `.config` layout for manual
> installs (see below) and is **not** chezmoi-compatible (chezmoi ignores
> top-level dotfiles/dirs that aren't named with its `dot_`/`executable_`
> convention). Only the `chezmoi` branch actually works with `chezmoi init`.

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

## 📦 External Dependencies

Chezmoi only manages files, not packages/binaries/system state. A few things
referenced by these dotfiles need to be installed separately on a fresh
machine, or the related config will silently do nothing (e.g. an empty
waybar module):

### Dell G15 keyboard/fan control (`g15`)

The waybar `custom/g15` module, the `~/.local/bin/omarchy-brightness-keyboard`
shim, the `~/.local/bin/g15-tui`/`g15-wedge-watch` scripts and the
`g15-wedge-watch` systemd user timer all call the `g15` binary, built from
[andeen171/g15-cli](https://github.com/andeen171/g15-cli).

1. Install the binary (published on the AUR):
   ```bash
   yay -S g15-cli
   ```
2. Apply the Omarchy-specific system integration (udev hwdb keycode remap,
   sudoers entry for `g15 power toggle`, masking `systemd-backlight` so it
   doesn't re-wedge the LED controller on boot/lock). This is hardware- and
   install-specific, so it's kept as a manual checklist in the project repo
   rather than automated here: see
   [`omarchy.md`](https://github.com/andeen171/g15-cli/blob/master/omarchy.md).
3. (Optional) Re-arm the wedge watchdog if you need to debug the LED
   controller again:
   ```bash
   systemctl --user enable --now g15-wedge-watch.timer
   ```
   It ships disabled by default (see the timer file for why).

## 🏗 Manual Installation
Just select the branch of the Window-Manager/Compositor/Desktop-Environment and clone the files inside `.config` folder.

## 🖼 Wallpapers
Wallpapers are maintained [HERE](https://github.com/andeen171/Wallpapers)

Screenshots coming soon...
