if not minetest.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
--[[
  DOM, renew of the watch mod

  Original from Echo, here: http://forum.minetest.net/viewtopic.php?id=3795
]]--


--Rotinas usadas pelo mod
dofile(minetest.get_modpath("watch").."/rotinas.lua")

--Declarações dos objetos
dofile(minetest.get_modpath("watch").."/itens.lua")

-- Apenas para indicar que este módulo foi completamente carregado.
DOM_mb(minetest.get_current_modname(),minetest.get_modpath(minetest.get_current_modname()))
