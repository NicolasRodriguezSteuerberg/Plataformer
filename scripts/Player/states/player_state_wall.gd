extends PlayerStateBase

var frames_in_wall: int = 0;

func start():
	frames_in_wall = 0;
	player.velocity.x = 0;
	player.velocity.y = 0;
	player.sprite.stop();

func end():
	player.sprite.play();

func on_physics_process(delta: float) -> void:
	if player.wall_raycast.is_colliding() and not player.is_on_floor(): 
		player.velocity.y += player.wall_gravity * delta;
		player.move_and_slide();
	elif player.is_on_floor(): 
		return state_machine.change_to(player.states.IDLE);
	elif not player.wall_raycast.is_colliding() and not player.is_on_floor():
		return state_machine.change_to(player.states.FALLING);
	
	

func _handle_state_transitions() -> void:
	if player.is_on_wall_only(): return;
	if player.is_on_floor(): return state_machine.change_to(player.states.IDLE);
	print(player.is_on_floor(), player.is_on_ceiling(), player.is_on_wall())
	return state_machine.change_to(player.states.FALLING);

func on_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		return state_machine.change_to(player.states.WALL_JUMPING);
