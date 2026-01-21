class_name spawner extends Area2D

@export var spawnChance:Array[int]
@export var enemy :Array[Enemy]
var room:Room
var currentChance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node = self
	while (node != null && !node is Room):
		node = node.get_parent()
		
	if node == null:
		push_error(node == null, "The door is not in any room")
		return

	room = (node as Room)
	if room.biome=="Forest" or room.biome=="Swamp" or room.biome=="Ruin":
		currentChance=spawnChance[0]
	elif room.biome=="LostWoods" or room.biome=="Bayou" or room.biome=="LostCity":
		currentChance=spawnChance[1]
	elif room.biome=="Desert1" or room.biome=="Desert2" or room.biome=="Desert3":
		currentChance=spawnChance[2]
	elif room.biome=="Steppe1" or room.biome=="Steppe2" or room.biome=="Steppe3":
		currentChance=spawnChance[3]
	else:
		currentChance=0;
	pass # Replace with function body.

func _spawn()-> void:
	var rand=randi_range(0,currentChance)
	if rand <= currentChance:
		var _entity = enemy[0].Instantiate()
		
