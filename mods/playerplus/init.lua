if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
--[[
    walking on ice makes player walk faster,
    stepping through snow slows player down,
    touching a cactus hurts player,
    player stuck inside node suffocates.

    PlayerPlus by TenPlus1
]]

pp = {}

local time = 0
multicraft.register_globalstep(function(dtime)

    time = time + dtime
    local def = {}

    -- every 1 second
    if time > 1 then

        -- reset time for next check
        time = 0

        -- check players
        for _,player in ipairs(multicraft.get_connected_players()) do

            -- where am I?
            local pos = player:getpos()

            -- what am I standing on?
            pos.y = pos.y - 0.1 -- just under player to detect snow also
            local nod = multicraft.get_node(pos).name
            pos.y = pos.y + 0.1

            -- is 3d_armor mod active? if so make armor physics default
            if multicraft.get_modpath("3d_armor") then
                def = armor.def[player:get_player_name()] or nil
            end

            -- set to armor physics or defaults
            pp.speed = def.speed or 1
            pp.jump = def.jump or 1
            pp.gravity = def.gravity or 1

            -- standing on ice? if so walk faster
            if nod == "default:ice" then
                pp.speed = pp.speed + 0.4

            -- standing on snow? if so walk slower
            elseif nod == "default:snow" or nod == "default:snowblock" then
                pp.speed = pp.speed - 0.4
            end

            -- set player physics
            player:set_physics_override(pp.speed, pp.jump, pp.gravity)
            -- print ("Speed:", pp.speed, "Jump:", pp.jump, "Gravity:", pp.gravity)

            -- get node at head level
            pos.y = pos.y + 1
            nod = multicraft.get_node(pos).name
            pos.y = pos.y - 1

            -- is player suffocating inside node? (nodes found in default game only)
            if multicraft.registered_nodes[nod]
            and multicraft.registered_nodes[nod].walkable
            and nod:find("default:")
            and not multicraft.check_player_privs(player:get_player_name(), {noclip=true}) then
                if player:get_hp() > 0 then
                    player:set_hp(player:get_hp()-1)
                end
            end

            -- am I near a cactus?
            local near = multicraft.find_node_near(pos, 1, "default:cactus")
            if near then

                -- am I touching the cactus? if so it hurts
                for _,object in ipairs(multicraft.get_objects_inside_radius(near, 1.0)) do
                    if object:get_hp() > 0 then
                        object:set_hp(object:get_hp()-1)
                    end
                end

            end

        end

    end
end)
