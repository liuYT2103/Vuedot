extends Node2D

var val:Ref = Vue.ref("")
var val2:Ref = Vue.ref("22")
var comp = Vue.computed(func():return val.value + val2.value + "45")
var color:Ref = Vue.ref(Color(1,1,1,1))

func _ready() -> void:
	var eff = Vue.watch(val, func(ov, nv):
		print(ov, nv)
	)
	Vue.model($LineEdit, "text", val)
	Vue.model($LineEdit2, "text", val2)
	Vue.model($TextEdit, "text", val)
	Vue.bind($Label, "text", val)
	Vue.bind($LabelComputed, "text", comp)
	
	print("BIND VAL END BIND COLOR BEGIN")
	Vue.model($ColorPicker, "color", color)
	Vue.bind($Label, "theme_override_colors/font_color", color)
	Vue.bind($LabelComputed, "theme_override_colors/font_color", color)
	Vue.bind($LineEdit, "theme_override_colors/font_color", color)
	
	await get_tree().create_timer(4).timeout
	for node in get_children():
		node.queue_free()
	val = null
	val2 = null
	color = null
	comp = null
	Vue.clean(eff)
