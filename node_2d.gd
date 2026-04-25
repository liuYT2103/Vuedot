extends Node2D
# 响应式数据
var val:Ref = Vue.ref("")
var color:Ref = Vue.ref(Color(1,1,1,1))

func _ready() -> void:
	Vue.bind($LineEdit, "text", val)
	Vue.bind($LabelComputed, "text", Vue.computed(func(): return "6" + val.value + "6"))
	Vue.bind($Label, "text", val)
	#绑定响应式数据
	Vue.bind($ColorPicker, "color", color)
	Vue.bind($Label, "theme_override_colors/font_color", color)
	Vue.bind($LabelComputed, "theme_override_colors/font_color", color)
