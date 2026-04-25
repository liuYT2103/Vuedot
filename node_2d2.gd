extends Node2D

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	$Node2D.queue_free()
