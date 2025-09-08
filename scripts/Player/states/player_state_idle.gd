extends PlayerStateGravity

func start():
	if player.dying: return;
	player.play_animation(player.animations.IDLE)
	player.can_dash = true;
	player.velocity.x = 0

func on_process(delta: float) -> void:
	pass

func on_physics_process(delta: float) -> void:
	handle_gravity(delta)
	player.move_and_slide();

func on_input(event) -> void:
	if player.dying: return;
	if Input.is_action_just_pressed("dash"):
		player.update_dash_direction();
		state_machine.change_to(player.states.DASH);
	elif Input.get_axis("move_left", "move_right") != 0:
		state_machine.change_to(player.states.RUNNING);
	elif Input.is_action_just_pressed("jump"):
		state_machine.change_to(player.states.JUMPING);
