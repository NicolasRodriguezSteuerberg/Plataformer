extends PlayerStateBase

func start():
	player.play_animation(player.animations.RUNNING)
	player.can_dash = true;

func on_process(delta: float) -> void:
	pass

func on_physics_process(delta: float) -> void:
	if player.dying: return;
	player.velocity.x = Input.get_axis("move_left", "move_right") * player.move_speed;
	if player.velocity.y >= 0 and not player.is_on_floor():
		state_machine.change_to(player.states.FALLING);
	player.move_and_slide();

func on_input(event) -> void:
	if player.dying: return;
	if Input.is_action_just_pressed("jump"):
		state_machine.change_to(player.states.JUMPING);
	elif Input.is_action_just_pressed("dash"):
		player.dash_direction.y = Input.get_axis("move_up", "move_down");
		player.dash_direction.x = Input.get_axis("move_left", "move_right");
		state_machine.change_to(player.states.DASH);
	elif not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		state_machine.change_to(player.states.IDLE);
	
