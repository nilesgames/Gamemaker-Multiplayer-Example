switch(async_load [?"event_type"]) {
	
	case "lobby_chat_update":

		if global.game_mode = 1{
			var member_steam_id = async_load[? "user_id"]
			if member_steam_id != steam_get_user_steam_id(){
				global.connected_player = member_steam_id
			}
		}
	
	break

}