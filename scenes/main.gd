extends Node

func change_scene(actual_scene, target_scene, transition = 'fade'):
	var animations = $SceneTransition/AnimationPlayer
	animations.play("fade")
	await animations.animation_finished
	var scene = target_scene.instantiate()
	add_child(scene)
	actual_scene.queue_free()
	animations.play_backwards("fade")
