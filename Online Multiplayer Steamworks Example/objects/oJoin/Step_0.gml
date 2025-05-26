event_inherited();

//Pulls in a list of open lobbies from Steam
if position_meeting(mouse_x, mouse_y, id) and mouse_check_button_pressed(mb_left){
	steam_lobby_list_request()

}