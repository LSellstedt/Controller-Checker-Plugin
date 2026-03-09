extends TextureRect

## Needs to be 4 elements. If you try to be funny by removing them the script will create the elements again but now empty.
@export var input_textures: Array[Texture2D] = [null,null,null,null]

func _ready() -> void:
	input_textures.resize(4)
	_set_texture_based_on_device(0,false)
	Input.joy_connection_changed.connect(_set_texture_based_on_device)
	Smiku_Controller_Checker.is_using_controller.connect(_set_texture_based_on_device.bind(0,true))
	Smiku_Controller_Checker.stopped_using_controller.connect(_set_texture_based_on_device.bind(0,true))

func _set_texture_based_on_device(device: int, connected: bool) -> void:
	texture = input_textures[Smiku_Controller_Checker.current_controller]
