extends PlayerStateGravity

func start():
	player.play_animation(player.animations.IDLE)

func on_process(delta: float) -> void:
	pass

func on_physics_process(delta: float) -> void:
	player.velocity.x = 0
	handle_gravity(delta)
	player.move_and_slide();

func on_input(event) -> void:
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_to(player.states.RUNNING);
	if Input.is_action_just_pressed("jump"):
		state_machine.change_to(player.states.JUMPING);
