class_name Dep extends RefCounted

var subs: Array[ReactiveEffect] = []   # 订阅此 dep 的所有 effect

# 添加当前活跃的 effect 到依赖列表
func depend(effect: ReactiveEffect):
	if effect != null and not subs.has(effect):
		subs.append(effect)
		# 反向记录：effect 知道自己依赖了此 dep
		effect.add_dep(self)

# 通知所有订阅者重新执行
func notify():
	# 复制一份，避免遍历过程中修改原数组
	for effect in subs.duplicate():
		if effect.active:
			effect.run()

# 移除指定的 effect
func remove(effect: ReactiveEffect):
	var idx = subs.find(effect)
	if idx != -1:
		subs.remove_at(idx)
