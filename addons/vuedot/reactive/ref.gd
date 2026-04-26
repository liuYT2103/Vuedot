class_name Ref extends RefCounted

var _value: Variant
var dep: Dep = Dep.new()

func _init(initial_value):
	_value = initial_value

# getter：收集依赖
func get_value():
	if Reactive.active_effect != null:
		dep.depend(Reactive.active_effect)
	return _value

# setter：派发更新
func set_value(new_value):
	if _value != new_value:
		_value = new_value
		dep.notify()

# 利用属性语法暴露 value
var value:
	get = get_value,
	set = set_value
