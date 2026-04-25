extends Node2D

var val:Ref = Vue.ref("")
var double:Computed = Vue.computed(func(): return  "6" + val.value + "6")

var color:Ref = Vue.ref(Color(1,1,1,1))

func _ready() -> void:
	Vue.model($LineEdit, "text", val)
	Vue.bind($LabelComputed, "text", double)
	Vue.bind($Label, "text", val)
	Vue.model($ColorPicker, "color", color)
	Vue.bind($Label, "theme_override_colors/font_color", color)
	Vue.bind($LabelComputed, "theme_override_colors/font_color", color)
	Vue.bind($LineEdit, "theme_override_colors/font_color", color)
