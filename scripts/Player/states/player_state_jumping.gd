extends PlayerStateGravity

var time_jumping: float = 0;
var jumping: bool = false;

func start():
	player.velocity.y = player.jump_speed;
	time_jumping = 0;
	player.coyote_time_left = 0;
	player.jump_buffer_time_left = 0;
	jumping = true;

func on_physics_process(delta: float) -> void:
	player.velocity.x = Input.get_axis("move_left", "move_right") * player.move_speed;
		
	if jumping:
		if Input.is_action_pressed("jump") and time_jumping <= player.jump_timer:
			time_jumping += delta;
		else:
			player.velocity.y /= 2;
			jumping = false;
		
	if player.velocity.y > 0:
		state_machine.change_to(player.states.FALLING);
	
	move_player(delta);
	
