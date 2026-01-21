class_name NPC extends Node2D
const QuestManager = preload("res://scripts/quest/quest_system.gd")
static var all_npc : Array[NPC]
@onready var bubble_text : BubbleText = $"MiniBubble"
var quest : QuestData
@export var type : QuestData.QuestType 
@export var can_give_quest : bool
@export var voicelines_list : Array[String] = []
var has_to_talk : bool
var has_to_give_quest : bool

func _init():
	all_npc.push_back(self)


func _setup() -> void:
	
	if(can_give_quest):
		if(quest != null):
			bubble_text.change_state(BubbleText.State.NewQuest)
			has_to_give_quest = true
		else:
			return
	else:
		
		bubble_text.change_state(BubbleText.State.Dialog)
		has_to_talk = true
	


func say_new_voiceline():
	var random_text : String = voicelines_list.pick_random()
	return random_text
