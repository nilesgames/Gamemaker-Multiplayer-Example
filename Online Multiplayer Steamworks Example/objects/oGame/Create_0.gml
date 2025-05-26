// 0 = solo, which is currently unused, 1 = host, 2 = client.  Defaluts to 0 until game starts
global.game_mode = 0

//SteamID of the player once players are connected
global.connected_player = undefined

//Network packets are sent in a sequence to prevent packets arriving out of order. These variables manage that info
global.update_sequence = 0
global.last_seq = 0

//These are the 4 main lists that get handled by the network packets.
global.entitylist = ds_list_create()	//All objects handled by whoever is hosting them
global.destroylist = ds_list_create()	//All objects being destroyed this frame being handled by whoever is hosting them
global.hitlist = ds_list_create()		//All collisions between bullets and drones that need to be confirmed by the host as hits
global.drone_ids = ds_map_create()		//A list of entity instance ids on the other players computer, indexed by the instance id of the drone on the client side

//3 package types
enum packet_enum {
	HIT = 0,
	DESTROY = 1,
	UPDATE = 2
}

