minetest.register_chatcommand("death_stats", {
    func = function(name, param)
        local death_count = custom_death.get_death_count(name) 
        if death_count == 0 then return end
        local death_pos = custom_death.get_death_position(name)
        local death_reason = custom_death.get_death_reason(name)
        minetest.chat_send_player(name, "[Server] Total times died "..death_count..", last death been at "..death_pos.x..", "..death_pos.y..", "..death_pos.z.." due to "..death_reason)
    end
})