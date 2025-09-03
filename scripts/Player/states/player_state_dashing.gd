extends PlayerStateBase

var in_dash_frames: int = 0;
var can_dash_again: bool = false;

func start():
	player.play_animation(player.animations.IDLE);
	player.velocity = Vector2.ZERO;
	player.can_dash = false;
	in_dash_frames = 0;
	can_dash_again = false;

func end():
	player.dash_direction = Vector2.ZERO;

func on_physics_process(delta: float) -> void:
	if player.dying: return;
	in_dash_frames += 1;
	if in_dash_frames > player.dash_frames:
		return _change_state();
	if in_dash_frames == 1:
		print("FRAME 1")
		return;
	elif in_dash_frames >= 2 and in_dash_frames <= 4:
		print("FRAME 2-4");
		player.change_freeze(true);
		return;
	
	print("FRAME 5-15")
	player.velocity = player.dash_direction.normalized() * player.dash_velocity;
	if in_dash_frames > 10:
		if player.is_on_floor():
			can_dash_again = true;
	else:
		player.change_freeze(false);
	
	player.move_and_slide();

func _change_state():
	if player.is_on_floor():
		player.can_dash = true;
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			state_machine.change_to(player.states.RUNNING);
		else:
			state_machine.change_to(player.states.IDLE);
	else:
		player.velocity.y = 0;
		state_machine.change_to(player.states.FALLING);

func on_input(event: InputEvent):
	if player.dying: return;
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_to(player.states.JUMPING);
	elif Input.is_action_just_pressed("dash") and player.is_on_floor() and can_dash_again:
		start();
