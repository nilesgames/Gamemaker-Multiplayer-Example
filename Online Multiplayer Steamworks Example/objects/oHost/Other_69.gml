//Listens for Steam lobby events.
switch(async_load [?"event_type"]) {
	
	//This joines the lobby when it is created by the host
	case "lobby_created":
		steam_lobby_join_id(steam_lobby_get_lobby_id())
	
		break

	//This is incredibly bare-bones, and you would want to change this if you were going beyond a test
	//Essntially, all this does is: if there is any Steam lobby for this game, it joins the first one.  I know.  Not ideal.
	case "lobby_list":
		var test = steam_lobby_list_get_count()
		if test > -1{
			steam_lobby_list_join(0)
		}
	break

	//Sets the game mode when you host/join the lobby
	case "lobby_joined":
		
		//if you're the host, game_mode is set to 1.  This is the "host" of the enemy logic.
		if steam_lobby_is_owner() = true{
			steam_lobby_set_data("Creator", steam_get_persona_name()) //not really used for anything at this point
			global.game_mode = 1
			room_goto(Room1)
		}  //if you're not the host, game mode will be set to 2, and the spawner will not spawn enemies.
		else {
			global.game_mode = 2
			global.connected_player = steam_lobby_get_owner_id()
			room_goto(Room1)
		}

		break
}