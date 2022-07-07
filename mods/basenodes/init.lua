local WATER_ALPHA = "^[opacity:" .. 160
local WATER_VISC = 1

--
-- Node definitions
--

-- Register nodes
minetest.register_node("basenodes:pipi_source", {
	description = "pipi",
	drawtype = "liquid",
	waving = 3,
	tiles = {"default_pipi.png"..WATER_ALPHA},
	stack_max = 1,
	special_tiles = {
		{name = "default_pipi.png"..WATER_ALPHA, backface_culling = false},
		{name = "default_pipi.png"..WATER_ALPHA, backface_culling = true},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "basenodes:pipi_flowing",
	liquid_alternative_source = "basenodes:pipi_source",
	liquid_viscosity = WATER_VISC,
	post_effect_color = {a = 64, r = 100, g = 100, b = 200},
	groups = {water = 3, liquid = 3},
})

minetest.register_node("basenodes:pipi_flowing", {
	description = "pipi",
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {"default_pipi_flowing.png"},
	special_tiles = {
		{name = "default_pipi_flowing.png"..WATER_ALPHA,
			backface_culling = false},
		{name = "default_pipi_flowing.png"..WATER_ALPHA,
			backface_culling = false},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "basenodes:pipi_flowing",
	liquid_alternative_source = "basenodes:pipi_source",
	liquid_viscosity = WATER_VISC,
	post_effect_color = {a = 64, r = 100, g = 100, b = 200},
	groups = {water = 3, liquid = 3},
})

minetest.register_node("basenodes:apple", {
	description = "Apple".."\n"..
		"Food (+2)",
	drawtype = "plantlike",
	tiles ={"default_apple.png"},
	inventory_image = "default_apple.png",
	paramtype = "light",
	is_ground_content = false,
	sunlight_propagates = true,
	walkable = false,
	groups = {dig_immediate=3},

	-- Make eatable because why not?
	on_use = minetest.item_eat(2),
})
minetest.register_node("basenodes:dirt", {
	description = "espace",
	tiles = {"morenodes_space.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	light_source = 14,
	--groups = {snappy=3}
})
minetest.register_node("basenodes:dirt_with_grass", {
	description = "espace",
	tiles = {"morenodes_space.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	light_source = 14,
	--groups = {snappy=3}
})
minetest.register_node("basenodes:stone", {
	description = "espace",
	tiles = {"morenodes_space.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	light_source = 14,
	--groups = {snappy=3}
})
if minetest.settings:get_bool("creative_mode") then
	local digtime = 42
	local caps = {times = {digtime, digtime, digtime}, uses = 0, maxlevel = 256}

	minetest.register_item(":", {
		type = "none",
		wield_image = "wieldhand.png",
		wield_scale = {x = 1, y = 1, z = 2.5},
		range = 10,
		tool_capabilities = {
			full_punch_interval = 0.5,
			max_drop_level = 3,
			groupcaps = {
				crumbly = caps,
				cracky  = caps,
				snappy  = caps,
				choppy  = caps,
				oddly_breakable_by_hand = caps,
				-- dig_immediate group doesn't use value 1. Value 3 is instant dig
				dig_immediate =
					{times = {[2] = digtime, [3] = 0}, uses = 0, maxlevel = 256},
			},
			damage_groups = {fleshy = 10},
		}
	})
else
	minetest.register_item(":", {
		type = "none",
		wield_image = "wieldhand.png",
		wield_scale = {x = 1, y = 1, z = 2.5},
		tool_capabilities = {
			full_punch_interval = 0.9,
			max_drop_level = 0,
			groupcaps = {
				crumbly = {times = {[2] = 3.00, [3] = 0.70}, uses = 0, maxlevel = 1},
				snappy = {times = {[3] = 0.40}, uses = 0, maxlevel = 1},
				oddly_breakable_by_hand =
					{times = {[1] = 3.50, [2] = 2.00, [3] = 0.70}, uses = 0}
			},
			damage_groups = {fleshy = 1},
		}
	})
end
