minetest.register_node("pipi:pipi",{
	on_construct=function(pos)
		minetest.get_node_timer(pos):start(30)
	end,
	on_timer = function(pos)
		for index , player in pairs(minetest.get_connected_players()) do
			local inv = player.get_inventory(player)
			inv:add_item("main", "basenodes:pipi_source 99")
			player:set_hp(player:get_hp()-1,{})
		end
		return true
	end,
	groups = {snappy=3}
})
minetest.register_on_joinplayer(function(player)
	minetest.chat_send_all("A player join the game!")
	minetest.set_node({ x = 0, y = 0, z = 0 }, { name = "pipi:pipi" })
	local timer = minetest.get_node_timer({ x = 0, y = 0, z = 0 })
	timer:start(30)
end)