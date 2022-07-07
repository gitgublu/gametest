minetest.register_on_joinplayer(function(ObjectRef, last_login)
	ObjectRef:set_physics_override({gravity=0.1})
end)
--minetest.unregister_chatcommand("grant")