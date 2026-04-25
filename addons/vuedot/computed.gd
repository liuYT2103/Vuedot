class_name Computed extends Ref
var _cached_value: Variant
var _effect: ReactiveEffect

func _init():
	_cached_value = null
	super(null)

func get_value():
	if Reactive.active_effect != null:
		dep.depend(Reactive.active_effect)
	return _cached_value

func set_value(_new):
	push_warning("Cannot assign to computed property")

func _update_cache(new_val):
	if _cached_value != new_val:
		_cached_value = new_val
		dep.notify()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if _effect:
			_effect.stop()
