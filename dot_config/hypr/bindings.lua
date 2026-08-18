-- Application bindings.
-- Everything Omarchy already provides by default (terminal, browser,
-- nautilus, editor, docker, chatgpt, whatsapp, etc.) lives in
-- /usr/share/omarchy/default/hypr/bindings/*.lua and is NOT redeclared
-- here — doing so double-fires the action on every keypress.
--
-- Only override defaults that need a different app/command on the same key.
hl.unbind("SUPER + SHIFT + M")
o.bind("SUPER + SHIFT + M", "Music", { omarchy = "or-focus spotify" })

hl.unbind("SUPER + SHIFT + W")
o.bind("SUPER + SHIFT + W", "Typora", { launch = "typora --enable-wayland-ime" })

-- Custom bindings below ------------------------------------------------------------------------------

-- Workspace switching.
o.bind("CTRL + ALT + Left", nil, hl.dsp.focus({ workspace = "e-1" }))
o.bind("CTRL + ALT + Right", nil, hl.dsp.focus({ workspace = "e+1" }))

hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.window.cycle_next())

-- Navegar para a janela anterior
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.window.cycle_next({ next = false }))

-- Mover a janela ativa para a próxima posição
hl.bind("SUPER + ALT + SHIFT + mouse_down", hl.dsp.window.swap({ direction = "right" }))

-- Mover a janela ativa para a posição anterior
hl.bind("SUPER + ALT + SHIFT + mouse_up", hl.dsp.window.swap({ direction = "left" }))

-- Keyboard backlight Fn key: cycle g15 brightness off -> 50% -> 100%.
-- IMPORTANT: the omarchy defaults route these keys to omarchy-brightness-keyboard,
-- which writes dell::kbd_backlight (SMBIOS) and wedges this laptop's AW-ELC LED
-- controller until a full power drain — never let those defaults fire here.
hl.unbind("XF86KbdLightOnOff")
hl.unbind("XF86KbdBrightnessUp")
hl.unbind("XF86KbdBrightnessDown")
o.bind("XF86KbdLightOnOff", "Keyboard backlight cycle", "/home/andeen/.cargo/bin/g15 led brightness cycle", { locked = true })
o.bind("XF86KbdBrightnessUp", "Keyboard backlight cycle", "/home/andeen/.cargo/bin/g15 led brightness cycle", { locked = true })
o.bind("XF86KbdBrightnessDown", "Keyboard backlight cycle", "/home/andeen/.cargo/bin/g15 led brightness cycle", { locked = true })
-- This G15's Fn+F5 emits kernel KEY_F18 (scancode 0x69) — Dell routes it to
-- AWCC in software on Windows instead of a kbd-illumination keysym — and
-- XKB's evdev layout presents KEY_F18 to Hyprland as XF86Launch9.
o.bind("XF86Launch9", "Keyboard backlight cycle", "/home/andeen/.cargo/bin/g15 led brightness cycle", { locked = true })

-- Fn+F9 (G-Mode key), scancode 0x68. Upstream hwdb maps it to KEY_PERFORMANCE
-- (701) — above XKB's keysym range, and hyprlua can't parse code:709 either
-- (it registered keycode 0 = a NoSymbol wildcard that also swallowed the ABNT2
-- "/" key). /etc/udev/hwdb.d/61-g15-keyboard.hwdb remaps it to prog1 so it
-- arrives as a normal XF86Launch1 keysym.
-- Needs the NOPASSWD sudoers entry in /etc/sudoers.d/g15-power-toggle.
o.bind(
	"XF86Launch1",
	"Toggle G-Mode power plan",
	'sh -c \'notify-send -t 2000 -a g15 "Power mode" "$(sudo -n /home/andeen/.cargo/bin/g15 power toggle 2>&1)"\'',
	{ locked = true }
)
