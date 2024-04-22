extends Node

@export var base_node: Node

var sounds_enum = {
	'ui_click': AudioStreamPlayer.new(),
	'ui_hover': AudioStreamPlayer.new()
}

func _ready():
	for key in sounds_enum.keys():
		sounds_enum[key].stream = load("res://assets/user_interfaces/" + key + ".ogg")
		sounds_enum[key].bus = 'UI'
		add_child(sounds_enum[key])
	
	_config_interfaces(base_node)

func _config_interfaces(target_node):
	if target_node is Button:
		target_node.mouse_entered.connect(self.ui_play_sound.bind('ui_hover'))
		target_node.pressed.connect(self.ui_play_sound.bind('ui_click'))
	
	for _node in target_node.get_children():
		_config_interfaces(_node)
	
func ui_play_sound(target_sound):
	sounds_enum[target_sound].play()
