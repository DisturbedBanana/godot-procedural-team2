extends Node2D
class_name Quest
var data : QuestData
const biome_list = preload("res://resources/biomes/biome_list.tres")
const Data = preload("res://scripts/quest/quest_data.gd")
func _ready() -> void:
	
	_create_new_quest(Data.QuestType.Tracassin)

func _create_new_quest(type : Data.QuestType):
	
	data = QuestData.new()
	var file_path
	if(type == Data.QuestType.Tracassin):
		file_path = "res://resources/json/quest_tracassin.json"
	else:
		file_path = "res://resources/json/quest_syndicat.json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parsed_json = json.parse(json_text)
	if parsed_json == OK:
		var rules = json.data
		
		var grammar = Tracery.Grammar.new(rules)
		
		var _quest = grammar.flatten("#origin#")
		var _quest_elements = grammar._save_data
		var _quest_text = _quest_elements.get("quest")
		data.type = type
		data.action = data.dic_action.get(_quest_elements.get("objective"))
		data.biome = biome_list.find_biome(_quest_elements.get("biome"))
		if _quest_elements.get("entity") != null:
			data.entity = data.dic_entity.get(_quest_elements.get("entity"))
		data.text = _quest_text
