extends Resource
class_name HeroData

@export 
var name:String
@export_enum("人类", "精灵", "兽人") 
var camp:String
@export_enum("战士", "法师")
var career:String
@export_multiline
var detail:String
