extends Panel
class_name HeroDetail

func set_props(ref:Ref):
	Vue.deepbind($HBoxContainer/Value/Name, "text", ref, "name")
	Vue.deepbind($HBoxContainer/Value/Camp, "text", ref, "camp")
	Vue.deepbind($HBoxContainer/Value/Career, "text", ref, "career")
	Vue.deepbind($HBoxContainer/Value/Detail, "text", ref, "detail")
