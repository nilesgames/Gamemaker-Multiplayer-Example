//bullet movement
y = y-5

//Destruction handled by oGame
if y < -10 {
	if ds_list_find_index(global.destroylist, id) = -1 {
	    ds_list_add(global.destroylist, id);
	}
}