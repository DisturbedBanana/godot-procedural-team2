extends CanvasLayer
var QuestManager = preload("res://scripts/quest/quest_system.gd")
@export var heart_scene : PackedScene
@export var quest_infos : PackedScene
var previous_life : int

@onready var life_container : BoxContainer = $"LifeContainer"
@onready var quest_container : BoxContainer = $"Quests"

func _ready() -> void:
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

func _add_quest() -> void:
	#var quest = quest_infos.instantiate()
	#quest_container.add_child(quest)
	#quest.name =  
	return

func _remove_quest() -> void:
	if quest_container.get_child_count() == 0:
		return
	var quest =	quest_container.get_child(0)
	quest_container.remove_child(quest)

func _update_quest(id : int) -> void:
	#var quest : QuestData = quest_container.find_child()
	#var quest =	quest_container.get_child(0)
	#quest_container.remove_child(quest)
	return 
