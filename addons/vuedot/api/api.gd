extends RefCounted
class_name __VUE_API

static func _effect(fn: Callable) -> Effect:
	var eff = Effect.new(fn)
	eff.run()
	return eff

static func ref(initial_value) -> Ref:
	return Ref.new(initial_value)

static func computed(getter: Callable) -> Ref:
	var result:Ref = ref(null)
	_effect(func():
		result.value = getter.call()
	)
	return result

static func _bind(node: Node, prop: StringName, ref: Ref) -> void:
	if not node:
		push_error("[VUEDOT:BIND_FAIL]", node, "不是有效的节点")
		return
	if not prop:
		push_error("[VUEDOT:BIND_FAIL]", prop, "不是有效的属性")
		return
	var eff = _effect(func():
		node.set(prop, ref.value)
	)
	if is_instance_valid(node):
		node.tree_exited.connect(func(): eff.stop())

static func bind(nodes, props, ref:Ref) -> void:
	if nodes is Node and props is String:
		_bind(nodes, props, ref)
	elif nodes is Array and props is String:
		for node in nodes:
			_bind(node, props, ref)
	elif nodes is Node and props is Array:
		_bind_props(nodes, props, ref)
	elif nodes is Array and props is Array:
		for node in nodes:
			_bind_props(node, props, ref)

static func on(node: Node, signal_name:StringName, fn:Callable) -> void:
	if not node.has_signal(signal_name):
		push_warning("[VUEDOT:ON_FAIL]", node.get_class(), "不存在信号", signal_name)	
		return
	node.connect(signal_name, fn)

static func hyper(node:Node, fn:Callable) -> void:
	if not node:
		push_warning("[VUEDOT:HYPER_FAIL]必须传入一个节点以标记副作用消失时机")
		return
	var eff = _effect(fn)
	if is_instance_valid(node):
		node.tree_exited.connect(eff.stop)

static func _bind_props(node, props, ref) ->void:
	var eff = _effect(func():
		for prop in props:
			node.set(prop, ref.value)	
	)
	if is_instance_valid(node):
		node.tree_exited.connect(eff.stop)

static func _bind_model(node: Node, prop: StringName, ref: Ref) -> void:
	var eff = _effect(func():
		var val = ref.value
		if node is Control and node.has_focus():
			return
		if not prop.is_empty():
			node.set(prop, val)
	)
	if is_instance_valid(node):
		node.tree_exited.connect(func(): eff.stop())

static func model(nodes, prop:StringName, ref:Ref) -> void:
	if nodes is Array:
		for node in nodes:
			_model(node, prop, ref)
	elif nodes is Node:
		_model(nodes, prop, ref)

static func _model(node:Node, prop: StringName, ref:Ref) -> void:
	if not node:
		push_error("")
		return
	_bind_model(node, prop, ref)
	var _func = func(nv): ref.value = nv
	if node is LineEdit:
		node.text_changed.connect(_func)
	elif node is TextEdit:
		node.text_changed.connect(func(): ref.value = node.text)
	elif node is ColorPicker:
		node.color_changed.connect(_func)

static func watch(node:Node, ref:Ref, callable:Callable) -> Effect:
	var org = [ref.value];
	var weak_res:WeakRef = weakref(ref)
	var eff:Effect = null
	eff = _effect(func():
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

static func clean(effect:Effect) -> void:
	if not effect:
		return
	effect.stop()
	effect = null
