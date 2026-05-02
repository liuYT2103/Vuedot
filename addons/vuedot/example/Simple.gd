extends Node2D

var val:Ref = V.ref("")
var val2:Ref = V.ref("22")
var comp = V.computed(func():return val.value + val2.value + "45")
var color:Ref = V.ref(Color(1,1,1,1))

func _ready() -> void:
	V.model($LineEdit2, "text", val2)
	V.model([$LineEdit, $TextEdit], "text", val)
	V.model([$ColorPicker2, $ColorPicker], "color", color)
	V.hyper($Label, func(): $Label.label_settings.font_color = color.value)
	V.bind($Label, "text", val)
	V.bind($LabelComputed, "text", comp)
	V.bind([$Label, $LabelComputed, $LineEdit, $LineEdit2, $TextEdit], "theme_override_colors/font_color", color)

func _on_button_pressed() -> void:
	for node in get_children():
		node.queue_free()
	val = null
	val2 = null
	color = null
	comp = null
