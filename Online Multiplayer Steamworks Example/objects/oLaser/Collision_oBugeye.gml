//sending laser and bugeye to be destroyed by oGame
if ds_list_find_index(global.destroylist, id) = -1 {
    ds_list_add(global.destroylist, id);
}
if ds_list_find_index(global.destroylist, other.id) = -1 {
    ds_list_add(global.destroylist, other.id);
}