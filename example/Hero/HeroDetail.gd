extends Panel
class_name HeroDetail

func set_hero(hero):
	if hero == null : return
	$HBoxContainer/Value/Name.text = hero.name
	$HBoxContainer/Value/Camp.text = hero.camp
	$HBoxContainer/Value/Career.text = hero.career
	$HBoxContainer/Value/Detail.text = hero.detail
