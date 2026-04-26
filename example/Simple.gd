extends Node2D

var val:Ref = Vue.ref("")
var val2:Ref = Vue.ref("22")
var comp = Vue.computed(func():return val.value + val2.value + "45")
var color:Ref = Vue.ref(Color(1,1,1,1))

func _ready() -> void:
	Vue.watch(val, func(ov, nv):
		print({"old": ov, "new": nv})
	, $Label)
	Vue.model($LineEdit, "text", val)
	Vue.model($LineEdit2, "text", val2)
	Vue.model($TextEdit, "text", val)
	Vue.bind($Label, "text", val)
	Vue.bind($LabelComputed, "text", comp)
	
	Vue.model($ColorPicker, "color", color)
	Vue.bind($Label, "theme_override_colors/font_color", color)
	Vue.bind($LabelComputed, "theme_override_colors/font_color", color)
	Vue.bind($LineEdit, "theme_override_colors/font_color", color)
	Vue.bind($LineEdit2, "theme_override_colors/font_color", color)
	Vue.bind($TextEdit, "theme_override_colors/font_color", color)

func _on_button_pressed() -> void:
	for node in get_children():
		node.queue_free()
	val = null
	val2 = null
	color = null
	comp = null

func _on_button_2_pressed() -> void:
	get_children().pick_random().queue_free()
