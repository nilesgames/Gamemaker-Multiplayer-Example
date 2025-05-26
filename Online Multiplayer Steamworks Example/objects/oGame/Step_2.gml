///@description Send Network Data

//SEND HIT - Sends hit on drone 
if ds_list_size(global.hitlist) > 0 {
	var buffer_size = ds_list_size(global.hitlist)*4 + 5  //u32 = 4 bytes, thus: global.hitlist size X 4.  The additional 5 is for the packet enum, and the sequence.
	var buff = buffer_create(buffer_size, buffer_fixed, 1)
	buffer_write(buff, buffer_u8, packet_enum.HIT)
	buffer_write(buff, buffer_u32, global.update_sequence)
	//This runs through each drone that is hit with a laser during the step event, and sends its network id to the person hosting the actual enemy for the 
	for (var i = 0; i < ds_list_size(global.hitlist); i++) {
		var hit = global.hitlist[| i];
		buffer_write(buff, buffer_u32, hit)  //the network_id of this droen was added to the hitlist, so the receiver should just need to look up the local instance referenced with this buffer
		}
	ds_list_clear(global.hitlist)

	//Sends a reliable packet to the connected player
	if global.connected_player != undefined{
		steam_net_packet_send(global.connected_player,buff, buffer_tell(buff), steam_net_packet_type_reliable)	
	}
	buffer_delete(buff)
}
	
//SEND DESTROY - Destroys local enemies, sends ids to other player to delete drones
if ds_list_size(global.destroylist) > 0 {
	var buffer_size = ds_list_size(global.destroylist)*4 + 5
	var buff = buffer_create(buffer_size, buffer_fixed, 1)

			
	buffer_write(buff, buffer_u8, packet_enum.DESTROY)
	buffer_write(buff, buffer_u32, global.update_sequence)
	//runs through each instance added to the destroy event (including ones received from the hit event), adds them to the buffer and deletes them.
	for (var i = 0; i < ds_list_size(global.destroylist); i++) {
		var destroy_id = global.destroylist[| i];
		var entity_index = ds_list_find_index(global.entitylist, destroy_id)
		if entity_index != -1{
			ds_list_delete(global.entitylist, entity_index)  //removes the entity, so it doesn't try to send its info over in the update after it's destroyed
		}
		buffer_write(buff, buffer_u32, destroy_id)   //since we're sending the id, the reciever will have to find the drone with this network ID and destroy it.
		if instance_exists(destroy_id){
			instance_destroy(destroy_id)	//this is also where instances are destroyed, not on collision or during a step event.
		}
	}
	ds_list_clear(global.destroylist)
	
	//this packet is also sent over reliably
	if global.connected_player != undefined{
		steam_net_packet_send(global.connected_player,buff, buffer_tell(buff), steam_net_packet_type_reliable)	
	}
	buffer_delete(buff)
}

//SEND UPDATE - Sends updated positions and animations each frame
var buffer_size = ds_list_size(global.entitylist)*12 + 5 //you can see the series of bytes added per entity below that add up to 12 per entity
var buff = buffer_create(buffer_size, buffer_fixed, 1)
buffer_write(buff, buffer_u8, packet_enum.UPDATE)
buffer_write(buff, buffer_u32, global.update_sequence)

for (var i = 0; i < ds_list_size(global.entitylist); i++) {
	var entity = global.entitylist[| i];
	buffer_write(buff, buffer_u32, entity.id);
	buffer_write(buff, buffer_f16, entity.x);
	buffer_write(buff, buffer_f16, entity.y);
	buffer_write(buff, buffer_u16, entity.sprite_index);
	buffer_write(buff, buffer_f16, entity.image_index);
}

//This packet is sent over UNRELIABLY, meaning there are times this packet may or may not reach the other player, but it is faster.
if global.connected_player != undefined{
	steam_net_packet_send(global.connected_player,buff, buffer_tell(buff), steam_net_packet_type_unreliable)	
}
buffer_delete(buff)

//update the sequence each step to make sure packets arrive in order, especially the unreliable one
global.update_sequence++