extends Control

@export var heroList:Array[HeroData]

var selected_hero:Ref = Vue.ref(null)

func _ready() -> void:
	$HeroList.set_heros(heroList)
	$HeroList.item_selected.connect(func(idx:int): selected_hero.value = heroList[idx])
	$HeroDetail.set_props(selected_hero)

func _on_button_pressed() -> void:
	$HeroDetail.queue_free()
	$HeroList.queue_free()
	selected_hero = null
