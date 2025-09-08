extends PlayerStateGravity;

var time_jumping: float = 0;
var jumping: bool = false;
var target_velocity_x: float = 0;

func start():
	player.play_animation(player.animations.IDLE);
	player.handle_direction(player.velocity.x);
	var dir_x: int = 1 if player.sprite.flip_h else -1;
	player.velocity = Vector2(dir_x * player.move_speed, player.jump_speed);
	time_jumping = 0;
	player.coyote_time_left = 0;
	player.jump_buffer_time_left = 0;
	jumping = true;
	

func on_physics_process(delta: float) -> void:
	if player.dying: return;
		
	if jumping:
		if Input.is_action_pressed("jump") and time_jumping <= player.jump_timer:
			time_jumping += delta;
		else:
			player.velocity.y /= 2;
			jumping = false;
		
	if player.velocity.y > 0:
		state_machine.change_to(player.states.FALLING);
		return;
	move_player(delta);
	if player.wall_raycast.is_colliding() and not jumping:
		print("hola")
		return state_machine.change_to(player.states.WALL);

func on_input(event: InputEvent) -> void:
	if player.dying: return;
	if Input.is_action_just_pressed("dash") and player.can_dash:
		player.update_dash_direction();
		state_machine.change_to(player.states.DASH);
