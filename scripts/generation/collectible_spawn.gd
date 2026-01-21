class_name collec_Spawner extends Area2D

@export var keyChance:int
@export var heartChance:int
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
	print(keyChance)
	if rand < keyChance:
		var collec = key.instantiate()
		print("key")
		add_child(collec)
	elif rand < heartChance:
		var collec = heart.instantiate()
		print("heart")
		add_child(collec)



		
