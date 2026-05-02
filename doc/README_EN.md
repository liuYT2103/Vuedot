# Vuedot

> Manage Godot nodes and data as effortlessly as Vue

Vuedot is a Godot 4 editor plugin that brings Vue.js-style reactive data binding to the Godot engine. With reactive primitives like Ref, Computed, and two-way Model binding, synchronizing UI nodes with data becomes clean and intuitive.

## Features

- **Reactive Data** — Create reactive references with `ref()`, derive computed values with `computed()`. UI updates automatically when data changes.
- **Node Binding** — One-way binding via `bind()` (data → node property), two-way binding via `model()` (like Vue's v-model).
- **Side Effect Management** — `hyper()` runs side effects scoped to a node's lifetime, auto-cleans on node destruction.
- **Change Watching** — `watch()` observes ref changes and provides old/new value comparison.
- **WeakRef Safety** — Dependency tracking uses weak references to prevent memory leaks.

## Quick Start

### Installation

1. Copy the `addons/vuedot` directory into your Godot project's `addons/` folder or search Vuedot in Godot Asset Library
2. Enable **Vuedot** in Project Settings → Plugins

### Basic Usage

```python
# Create reactive data
var message: Ref = V.ref("Hello")
var count: Ref = V.ref(0)
var greeting = V.computed(func(): return message.value + " World")

# One-way binding: data changes → UI auto-updates
V.bind($Label, "text", message)

# Two-way binding: data ↔ input control (like v-model)
V.model($LineEdit, "text", message)

# Side effect: runs while node exists, auto-cleans on destruction
V.hyper($Label, func():
    $Label.modulate = Color.RED if count.value < 0 else Color.WHITE
)

# Watch for changes
V.watch(self, message, func(old_val, new_val):
    print("Message changed from ", old_val, " to ", new_val)
)
```

See `addons/vuedot/example/` for complete example scenes.

## API Reference

| Method | Description |
|---|---|
| `V.ref(initial_value)` | Create a reactive reference. Reading `.value` collects dependencies; writing `.value` dispatches updates. |
| `V.computed(getter)` | Create a computed property that auto-recalculates when its dependencies change. |
| `V.bind(node, prop, ref)` | One-way bind: ref changes → node property updates. Supports batch nodes/properties. |
| `V.model(node, prop, ref)` | Two-way bind: supports LineEdit, TextEdit, ColorPicker and other controls. |
| `V.hyper(node, fn)` | Run a side effect scoped to the node's lifetime. Auto-stops when node exits the scene tree. |
| `V.on(node, signal, fn)` | Listen to a node signal. |
| `V.watch(node, ref, callable)` | Watch ref changes. Callback receives (old_value, new_value). |
| `V.clean(effect)` | Manually stop a side effect. |

> All methods are also accessible via `Vue.xxx()` (`Vue` is an alias for `V`).

## Examples

| Example | Path | Description |
|---|---|---|
| Simple | `addons/vuedot/example/Simple.tscn` | Demonstrates ref, computed, bind, model, and hyper basics |
| Hero | `addons/vuedot/example/Hero/Hero.tscn` | Full example: hero list, selection binding, random addition |

![Code Screenshot](../doc/code.png)

![Running Effect](../doc/game.png)

## Architecture

```
addons/vuedot/
├── api/
│   ├── api.gd        # Core API implementation (reactive binding, side effects)
│   ├── v.gd           # Public API (V class)
│   └── Vue.gd         # Vue alias
├── reactive/
│   ├── ref.gd         # Reactive reference (Ref)
│   ├── effect.gd      # Side effect (Effect)
│   └── dep.gd         # Dependency tracking & dispatch (Dep)
├── example/
│   ├── Simple.gd/tscn # Basic example
│   └── Hero/          # Hero list example
├── plugin.cfg         # Plugin configuration
└── vuedot.gd          # Plugin entry point
```

### Reactivity System

1. **Ref** — Wraps a value with getter/setter on `.value`. On read, calls `Dep.depend()` to collect the currently active Effect. On write, calls `Dep.notify()` to trigger all subscribers.
2. **Effect** — Wraps a function. Before execution, sets itself as the global active Effect so all Refs read during execution register it as a dependency.
3. **Dep** — Each Ref holds a Dep instance that maintains the subscriber list and handles dependency collection and update dispatch.

## Requirements

- Godot 4.1+
- Forward+ renderer and Jolt Physics (example project configuration)

## License

MIT © 2026 ATAO (LiuYT2103)
