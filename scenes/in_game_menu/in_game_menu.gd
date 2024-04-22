extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_continue_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	hide()


func _on_settings_pressed():
	# TODO: make this later
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().paused = false
	get_tree().root.get_node("Main").change_scene(get_parent(), load("res://scenes/main_menu/main_menu.tscn"))
