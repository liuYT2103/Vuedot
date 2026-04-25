class_name Dep extends RefCounted

var subs: Dictionary[int, ReactiveEffect] = {}   # 订阅此 dep 的所有 effect

# 添加当前活跃的 effect 到依赖列表
func depend(effect: ReactiveEffect):
	if effect != null:
		subs[effect.get_instance_id()] = effect
		effect.add_dep(self)

# 通知所有订阅者重新执行
func notify():
	# 复制一份，避免遍历过程中修改原数组
	for effect in subs.values():
		if effect.active:
			effect.run()

# 移除指定的 effect
func remove(effect: ReactiveEffect):
	subs.erase(effect.get_instance_id())
