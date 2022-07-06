local morenodesfuel = 0
local distance = 100000
local speed = 0
local is_joinplayer = false
local newpl = nil
local telpposun = {}
local telpposdeux = {}
local spawned=false
minetest.register_on_respawnplayer(function(player)
	spawned=false
	is_joinplayer=true
	newpl=player
	minetest:chat_send_player(player,"vous êtes mort! votre progression a été REINITIALISEE!!!")
end)
minetest.register_on_joinplayer(function(player)
	spawned=false
	is_joinplayer=true
	newpl=player
end)
minetest.register_node("morenodes:Fe",{
	description = "Fer",
	tiles = {"morenodes_Fe.png"},
	--groups = {snappy=3}
})
minetest.register_node("morenodes:space",{
	description = "espace",
	tiles = {"morenodes_space.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	light_source = 14,
	--groups = {snappy=3}
})
minetest.register_node("morenodes:glass", {
	description = "vitre",
	drawtype = "glasslike_framed_optional",
	tiles = {"default_glass.png", "default_glass_detail.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	paramtype2 = "glasslikeliquidlevel",
	sunlight_propagates = true,
	is_ground_content = false,
	--groups = {snappy=3}
})
minetest.register_node("morenodes:meselamp", {
	description = "Lampe",
	drawtype = "glasslike",
	tiles = {"default_meselamp.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	light_source = 14,
	--groups = {snappy=3}
})
minetest.register_node("morenodes:Spw",{
	description = "spawn",
	tiles = {"morenodes_Fe.png"},
	on_construct=function(pos)
		minetest.get_node_timer(pos):start(0.5)
	end,
	on_timer=function(pos)
		if is_joinplayer then
			newpl:set_pos(pos)
			spawned=true
		end
		return true
	end,
	--groups = {snappy=3}
})
minetest.register_on_joinplayer(function(player)
	minetest.show_formspec(player:get_player_name(), "morenodes:hello", "formspec_version[4]size[10,10]label[0,0.3;Bienvenue dans votre vesseau spatiale! vous devez]label[0,0.8;retourner sur Terre. Pour ce faire, vous devez produire]label[0,1.3;du bio carburant à base de plantes. Utilisez]label[0,1.8;la rafinerie pour cela. Ensuite, introduisez le carburant]label[0,2.3;dans les réacteurs. Vous devez manger pour régénérer]label[0,2.3;vos vies qui disparaissent régulièrement.Les bessoins humains]label[0,2.3;vous obligent à aller aux toilettes régulièrement.]label[0,2.3;Vous pouvez fabriquer des rafineries en minant]label[0,2.3;dans l'astéroïd. le craft consiste à mettre les]label[0,2.3;morceaux d'astéroïdes en carré (comme pour un four)]label[0,2.3;votre distance à la terre s'affiche sur le tableau de bord.]label[0,2.3;Bonne chance !]button_exit[3.5,9;3,1;quit;ok]")
end)
minetest.register_node("morenodes:foin",{
	description = "foin destinée à la fabrication de biocarburant",
	tiles={"morenodes_foin.png"},
	groups = {snappy=3}
})
minetest.register_node("morenodes:plant5",{
	description = "plante destinée à la fabrication de biocarburant",
	tiles = {"morenodes_plant5.png"},
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	on_construct=function(pos)
		minetest.get_node_timer(pos):start(1)
	end,
	on_timer = function(pos)

	end,
	after_dig_node=function(pos)
		minetest.add_item(pos, "morenodes:foin")
		minetest.add_item(pos,"morenodes:plant1")
	end,
	drop="",
	groups = {snappy=3}
})
local metas={
	"morenodes:plant1",
	"morenodes:plant1",
	"morenodes:plant1",
	"morenodes:plant1"
}
for i,ii in pairs(metas)do
		minetest.register_node("morenodes:plant"..i,{
			description = "plante destinée à la fabrication de biocarburant",
			tiles = {"morenodes_plant"..i..".png"},
			drawtype = "plantlike",
			paramtype = "light",
			sunlight_propagates = true,
			walkable = false,
			buildable_to = true,
			drop=ii,
			on_construct=function(pos)
				minetest.get_node_timer(pos):start(60)
			end,
			on_timer = function(pos)

			end,
			groups = {snappy=3}
		})
end
for i,ii in pairs(metas)do
	local def = minetest.registered_nodes["morenodes:plant"..i]
	def.on_timer=function(pos)
		minetest.set_node(pos,minetest.registered_nodes["morenodes:plant"..i+1])
	end
end
minetest.register_node("morenodes:spaceshipfuel",{
	description = "carburant",
	tiles = {"morenodes_spaceshipfuel.png"},
	groups = {snappy=3}
})
minetest.register_node("morenodes:rafinery",{
	description = "rafinerie",
	tiles = {"morenodes_rafinery.png"},
	on_construct=function(pos)
		minetest.get_node_timer(pos):start(1)
		local meta=minetest.get_meta(pos)
		meta:set_string("infotext", "rafinerie")
		local inv = meta:get_inventory()
		inv:set_size("main", 1)
		meta:set_string("formspec",
		"size[8,9]"..
		"list[current_name;main;0,0;8,4;]"..
		"list[current_player;main;0,5;8,4;]" ..
		"listring[]"..
		"button[3.5,3.5;2,2;go;GO]")
		meta:set_int("go",0)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	on_timer = function(pos)
		local meta = minetest.get_meta(pos)
		local inv=meta:get_inventory()
		local invmain=inv:get_list("main")
		local cooked, aftercooked
		cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = invmain})
		if cooked.time ~= 0 then
			if meta:get_int("go")==1 then
				meta:set_int("time",meta:get_int("time")+1)
				if meta:get_string("infotext")== "rafinage..." then
					meta:set_string("infotext", "rafinage")
					meta:set_string("formspec","size[8,9]list[current_name;main;0,0;8,4;]list[current_player;main;0,5;8,4;]listring[]button[3.5,3.5;2,2;go;"..
					"rafinage]")
				elseif meta:get_string("infotext")== "rafinage" then
					meta:set_string("infotext", "rafinage.")
					meta:set_string("formspec","size[8,9]list[current_name;main;0,0;8,4;]list[current_player;main;0,5;8,4;]listring[]button[3.5,3.5;2,2;go;"..
					"rafinage.]")
				elseif meta:get_string("infotext")== "rafinage." then
					meta:set_string("infotext", "rafinage..")
					meta:set_string("formspec","size[8,9]list[current_name;main;0,0;8,4;]list[current_player;main;0,5;8,4;]listring[]button[3.5,3.5;2,2;go;"..
					"rafinage..]")
				elseif meta:get_string("infotext")== "rafinage.." then
					meta:set_string("infotext", "rafinage...")
					meta:set_string("formspec","size[8,9]list[current_name;main;0,0;8,4;]list[current_player;main;0,5;8,4;]listring[]button[3.5,3.5;2,2;go;"..
					"rafinage...]")
				end
				if meta:get_int("time")>60 then
					inv:set_stack("main",1,cooked.item)
					meta:set_int("time",0)
					meta:set_int("go",0)
					meta:set_string("formspec",
					"size[8,9]"..
					"list[current_name;main;0,0;8,4;]"..
					"list[current_player;main;0,5;8,4;]" ..
					"listring[]"..
					"button[3.5,3.5;2,2;go;GO]")
					meta:set_string("infotext", "rafinerie")
				end
			end
		end
		return true
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.go then
			local meta = minetest.get_meta(pos)
			meta:set_int("go",1)
			meta:set_string("formspec",
			"size[8,9]"..
			"list[current_name;main;0,0;8,4;]"..
			"list[current_player;main;0,5;8,4;]" ..
			"listring[]"..
			"button[3.5,3.5;2,2;go;rafinage...]")
			meta:set_string("infotext", "rafinage...")
		end
	end,
	groups = {snappy=3}
})
minetest.register_craft({
	type = "cooking",
	output = "morenodes:spaceshipfuel",
	recipe = "morenodes:foin",
})
minetest.register_node("morenodes:WC",{
	description = "toilettes",
	tiles = {"morenodes_WC.png","morenodes_Fe.png"},
	on_construct=function(pos)
		local meta =minetest.get_meta(pos)
		meta:set_string("formspec",
		"formspec_version[4]"..
		"size[2,2]"..
		"button[0,0;2,2;go;faire pipi]"
		)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.go then
			local inv=sender:get_inventory()
			for i,ii in pairs(inv:get_list("main"))do
				--minetest.chat_send_player("singleplayer",ii:get_name())
				if ii:get_name() == "basenodes:pipi_source" then
					--minetest.chat_send_player("singleplayer","PIPI!")
					for i=1,99 do
					inv:remove_item("main", ii)
					end
				end
			end
		end
	end
})
minetest.register_node("morenodes:spaceshipreactor",{
	description = "reactor",
	tiles = {"morenodes_reactor.png"},
	on_construct=function(pos)
		local meta =minetest.get_meta(pos)
		meta:set_string("formspec",
		"formspec_version[4]"..
		"size[4,4]"..
		"button[0,0;4,4;go;vider carburant]"
		)
		meta:set_string("infotext", "réacteur")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.go then
			local inv=sender:get_inventory()
			for i,ii in pairs(inv:get_list("main"))do
				--minetest.chat_send_player("singleplayer",ii:get_name())
				if ii:get_name() == "morenodes:spaceshipfuel" then
					--minetest.chat_send_player("singleplayer","FUEL!")
					
					if inv:remove_item("main", ii) then
						morenodesfuel=morenodesfuel+1
					end
					
				end
			end
		end
	end
})
minetest.register_node("morenodes:gotomine",{
	description = "ecran de teleportation",
	tiles = {"morenodes_statuslabel.png","morenodes_Fe.png"},
	on_construct=function(pos)
		local meta =minetest.get_meta(pos)
		meta:set_string("formspec",
		"formspec_version[4]"..
		"size[4,4]"..
		"button[0,0;4,4;go;aller à la mine]"
		)
		meta:set_string("infotext", "cliquez pour voyager")
		if telpposun.x then
			telpposdeux=pos
			meta:set_int("is_telpposun",0)
			minetest.chat_send_player("singleplayer","pos1")
		else
			telpposun=pos
			meta:set_int("is_telpposun",1)
			minetest.chat_send_player("singleplayer","pos2")
		end
		minetest.get_node_timer(pos):start(0.1)
	end,
	on_timer=function(pos)
			local meta =minetest.get_meta(pos)
			if meta:get_int("is_telpposun")==1 then
				telpposun=pos
			else
				telpposdeux=pos
			end
		return true
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.go then
			local meta =minetest.get_meta(pos)
			if meta:get_int("is_telpposun")==1 then
				sender:set_pos(telpposdeux)
			else
				sender:set_pos(telpposun)
			end
		end
	end,
})
minetest.register_node("morenodes:statuslabel",{
	description = "tableau de bord",
	tiles = {"morenodes_statuslabel.png","morenodes_Fe.png"},
	on_construct=function(pos)
		minetest.get_node_timer(pos):start(0.2)
	end,
	on_timer = function(pos)
		local meta =minetest.get_meta(pos)
		meta:set_string("formspec",
		"formspec_version[4]"..
		"size[10,5]"..
		"label[0,0.3;carburant: "..morenodesfuel.."]"..
		"label[0,0.8;vitesse: "..speed.."]"..
		"label[0,1.3;distance de la Terre: "..distance.."]"..
		"button[5,0;4,1;reactor; activer les réacteurs]"..
		"button_exit[3,4;2,1;ok;OK]"
		)
		meta:set_string("infotext", "carburant: "..morenodesfuel.."\nvitesse: "..speed.."\ndistance de la Terre: "..distance)
		if meta:get_string("reactor")=="true" then
			if morenodesfuel>0 then
				morenodesfuel=morenodesfuel-1
				speed=speed+1
			else
				meta:set_string("reactor","false")
			end
		end
		if is_joinplayer then
			minetest.chat_send_player("singleplayer","load...")
			distance = meta:get_int("distance")
			speed = meta:get_int("speed")
			morenodesfuel = meta:get_int("carburant")
			if distance==0 then
				distance=100000
			end
			if spawned then
				is_joinplayer=false
			end
		end
		distance=distance-(speed/50)
		meta:set_int("distance",distance)
		meta:set_int("speed",speed)
		meta:set_int("carburant",morenodesfuel)
		return true
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.reactor then
			local meta =minetest.get_meta(pos)
			meta:set_string("reactor","true")
		end
	end
})
minetest.register_node("morenodes:spaceshipfuelore",{
	description = "minerai de carburant",
	tiles={"morenodes_spaceshipfuelore.png"},
	groups = {crumbly=2}
})
minetest.register_craft({
	output = "morenodes:spaceshipfuel",
	recipe = {
		{"morenodes:spaceshipfuelore"},
	}
})
minetest.register_craft({
	output = "morenodes:rafinery",
	recipe = {
		{"morenodes:spaceshipfuelore","morenodes:spaceshipfuelore","morenodes:spaceshipfuelore"},
		{"morenodes:spaceshipfuelore",				"",			  "morenodes:spaceshipfuelore"},
		{"morenodes:spaceshipfuelore","morenodes:spaceshipfuelore","morenodes:spaceshipfuelore"}
	}
})
minetest.register_node("morenodes:earth", {
	description = "Terre",
	tiles = {"morenodes_earth.png"}
})
minetest.register_node("morenodes:earthspw", {
	description = "spawn de la Terre",
	tiles = {"morenodes_earth.png"},
	on_construct=function(pos)
		local meta = minetest.get_meta(pos)
		minetest.get_node_timer(pos):start(5)
	end,
	on_timer=function(pos)
		if distance<1 then
			for index , player in pairs(minetest.get_connected_players()) do
				player:set_pos(pos)
			end
		end
		return true
	end
	
})

