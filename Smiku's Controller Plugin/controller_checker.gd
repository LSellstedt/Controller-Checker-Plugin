extends Node

signal is_using_controller
signal stopped_using_controller

const DEVICE_XBOX_CONTROLLER = "xbox"
const DEVICE_PLAYSTATION_CONTROLLER = "playstation"
const DEVICE_SWITCH_CONTROLLER = "switch"

var using_controller = false

var controllers := {} # device_id
var active_device: int = -1 # the one currently being used

var current_controller: ControllerType = ControllerType.KEYBOARD
var last_controller: ControllerType = ControllerType.KEYBOARD

var last_input_time := 0.0
var input_switch_cooldown := 0.15

var deadzone: float = 0.5
var mouse_motion_threshold: int = 100

enum ControllerType {
	## Keyboard and mouse input.
	KEYBOARD,
	## Xbox or XInput input. This is default if your controller is unrecongnized by the script.
	XBOX,
	## Playstation Input.
	PLAYSTATION,
	## Nintendo Switch Input.
	SWITCH
}

func _ready() -> void:
	for device in Input.get_connected_joypads():
		_register_controller(device)
	
	if controllers.is_empty():
		current_controller = ControllerType.KEYBOARD
	
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	

func _on_joy_connection_changed(device: int, connected: bool) -> void:
	if connected:
		_register_controller(device)
		print("Controller connected:", device, controllers[device])
	else:
		_unregister_controller(device)
		print("Controller disconnected:", device)
		
		if device == active_device:
			active_device = -1
			current_controller = ControllerType.KEYBOARD
		
	

func _register_controller(device: int) -> void:
	var type := get_controller_type(Input.get_joy_name(device))
	controllers[device] = type
	last_controller = type
	

func _unregister_controller(device: int) -> void:
	controllers.erase(device)
	

func _input(event: InputEvent) -> void:
	var now := Time.get_ticks_msec() / 1000.0
	
	if event is InputEventJoypadButton or (event is InputEventJoypadMotion and abs(event.axis_value) > deadzone):
		if now - last_input_time < input_switch_cooldown:
			return
		
		last_input_time = now
		
		var device := event.device
		if controllers.has(device):
			active_device = device
			var new_type = controllers[device]
			
			if current_controller != new_type:
				current_controller = new_type
				is_using_controller.emit()
				print("Now using controller:", device, new_type)
			
		return
	
	if event is InputEventKey or event is InputEventMouseButton or (event is InputEventMouseMotion and event.relative.length_squared() > mouse_motion_threshold):
		if now - last_input_time < input_switch_cooldown:
			return
		
		last_input_time = now
		
		if current_controller != ControllerType.KEYBOARD:
			active_device = -1
			current_controller = ControllerType.KEYBOARD
			stopped_using_controller.emit()
			print("Now using keyboard/mouse")
		
	

func get_controller_type(raw_name: String) -> ControllerType:
	match raw_name:
		"DualSense Wireless Controller":
			return ControllerType.PLAYSTATION
		"Switch":
			return ControllerType.SWITCH
		_:
			return ControllerType.XBOX
	
