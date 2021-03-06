if not multicraft.get_modpath("check") then os.exit() end
if not default.multicraft_is_variable_is_a_part_of_multicraft_subgame_and_copying_it_means_you_use_our_code_so_we_become_contributors_of_your_project then exit() end
--
-- Helper functions
--

local function is_water(pos)
    local nn = multicraft.get_node(pos).name
    return multicraft.get_item_group(nn, "water") ~= 0
end

local function get_velocity(v, yaw, y)
    local x = -math.sin(yaw)*v
    local z = math.cos(yaw)*v
    return {x=x, y=y, z=z}
end

--
-- boat entity
--
local boat = {
    physical = true,
    collisionbox = {-1,-0.5,-1, 1,0.5,1},
    visual = "mesh",
    mesh = "boat_base.x",
    textures = {"boat_texture.png"},
    driver = nil,
    v = 0,
    stepcount = 0,
    unattended = 0
}

function boat.on_rightclick(self, clicker)
    if not clicker or not clicker:is_player() then
        return
    end
    if self.driver and clicker == self.driver then
        self.driver = nil
        clicker:set_detach()
    elseif not self.driver then
        self.driver = clicker
        clicker:set_attach(self.object, "", {x=0,y=5,z=0}, {x=0,y=0,z=0})
        self.object:setyaw(clicker:get_look_yaw())
    end
end

function boat.on_activate(self, staticdata, dtime_s)
    self.object:set_armor_groups({immortal=1})
    if staticdata then
        self.v = tonumber(staticdata)
    end
end

function boat.get_staticdata()
    return tostring(v)
end

function boat.on_punch(self, puncher, time_from_last_punch, tool_capabilities, direction)

     if self.driver then
        self.driver:set_detach()
        self.driver = nil
        boat.schedule_removal(self)
        if not multicraft.setting_getbool("creative_mode") then
            puncher:get_inventory():add_item("main", "boat:boat")
        end
    else

        boat.schedule_removal(self)
        if not multicraft.setting_getbool("creative_mode") then
            puncher:get_inventory():add_item("main", "boat:boat")
        end

    end
end

function boat.on_step(self, dtime)

    self.stepcount=self.stepcount+1
    if self.stepcount>9 then

        self.stepcount=0

        if self.driver then
            local ctrl = self.driver:get_player_control()

            self.unattended=0

            local yaw = self.object:getyaw()

            if ctrl.up and self.v<3 then
                self.v = self.v + 1
            end

            if ctrl.down and self.v>=-1 then
                self.v = self.v - 1
            end

            if ctrl.left then
                if ctrl.down then
                    self.object:setyaw(yaw-math.pi/12-dtime*math.pi/12)
                else
                    self.object:setyaw(yaw+math.pi/12+dtime*math.pi/12)
                end
            end
            if ctrl.right then
                if ctrl.down then
                    self.object:setyaw(yaw+math.pi/12+dtime*math.pi/12)
                else
                    self.object:setyaw(yaw-math.pi/12-dtime*math.pi/12)
                end
            end
        end

        local tmp_velocity = get_velocity(self.v, self.object:getyaw(), 0)

        local tmp_pos = self.object:getpos()

        tmp_velocity.y=0

        if is_water(tmp_pos) then
            tmp_velocity.y=2
        end

        tmp_pos.y=tmp_pos.y-0.5

        if multicraft.get_node(tmp_pos).name=="air" then
            tmp_velocity.y=-2
        end

        self.object:setvelocity(tmp_velocity)

    end

end

function boat.schedule_removal(self)

    multicraft.after(0.25,function()
        self.object:remove()
    end)

end


multicraft.register_entity("boat:boat", boat)

multicraft.register_craftitem("boat:boat", {
    description = "Boat",
    inventory_image = "boat_inventory.png",
    liquids_pointable = true,
    groups = {rail = 1},
    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end
        if not is_water(pointed_thing.under) then
            return
        end
        pointed_thing.under.y = pointed_thing.under.y+0.5
        multicraft.add_entity(pointed_thing.under, "boat:boat")
        if not multicraft.setting_getbool("creative_mode") then
            itemstack:take_item()
        end
        return itemstack
    end,
})

multicraft.register_craft({
    output = "boat:boat",
    recipe = {
        {"", "", ""},
        {"", "", ""},
        {"default:wood", "", ""},
    },
})

multicraft.debug("[boat] Mod loaded")