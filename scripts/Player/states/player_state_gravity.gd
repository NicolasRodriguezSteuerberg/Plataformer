class_name PlayerStateGravity extends PlayerStateBase

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func move_player(delta):
	handle_gravity(delta);
	handle_jump_timer(delta);
	handle_coyote_timer(delta);
	player.move_and_slide();

func _handle_horizontal_input(delta) -> void:
	var dir_x = Input.get_axis("move_left", "move_right");
	player.velocity.x = dir_x * player.move_speed;

func handle_gravity(delta):
	if not player.is_on_floor():
		if player.velocity.y > 0:
			player.velocity.y += gravity * player.fall_multiplier * delta;
		else:
			player.velocity.y += gravity * delta;

func handle_coyote_timer(delta):
	if player.is_on_floor():
		player.coyote_time_left = player.coyote_timer;
	else:
		player.coyote_time_left = max(player.coyote_time_left-delta, 0);
		
func handle_jump_timer(delta):
	if player.jump_buffer_time_left > 0:
		player.jump_buffer_time_left = max(player.jump_buffer_time_left - delta, 0.0);
