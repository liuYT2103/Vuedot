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
	var result:Computed = Computed.new()
	var weak_res:WeakRef = weakref(result)
	var eff:ReactiveEffect = null
	eff = effect(func():
		var r = weak_res.get_ref() as Computed
		if not r and eff:
			eff.stop()
			return
		r._update_cache(getter.call())
	)
	result._effect = eff
	return result

func bind(node: Node, property: StringName, ref: Ref, callback: Callable = func(_n): pass) -> void:
	var eff = effect(func():
		var val = ref.value # 强制建立依赖关系，避免首帧已在编辑状态无法关联依赖
		if node is LineEdit and node.is_editing():
			return
		node.set(property, val)
		callback.call(node)
	)
	if is_instance_valid(node):
		node.tree_exited.connect(func(): eff.stop())

func model(node:Node, property: StringName, ref:Ref):
	bind(node, property, ref)
	var update_func = func(nv): ref.value = nv
	if node is LineEdit or node is TextEdit:
		node.text_changed.connect(update_func)
	elif node is ColorPicker:
		node.color_changed.connect(update_func)
