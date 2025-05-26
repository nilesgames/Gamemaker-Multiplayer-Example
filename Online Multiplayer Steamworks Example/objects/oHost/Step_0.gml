event_inherited()

//Creates a public lobby open to 2 players
if position_meeting(mouse_x, mouse_y, id) and mouse_check_button_pressed(mb_left){
	steam_lobby_create(steam_lobby_type_public, 2)

}