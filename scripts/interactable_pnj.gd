class_name InteractablePnj extends InteractableBase
var npc : NPC
var can_interact : bool
func _ready() -> void:
	npc = get_parent()

	can_interact = true
func _set_interactable():
	print_debug("set player interactable object : " + self.name)
	Player.Instance.Interactable = self
func _remove_interactable():
	npc.bubble_text.remove_text()

func on_interact():
	if(can_interact):
		if(npc.has_to_talk):
			can_interact = false
			npc.bubble_text.display_text(npc.say_new_voiceline())
		elif(npc.has_to_give_quest):
			can_interact = false
			npc.bubble_text.display_quest(npc.quest.text)
		print_debug("Interacted : " + self.name)
	
	# Pnj interaction code goes here
