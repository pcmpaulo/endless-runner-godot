extends Node3D

const initial_character_position = Vector3(0, 4, 0)

@onready var platform_large_round_preload = preload("res://assets/objects/platform_large_round.tscn")
@onready var platform_preload = preload("res://scenes/platform/platform.tscn")
@onready var character_preload = preload("res://scenes/character/character.tscn")
@onready var in_game_menu_preload = preload("res://scenes/in_game_menu/in_game_menu.tscn")

var rng = RandomNumberGenerator.new()

var last_platform: Node3D
var character: CharacterBody3D
var game_over: bool = false
var score: int = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_create_initial_platform()
	_create_character()


func _input(event):
	if event.is_action_pressed('ui_cancel'):
		if $InGameMenu.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			get_tree().paused = false
			$InGameMenu.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		$InGameMenu.show()

func _create_initial_platform():
	var initial_platform = platform_large_round_preload.instantiate()
	initial_platform.position = Vector3.ZERO
	last_platform = initial_platform
	$Platforms.add_child(initial_platform)
	$SpawnTimer.start()


func _create_character():
	character = character_preload.instantiate()
	character.position = initial_character_position
	character.connect('character_fall', handle_end_game)
	add_child(character)


func _on_spawn_timer_timeout():
	if len($Platforms.get_children()) < 10:
		# Select platform position
		var minimum_platform_distance: int = 6
		var maximum_platform_distance: int = 8
		var random_distance = rng.randi_range(minimum_platform_distance, maximum_platform_distance)
		var random_height = rng.randf_range(-4, 1)
		var random_rotation = rng.randf_range(0, PI/4)

		
		# spawn platform and set position
		var platform = platform_preload.instantiate()
		
		# Set Platform position
		platform.position = last_platform.position
		platform.rotation = last_platform.rotation

		platform.position.y += random_height
		platform.rotation += Vector3(0, random_rotation, 0)
		platform.position += platform.transform.basis.z * random_distance

		last_platform = platform
		$Platforms.add_child(platform)
	
	# Start timer again
	$SpawnTimer.start()

func add_score():
	score += 1
	$CanvasLayer/PanelContainer/MarginContainer/Score.text = str(score)

func handle_end_game():
	if game_over:
		return
	game_over = true
	var end_game_menu_preload = preload("res://scenes/end_game_menu/end_game_menu.tscn")
	var end_game_menu = end_game_menu_preload.instantiate()

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	$InGameMenu.hide()
	add_child(end_game_menu)

	get_tree().paused = true
