#!/bin/bash
# Workaround for an Omarchy 4.0.0.alpha bug: omarchy-hook invokes theme-set.d/*
# scripts twice, and the second (bare) invocation lacks the exported rgb_*
# variables that 40-steam.sh needs, overwriting steam.css with empty colors.
# This script is self-contained (reads colors.toml directly) and sorts after
# 40-steam.sh in both passes, so it always leaves a correct steam.css/omarchy.css
# in place no matter which pass runs last.

input_file="$HOME/.local/state/omarchy/current/theme/colors.toml"
output_file="$HOME/.local/state/omarchy/current/theme/steam.css"
adwaita_location="$HOME/.local/share/steam-adwaita"

command -v steam >/dev/null 2>&1 || exit 0
command -v python >/dev/null 2>&1 || exit 0
[[ -f $input_file ]] || exit 0
[[ -d $adwaita_location ]] || exit 0

extract_color() {
    omarchy-theme-color --file "$input_file" "$1" | sed 's/^#//'
}

hex2rgb() {
    local h=$1
    echo "$((16#${h:0:2})), $((16#${h:2:2})), $((16#${h:4:2}))"
}

primary_foreground=$(extract_color foreground)
primary_background=$(extract_color background)
normal_black=$(extract_color color0)
normal_red=$(extract_color color1)
normal_green=$(extract_color color2)
normal_blue=$(extract_color color4)
bright_black=$(extract_color color8)
bright_yellow=$(extract_color color11)

# Bail out if extraction failed rather than writing broken empty values again.
if [[ -z $primary_foreground || -z $primary_background || -z $normal_blue ]]; then
    echo "[SKIPPED] 99-fix-steam-theme: could not extract colors from $input_file"
    exit 0
fi

rgb_primary_foreground=$(hex2rgb "$primary_foreground")
rgb_primary_background=$(hex2rgb "$primary_background")
rgb_normal_black=$(hex2rgb "$normal_black")
rgb_normal_red=$(hex2rgb "$normal_red")
rgb_normal_green=$(hex2rgb "$normal_green")
rgb_normal_blue=$(hex2rgb "$normal_blue")
rgb_bright_black=$(hex2rgb "$bright_black")
rgb_bright_yellow=$(hex2rgb "$bright_yellow")

cat > "$output_file" << EOF
:root {
    /* The main accent color and the matching text value */
    --adw-accent-bg-rgb: ${rgb_normal_blue} !important;
    --adw-accent-fg-rgb: ${rgb_primary_background} !important;
    --adw-accent-rgb: ${rgb_normal_blue} !important;

	/* destructive-action buttons */
    --adw-destructive-bg-rgb: ${rgb_normal_red} !important;
    --adw-destructive-fg-rgb: ${rgb_primary_foreground} !important;
    --adw-destructive-rgb: ${rgb_normal_red} !important;

	/* Levelbars, entries, labels and infobars. These don't need text colors */
    --adw-success-bg-rgb: ${rgb_normal_green} !important;
    --adw-success-fg-rgb: ${rgb_normal_black} !important;
    --adw-success-rgb: ${rgb_normal_green} !important;

    --adw-warning-bg-rgb: ${rgb_bright_yellow} !important;
    --adw-warning-fg-rgb: ${rgb_primary_background} !important;
    --adw-warning-fg-a: 0.8 !important;
    --adw-warning-rgb: ${rgb_bright_yellow} !important;

    --adw-error-bg-rgb: ${rgb_normal_red} !important;
    --adw-error-fg-rgb: ${rgb_normal_black} !important;
    --adw-error-rgb: ${rgb_normal_red} !important;

	/* Window */
    --adw-window-bg-rgb: ${rgb_primary_background} !important;
    --adw-window-fg-rgb: ${rgb_primary_foreground} !important;

	/* Views - e.g. text view or tree view */
    --adw-view-bg-rgb: ${rgb_normal_black} !important;
    --adw-view-fg-rgb: ${rgb_primary_foreground} !important;

	/* Header bar, search bar, tab bar */
    --adw-headerbar-bg-rgb: ${rgb_primary_background} !important;
    --adw-headerbar-fg-rgb: ${rgb_primary_foreground} !important;
    --adw-headerbar-border-rgb: ${rgb_bright_black} !important;
    --adw-headerbar-backdrop-rgb: ${rgb_normal_black} !important;
    --adw-headerbar-shade-rgb: 0, 0, 0 !important;
    --adw-headerbar-shade-a: 0.36 !important;
    --adw-headerbar-darker-shade-rgb: 0, 0, 0 !important;
    --adw-headerbar-darker-shade-a: 0.9 !important;

	/* Split pane views */
    --adw-sidebar-bg-rgb: ${rgb_primary_background} !important;
    --adw-sidebar-fg-rgb: ${rgb_primary_foreground} !important;
    --adw-sidebar-backdrop-rgb: ${rgb_bright_black} !important;
    --adw-sidebar-shade-rgb: 0, 0, 0 !important;
    --adw-sidebar-shade-a: 0.36 !important;
    --adw-secondary-sidebar-bg-rgb: ${rgb_primary_background} !important;
    --adw-secondary-sidebar-fg-rgb: ${rgb_primary_foreground} !important;
    --adw-secondary-sidebar-backdrop-rgb: ${rgb_bright_black} !important;
    --adw-secondary-sidebar-shade-rgb: 0, 0, 0 !important;
    --adw-secondary-sidebar-shade-a: 0.36 !important;

	/* Cards, boxed lists */
    --adw-card-bg-rgb: 255, 255, 255 !important;
    --adw-card-bg-a: 0.08 !important;
    --adw-card-fg-rgb: 255, 255, 255 !important;
    --adw-card-shade-rgb: 0, 0, 0 !important;
    --adw-card-shade-a: 0.36 !important;

	/* Dialogs */
    --adw-dialog-bg-rgb: ${rgb_primary_background} !important;
    --adw-dialog-fg-rgb: ${rgb_primary_foreground} !important;

    /* Popovers */
    --adw-popover-bg-rgb: ${rgb_primary_background} !important;
    --adw-popover-fg-rgb: ${rgb_primary_foreground} !important;
    --adw-popover-shade-rgb: 0, 0, 0 !important;
    --adw-popover-shade-a: 0.36 !important;

	/* Thumbnails */
    --adw-thumbnail-bg-rgb: ${rgb_primary_background} !important;

	/* Miscellaneous */
    --adw-shade-rgb: 0, 0, 0 !important;
    --adw-shade-a: 0.36 !important;
}
EOF

mkdir -p "$adwaita_location/adwaita/colorthemes/omarchy"
cp -p -f "$output_file" "$adwaita_location/adwaita/colorthemes/omarchy/omarchy.css"

cd "$adwaita_location" && ./install.py \
    --color-theme omarchy \
    --extras library/hide_whats_new > /dev/null 2>&1

if pgrep -x steam > /dev/null; then
    echo "steam" >> "${restart_file:-/tmp/.omarchy-steam-fix-restart}"
fi

echo "[SUCCESS] Steam theme re-verified (workaround for omarchy-hook double-invocation bug)"
exit 0
