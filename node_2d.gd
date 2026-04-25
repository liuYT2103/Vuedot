extends Node2D

var val:Ref = Vue.ref("")
var val2:Ref = Vue.ref("22")
var double:Computed = Vue.computed(func(): return  "6" + val.value + val2.value)

var color:Ref = Vue.ref(Color(1,1,1,1))

func _ready() -> void:
	Vue.watch(val, func(old, new):
		print("old:", old)
		print("new", new)
	)
	Vue.model($LineEdit, "text", val)
	Vue.model($LineEdit2, "text", val2)
	Vue.bind($LabelComputed, "text", double)
	Vue.bind($Label, "text", val)

	print("BIND VAL END BIND COLOR BEGIN")
	Vue.model($ColorPicker, "color", color)
	Vue.bind($Label, "theme_override_colors/font_color", color)
	Vue.bind($LabelComputed, "theme_override_colors/font_color", color)
	Vue.bind($LineEdit, "theme_override_colors/font_color", color)
