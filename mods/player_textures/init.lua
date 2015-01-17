minetest.register_on_joinplayer(function(player)
	local filename = minetest.get_modpath("player_textures").."/textures/character"
	local f = io.open(filename..".png")
	if f then
		f:close()
	end
end)
