extends Node

var npc_list: Array[PackedScene] = []
@export var npc_templates: Array[PackedScene] = []
func _ready() -> void:
	pass
	
func _create_npc(position: Vector2):
	var npc_to_spawn = npc_templates.pick_random().instantiate()
	add_child(npc_to_spawn)
	npc_to_spawn.position = position
	return
