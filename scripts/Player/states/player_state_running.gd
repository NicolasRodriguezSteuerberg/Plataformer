extends PlayerStateBase

func start():
	player.play_animation(player.animations.RUNNING)

func on_process(delta: float) -> void:
	pass

func on_physics_process(delta: float) -> void:
	player.velocity.x = Input.get_axis("move_left", "move_right") * player.move_speed;
	if player.velocity.y >= 0 and not player.is_on_floor():
		state_machine.change_to(player.states.FALLING);
	player.move_and_slide();

func on_input(event) -> void:
	if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		state_machine.change_to(player.states.IDLE);
	if Input.is_action_just_pressed("jump"):
		state_machine.change_to(player.states.JUMPING);
