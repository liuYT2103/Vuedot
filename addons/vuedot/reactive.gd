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
	var result = ref(null)
	var _dummy = effect(func():
		result.value = getter.call()
	)
	return result

func bind(node: Node, property: StringName, ref: Ref, callback: Callable = func(_n): pass) -> void:
	var binds: Dictionary = node.get_meta("__reactive_binds__", {})
	binds[property] = ref
	node.set_meta("__reactive_binds__", binds)
	
	var eff = Vue.effect(func():
		node.set(property, ref.value)
		callback.call(node)
	)
	
	var effects = node.get_meta("__reactive_effects__", [])
	effects.append(eff)
	node.set_meta("__reactive_effects__", effects)
	
	if not node.is_connected("tree_exited", _on_node_exited):
		node.tree_exited.connect(_on_node_exited.bind(node), CONNECT_ONE_SHOT)



func _on_node_exited(node: Node) -> void:
	var effects = node.get_meta("__reactive_effects__", [])
	for eff in effects:
		eff.stop()
	node.remove_meta("__reactive_effects__")
	node.remove_meta("__reactive_binds__")

func get_bound_ref(node: Node, property: StringName) -> Ref:
	var binds = node.get_meta("__reactive_binds__", {})
	return binds.get(property, null)
