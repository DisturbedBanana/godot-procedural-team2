class_name QuestSystem
extends Node2D

const Data = preload("res://scripts/quest/quest_data.gd")

static var Instance : QuestSystem
var quest_list : Array[QuestData] = []
const biome_list = preload("res://resources/biomes/biome_list.tres")
var id_quest : int = 0
func _init() -> void:
	Instance = self
	_create_new_quest(Data.QuestType.Tracassin)
	_create_new_quest(Data.QuestType.Syndicat)

func _create_new_quest(type : Data.QuestType) -> QuestData:

	var data = QuestData.new()
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
		data.id = id_quest
		id_quest += 1
		return data
	return null
		
func _check_data(data: ActionData):
	for quest in quest_list:
		if((data.action == quest.action) && (data.biome == quest.biome) && (data.entity == quest.entity)):
			quest.current_numb -= 1
			if(quest.current_numb == 0):
				_validate_quest(quest)
				
func _validate_quest(quest: QuestData):
	var index_quest = quest_list.find(quest)
	if(index_quest != -1):
		quest_list.remove_at(index_quest)

func _find_quest(type : Data.QuestType):
	for quest in quest_list:
		if(quest.type == type):
			return quest
		
class ActionData extends Resource:
	var action : Data.QuestObjective
	var number : int
	var entity : Data.QuestEntity
	var biome : BiomeData			
	
