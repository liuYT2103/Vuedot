class_name Dep extends RefCounted

var subs: Array[WeakRef] = []   # 订阅此 dep 的所有 effect

# 添加当前活跃的 effect 到依赖列表
func depend(effect: ReactiveEffect):
	if effect == null:
		return
	for w in subs:
		if w.get_ref() == effect:
			return
	subs.append(weakref(effect))
	effect.add_dep(self)
	
# 派发更新
func notify():
	for w in subs:
		var eff = w.get_ref()
		if eff and eff.active:
			eff.run()
	subs = subs.filter(func(w): return w.get_ref() != null)

# 移除指定的 effect
func remove(effect: ReactiveEffect):
	subs = subs.filter(func(w): 
		var e = w.get_ref()
		return e != null and e != effect
	)
