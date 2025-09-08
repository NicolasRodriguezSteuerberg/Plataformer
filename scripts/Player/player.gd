class_name Player extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var wall_raycast: RayCast2D = $WallRaycast;
@onready var camera: Camera2D = $Camera2D
@onready var state_machine: StateMachine = $StateMachine

@export var move_speed: float = 200;
@export var jump_height: float = 72;
@export var fall_multiplier: float = 1.7;
@export var jump_timer: float = 0.25;
@export var coyote_timer: float = 0.075;
@export var jump_buffer_timer: float = 0.08;
@export var dash_velocity: float = 460;
@export var dash_frames: int = 15;
@export var wall_gravity: float = 490;
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var dying: bool = false;

var jump_speed: float = -sqrt(2 * _gravity * jump_height);
var coyote_time_left: float = coyote_timer;
var jump_buffer_time_left: float = 0;
var can_dash: bool = true;
var block_dash: bool = false;
var dash_direction: Vector2 = Vector2.ZERO;
var game_freeze: bool = false;

var states: PlayerStatesNames = PlayerStatesNames.new();
var animations: PlayerAnimations = PlayerAnimations.new();

var spawn_position: Vector2 = Vector2.ZERO;

func _physics_process(_delta: float) -> void:
	handle_direction(velocity.x)

func handle_direction(x: float) -> void:
	if abs(x) > 0:
		sprite.flip_h = x < 0;
		wall_raycast.scale.x = -1 if x < 0 else 1;

func play_animation(animation: String):
	if animation != sprite.animation:
		sprite.animation = animation
		sprite.play()

func handle_danger() -> void:
	print("dmg");

func update_dash_direction():
	var dir := Vector2.ZERO;
	dir.x = Input.get_axis("move_left", "move_right");
	dir.y = Input.get_axis("move_up", "move_down");
	if abs(dir.x) < 0.2: dir.x = 0;
	else: dir.x = sign(dir.x);
	if dir.x != 0:
		dir.y = sign(dir.y);
	if is_on_floor() and dir.x == 0 and dir.y != 0:
		dir.y = 0;
		
	
	if dir.x == 0 and dir.y == 0:
		dir.x = -1 if sprite.flip_h else 1;
	dash_direction = dir;


func _on_room_detector_area_entered(area: Area2D) -> void:
	var collision_shape: CollisionShape2D = area.get_node("CollisionShape2D");
	var spawn_point: Marker2D = area.get_node("SpawnPoint");
	if not collision_shape: return;
	var size = collision_shape.shape.size;
	
	camera.limit_top = collision_shape.global_position.y - size.y / 2;
	camera.limit_left = collision_shape.global_position.x - size.x / 2;
	
	camera.limit_bottom = camera.limit_top + size.y;
	camera.limit_right = camera.limit_left + size.x;
	if spawn_point:
		spawn_position = spawn_point.global_position;
		global_position = spawn_position;

func change_freeze(freeze: bool):
	if freeze == game_freeze: return
	return;
	game_freeze == freeze;
	if freeze:
		print("freeze");
	else:
		print("unfreeze");


func _on_danger_area_body_entered(body: Node2D) -> void:
	dying = true;
	state_machine.change_to(states.IDLE);
	sprite.stop();
	get_tree().create_timer(1).connect("timeout", revive)

func revive():
	global_position = spawn_position;
	dying = false;
	sprite.play();
