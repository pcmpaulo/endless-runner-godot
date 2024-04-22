extends CharacterBody3D

@export_group('Movement properties')
@export var base_speed = 400
@export var jump_height: float = 2
@export var jump_time_to_peak: float = 0.4
@export var jump_time_to_descent: float = 0.4

@export_group('Camera properties')
@export var sensitivity: int = 100

signal character_fall

@onready var camera_pivot = $CameraPivot

var jump_velocity: float = (2.0 * jump_height) / jump_time_to_peak
var jump_gravity: float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
var fall_gravity: float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)


func _physics_process(delta):
	var direction = Vector3(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		0,
		Input.get_action_strength("backward") - Input.get_action_strength("forward")
	)
	
	direction = direction.rotated(Vector3.UP, camera_pivot.global_transform.basis.get_euler().y)
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Moving the Character
	velocity.x = direction.x * base_speed * delta
	velocity.z = direction.z * base_speed * delta
	velocity.y += _get_gravity() * delta
	
	if velocity.y < -50:
		character_fall.emit()

	_handle_animation(direction)
	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / sensitivity
		
		camera_pivot.rotation.x -= event.relative.y / sensitivity
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	if event.is_action_pressed('ui_select') and is_on_floor():
		velocity.y = jump_velocity
		$JumpAudioStreamPlayer.play()
		
		
func _handle_animation(direction):
	if not is_on_floor():
		$CharacterMesh.play_animation('jump')
	elif direction != Vector3.ZERO:
		$CharacterMesh.play_animation('walk')
		if not $WalkAudioStreamPlayer3D.playing:
			$WalkAudioStreamPlayer3D.play()
	else:
		$CharacterMesh.play_animation('idle')


func _get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity

