extends Node
class_name Reactive

static var active_effect: ReactiveEffect = null

func effect(fn: Callable) -> ReactiveEffect:
	var eff = ReactiveEffect.new(fn)
	eff.run()
	return eff

func ref(initial_value) -> Ref:
	return Ref.new(initial_value)

func computed(getter: Callable) -> Ref:
	var result:Ref = ref(null)
	effect(func():
		result.value = getter.call()
	)
	return result

func bind(node: Node, property: StringName, ref: Ref, callback: Callable = func(_n): pass) -> void:
	var eff = effect(func():
		var val = ref.value # 强制建立依赖关系，避免首帧已在编辑状态无法关联依赖
		if _is_editable(node):
			return
		if not property.is_empty():
			node.set(property, val)
		callback.call(node)
	)
	if is_instance_valid(node):
		node.tree_exited.connect(func(): eff.stop())
	
func deepbind(node: Node, property: StringName, ref: Ref, ref_property: String, callback: Callable = func(_n): pass) -> void:
	var eff = effect(func():
		var val = ref.value
		if _is_editable(node):
			return
		if val:
			node.set(property, val[ref_property])
		callback.call(node)
	)
	if is_instance_valid(node):
		node.tree_exited.connect(func(): eff.stop())

func model(node:Node, property: StringName, ref:Ref):
	bind(node, property, ref)
	var update_func = func(nv): ref.value = nv
	if node is LineEdit:
		node.text_changed.connect(update_func)
	if node is TextEdit:
		node.text_changed.connect(func(): ref.value = node.text)
	elif node is ColorPicker:
		node.color_changed.connect(update_func)

func watch(ref:Ref, callable:Callable, node:Node = null) -> ReactiveEffect:
	var org = [ref.value];
	var weak_res:WeakRef = weakref(ref)
	var eff:ReactiveEffect = null
	eff = effect(func():
		var r = weak_res.get_ref()
		if not r:
			eff.stop()
			return
		callable.call(org[0], ref.value)
		org[0] = ref.value
	)
	if node:
		node.tree_exited.connect(eff.stop)
	return eff

func clean(effect:ReactiveEffect):
	if not effect:
		return
	effect.stop()
	effect = null

func _is_editable(node:Node):
	return (node is LineEdit and node.is_editing()) or (node is TextEdit and node.has_focus())
