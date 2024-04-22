extends StaticBody3D

func _on_body_entered(body):
	if body is CharacterBody3D:
		get_parent().get_parent().touch_on_platform()
