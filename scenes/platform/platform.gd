extends Node3D

@onready var platform_large_preload = preload("res://assets/objects/platform_large.tscn")
@onready var platform_medium_preload = preload("res://assets/objects/platform_medium.tscn")
@onready var platform_small_preload = preload("res://assets/objects/platform_small.tscn")

var already_touched: bool = false

func _ready():
	# Select platform
	var selected_platform_preload
	var randon_number = randi_range(1, 100)
	if randon_number <= 10:
		selected_platform_preload = platform_small_preload
	elif randon_number <= 40:
		selected_platform_preload = platform_medium_preload
	else:
		selected_platform_preload = platform_large_preload

	var platform = selected_platform_preload.instantiate()
	platform.position = Vector3.ZERO
	$PlatformPivot.add_child(platform)
	$AnimationPlayer.play("spawn")

func touch_on_platform():
	if already_touched:
		return
	already_touched = true
	$LifeSpanTimer.start()
	get_parent().get_parent().add_score()


func _on_life_span_timer_timeout():
	queue_free()
