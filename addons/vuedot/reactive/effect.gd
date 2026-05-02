class_name Effect extends RefCounted

static var active_effect: Effect = null

var fn: Callable               # 要执行的函数
var active: bool = true        # 是否活跃
var deps: Array[WeakRef] = []      # 当前 effect 依赖的所有 dep（用于清理）
var running: bool = false      # 防止递归执行

func _init(_fn: Callable):
	fn = _fn

# 运行 effect（收集依赖 -> 执行函数）
func run():
	if not active or running:
		return
	running = true
	
	# 清理旧的依赖关系，确保旧数据变化不会再次触发本 effect
	cleanup_deps()
	
	# 设置全局活跃 effect
	var prev = active_effect
	active_effect = self
	fn.call()
	active_effect = prev
	
	running = false

# 将本 effect 注册到某个 dep 中（由 dep.depend 调用）
func add_dep(dep: Dep):
	for w in deps:
		if w.get_ref() == dep:
			return
	deps.append(weakref(dep))

# 从所有依赖的 dep 中移除自己，并清空 deps 列表
func cleanup_deps():
	for weakref in deps:
		var dep = weakref.get_ref()
		if dep:
			dep.remove(self)
	deps.clear()

# 停止 effect，不再响应任何变化
func stop():
	if active:
		active = false
		cleanup_deps()
