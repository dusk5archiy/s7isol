return function(hl)
	hl.on("hyprland.start", function()
		hl.exec_cmd("systemctl --user start hyprpolkitagent")
		hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")
	end)
end
