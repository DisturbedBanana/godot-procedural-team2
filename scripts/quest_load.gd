extends Node

const grammar = preload("res://resources/json/quest.json")
# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open("res://resources/json/quest.json", FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parsed_json = json.parse(json_text)
	
	if parsed_json == OK:
		var rules = json.data
		
		var grammar = Tracery.Grammar.new(rules)
		
		grammar.add_modifiers(Tracery.UniversalModifiers.get_modifiers())
		
		for i in range(5):
			var quest = grammar.flatten("#origin#")
			print(quest)
