extends CanvasLayer

var world_preload = preload("res://scenes/world/world.tscn")

func _on_start_pressed():
	get_parent().change_scene(self, world_preload)


func _on_settings_pressed():
	# TODO create an settings menu
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
