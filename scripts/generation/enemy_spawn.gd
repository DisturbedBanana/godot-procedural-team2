class_name spawner extends Area2D

@export var spawnChance:Array[int]
var monster=preload("res://scenes/npc/enemy/fox.tscn")# PAS EU LE TEMPS 
var slug=preload("res://scenes/npc/enemy/slug.tscn")
var mosquito=preload("res://scenes/npc/enemy/mosquito.tscn")
var mouse=preload("res://scenes/npc/enemy/mouse.tscn")
var skull=preload("res://scenes/npc/enemy/mosquito.tscn")
var castor=preload("res://scenes/npc/enemy/fox.tscn")
var radish=preload("res://scenes/npc/enemy/mosquito.tscn")
var rabbit=preload("res://scenes/npc/enemy/mouse.tscn")

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

	room = (node as Room)# CHANCES PROGRESSIVES EN FONCTION DE LA DISTANCE DU BIOME
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
		match room.biome:#ON A TROP DE BIOMES AVEC UN ENNEMI PAR BIOME BON 
			"Forest":
				var en = rabbit.instantiate()
				add_child(en)
			"Ruin":
				var en = radish.instantiate()
				add_child(en)
			"Swamp":
				var en = slug.instantiate()
				add_child(en)
			"LostWoods":
				var en = castor.instantiate()
				add_child(en)
			"Bayou":
				var en = mosquito.instantiate()
				add_child(en)
			"LostCity":
				var en = mouse.instantiate()
				add_child(en)
			"Desert1":
				var en = monster.instantiate()
				add_child(en)
			"Desert2":
				var en = monster.instantiate()
				add_child(en)
			"Desert3":
				var en = monster.instantiate()
				add_child(en)
			"Enemy1":
				var en = skull.instantiate()
				add_child(en)
			"Enemy2":
				var en = skull.instantiate()
				add_child(en)
			"Enemy3":
				var en = skull.instantiate()
				add_child(en)
