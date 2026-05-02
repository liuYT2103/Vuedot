extends ItemList
class_name HeroList

func set_heros(val):
	clear()
	for hero in val:
		add_item(hero.name)
