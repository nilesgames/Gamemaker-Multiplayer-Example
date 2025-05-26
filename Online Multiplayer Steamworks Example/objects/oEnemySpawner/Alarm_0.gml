//Host creates enemies and adds them to the entitylist, which entries are sent to the other player
var inst = instance_create_layer(irandom_range(80, 240), -15, "instances", oBugeye)
ds_list_add(global.entitylist, inst)
alarm[0] = irandom_range(40, 70)