custom_death = {}
--Settings
custom_death.save_on_time = true 
custom_death.save_timer = 1800
custom_death.tp_bones = true
custom_death.pay_tp_bones = true
custom_death.pay_item_tp_bones = "default:diamond"
custom_death.pay_amouth = 5
custom_death.show_death_reason = true
--
local storage = minetest.get_mod_storage()
function custom_death.save_data(data)
    if type(data) == "table" then
        storage:set_string("custom_death", minetest.serialize(data))
    end
end

function custom_death.load_data()
    local death_data = storage:get_string("custom_death")
    if death_data then
        death_data = minetest.deserialize(death_data)
        --extra check needed
        if type(death_data) ~= "table" then
            death_data = {} 
        end
    else 
        death_data = {}
    end
    return death_data
end

local data = custom_death.load_data()

function custom_death.get_head_image(player)
    local pname = player:get_player_name()
    local skin = skins.skins[pname]..".png"
    local texture = "[combine:8x8:-8,-8="..skin.."^[brighten"
    return texture
end

function custom_death.get_death_position(name)
   return data[name].death_pos
end
    
function custom_death.get_death_count(name)
   return data[name].death_count 
end
    
function custom_death.increase_death_count(name)
    data[name].death_count = tonumber(data[name].death_count) +1    
end

function custom_death.set_death_position(name, pos)
    data[name].death_pos = pos
end

function custom_death.set_death_reason(name, reason)
    data[name].death_reason = reason 
end

function custom_death.get_death_reason(name)
    return data[name].death_reason    
end
   
function custom_death.get_death_reason_description(name)
    return data[name].death_reason_description    
end

function custom_death.set_death_reason_description(name, reason)
    data[name].death_reason_description = reason   
end

function custom_death.get_last_killer(name)
    return data[name].killer, data[name].killer_weapon
end

function custom_death.set_last_killer(name, killer, weapon)
    data[name].killer = killer
    data[name].killer_weapon = weapon
end

local function create_registery(name)
    data[name] = {
        death_pos = {},
        death_count = 0,
        death_reason = "",
        death_reason_description = "",
        killer = "",
        killer_weapon = ""
    }
end
 
if custom_death.save_on_time == true then
    local timer = 0
    minetest.register_globalstep(function(dtime)
        timer = timer +dtime
        if timer >= custom_death.save_timer then
            custom_death.save_data(data)
            timer = 0
        end
    end)
end

minetest.register_on_shutdown(function() 
    custom_death.save_data(data)
end)

minetest.register_on_joinplayer(function(player)
    if player == nil then return end
    local name = player:get_player_name()
    if data[name] == nil then
        create_registery(name)
    end
end)
