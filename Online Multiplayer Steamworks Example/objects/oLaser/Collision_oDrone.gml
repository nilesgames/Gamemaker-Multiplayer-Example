//sending drone to hitlist, to be handled by the host, and sending laser to be destroyed by oGame
if ds_list_find_index(global.hitlist, other.network_id) = -1 {
	ds_list_add(global.hitlist, other.network_id)
}
if ds_list_find_index(global.destroylist, id) = -1 {
    ds_list_add(global.destroylist, id);
}