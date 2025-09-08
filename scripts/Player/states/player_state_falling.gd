extends PlayerStateGravity

var player_moved: bool = false;
var target_velocity_x: float = 0;

func start():
	player_moved = false;

func on_physics_process(delta: float) -> void:
	if player.dying: return;
	
	_handle_horizontal_input(delta);
	move_player(delta);
	_handle_state_transitions();
	

func _handle_state_transitions() -> void:
	if player.velocity.y >= 0 and player.is_on_floor():
		if player.jump_buffer_time_left > 0:
			return state_machine.change_to(player.states.JUMPING);
		else:
			if abs(player.velocity.x) > 0:
				return state_machine.change_to(player.states.RUNNING);
			else:
				return state_machine.change_to(player.states.IDLE);
	elif player.wall_raycast.is_colliding():
		return state_machine.change_to(player.states.WALL);

func on_input(event):
	if player.dying: return;
	if Input.is_action_just_pressed("jump"):
		if player.is_on_floor() or player.coyote_time_left > 0:
			player.coyote_time_left = 0;
			state_machine.change_to(player.states.JUMPING);
		else:
			player.jump_buffer_time_left = player.jump_buffer_timer;
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		player.update_dash_direction();
		state_machine.change_to(player.states.DASH);
