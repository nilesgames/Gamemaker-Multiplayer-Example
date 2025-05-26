///@description Receive Network Data

while (steam_net_packet_receive()) {
	
	var packet_size = steam_net_packet_get_size()
	var rec_buff = buffer_create(packet_size, buffer_fixed, 1)
	
	steam_net_packet_get_data(rec_buff)
	buffer_seek(rec_buff,buffer_seek_start,0)

	var packet_sort = buffer_read(rec_buff, buffer_u8)	//The first byte of data is read, and tells us how to read the rest of the data in that buffer
	
	switch (packet_sort){
	
		case packet_enum.HIT:
			var seq = buffer_read(rec_buff, buffer_u32)
			//since this is a reliable packet, we run this code regardless of whether it's out of sequence or not.  However, we do want to update the sequence to make sure no unreliable data comes in from before this.
			if seq > global.last_seq{					
				global.last_seq = seq
			}
			//received hits turn into destruction, but you could put HP here, and update that rather than destroy it, if you want.
			for (var i = 0; buffer_tell(rec_buff) < packet_size; i++){
				var rec_id = buffer_read(rec_buff, buffer_u32)
				if instance_exists(rec_id){
					ds_list_add(global.destroylist, rec_id)		//since the hit was on a drone on the client side, it needs to add it to the destroy list on this side, to tell the client side to destroy that drone.
					instance_destroy(rec_id)
				}
			}
			
		break
		
		case packet_enum.DESTROY:
			var seq = buffer_read(rec_buff, buffer_u32)
			//also reliable, so will run regardless of sequence
			if seq > global.last_seq{					
				global.last_seq = seq
			}
			for (var i = 0; buffer_tell(rec_buff) < packet_size; i++){
				var rec_id = buffer_read(rec_buff, buffer_u32)
				//the received DESTROY packet is just for destroying drones
				if (ds_map_exists(global.drone_ids, rec_id)){
					var drone_destroy = global.drone_ids[? rec_id] //looks for the drone's network_id using its instance id as an index on the ds_map
					if instance_exists(drone_destroy){
						instance_destroy(drone_destroy)	//no need to add to the destroylist, as the destroylist is only for entites, not drones
					}
					ds_map_delete(global.drone_ids, rec_id)
				}
			}
		
			
		break
		
		case packet_enum.UPDATE:
			var seq = buffer_read(rec_buff, buffer_u32)
			//This code only runs if it's coming from the same frame or a newer frame than what has been registered in the sequence.  The same frame part is important as the HIT or DESTROY packets could update the sequence to the current sequence number.
			if seq >= global.last_seq {
				global.last_seq = seq
				//first things first, pull all the information out of the buffer and put it into useable variables
				for (var i = 0; buffer_tell(rec_buff) < packet_size; i++) {
					var rec_id = buffer_read(rec_buff, buffer_u32);
					var rec_x = buffer_read(rec_buff, buffer_f16);
					var rec_y = buffer_read(rec_buff, buffer_f16);
					var rec_sprite = buffer_read(rec_buff, buffer_u16);
					var rec_img = buffer_read(rec_buff, buffer_f16);
					//then you check to see if this id already exists.  If it doesnt't, we create a new drone.  If it does, skip to updating its x, y, and animations.
					if(!ds_map_exists(global.drone_ids, rec_id)){
						var drone = instance_create_layer(rec_x, rec_y, "Instances", oDrone)
						drone.network_id = rec_id				//VERY IMPORTANT.  The client will create the drone, and give it a variable called "network_id" which will match the instance id of the host.  This is nessecary for sending the hits on drones back to the host.
						global.drone_ids[? rec_id] = drone		//EQUALLY IMPORTANT.  This puts all drones into a ds_map that is indexed by the local instance ids.
					}
					else {
						var drone = global.drone_ids[? rec_id]	//If the drone is already created, you look up that drone based on the id received from the host.
					}
					if instance_exists(drone){
						with (drone) {
							x = rec_x
							y = rec_y
							sprite_index = rec_sprite
							image_index = rec_img
						}
					}
				}
			}
			
		break
	}
}