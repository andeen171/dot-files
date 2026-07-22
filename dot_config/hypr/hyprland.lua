-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Load user modules from ~/.config and Omarchy defaults from $OMARCHY_PATH.
package.path = os.getenv("HOME")
	.. "/.config/?.lua;"
	.. (os.getenv("OMARCHY_PATH") or (os.getenv("HOME") .. "/.local/share/omarchy"))
	.. "/?.lua;"
	.. package.path

-- All Omarchy default setups
require("default.hypr.omarchy")

-- Change your own setup in these files and override defaults.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- App-specific window rules.
require("hypr.apps")

-- Workspace-to-monitor assignments.
-- hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "4", monitor = "eDP-2" })
-- hl.workspace_rule({ workspace = "5", monitor = "eDP-2" })
-- o.window("qemu", { workspace = "5" })
hl.on("hyprland.start", function()
	-- Executa o comando de setar o cursor ao iniciar
	hl.exec_cmd("hyprctl setcursor catppuccin-mocha-dark-cursors 24")
end)
-- Regra para os tooltips padrão do Edge
hl.window_rule({
	name = "edge-empty-popups",
	match = {
		class = "",
		title = "^$",
	},
	float = true,
	no_anim = true,
	no_focus = true,
	move = { "cursor_x + 15", "cursor_y + 15" },
})
