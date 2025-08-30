extends PlayerStateGravity

func on_physics_process(delta: float) -> void:
	
	player.velocity.x = Input.get_axis("move_left", "move_right") * player.move_speed;
	
	if player.velocity.y >= 0 and player.is_on_floor():
		if player.jump_buffer_time_left > 0:
			state_machine.change_to(player.states.JUMPING);
		else:
			if abs(player.velocity.x) > 0:
				state_machine.change_to(player.states.RUNNING);
			else:
				state_machine.change_to(player.states.IDLE);
	
	move_player(delta);

func on_input(event):
	if Input.is_action_just_pressed("jump"):
		if player.is_on_floor() or player.coyote_time_left > 0:
			player.coyote_time_left = 0;
			state_machine.change_to(player.states.JUMPING);
		else:
			player.jump_buffer_time_left = player.jump_buffer_timer;
