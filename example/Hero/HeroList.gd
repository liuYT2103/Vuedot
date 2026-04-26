extends ItemList
class_name HeroList

func set_heros(val:Array[HeroData]):
	clear()
	for hero in val:
		add_item(hero.name)
