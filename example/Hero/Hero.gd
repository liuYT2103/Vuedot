extends Control

@export var _hero_list:Array[HeroData]

var selected_hero:Ref = Vue.ref(null)
var hero_list:Ref = Vue.ref([])

func _ready() -> void:
	V.hyper(self, func(): $HeroList.set_heros(hero_list.value))
	V.hyper(self, func(): $HeroDetail.set_hero(selected_hero.value))
	V.on($HeroList, "item_selected", _on_list_item_selected)

func _on_list_item_selected(idx:int):
	selected_hero.value = hero_list.value.get(idx)

func _on_button_pressed() -> void:
	hero_list.value += [_hero_list.pick_random()]
