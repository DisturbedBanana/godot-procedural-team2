class_name collec_Spawner extends Area2D

@export var spawnChance:Array[int]
var key=preload("res://scenes/key_collectible.tscn")
var heart=preload("res://scenes/heart_collectible.tscn")
var room:Room
var currentChance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn()
	pass # Replace with function body.

func _spawn()-> void:
	var rand=randi_range(0,100)
	print(rand)
	if rand <= spawnChance[0]:
		var collec = key.instantiate()
		add_child(collec)
	elif rand <= spawnChance[1]:
		var collec = heart.instantiate()
		add_child(collec)



		
