class_name BubbleText extends Node2D
@onready var bubble_anim = $"AnimatedSprite2D"
@onready var bubble_bg = $"FullBubble"
@onready var bubble_text = $"FullBubble/Node2D/Text"
enum State {None, NewQuest, Dialog, DisplayedQuest, DisplayedDialog}

func _ready() -> void:
	pass 

func display_text(text : String):
	change_state(State.DisplayedDialog)
	bubble_text.text = text

func remove_text():
	change_state(State.None)
	bubble_text.text = ""
	
func display_quest(text : String):
	change_state(State.DisplayedQuest)
	bubble_text.text = text

func change_state(new_state : State):
	match new_state:
		State.None:
			bubble_anim.play("none")
			bubble_bg.play("none")
		State.NewQuest:
			bubble_anim.play("notif_quest")
			bubble_bg.play("none")
		State.Dialog:
			bubble_anim.play("notif_message")
			bubble_bg.play("none")
		State.DisplayedQuest:
			bubble_anim.play("none")
			bubble_bg.play("quest")
		State.DisplayedDialog:
			bubble_anim.play("none")
			bubble_bg.play("message")
		
