//Movement
var Xmovement = InputCheck(INPUT_VERB.RIGHT) - InputCheck(INPUT_VERB.LEFT)
x += Xmovement*2
x = clamp(x, 79, 241)
var Ymovement = InputCheck(INPUT_VERB.DOWN) - InputCheck(INPUT_VERB.UP)

if Xmovement != 0{
	y += Ymovement
}
else{
	y += Ymovement*1.5
}
y = clamp(y, 7, 173)

//Sprites depend on player 1 vs player 2.  Colors are slightly different on two sprites.
if global.game_mode != 2{
	if Xmovement = -1{
		sprite_index = sPlayerLeft
	}
	else if Xmovement = 0{
		sprite_index = sPlayerStraight
	}
	else if Xmovement = 1{
		sprite_index = sPlayerRight
	}
}
else 
	if Xmovement = -1{
		sprite_index = sPlayer2Left
	}
	else if Xmovement = 0{
		sprite_index = sPlayer2Straight
	}
	else if Xmovement = 1{
		sprite_index = sPlayer2Right
	}

//Firing Bullets
if InputPressed(INPUT_VERB.SHOOT){
	shot_alternate = ! shot_alternate
	if Xmovement = 0{
		var inst = instance_create_layer(x-8 + (15 * shot_alternate), y-8, "Instances",oLaser)

	}
	else {
		var inst = instance_create_layer(x-6 + (11 * shot_alternate), y-8, "Instances",oLaser)
	}
	//Bullets are added to the entity list, which is referenced in oGame
	ds_list_add(global.entitylist, inst)
}