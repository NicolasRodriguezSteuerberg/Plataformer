extends PlayerStateGravity

func start():
	if player.dying: return;
	player.play_animation(player.animations.IDLE)
	player.can_dash = true;

func on_process(delta: float) -> void:
	pass

func on_physics_process(delta: float) -> void:
	player.velocity.x = 0
	handle_gravity(delta)
	player.move_and_slide();

func on_input(event) -> void:
	if player.dying: return;
	if Input.is_action_just_pressed("dash"):
		player.dash_direction.y = Input.get_axis("move_up", "move_down");
		if player.dash_direction.y == 0:
			player.dash_direction.x = -1 if player.sprite.flip_h else 1;
		state_machine.change_to(player.states.DASH);
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_to(player.states.RUNNING);
	elif Input.is_action_just_pressed("jump"):
		state_machine.change_to(player.states.JUMPING);
