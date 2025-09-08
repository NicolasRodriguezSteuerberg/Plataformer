extends PlayerStateBase

func start():
	player.play_animation(player.animations.RUNNING)
	player.can_dash = true;

func on_process(delta: float) -> void:
	pass

func on_physics_process(delta: float) -> void:
	if player.dying: return;
	player.velocity.x = Input.get_axis("move_left", "move_right") * player.move_speed;
	player.move_and_slide();
	_handle_state_transitions();

func _handle_state_transitions() -> void:
	if player.velocity.y >= 0 and not player.is_on_floor():
		return state_machine.change_to(player.states.FALLING);
	elif player.velocity.x == 0:
		return state_machine.change_to(player.states.IDLE);

func on_input(event) -> void:
	if player.dying: return;
	if Input.is_action_just_pressed("jump"):
		return state_machine.change_to(player.states.JUMPING);
	elif Input.is_action_just_pressed("dash"):
		player.update_dash_direction();
		return state_machine.change_to(player.states.DASH);
	
