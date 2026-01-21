class_name NPC extends Node2D
var QuestManager = preload("res://scripts/quest/quest_system.gd")
@onready var bubble_text : BubbleText = $"MiniBubble"
var quest : QuestData
@export var type : QuestData.QuestType 
@export var can_give_quest : bool
@export var voicelines_list : Array[String] = []
var has_to_talk : bool
var has_to_give_quest : bool

func _ready() -> void:
	if(can_give_quest):
		bubble_text.change_state(BubbleText.State.NewQuest)
		has_to_give_quest = true
	else:
		
		bubble_text.change_state(BubbleText.State.Dialog)
		has_to_talk = true
	

func get_new_quest():
	var quest_temp = QuestManager.Instance._find_quest(type)
	if(quest_temp == null):
		quest = QuestManager.Instance._create_new_quest(type)
	else:
		quest = quest_temp
	HUD.Instance._add_quest(quest.id)
	
func say_new_voiceline():
	var random_text : String = voicelines_list.pick_random()
	return random_text
