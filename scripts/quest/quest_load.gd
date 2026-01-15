extends Node

func _init():
	
	_create_new_data()

func _create_new_data():
	var _data = QuestData.new()
	var file = FileAccess.open("res://resources/json/quest.json", FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parsed_json = json.parse(json_text)
	
	if parsed_json == OK:
		var rules = json.data
		
		var grammar = Tracery.Grammar.new(rules)
		grammar.add_modifiers(Tracery.UniversalModifiers.get_modifiers())
		
		var _quest_text = grammar.flatten("#origin#")
		
		var _quest_elements = grammar._save_data
		print(_quest_text)
		print("Objective: ", _quest_elements.get("objective"))
		_data.quest_text = _quest_text
	
