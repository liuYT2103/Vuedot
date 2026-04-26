class_name VueNode extends Node

var _props:Dictionary[String, Ref] = {}

func set_prop(key:String, val:Ref) -> void:
	if _props.has(key):
		push_warning("已有同名参数在组件内")
	_props[key] = val

func set_props(props:Dictionary[String, Ref]) -> void:
	_props.merge(props, true)

func get_prop(key:String) -> Ref:
	return _props.get(key, null)
	
