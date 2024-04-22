extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var score_text = 'Final Score: ' + str(get_parent().score)
	$CenterContainer/MarginContainer/VBoxContainer/Score.text = score_text

func _on_play_pressed():
	get_tree().paused = false
	get_tree().root.get_node("Main").change_scene(get_parent(), load("res://scenes/world/world.tscn"))


func _on_exit_pressed():
	get_tree().paused = false
	get_tree().root.get_node("Main").change_scene(get_parent(), load("res://scenes/main_menu/main_menu.tscn"))
