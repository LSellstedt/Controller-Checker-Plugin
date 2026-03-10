Godot Input Device Detector

A lightweight Godot input manager that automatically detects whether the player is using:

Keyboard & Mouse

Xbox Controllers

PlayStation Controllers

Nintendo Switch Controllers

The system tracks active input in real time and emits signals when the player switches between input devices. This makes it easy to dynamically update UI button prompts, control schemes, or navigation behavior.

Features:
Automatic controller connection detection
Detects active input device
Supports multiple controllers
Identifies controller type (Xbox / PlayStation / Switch)
Prevents rapid device switching with a cooldown
Emits signals when input type changes

How It Works

The node listens to all input events and determines which device is actively being used.

Keyboard / Mouse Input
        │
        ▼
Switch to KEYBOARD mode
Emit: stopped_using_controller


Controller Input
        │
        ▼
Detect controller device
        │
        ▼
Switch to controller mode
Emit: is_using_controller

The active device is determined based on the most recent valid input event.

Signals
is_using_controller
Emitted when the player switches from keyboard/mouse → controller.

Example uses:
Show controller button prompts
Enable controller UI navigation
Switch control scheme

stopped_using_controller
Emitted when the player switches from controller → keyboard/mouse.

Example uses:
Show keyboard key prompts
Enable mouse cursor UI

Supported Controller Types
The script categorizes controllers into these types:

enum ControllerType {
	KEYBOARD,
	XBOX,
	PLAYSTATION,
	SWITCH
}

This allows the game to show the correct button icons depending on the device.

Example:
DualSense/DualShock	: PlayStation
Xbox Controller	: Xbox
Switch Controller	: Switch
Keyboard / Mouse	: Keyboard

Unrecognized controllers default to Xbox mapping.

Device Detection

When the game runs the autoload automatically registers connected controllers:

Input.get_connected_joypads()

Controllers are stored internally:

device_id → controller_type

The script also listens for controllers being plugged in or disconnected using:

Input.joy_connection_changed

Important Variables:
current_controller :	The current input type
active_device	: Device ID of the active controller
controllers	: Dictionary of detected controllers
deadzone	: Minimum joystick movement required
input_switch_cooldown	: Prevents rapid switching

Example Usage
InputManager.is_using_controller.connect(_on_controller_started)
InputManager.stopped_using_controller.connect(_on_keyboard_started)

Example UI switching:

func _on_controller_started():
	show_controller_icons()

func _on_keyboard_started():
	show_keyboard_icons()

The plugin also comes with a custom TextureRect that isn't that fancy it just switches between different textures in an array using the aforemention controller checker.
If you want an example of how to use the stuff in the autload you can check out the input_texturerect.gd file. It has to most basic stuff 👍
