if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
multicraft.register_on_joinplayer(function(player)
	local filename = multicraft.get_modpath("player_textures").."/textures/character"
	local f = io.open(filename..".png")
	if f then
		f:close()
	end
end)
