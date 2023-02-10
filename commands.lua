--only enable the command if the setting is set to true
local Colorize = minetest.colorize
if custom_death.tp_bones == true then
    minetest.register_chatcommand("bones", {
        description = "",
        privs = {interact=true}, 
        func = function(name, param)
            local player = minetest.get_player_by_name(name)
            --not died once?
            local death_pos = custom_death.get_death_position(name)
            if not next(death_pos) == 0 then 
                minetest.chat_send_player(name, Colorize("#ef3b3b", "[Server] You haven't died yet"))
                return 
            end
            if custom_death.pay_tp_bones == true then
                local wielditem = player:get_wielded_item()
                if wielditem:get_name() == custom_death.pay_item_tp_bones and wielditem:get_count() >= custom_death.pay_amouth then 
                    wielditem:set_count(wielditem:get_count() - custom_death.pay_amouth)
                    player:set_wielded_item(wielditem)
                    player:set_pos(custom_death.get_death_position(name))
                else
                    minetest.chat_send_all("[Server] Error you need to hold "..custom_death.pay_amouth.." "..custom_death.pay_item_tp_bones.." in order to teleport") 
                end
            else    
                player:set_pos(custom_death.get_death_position(name))
            end
        end
    }) 
end


if custom_death.show_death_reason == true then
    minetest.register_chatcommand("death_reason", {
        description = "",
        privs = {interact=true},
        func = function(name, param)
            --not died once?
            local message = custom_death.get_death_reason_description(name)
            if if message == "" then 
                minetest.chat_send_player(name, Colorize("#ef3b3b", "[Server] You haven't died yet"))
                return 
            end
            minetest.chat_send_player(name, Colorize("#3aafe9", "[Server] "..message)) 
        end
    }) 
end

minetest.register_chatcommand("death_coords", {
    description = "",
    privs = {interact=true},
    func = function(name, param)
        --not died once?
        local death_pos = custom_death.get_death_position(name)
        if not next(death_pos) == 0 then 
            minetest.chat_send_player(name, Colorize("#ef3b3b", "[Server] You haven't died yet"))
            return 
        end
        minetest.chat_send_player(name, Colorize("#3aafe9", "[Server] Last death coords "..death_pos.x..", "..death_pos.y..", "..death_pos.z)) 
    end
}) 
