extends PlayerStateGravity

var time_jumping: float = 0;
var jumping: bool = false;
var player_moved: bool = false;

func start():
	player.velocity.y = player.jump_speed;
	time_jumping = 0;
	player.coyote_time_left = 0;
	player.jump_buffer_time_left = 0;
	jumping = true;
	player_moved = false;

func on_physics_process(delta: float) -> void:
	if player.dying: return;
	if player.is_on_wall_only():
		print("AAAAAAAAAAAAAAAAA");
	
	var dir_x = Input.get_axis("move_left", "move_right");
	if dir_x == 0 and not player_moved:
		pass
	else:
		player.velocity.x = dir_x * player.move_speed;
		player_moved = true;
		
	if jumping:
		if Input.is_action_pressed("jump") and time_jumping <= player.jump_timer:
			time_jumping += delta;
		else:
			player.velocity.y /= 2;
			jumping = false;
		
	if player.velocity.y > 0:
		state_machine.change_to(player.states.FALLING);
	
	move_player(delta);

func on_input(event: InputEvent) -> void:
	if player.dying: return;
	if Input.is_action_just_pressed("dash") and player.can_dash:
		var dir = Vector2.ZERO;
		dir.x = Input.get_axis("move_left", "move_right");
		dir.y = Input.get_axis("move_up", "move_down");
		if dir == Vector2.ZERO:
			dir.x = -1 if player.sprite.flip_h else 1;
		player.dash_direction = dir;
		state_machine.change_to(player.states.DASH);
