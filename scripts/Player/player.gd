class_name Player extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var camera: Camera2D = $Camera2D

@export var move_speed: float = 200;
@export var jump_height: float = 72;
@export var fall_multiplier: float = 1.7;
@export var jump_timer: float = 0.25;
@export var coyote_timer: float = 0.075;
@export var jump_buffer_timer: float = 0.08;
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var jump_speed: float = -sqrt(2 * _gravity * jump_height);
var jump_buffer_time_left: float = 0;
var coyote_time_left: float = coyote_timer;

var states: PlayerStatesNames = PlayerStatesNames.new();
var animations: PlayerAnimations = PlayerAnimations.new();

func _physics_process(delta: float) -> void:
	handle_animation_direction(velocity.x)

func handle_animation_direction(x: float) -> void:
	if abs(x) > 0:
		animated_sprite_2d.flip_h = x < 0;

func play_animation(animation: String):
	if animation != animated_sprite_2d.animation:
		animated_sprite_2d.animation = animation
		animated_sprite_2d.play()

func handle_danger() -> void:
	print("dmg");


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
		global_position = spawn_point.global_position;
