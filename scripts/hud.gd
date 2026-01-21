class_name HUD extends CanvasLayer
@export var heart_scene : PackedScene
@export var quest_infos : PackedScene
var previous_life : int
static var Instance : HUD
const QuestManager = preload("res://scripts/quest/quest_system.gd")
@onready var life_container : BoxContainer = $"LifeContainer"
@onready var quest_container : BoxContainer = $"Quests"

func _ready() -> void:
	if(Instance == null):
		Instance = self
	previous_life = Player.Instance.life
	Player.Instance.life_changed.connect(_on_life_changed)
	for heart in previous_life:
		_add_heart()


func _on_life_changed(new_life : int) -> void:
	if new_life < previous_life:
		_remove_heart()
	elif new_life > previous_life:
		_add_heart()


func _add_heart() -> void:
	var heart = heart_scene.instantiate()
	life_container.add_child(heart)


func _remove_heart() -> void:
	if life_container.get_child_count() == 0:
		return

	var heart =	life_container.get_child(0)
	life_container.remove_child(heart)

func _add_quest(id : int) -> void:
	var quest = quest_infos.instantiate()
	quest_container.add_child(quest)
	quest.name = str(id)
	_update_quest(id)
	return

func _remove_quest(id : int) -> void:
	var quest_hud = quest_container.find_child(str(id))
	quest_container.remove_child(quest_hud)

func _update_quest(id : int) -> void:
	var quest_text = quest_container.get_node(str(id))
	var quest : QuestData = QuestManager.Instance._find_quest_with_id(id)
	quest_text.text = "Vous devez {action} {number} {entity} dans {biome}".format({
		"action": quest.dic_action.find_key(quest.action), 
		"number": quest.current_numb,
		"entity": quest.dic_entity.find_key(quest.entity), 
		"biome": quest.dic_biome.find_key(quest.biome.biome_name), 
		})
	return 
