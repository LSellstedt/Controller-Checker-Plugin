@tool
extends EditorPlugin

const AUTOLOAD_NAME = "Smiku_Controller_Checker"

func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/Smiku's Controller Plugin/controller_checker.gd")

func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)

func _enter_tree() -> void:
	add_custom_type("Input TextureRect", "TextureRect", preload("res://addons/Smiku's Controller Plugin/input_texturerect.gd"), preload("res://addons/Smiku's Controller Plugin/TextureRectController.png"))

func _exit_tree() -> void:
	remove_custom_type("Input TextureRect")
