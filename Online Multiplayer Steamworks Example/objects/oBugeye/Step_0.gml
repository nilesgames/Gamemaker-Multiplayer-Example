//Bugeye movement
y = y + 0.5

//Destruction handled by oGame
if y > 200 and ds_list_find_index(global.destroylist,id) != -1 {
	ds_list_add(global.destroylist,id)
}