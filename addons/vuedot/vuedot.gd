@tool
extends EditorPlugin

const AUTOLOAD_NAME = "Vue"
const AUTOLOAD_PATH = "res://addons/vuedot/reactive.gd"   # 根据实际路径修改


func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
