class_name V extends __VUE_API

static func ref(initial_value) -> Ref:
	return super(initial_value)

static func computed(getter: Callable) -> Ref:
	return super(getter)

static func bind(node, prop, ref: Ref) -> void:
	return super(node, prop, ref)

static func on(node: Node, signal_name:StringName, fn:Callable) -> void:
	return super(node, signal_name, fn)

static func hyper(node:Node, fn:Callable) -> void:
	return super(node, fn)
	
static func model(node, prop: StringName, ref:Ref) -> void:
	return super(node, prop, ref)

static func watch(node:Node, ref:Ref, callable:Callable) -> Effect:
	return super(node, ref, callable)

static func clean(effect:Effect) -> void:
	return super(effect)
