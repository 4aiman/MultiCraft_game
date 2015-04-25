if not minetest.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
hud = {}

local health_hud = {}
local air_hud = {}
hud.armor = {}
local armor_hud = {}

local SAVE_INTERVAL = 0.5*60--currently useless

--default settings
HUD_ENABLE_HUNGER = minetest.setting_getbool("hud_hunger_enable")
HUD_SHOW_ARMOR = false
if minetest.get_modpath("3d_armor") ~= nil then HUD_SHOW_ARMOR = true end
if HUD_ENABLE_HUNGER == nil then HUD_ENABLE_HUNGER = minetest.setting_getbool("enable_damage") end
HUD_HUNGER_TICK = 300
HUD_HEALTH_POS = {x=0.5,y=0.85}
HUD_HEALTH_OFFSET = {x=-175, y=2}
HUD_HUNGER_POS = {x=0.5,y=0.85}
HUD_HUNGER_OFFSET = {x=15, y=2}
HUD_AIR_POS = {x=0.5,y=0.83}
HUD_AIR_OFFSET = {x=15,y=-15}
HUD_ARMOR_POS = {x=0.5,y=0.83}
HUD_ARMOR_OFFSET = {x=-175, y=-15}

--load custom_fuck settings
local set = io.open(minetest.get_modpath("hud").."/hud.conf", "r")
if set then
	dofile(minetest.get_modpath("hud").."/hud.conf")
	set:close()
else
	if not HUD_ENABLE_HUNGER then
		HUD_AIR_OFFSET = {x=15,y=0}
	end
end

--minetest.after(SAVE_INTERVAL, timer, SAVE_INTERVAL)

local function hide_builtin(player)
	 player:hud_set_flags({crosshair = true, hotbar = true, healthbar = false, wielditem = true, breathbar = false})
end


local function custom_fuck_hud(player)

 --fancy hotbar
 --player:hud_set_hotbar_image("hud_hotbar.png")
 --player:hud_set_hotbar_selected_image("hud_hotbar_selected.png")

 if minetest.setting_getbool("enable_damage") then
 --health
        player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_HEALTH_POS,
		scale = {x=1, y=1},
		text = "hud_heart_bg.png",
		number = 20,
		alignment = {x=-1,y=-1},
		offset = HUD_HEALTH_OFFSET,
	})

	health_hud[player:get_player_name()] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_HEALTH_POS,
		scale = {x=1, y=1},
		text = "hud_heart_fg.png",
		number = player:get_hp(),
		alignment = {x=-1,y=-1},
		offset = HUD_HEALTH_OFFSET,
	})

 --air
	air_hud[player:get_player_name()] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_AIR_POS,
		scale = {x=1, y=1},
		text = "hud_air_fg.png",
		number = 0,
		alignment = {x=-1,y=-1},
		offset = HUD_AIR_OFFSET,
	})

 --armor
 if HUD_SHOW_ARMOR then
       player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_ARMOR_POS,
		scale = {x=1, y=1},
		text = "hud_armor_bg.png",
		number = 20,
		alignment = {x=-1,y=-1},
		offset = HUD_ARMOR_OFFSET,
	})

	armor_hud[player:get_player_name()] = player:hud_add({
		hud_elem_type = "statbar",
		position = HUD_ARMOR_POS,
		scale = {x=1, y=1},
		text = "hud_armor_fg.png",
		number = 0,
		alignment = {x=-1,y=-1},
		offset = HUD_ARMOR_OFFSET,
	})
  end
 end

end

--needs to be set always(for 3darmor)
function hud.set_armor()
end


if HUD_ENABLE_HUNGER then dofile(minetest.get_modpath("hud").."/4hunger.lua") end
if HUD_SHOW_ARMOR then dofile(minetest.get_modpath("hud").."/armor.lua") end


local function update_hud(player)
 --air
	local air = player:get_breath()*2
	if player:get_breath() > 10 then air = 0 end
	player:hud_change(air_hud[player:get_player_name()], "number", air)
 --health
	player:hud_change(health_hud[player:get_player_name()], "number", player:get_hp())
 --armor
	local arm = tonumber(hud.armor[player:get_player_name()])
	if not arm then arm = 0 end
	player:hud_change(armor_hud[player:get_player_name()], "number", arm)
end

local function timer(interval, player)
	if interval > 0 then
		minetest.after(interval, timer, interval, player)
	end
end

minetest.register_on_joinplayer(function(player)
	hud.armor[player:get_player_name()] = 0
	minetest.after(0.5, function()
		hide_builtin(player)
		custom_fuck_hud(player)
	end)
end)

local timer = 0
local timer2 = 0
minetest.after(2.5, function()
	minetest.register_globalstep(function(dtime)
	 timer = timer + dtime
	 timer2 = timer2 + dtime
		for _,player in ipairs(minetest.get_connected_players()) do
			if minetest.setting_getbool("enable_damage") then
			 if HUD_SHOW_ARMOR then hud.get_armor(player) end
			 update_hud(player)
			end
		end
		if timer>4 then timer=0 end
	end)
end)
