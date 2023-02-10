local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath .. '/api.lua')
dofile(modpath .. '/commands.lua')

local Colorize = minetest.colorize
local last_hitter = {}
minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
    if player == nil or hitter == nil or damage <= 0 then return end
    if player:get_hp() > 0 then 
        local weapon = "hand" 
        local pname = player:get_player_name()
        local hname = hitter:get_player_name()
        if tool_capabilities then
            local wielditem = hitter:get_wielded_item()
            weapon = wielditem:get_name()
        end
        last_hitter[pname] = {
            hitter = hname,
            tool_used = weapon
        }
    end
end) 

minetest.register_on_dieplayer(function(player, reason)
    if player then 
        local head_texture = custom_death.get_head_image(player)
        local pos = player:get_pos()
        local pname = player:get_player_name()
        minetest.add_particlespawner({ 
            amount = 1,
            time = 1,
            minpos = {x=pos.x, y=pos.y+1, z=pos.z},
            maxpos = {x=pos.x, y=pos.y+1, z=pos.z},
            minvel = {x=0, y=2, z=0}, 
            maxvel = {x=0, y=2, z=0}, 
            minacc = {x=0,y=0,z=0}, 
            maxacc = {x=0,y=0,z=0}, 
            minexptime = 5,  
            maxexptime = 5,
            minsize = 7.5,
            maxsize = 7.5, 
            texture = head_texture,
            collisiondetection = true,
            vertical = true,
            glow = 10  
        }) 
        custom_death.set_death_position(pname, {x=pos.x-pos.x%1, y=pos.y-pos.y%1, z=pos.z-pos.z%1})
        custom_death.increase_death_count(pname)
        local type = reason.type 
        if type == "punch" then
            if reason.object:is_player() and last_hitter[pname] ~= nil then
                local death_reason_text = "Killed by "..last_hitter[pname].hitter.." with "..last_hitter[pname].tool_used
                custom_death.set_last_killer(pname, last_hitter[pname].hitter, last_hitter[pname].tool_used)
                custom_death.set_death_reason(pname, "player")
                custom_death.set_death_reason_description(pname, death_reason_text)
                minetest.chat_send_player(pname, Colorize("#ef3b3b", "[Server] "..death_reason_text))
            else 
                local death_reason_text = "Killed by a mob"
                custom_death.set_death_reason(pname, "mob")
                custom_death.set_death_reason_description(pname, death_reason_text)
                minetest.chat_send_player(pname, Colorize("#ef3b3b", "[Server] "..death_reason_text))
            end 
        elseif type == "node_damage" then
            local node = minetest.registered_nodes[minetest.get_node(player:getpos()).name]
            local death_reason_text = "Died by "..node.description
            custom_death.set_death_reason_description(pname, death_reason_text)
            custom_death.set_death_reason(pname, "node_damage")
            minetest.chat_send_player(pname, Colorize("#ef3b3b", "[Server] "..death_reason_text))
        elseif type == "fall" then
            local death_reason_text = "Died due to fall damage"
            custom_death.set_death_reason_description(pname, death_reason_text)
            custom_death.set_death_reason(pname, "fall")
            minetest.chat_send_player(pname, Colorize("#ef3b3b", "[Server] "..death_reason_text))
        elseif type == "drown" then
            local death_reason_text = "Died due to drowning"
            custom_death.set_death_reason_description(pname, death_reason_text)
            custom_death.set_death_reason(pname, "drown")
            minetest.chat_send_player(pname, Colorize("#ef3b3b", "[Server] "..death_reason_text))
        end
    end
end)
